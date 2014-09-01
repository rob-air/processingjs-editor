<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>Processing.js editor</title>

		<!-- Bootstrap -->
		<link href="css/bootstrap.min.css" rel="stylesheet">
		<link href="css/bootstrap-theme.min.css" rel="stylesheet">
		<link href="css/app.css" rel="stylesheet">

		<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
		<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
		<!--[if lt IE 9]>
		<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
		<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
		<![endif]-->
	</head>
	<body class="ace-monokai">
		<div role="navigation" id="navbar" class="navbar navbar-inverse navbar-fixed-top">
			<div class="container-fluid">
				<button onclick="runSketch();" type="button" id="action_run" class="btn btn-primary btn-sm"><span class="glyphicon glyphicon-play"></span> Run</button>
				<!--
				<button onclick="convertToJS();" type="button" value="" class="btn btn-sm btn-default">Convert to JS</button>
				<button onclick="generateDataURI();" type="button" value="" class="btn btn-sm btn-default">Generate Data URI</button>
				-->
				<button onclick="saveData();" type="button" id="action_save" class="btn btn-sm btn-default"><span class="glyphicon glyphicon-save"></span> Save</button>
				<div class="btn-group btn-group-sm">
					<button onclick="restoreData();" type="button" id="action_reload" class="btn btn-sm btn-default"><span class="glyphicon glyphicon-open"></span> Reload</button>
					
					<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
						<span class="caret"></span>
						<span class="sr-only">Toggle Dropdown</span>
					</button>
					<ul class="dropdown-menu" role="menu" id="list_sketches">
						<li><a id="action-listsketches" onclick="listSketches(); this.style.display = 'none';" href="#">List available sketches</a></li>
					</ul>

				</div>
				<button onclick="saveImage('modsketch_sketch', true);" type="button" id="action_export" class="btn btn-sm btn-default"><span class="glyphicon glyphicon-picture"></span> Screenshot</button>
			</div>

		<!-- Nav tabs -->
		<ul class="nav nav-pills" role="tablist" id="tablist">
		</ul>

		<ul class="nav nav-pills" id="actionlist">
			<li><a id="opennewtab" class="active"><span class="glyphicon glyphicon-plus"></span> New tab</a>
		</ul> 

			
		</div>

		<!-- Tab panes -->
		<div class="container-fluid tab-content" id="tabcontainer">			
		</div>

		<div id="output"></div>

		<div class="modal" id="screenshot" tabindex="-1" role="dialog" aria-labelledby="screenshot_label" aria-hidden="true">
			<div class="modal-dialog modal-inverted">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
						<h4 class="modal-title" id="screenshot_label">Screenshot</h4>
					</div>
					<div class="modal-body"><img src="" id="screenshot_img" /></div>
					<div class="modal-footer"></div>
				</div>
			</div>
		</div>

		<div class="modal" id="modsketch" tabindex="-1" role="dialog" aria-labelledby="modsketch_label" aria-hidden="true">
			<div class="modal-dialog modal-inverted">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
						<h4 class="modal-title" id="modsketch_label">Sketch window</h4>
					</div>
					<div class="modal-body" id="modsketch_container">
						<canvas id="modsketch_sketch"></canvas>
					</div>
					<div class="modal-footer">
						<button onclick="saveImage('modsketch_sketch');" type="button" id="action_export" class="btn btn-xs btn-default"><span class="glyphicon glyphicon-picture"></span> Screenshot</button>
					</div>
				</div>
			</div>
		</div>
		
		<script src="js/require.js"></script>
		<script src="js/processing.js"></script>
		<script src="js/processing-helper.js"></script>
		<script src="js/script.js"></script>
	</body>
</html>
