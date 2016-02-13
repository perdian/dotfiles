-- Auto-reload configuration if any file inside the hammerspoon directory has changed
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function()
    hs.alert.show('Reloading Hammerspoon configuration...');
    hs.reload();
end):start()

-- Include other files in directory
function importFilesInDirectory(directory)
    for file in hs.fs.dir(directory) do
        if ("." ~= string.sub(file, 0, 1)) then
            local filePath = directory .. "/" .. file;
            if ("directory" == hs.fs.attributes(filePath, "mode")) then
                importFilesInDirectory(filePath);
            elseif ("file" == hs.fs.attributes(filePath, "mode")) then
                if (".lua" == string.sub(filePath, -4) and "init.lua" ~= file) then
                    dofile(filePath);
                end
            end
        end
    end
end
importFilesInDirectory(os.getenv("HOME") .. "/.hammerspoon");


-- Bind hotkeys
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'h', function() hs.openConsole() end)
hs.hotkey.bind(nil, 'F18', function() hs.caffeinate.startScreensaver() end)
hs.hotkey.bind({'ctrl'}, 'F18', function() hs.caffeinate.systemSleep() end)
