-- Hyper = left_command + left_shift + left_option + left_control (set in Karabiner)
local hyper = { "cmd", "shift", "alt", "ctrl" }

-- Quick switch to favourite apps with Hyper+<N>
hs.hotkey.bind(hyper, "1", function()
	hs.application.launchOrFocus("Firefox")
end)
hs.hotkey.bind(hyper, "2", function()
	hs.application.launchOrFocus("Alacritty")
end)
hs.hotkey.bind(hyper, "3", function()
	hs.application.launchOrFocus("Obsidian")
end)
hs.hotkey.bind(hyper, "4", function()
	hs.application.launchOrFocus("Calendar")
end)
hs.hotkey.bind(hyper, "5", function()
	hs.application.launchOrFocus("Spotify")
end)
