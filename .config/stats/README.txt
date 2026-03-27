Stats config in this repo is manual.

`Stats.plist` is an exported Stats configuration kept under version control.

Stats does not automatically read this repo file at startup. To use it, do one of:

- import `Stats.plist` from the Stats GUI
- manually link or copy it to Stats' live preferences location

If you change Stats in the GUI and want this repo to stay current, export it again and overwrite `Stats.plist` here.

This tracked copy already includes the clock format that renders like `Fri, W13` on the top row.
