# SimpleSwingTimer

A minimal swing timer addon for World of Warcraft 3.3.5a (Wrath of the Lich King).

## Features

- **Simple and Lightweight**: No complex configuration, just the essentials
- **Single Swing Timer**: Shows one bar for melee weapon swings
- **Visual Feedback**: Yellow progress bar with remaining time display
- **Movable**: Drag and drop positioning when unlocked
- **Lock/Unlock**: Prevent accidental movement during gameplay

## Installation

1. Download the addon files
2. Extract to your `World of Warcraft/Interface/AddOns/` folder
3. Create a folder named `SimpleSwingTimer`
4. Place all addon files in that folder
5. Restart WoW or reload your UI (`/reload`)

## Usage

### Commands

- `/sst` or `/simpleswingtimer` - Show help
- `/sst lock` - Lock the bar in place
- `/sst unlock` - Unlock the bar for moving (shows test bar)
- `/sst reset` - Reset bar position to default
- `/sst test` - Test the bar for 5 seconds
- `/sst status` - Show current addon status

### How It Works

- The addon automatically detects when you swing your weapon
- Shows a single yellow progress bar during melee combat
- Bar persists when switching targets (only hides when leaving combat)
- Displays remaining time until next swing

### Positioning

1. Type `/sst unlock` to enable movement (bar will appear for positioning)
2. Click and drag the bar to your desired position
3. Type `/sst lock` to prevent accidental movement (test bar will hide)

## Requirements

- World of Warcraft 3.3.5a (WotLK)
- No additional libraries required

## Customization

The addon uses default WoW textures and colors. If you want to modify colors or sizes, you can edit the `settings` table in the main file.

## Troubleshooting

- **Bar not showing**: Make sure you're in combat and swinging weapons
- **Can't move bar**: Use `/sst unlock` first
- **Addon not loading**: Check that the folder structure is correct

## License

GPL v2 - Same as the original Quartz addon that inspired this project.

## Credits

Based on the swing timer functionality from Quartz addon, simplified for minimal use.
