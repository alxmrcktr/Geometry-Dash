# How to Edit Level 2 in Godot

## Opening Level 2

1. **Open Godot Engine** on your computer
2. Click **"Import"** or **"Open"** existing project
3. Navigate to: `C:\Users\alxmr\Geometry Dash Ai\game`
4. Select the `project.godot` file and click **"Import & Edit"**

## Editing Level 2

1. In the **FileSystem** panel (usually bottom-left), navigate to:
   - `res://scenes/level_2.tscn`

2. **Double-click** on `level_2.tscn` to open it

3. You'll see the level editor with:
   - Ground blocks
   - Spikes
   - Player starting position
   - Background

## Adding Yellow Launch Pads

1. Look for the **Scene** panel (usually top-left)
2. Click the **"+" button** or **"Instantiate Child Scene"** (chain link icon)
3. Navigate to `res://scenes/yellow_pad.tscn`
4. Click **"Open"**
5. The yellow pad will appear - **click and drag** to position it
6. Place it on the ground or platforms where you want the player to get a boost

## Modifying the Level

### Moving Objects:
- Click on any object in the scene tree or viewport
- Use the **transform tools** (arrow icon) to move it
- Or change the **position** values in the Inspector panel (right side)

### Adding More Obstacles:
1. Click the **"+"** button in Scene panel
2. Select:
   - `spike.tscn` for death spikes
   - `ground_block.tscn` for platforms
   - `yellow_pad.tscn` for launch pads

### Deleting Objects:
- Right-click on the object in the Scene tree
- Select **"Delete Node"**

## Changing the Level Length

The player completes the level at `x = 12000` (see player.gd line 52)

To make Level 2 longer or shorter:
1. Open `res://scenes/level_2.tscn`
2. Click on the **Player** node in the scene tree
3. Click the script icon or open `player.gd`
4. Find line 52: `if global_position.x > 12000:`
5. Change `12000` to a different value (e.g., `15000` for longer)

## Saving Your Changes

1. Press **Ctrl + S** or click **File → Save Scene**
2. Your changes are automatically saved!

## Testing Level 2

1. Click the **"Play" button** (▶) at the top-right of Godot
2. Select **Level 2** from the menu
3. Test your changes!

## Tips for Level Design

- Place yellow pads before gaps or tall obstacles
- Mix easy and hard sections
- Test frequently to ensure it's playable
- Add variety with different spike patterns
- Use platforms at different heights

## Quick Reference

**Yellow Pad Launch Power**: -1200 (vs normal jump -750)
**Player Speed**: 350 pixels/second
**Jump Height**: About 3-4 ground blocks
**Yellow Pad Height**: About 5-6 ground blocks

Happy level designing! 🎮
