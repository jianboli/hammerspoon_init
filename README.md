# hammerspoon_init
The init file for hammerspoon. To use it, please direct download or copy the content of the `init.lua` into the configuration file of hammerspoon. Then click the `reload config` button.

Here are some of the functions that this init file do:
1. Hot keys to quickly moving windows around
  * {"cmd", "alt", "ctrl"} + "Left": move the window to occupy the left half screen
  * {"cmd", "alt", "ctrl"} + "Right": move the window to occupy the right half screen
  * {"cmd", "alt", "ctrl"} + "Up": move the window to occupy the *full* screen
  * {"cmd", "alt", "ctrl"} + "Down": move the window to occupy the botton half screen
  * {"cmd", "alt", "ctrl"} + "f": toggle fullscreen
  * {"cmd", "alt", "ctrl"} + "n": move the window to next screen
2. Hot keys to quickly moving windows around without change its other dimension
  * {"cmd", "ctrl"} + "Left": Set the window width to half of the screen and move it to the left side without change the height
  * {"cmd", "ctrl"} + "Right": Set the window width to half of the screen and move it to the right side without change the height
  * {"cmd", "ctrl"} + "Up": Set the window height to half of the screen and move it to the top  without change the width
  * {"cmd", "ctrl"} + "Down": Set the window height to half of the screen and move it to the bottom without change the width
3. Apply different layout when the number of minitors are different
  * {"cmd", "alt", "ctrl"} + "1": apply pre-defined layout
4. Some short keys to bring up some applications
  * Please check the code at the bottom of the file for different key bindings
