VolumeBar9
==========

A replacement for the disruptive, rounded-square volume HUD included with stock iOS. Only for jailbroken devices.

Now the HUD is a small slider at the top of the screen, with many customizable options and features, and an easier way to change the volume quickly. This project stems from my previous project, [VolumeBar](https://github.com/cgm616/VolumeBar). Confirmed to work on iOS 9.3.3, on an iPhone 6S set to the resolution of an iPhone 6S+. There doesn't seem to be a reason for it not to work on iOS 9.3.2 and below, but it has not been tested (yet), and it also hasn't been extensively tested on any other devices. iPads in particular may cause bugs concerning the bigger screens.

Please contribute to the project! Fix memory leaks, add improvements, anything really. The code is very, very bad. In particular the VolumeBar class is all stateful, which I hope can be fixed at some point.

[![GitHub release](https://img.shields.io/github/release/cgm616/volumebar9.svg?maxAge=2592000)](https://github.com/cgm616/VolumeBar9/releases)

Table of contents
=================

- [VolumeBar9](#volumebar9)
- [Table of contents](#table-of-contents)
- [Install](#install)
- [Changelog](#changelog)
- [License](#license)
- [Contributing](#contributing)
- [Contributors](#contributors)


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
