processingjs-editor
===================

My try at building a web-based code editor for Processing.js

This is an experiment around Processing.js, aiming towards the creation of a full-featured web-based code editor for the awesome language that Processing is.
It's first been thought as a "playable demo" for a few sketches I wrote, the main goal for this was to highlight the power and ease of use of Processing.

Any help or ideas are welcome, I don't mind beginners trying out their skills.


####Requirements (not much):
* PHP 4+ (see notes)
* An up-to-date browser on your client (html5, canvas, localStorage)

####Based on:
* the helper script from the official website http://processingjs.org/tools/processing-helper.html
* Twitter bootstrap http://getbootstrap.com/
* Ace editor http://ace.c9.io/#nav=about
* RequireJS lib http://requirejs.org/

####Todo:
* Improve sketch control during execution (pause/stop button, clean exit, framerate, ...)
* Add a Processing "mode" for Ace
* Use a package controller to limit the size of this repo
* Add server-side saves and versioning
* _DONE Use tabs just like the Processing PDE for sketches that need multiple files_ 
* Use permalink-type URLs for sketches and versions
* ?Collaborative edition maybe?

####Notes
No database nor configuration needed. The app should run right out of the box.
I use PHP as a prototyping help for XHR communications and sketch loading. If you don't want or can't use PHP on your server, here's what you'll need to do:
* Obviously remove any PHP code from the files and rename them, there are only two: index.php and pde/list.php
* The PHP code inside index.php can simply be removed without breaking anything
* The PHP code inside pde/list.php on the other hand is used by the app to fetch a list of all files inside that directory, the most straightforward way to get rid of that file without breaking the app is to hard-code a JSON array listing the files. You'll still need to change the link to that list.php file inside js/script.js (function listSketches), so don't forget that.
