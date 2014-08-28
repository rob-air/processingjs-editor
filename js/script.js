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
	window.ace = ace;

});

require(['jquery-ui', 'bootstrap'], function($, _bootstrap) {
	jQuery(document).ready(function() {
		destroyTabs();
		initTab(0);
		
		jQuery(".modal").draggable({
			handle: ".modal-header"
		});


		listSketches();


		jQuery('#tablist a').click(function (e) {
			e.preventDefault()
			jQuery(this).tab('show')
		})
	});
	return {};
});

function initTab(tabId, tabLabel) {
	var label = tabLabel || 'code'+tabId;
	var active = tabId==0? ' active': '';
	jQuery('<li class="'+active+'"><a href="#code'+tabId+'" role="tab" data-toggle="tab">'+label+'</a></li>').appendTo(jQuery('#tablist'));
	jQuery('<div class="code tab-pane'+active+'" id="code'+tabId+'"></div>').appendTo(jQuery('#tabcontainer'));

	if (!window.editor.pjstabs || typeof window.editor.pjstabs === 'undefined') window.editor.pjstabs = [];
	window.editor.pjstabs[tabId] = window.ace.edit('code'+tabId);
	window.editor.pjstabs[tabId].setTheme('ace/theme/monokai');
	window.editor.pjstabs[tabId].getSession().setMode('ace/mode/java');
	window.editor.pjstabs[tabId].getSession().setTabSize(4);
	window.editor.pjstabs[tabId].getSession().setUseSoftTabs(true);
}

function destroyTabs() {
	i=0;
	jQuery('#tablist li').each(function() {
		console.log(jQuery(this));
		jQuery(this).remove();
		i++;
	});

	j=0;
	jQuery('#tabcontainer div.code').each(function() {
		jQuery(this).remove();
		j++;
	});

	window.editor = [];
	window.editor.pjstabs = [];
}

function saveData(tabId) {
	localStorage.setItem("processing_sketch", editor.pjstabs[tabId].getValue());
	log('Sketch saved in browser localStorage');
}

function restoreData(tabId) {
	var sketch = localStorage.getItem("processing_sketch");
	if (sketch!=null && sketch!="") {
		editor.pjstabs[tabId].setValue(localStorage.getItem("processing_sketch"));
		log('Sketch restored from browser localStorage');
	} else {
		loadSketch('default.pde');
	}
}

function loadSketch(sketch, tab) {
	var tab = tab || 0;
	var sketch = sketch || 'default.pde';

	jQuery.get("pde/"+sketch, function(data) {

		window.editor.pjstabs[tab].setValue(data);
		log(sketch+' sketch loaded');
	});
}

function loadProject(sketches) {
	var sk = sketches.split(',');
	var tab = 0;
	destroyTabs();

    for (var i = 0; i < sk.length; i++) {
console.log(i);
        initTab(i, sk[i]);
        loadSketch(sk[i], i);
        tab++;
    };

}

function getSketch() {
	var globalSketch = '';
	for (var i = 0; i < editor.pjstabs.length; i++) {
		globalSketch += editor.pjstabs[i].getValue();
	};

	return globalSketch;
}

function listSketches() {
	jQuery.get("pde/list.php", function(data) {
		var list = jQuery('#list_sketches');
		
		for (var i in data) {
			//console.log(data[i]);
			if (typeof data[i] === 'string') {
				jQuery('<li><a href="#" class="sketchload" onclick="loadProject(\''+data[i]+'\');">'+data[i]+'</a></li>').appendTo(list);
			} else if (typeof data[i] === 'object') {
				var sketches = '';
				for (var j = data[i].length - 1; j >= 0; j--) {
					if (j<data[i].length - 1) sketches += ',';
					sketches += i+'/'+data[i][j];

				};
				jQuery('<li><a href="#" class="sketchload" onclick="loadProject(\''+sketches+'\');">'+i+' <span class="badge">'+data[i].length+'</span></a></li>').appendTo(list);
			}
		}

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

