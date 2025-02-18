local AutoEject = {}

AutoEject.author = "Jussi Vesa <jussi.vesa@gmail.com>"
AutoEject.homepage = "https://github.com/jussivesa/AutoEject.spoon"
AutoEject.license = "MIT"
AutoEject.name = "AutoEject"
AutoEject.version = "0.0.1"
AutoEject.spoon = hs.spoons.scriptPath()

AutoEject.ejectDailyAt = "23:55"

local function stopBackup()
  local path = hs.fs.pathToAbsolute("~/.hammerspoon/Spoons/AutoEject.spoon/stop_backup.applescript")
  hs.osascript.applescriptFromFile(path)
  print("AutoEject: Stopped TimeMachine backup")
  hs.notify.show("AutoEject", "Stopped TimeMachine backup", "")
end

local function ejectDisk()
  local path = hs.fs.pathToAbsolute("~/.hammerspoon/Spoons/AutoEject.spoon/eject_disk.applescript")
  hs.osascript.applescriptFromFile(path)
  print("AutoEject: Ejected TimeMachine disk")
  hs.notify.show("AutoEject", "Ejected TimeMachine disk", "")
end

function AutoEject:init()
  self.ejectTimer = nil
end

function AutoEject:configure(options)
  self.ejectDailyAt = options.ejectDailyAt or self.ejectDailyAt
  return self
end

function AutoEject:start()
  if self.ejectTimer ~= nil then
    self.ejectTimer:stop()
    self.ejectTimer = nil
  end

  print("AutoEject: Started timer")

  self.ejectTimer = hs.timer.doAt(self.ejectDailyAt, function(t)
    stopBackup()
    ejectDisk()
  end)
end

function AutoEject:stop()
  if self.ejectTimer ~= nil then
    self.ejectTimer:stop()
    self.ejectTimer = nil
  end

  print("AutoEject: Stopped timer")
end

return AutoEject