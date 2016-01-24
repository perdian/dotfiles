-- Auto-reload configuration if any file inside the hammerspoon directory has changed
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function()
    hs.alert.show('Reloading Hammerspoon configuration...');
    hs.reload()
end):start()

-- Bind hotkeys
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'h', function() hs.openConsole() end)
hs.hotkey.bind(nil, 'F18', function() hs.caffeinate.startScreensaver() end)
hs.hotkey.bind({'ctrl'}, 'F18', function() hs.caffeinate.systemSleep() end)