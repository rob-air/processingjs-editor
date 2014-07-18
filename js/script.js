require.config({
	paths: {
		'ace': 'js/ace',
		'jquery': 'js/jquery.min', // v1.11.1
		'jquery-ui': 'js/jquery-ui.min',
		'bootstrap': 'js/bootstrap.min'/*,
		'processing': 'js/processing',
		'processing-helper': 'js/processing-helper',
		'jsbeautify': 'js/jsbeautify'*/
	},
	shim: {
		'jquery-ui': 	{ deps: ['jquery'] },
		'bootstrap': 	{ deps: ['jquery'] },
		'bootstrap/affix':      { deps: ['jquery'], exports: '$.fn.affix' }, 
		'bootstrap/alert':      { deps: ['jquery'], exports: '$.fn.alert' },
		'bootstrap/button':     { deps: ['jquery'], exports: '$.fn.button' },
		'bootstrap/carousel':   { deps: ['jquery'], exports: '$.fn.carousel' },
		'bootstrap/collapse':   { deps: ['jquery'], exports: '$.fn.collapse' },
		'bootstrap/dropdown':   { deps: ['jquery'], exports: '$.fn.dropdown' },
		'bootstrap/modal':      { deps: ['jquery'], exports: '$.fn.modal' },
		'bootstrap/popover':    { deps: ['jquery'], exports: '$.fn.popover' },
		'bootstrap/scrollspy':  { deps: ['jquery'], exports: '$.fn.scrollspy' },
		'bootstrap/tab':        { deps: ['jquery'], exports: '$.fn.tab'        },
		'bootstrap/tooltip':    { deps: ['jquery'], exports: '$.fn.tooltip' },
		'bootstrap/transition': { deps: ['jquery'], exports: '$.fn.transition' }/*,
		'processing-helper': { deps: ['processing'] }*/
	}
});

// Load the ace module
require(['ace/ace'], function(ace) {
	// Set up the editor
	window.editor = ace.edit('code');
	window.editor.setTheme('ace/theme/monokai');
	window.editor.getSession().setMode('ace/mode/java');
	// etc...
});

require(['jquery-ui', 'bootstrap'], function($, _bootstrap) {
	jQuery(document).ready(function() {
		jQuery(".modal").draggable({
			handle: ".modal-header"
		});
		listSketches();
	});
	return {};
});

function saveData() {
	localStorage.setItem("processing_sketch", editor.getValue());
	log('Sketch saved in browser localStorage');
}

function restoreData() {
	var sketch = localStorage.getItem("processing_sketch");
	if (sketch!=null && sketch!="") {
		editor.setValue(localStorage.getItem("processing_sketch"));
		log('Sketch restored from browser localStorage');
	} else {
		loadSketch('default.pde');
	}
}

function loadSketch(sketch) {
	var sketch = sketch || 'default.pde';
	jQuery.get("pde/"+sketch, function(data) {
		editor.setValue(data);
		log(sketch+' sketch loaded');
	});
}

function listSketches() {
	jQuery.get("pde/list.php", function(data) {
		var list = jQuery('#list_sketches');
		for (var i = data.length - 1; i >= 0; i--) {
			if (data[i]=='default.pde') continue;
			jQuery('<li><a href="#" class="sketchload" onclick="loadSketch(this.innerHTML);">'+data[i]+'</a></li>').appendTo(list);
		};
		jQuery('<li class="divider"></li>').appendTo(list);
		jQuery('<li><a href="#" class="sketchload" onclick="loadSketch(this.innerHTML);">default.pde</a></li>').appendTo(list);
		jQuery('#action-listsketches').hide();
	}, 'json');
}

function log(str) {
	Processing.logger.println(str);
	console.log(str);
}

function saveImage(sketchId, modal) {
	var modal = modal==true? true: false;
	var pjs = Processing.getInstanceById(sketchId);
	var imgdata = pjs.externals.canvas.toDataURL();
	if (modal) {
		jQuery('#screenshot_img').prop('src', imgdata);
		$('#screenshot').modal();
		setModalSize();
	}
	log('Image export: <a target="_blank" href="'+imgdata+'">right-click save</a>');
}

function getSketchSize(sketchId) {
	var pjs = Processing.getInstanceById(sketchId);
	return {width:pjs.width, height:pjs.height};
}

function setModalSize() {
	var sketch = getSketchSize('modsketch_sketch');
	jQuery('.modal .modal-dialog').css({
		width: sketch.width,
		height: sketch.height
	});
}