# KomicsReader

## TODOs:
* [x] save index of read files and reload it on startup
* [x] change the "remember file index" method from filepath to hash with [this](https://doc.qt.io/qt-5/qcryptographichash.html) (I did it with just the filesize)
* [x] "open" action doesn't load the image if the current one was at position 0, fix (perhaps with a timer)
* [x] "open" action doesn't work with files with `#` in it, fix
* [x] touchscreen doesn't work anymore????? WTF??? (it doesn't work inside a `Kirigami.Page`) ~~TODO REPORT BUG!~~ (done)
* [x] display a busyindicator before unzipping
* [ ] sometimes ark fails (but the files are extracted correctly), understand why and fix
* [x] change color of leftbar (perhaps not transparent?)
* [x] hide leftbar on fullscreen and show on windowed
* [x] change every hardcoded color so that they follows the color scheme
* [ ] add a help button
* [x] add also a "rotate clockwise" button
* [ ] load the page before and after so that the switching will be faster
* [ ] (important) instead of extracting the whole file, just take the images you need time by time with karchive