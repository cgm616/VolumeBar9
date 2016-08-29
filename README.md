VolumeBar9
==========

A replacement for the disruptive, rounded-square volume HUD included with stock iOS. Only for jailbroken devices.

When you press the volume buttons, a small banner now appears at the top of the screen with a slider. This slider shows the current volume, is updated when the volume buttons are pressed, and can be moved to change the volume as well!

VolumeBar9 has many customizable options, from the colors of the banner and slider to interaction with the banner itself.

This project stems from my previous project, [VolumeBar](https://github.com/cgm616/VolumeBar).

VolumeBar9 is confirmed to work on iOS 9.3.3, on an iPhone 6S set to the resolution of an iPhone 6S+. There doesn't seem to be a reason for it not to work on iOS 9.3.2 and below, but it has not been tested (yet), and it also hasn't been extensively tested on any other devices. iPads in particular may cause bugs concerning the bigger screens.

[![Cydia repo](https://img.shields.io/badge/repo-cgm616.me%2Frepo-blue.svg)](https://cgm616.me/repo)
[![GitHub release](https://img.shields.io/github/release/cgm616/volumebar9.svg?maxAge=2592000)](https://github.com/cgm616/VolumeBar9/releases)

Table of contents
=================

- [VolumeBar9](#volumebar9)
- [Table of contents](#table-of-contents)
- [Features](#features)
- [Install](#install)
- [Changelog](#changelog)
- [License](#license)
- [Contributing](#contributing)
- [Contributors](#contributors)


Features
========

Currently, VolumeBar9 is full of features that users have asked for. However, there's always room for improvement, so feel free to suggest more.

- Interactive slider to control volume, in a small non-irritating banner
- Works on both the ringer and the player volumes
  - Icons to differentiate between modes, or alternatively a mode label
- Handles orientation change events and animates changing
- Can be themed in many different ways to fit any device theme
  - Banner can be blurred in three different styles, or custom-colored
  - Slider track can be colored a color of your choice
- Can be dismissed by a easy, user-controlled gesture
- UI elements automatically change color to maximize contrast
- Animation and time the banner appears can be customized


Install
=======

To install on a jailbroken iOS device, add my Cydia repo: [cgm616.me/repo/](https://cgm616.me/repo/). Then install the VolumeBar9 package.

It has a few dependencies: [libcolorpicker](http://git.pixelfiredev.com/pixelfire/libcolorpicker) and [libobjcipc](https://github.com/a1anyip/libobjcipc), which are both most likely installed already on your device.

Alternatively, you can install and setup [theos](https://github.com/theos/theos), clone this repo, and build it and install it on your device with:

    make do

In addition to both of those methods, deb files can be downloaded from the GitHub [releases page](https://github.com/cgm616/VolumeBar9/releases). Then, they will need to be transferred to the device and installed using iFile, Filza, some other file manager, `aptitude`, or `dpkg`.


Changelog
=========

Every new update pushed on my Cydia repo is also tagged and signed, which can be seen on the GitHub [tags page](https://github.com/cgm616/VolumeBar9/tags).

These tags have small descriptions of changes, which are also copied below. Longer versions can be found on the GitHub [releases page](https://github.com/cgm616/VolumeBar9/releases).

- [v0.3.2-beta](https://github.com/cgm616/VolumeBar9/releases/tag/v0.3.2-beta) | August 28, 2016
  - Add package depiction
- [v0.3.1-beta](https://github.com/cgm616/VolumeBar9/releases/tag/v0.3.1-beta) | August 27, 2016
  - Fix and clarify language in preferences
- [v0.3.0-beta](https://github.com/cgm616/VolumeBar9/releases/tag/v0.3.0-beta) | August 27, 2016
  - Add icons to either side of slider and option
  - Reorganize preferences slightly
  - Fix some problems with slide to dismiss
  - Add other ways to dismiss slider
- [v0.2.0-beta](https://github.com/cgm616/VolumeBar9/releases/tag/v0.2.0-beta) | August 25, 2016
  - Fix orientation changes in apps
  - Start with correct orientation
  - Bar now resizes for orientation
  - Ringer volume slider now works correctly
- [v0.1.2-beta](https://github.com/cgm616/VolumeBar9/releases/tag/v0.1.2-beta) | August 23, 2016
  - Timer resets on volume change or slider touch
  - Status bar hides when the volumebar is shown, and shows after it disappears
- [v0.1.1-beta](https://github.com/cgm616/VolumeBar9/releases/tag/v0.1.1-beta) | August 13, 2016
  - Add ability to set custom slider track colors
- v0.1.0-beta | (not tagged)
  - Initial version
  - Same functionality as VolumeBar, but updated to work on iOS 9


License
=======

All of the code I have written in this project, which is most of it, along with some snippets from StackOverflow and otherwise, is licensed under the MIT License.

The full text of this License is below, contained in the [LICENSE.md](https://github.com/cgm616/VolumeBar9/blob/master/LICENSE.md) file, and available at [choosealicense.com](http://choosealicense.com/licenses/mit/).

> The MIT License (MIT)
>
> Copyright (c) 2015 - 2016 Cole Graber-Mitchell / cgm616
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> SOFTWARE.


Contributing
============

If you find something you can fix or otherwise make better, please feel free to do so. Another way to contribute is create GitHub issues for features you want and bugs you find. I need help testing the tweak on many different devices.

Fork the repo and create a pull request here on GitHub and I'll take a look. In your fork, add yourself to the contributors list below as well!


Contributors
============

- [cgm616](https://github.com/cgm616) (author)
