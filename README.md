# AutoEject.spoon

This Hammerspoon allows you to set automatic daily time that ejects (TimeMachine external) disk. Useful if using external disk to make backups and you are using dock.

> [!NOTE]
> Due to OS limitations, I could not figure out a way to mount the disk automatically. This is limitation most likely caused by the encryption of the disk.

## Installation

This tool requires [Hammerspoon](https://www.hammerspoon.org/) to be installed and running.

### Option 1: Use Git

In the Terminal:

```bash
mkdir -p ~/.hammerspoon/Spoons
git clone https://github.com/jussivesa/AutoEject.spoon.git ~/.hammerspoon/Spoons/AutoEject.spoon
```

And then continue with the Usage section.

## Usage

After you installed AutoEject, add this to your `~/.hammerspoon/init.lua` file:

```lua
local AutoEject = hs.loadSpoon("AutoEject"):start()
```

Then reload your Hammerspoon configuration. This will start AutoEject with the default settings. To adjust the configuration, see the Configuration section below.

You can temporarily stop the spoon by calling `AutoEject:stop()` and then restart it by calling `AutoEject:start()` again.

### Configuration

```lua
local AutoEject = hs.loadSpoon("AutoEject"):configure{
  ejectDailyAt = "14:30"
}:start()
