#include <CoreFoundation/CoreFoundation.h>
#include <mach/mach_error.h>
#include <IOKit/IOCFPlugIn.h>
#include <IOKit/usb/IOUSBLib.h>
#include <stdio.h>
#include <stdlib.h>

static void check(IOReturn status, const char *operation) {
    if (status != kIOReturnSuccess) {
        fprintf(stderr, "%s failed: %s. Reconnect the keypad and retry.\n",
                operation, mach_error_string(status));
        exit(1);
    }
}

static int property(io_service_t service, CFStringRef name) {
    int value = -1;
    CFTypeRef number = IORegistryEntryCreateCFProperty(service, name, NULL, 0);
    if (number) {
        if (CFGetTypeID(number) == CFNumberGetTypeID())
            CFNumberGetValue(number, kCFNumberIntType, &value);
        CFRelease(number);
    }
    return value;
}

int main(void) {
    io_iterator_t devices;
    check(IOServiceGetMatchingServices(kIOMainPortDefault,
          IOServiceMatching("IOUSBHostInterface"), &devices), "USB discovery");
    io_service_t service, target = 0;
    while ((service = IOIteratorNext(devices))) {
        if (property(service, CFSTR("idVendor")) == 0x1189 &&
            property(service, CFSTR("idProduct")) == 0x8890 &&
            property(service, CFSTR("bInterfaceNumber")) == 1 &&
            property(service, CFSTR("bInterfaceClass")) == 3) {
            if (target) {
                fputs("Multiple keypads found. Connect one keypad.\n", stderr);
                return 1;
            }
            target = service;
        } else {
            IOObjectRelease(service);
        }
    }
    IOObjectRelease(devices);
    if (!target) {
        fputs("Keypad interface missing. Connect one 1189:8890 keypad by USB.\n", stderr);
        return 1;
    }
    IOCFPlugInInterface **plugin;
    SInt32 score;
    check(IOCreatePlugInInterfaceForService(target, kIOUSBInterfaceUserClientTypeID,
          kIOCFPlugInInterfaceID, &plugin, &score), "USB interface access");
    IOUSBInterfaceInterface **usb;
    if ((*plugin)->QueryInterface(plugin, CFUUIDGetUUIDBytes(kIOUSBInterfaceInterfaceID),
                                 (void **)&usb) != S_OK) {
        fputs("USB interface unavailable. Reconnect the keypad.\n", stderr);
        return 1;
    }
    check((*usb)->USBInterfaceOpen(usb), "Open keypad interface");
    UInt8 direction, number, type, interval;
    UInt16 size;
    check((*usb)->GetPipeProperties(usb, 1, &direction, &number, &type, &size, &interval),
          "Read endpoint");
    if (direction != kUSBOut || number != 2 || type != kUSBInterrupt || size != 64) {
        fputs("Unexpected endpoint. Check the keypad model.\n", stderr);
        return 1;
    }
    unsigned char packet[64];
    size_t count;
    while ((count = fread(packet, 1, sizeof packet, stdin)) == sizeof packet)
        check((*usb)->WritePipe(usb, 1, packet, sizeof packet), "Send keypad command");
    check((*usb)->USBInterfaceClose(usb), "Close keypad interface");
    return count || ferror(stdin);
}
