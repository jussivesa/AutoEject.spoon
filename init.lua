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

-- Function to calculate the next occurrence of the target time
local function getNextTriggerTime(ejectDailyAt)
    local now = os.date("*t")
    local targetHour, targetMin = ejectDailyAt:match("(%d+):(%d+)")
    targetHour, targetMin = tonumber(targetHour), tonumber(targetMin)
    
    local triggerTime = os.time({
        year = now.year,
        month = now.month,
        day = now.day,
        hour = targetHour,
        min = targetMin,
        sec = 0
    })
    
    -- If the target time has already passed today, schedule for tomorrow
    if triggerTime <= os.time() then
        triggerTime = triggerTime + 86400 -- Add 24 hours in seconds
    end

    local nextTrigger = triggerTime - os.time()
    local nextTriggerHHMM = os.date("%H:%M", triggerTime)

    print("AutoEject: Next trigger at " .. nextTriggerHHMM .. " (" .. nextTrigger / 60 .. " minutes from now)")
    
    return nextTrigger
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

  -- Create and start the timer
  self.ejectTimer = hs.timer.doAfter(getNextTriggerTime(self.ejectDailyAt), function(t)
    stopBackup()
    ejectDisk()
    -- Restart the timer for the next day
    self.ejectTimer:setNextTrigger(getNextTriggerTime(self.ejectDailyAt))
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