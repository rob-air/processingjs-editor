processingjs-editor
===================

My try at building a web-based code editor for Processing.js

This is a personnal experiment around Processing.js, aiming towards the creation of a full-featured web-based code editor for the awesome language that it is.
It's first been thought as a "playable demo" for a few sketches I wrote. My initial goal for this was to highlight the power and ease of use of Processing.

Any help is welcome, I don't mind beginners trying out their skills as mine ain't that high.

Based on:
* the helper script from the official website http://processingjs.org/tools/processing-helper.html
* Twitter bootstrap http://getbootstrap.com/
* Ace editor http://ace.c9.io/#nav=about
* RequireJS lib http://requirejs.org/

Todo:
* Improve sketch control during execution (pause/stop button, framerate, ...)
* Add a Processing "mode" for Ace
* Use a package controller to limit the size of this repo
* Add server-side saves and versioning
* Use tabs just like the Processing PDE for sketches that need multiple files (currently only signe-file sketches allowed)
* Use permalink-type URLs for sketches (done) and versions (todo)
* ?Collaborative edition maybe?