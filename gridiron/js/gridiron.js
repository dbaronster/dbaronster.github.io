/*  Gridiron JavaScript framework, version 1.0 
 *    (c) 2007 Doug Baron
 *  Gridiron is freely distributable under the terms of an MIT-style license.
 *--------------------------------------------------------------------------*/

var gridiron = {};
gridiron.instance;

gridiron.load = function(xmlSource) {
	gridiron.instance = new gridiron.Controller(xmlSource);
	return gridiron.instance;
}

gridiron.Player = function(element) {
	this.playerMetrics = new Array(/*Metric*/);
	for (var i in element.childNodes) {
		var field = element.childNodes[i];
		if (field.nodeType == 1)
			this.playerMetrics[ field.nodeName ] = field.textContent;
	}
}

gridiron.Player.prototype = {
	getMetricValue : function(key) { return this.playerMetrics[key]; },
}

/*
	these are the attributes, the performance and meta data collected for each player
*/
gridiron.Player.keys = {
	FIRSTNAME : "firstName",
	LASTNAME : "lastName",
	GRADYEAR : "gradYear",
	HEADCOACH : "headCoach",
	HIGHSCHOOL : "highSchool",
	OFFPOSITION : "offPosition",
	DEFPOSITION : "defPosition",
	ZIPCODE : "zipCode",

	TIME10 : "time10",
	TIME20 : "time20",
	TIME40 : "time40",
	TIMESHUTTLE : "timeShttl",
	
	HEIGHT : "height",
	WEIGHT : "weight",
	SQUAT : "squat",
	SQUATREPS : "squatReps",
	BENCH : "bench",
	BENCHREPS : "benchReps",
	BROADJUMP : "broadJmp",
	VERTJUMP : "vertJmp"
};

// 'alias' keys to shorten collection literals
var _pk = gridiron.Player.keys;
gridiron.Player.keys.SPEED_KEYS = new Array (_pk.TIME10, _pk.TIME20, _pk.TIME40, _pk.TIMESHUTTLE );
gridiron.Player.keys.POWER_KEYS = new Array ( _pk.SQUAT, _pk.SQUATREPS, _pk.BENCH, _pk.BENCHREPS );
gridiron.Player.keys.EXPLOSIVE_KEYS = new Array (_pk.BROADJUMP, _pk.VERTJUMP );
gridiron.Player.keys.PLAYER_KEYS = new Array ( _pk.FIRSTNAME, _pk.LASTNAME, _pk.HEIGHT, _pk.WEIGHT );
gridiron.Player.keys.TEAM_KEYS = new Array ( _pk.GRADYEAR, _pk.HIGHSCHOOL, _pk.HEADCOACH, _pk.ZIPCODE );
gridiron.Player.keys.BODY_KEYS = new Array (_pk.HEIGHT, _pk.WEIGHT );
gridiron.Player.keys.POSITION_KEYS = new Array (_pk.OFFPOSITION, _pk.DEFPOSITION );

gridiron.isMemberOf = function (obj, list) {
	return $.inArray(obj, list) > -1;
}

gridiron.Metric = function(key, value) {
	this.key = key;
	this.isSpeed = gridiron.isMemberOf(key, gridiron.Player.keys.SPEED_KEYS);
	this.isNumeric = this.isSpeed || gridiron.isMemberOf(key, gridiron.Player.keys.POWER_KEYS) 
	|| gridiron.isMemberOf(key, gridiron.Player.keys.EXPLOSIVE_KEYS) || gridiron.isMemberOf(key, gridiron.Player.keys.BODY_KEYS);
	if (this.isNumeric)
		this.value = Number(value);
	else
		this.value = value.toLowerCase();
}

gridiron.Metric.prototype = {
	isNumeric: function() {
		return this.isNumeric();
	},
	compareValueTo: function(value) {
		if (this.isNumeric) {
			value = Number(value);
			var diff = value - this.value;
			if (this.isSpeed)
				diff = -diff;
			return diff;
		} else {
			value = value.toLowerCase();
			return (value == this.value)? 0 : ((value > this.value)? 1 : -1);
		}
	},
	test: function(value) { // test value for satisfying this metric
		if (this.isNumeric) {
			value = Number(value);
			var diff = value - this.value;
			if (this.isSpeed)
				diff = -diff;
			return diff >= 0;
		} else {
			value = value.toLowerCase();
			return value.indexOf(this.value) == 0;
		}
	}
}

gridiron.Recruiter = function (players) {
	this.players = this.recruits = players;
	this.reset();
}

gridiron.Recruiter.prototype = {
	getPlayers: function() {
		return this.players;
	},

	getRecruits: function() {
		return this.recruits;
	},
	
	getCriteria: function() {
		return this.criteria;
	},
	
	getSearchSpec: function() {
		return this.criteria;
	},
	
	getSelectedCriterion: function() {
		return this.selectedCriterion;
	},
	
	setSelectedCriterion: function(value) {
		 this.selectedCriterion = value;
	},
	
	addCriterion: function(key, value) {
		this.criteria.push(new gridiron.Metric(key, value));
		this.recruits = this.filter(this.players, this.criteria);
		this.sort(this.recruits, this.criteria);
	},
	
	getCriterion: function(key) {
		return this.criteria.find(function(metric) {
			return metric.key == key;
		});
	},
	
	deleteCriterion: function(key, value) {
		this.criteria.without(key);
	},
	
	reset: function() {
		//if (confirm("Discard these filters?"))
		this.criteria = new Array();
		this.recruits = new Array();
		this.selectedCriterion = "";
	},

	filter: function(candidates, criteria) {
		var recruits = new Array();
		
		for (var i = 0; i < candidates.length; i++) {
			var player = candidates[i];
			
			for (var j = 0; j < criteria.length; j++) {
				var need = criteria[j];
				var key = need.key;
				var got = player.getMetricValue(key);
				if (got == null) {
					throw("missing key " + key);
				}
				if (!need.test(got)) { // filter it
					player = undefined;
					break;
				}
			}
			
			if (player)
				recruits.push(player);
		}
		
		return recruits;
	},
	
	
	/*
	 * sort the list of players according to the criteria provided
	 * the first criteria is the primary sort, the second the secondary, etc.
	 * @return inverse sorted list of the players input
	 */
	sort: function(recruits, criteria) {
		
		if (recruits == null)
			return;
		
		try {
			recruits.sort(function(m1, m2) {
				for (var i= 0; i < criteria.length; i++) {
					var key = criteria[i].key;
					var metric = new gridiron.Metric(key, m1.getMetricValue(key));
					var cmp = metric.compareValueTo(m2.getMetricValue(key));
					if (cmp != 0)
						return cmp;
				}
				return 0;});
		} catch (e) {
			alert("e?"+e);
		}
	}
}

gridiron.Controller = function(xmlSource) {
	this.players = new Array();
	var xmlDoc = gridiron.util.loadXmlDoc(xmlSource);
	var elements = xmlDoc.getElementsByTagName('player');
	for (var i = 0; i < elements.length; i++) { 
		this.players.push(new gridiron.Player(elements[i]));
	}
	this.recruiter = new gridiron.Recruiter(this.players);
	//this.view = new gridiron.View("start");
}

gridiron.Controller.prototype = {
	players : function() {
		return this.players;
	},
	cancel : function () {
		history.back();
	},
	back: function() {
		history.back();
	},
	shutdown: function() {
		alert("bye!");
		this.action = gridiron.Control.actions.RESET;
	},
	pick: function() {
		this.action = gridiron.Control.actions.ADD_CRITERION;
	},
	start: function() {
		this.setView("start");
	},
	resetForm: function() {
		$("#playerForm")[0].reset();
	},
	pickCriterion: function(e) {
		var key = e.value;
		this.recruiter.setSelectedCriterion(key);
		//if (this.recruiter.getCriterion(key) != undefined)
			//this.recruiter.deleteCriterion(key);
		//else
			this.setView("pick");
	},
	review: function() {
		if (this.recruiter.getCriteria().length > 0) {
			this.setView("review");
		} else
			this.setView("start");
	},
	acceptCriterion: function() {
		var metricValue = $("#metricValue").val();
		this.recruiter.addCriterion(this.recruiter.getSelectedCriterion(), metricValue);
		this.review();
		this.resetForm();
	},
	cancelCriterion: function() {
		this.review();
		this.resetForm();
	},
	startOver: function() {
		this.recruiter.reset();
		this.start();
	},
	viewResults: function() {
		this.setView("print");
	},
	setView: function(view) {
//		var componentsToHide = Object.keys(gridiron.view.components);
		var state = gridiron.view.states[view];
		var shownComponents = gridiron.view.shownComponents;
		for (var i = 0; i < shownComponents.length; i++) {
			if (!gridiron.isMemberOf(shownComponents[i], state))
				$("#"+shownComponents[i]).hide();
		}
		for (var i = 0; i < state.length; i++ ) {
			var componentKey = state[i];
			var renderer = gridiron.view.renderers[componentKey];
			if (jQuery.isFunction(renderer)) {
				var content = renderer(this.recruiter);
				$("#"+componentKey).html(content);
			}
			if ($.inArray(componentKey, shownComponents) == -1) {
				$("#"+componentKey).fadeIn( "slow" );
			}
			else {
				$("#"+componentKey).show();
			}
		}
		gridiron.view.shownComponents = state;
		
		//window.setTimeout(function() {
				var focusControl = $("#metricValue");
				if (focusControl && focusControl.type != "hidden") { focusControl.focus(); }
		//}
		// , 300);
	}
}

gridiron.view = {
	shownComponents: [],

	states: {
		start: ["filterView", "criteriaList", "cancelPick"],
		pick: ["filterView", "criteriaList", "metricEdit", "metricEditFields", "metricRange"],
		review: ["filterView", "criteriaList", "criteriaAction"],
		print: [ "printView", "filteredPlayerList" ],
	},

	renderers: {
		filteredPlayerList: function(recruiter) {return gridiron.view.showResults(recruiter)},
		metricEditFields: function(recruiter) {return gridiron.view.showMetricEditor(recruiter)},
		criteriaList: function(recruiter) {return gridiron.view.showCriteriaList(recruiter)},
	},
	
	init : function () {
		shownComponents = [];
	},

	showCriteriaList: function(recruiter) {
		var criteria = recruiter.getCriteria();
		var html = '<p class="title">';
		if (criteria.length == 0) {
			html += 'No filters have been set.</p>'
						+ '<p><em>To establish a filter:</em><ol>'
						+ '<li id="doPick">Click on a criterion to the right</li>'
						+ '<li>Enter a value for that metric</li>'
						+ '<li>Click the Add Criterion button</li></ol></p>';
		} else {
			html += 'Filtering on:<ol>';
			for (var i = 0; i < criteria.length; i++) {
				var metric = criteria[i];
				html += '<li>' + gridiron.view.showMetricValue(metric.key, metric.value) + '</li>';
			}
			html += '</ol></p>';
			html += gridiron.view.showMatchSummary(recruiter.getRecruits());
			html += '<p><em>To add another filter, click a criterion to the right</em></p>'
		}
		return html;
	},

	showMatchSummary: function(recruits) {
		var html = '<p>';
		var matched = recruits.length;
		var max = 100; //gridiron.model.Recruiter.MAX_MATCHES;
		var maches;
		if (matched > 0) {
			$("#viewResultsButton").show();
			matches = (matched > max) ? ("Over " + max) : (""+matched);
		} else {
			$("#viewResultsButton").hide();
			matches = "No";
		}
		html += '<p><b>' + matches + '</b> ' + (matched == 1?'player meets' : 'players meet') + ' these criteria.</p>';
		return html;
	},

	showMetricEditor: function(recruiter) {
		var criterion = recruiter.getSelectedCriterion();
		var criteria = [new gridiron.Metric(criterion, "")];
		// sort selected players by this criterion - or all players if none are selected
		var selectedPlayers = recruiter.recruits;
		if (selectedPlayers.length == 0) {
			selectedPlayers = recruiter.players;
		}
		
		recruiter.sort(selectedPlayers, criteria);
		var sortedRecruits = selectedPlayers;
		
		// grab first and last00 for range
		var firstPlayer = sortedRecruits[0];
		var lastPlayer = sortedRecruits[sortedRecruits.length-1];
		var firstPlayerMetricValue = firstPlayer.getMetricValue(criterion);
		var lastPlayerMetricValue = lastPlayer.getMetricValue(criterion);
		// show range in logical order for metric
		if (criteria[0].isSpeed) {
			$("#metricMin").html(firstPlayerMetricValue);
			$("#metricMax").html(lastPlayerMetricValue);
		}
		else {
			$("#metricMin").html(lastPlayerMetricValue);
			$("#metricMax").html(firstPlayerMetricValue);
		}
		return gridiron.view.showMetricValue(recruiter.getSelectedCriterion());
	},

	showMetricValue: function(key, value) {
		var test = gridiron.resources.metric[key];
		var rel = "begins with";
		var units = "";
		var len = "5";
		var inputs = '<input type="text" id="metricValue" size="{len}" value="" />';
		var html = '<div class="metric-value">{test} <span> {rel} </span> {val} {units}';

		if (value == undefined)
			value = inputs.replace("{len}", len);

		if (/time/.test(key)) {
			rel = "<=";
			units = "seconds";
		}
		if (/weigh/.test(key) || "squat" == key || "bench" == key) {
			rel = ">=";
			units = "pounds";
		}
		if (/Jmp/.test(key) || /heigh/.test(key)) {
			rel = ">=";
			units = "inches";
		}
		if (/Pos/.test(key) || /ear/.test(key) || /zip/.test(key)) {
			rel = "is";
		}
		if (/Reps/.test(key)) {
			rel = ">=";
		}

		inputs = inputs.replace("{len}", len);
		html = html.replace("{test}", test).replace("{rel}", rel).replace("{units}", units).replace("{val}", value);
		html += '</div>';
		return html;
	},

	showMetricGroup: function(groupKey, metricKeys) {
		var eol = '\n';
		try {
			document.write("<div class=\"metric-group\">" + eol
				+ "\t<p class=\"title\">"+ gridiron.resources.metricGroup[groupKey] +"</p>" + eol
				+ "\t<div class=\"select\">" + eol);

			for (var i = 0; i < metricKeys.length; i++) {
				document.write(
				"\t<input type=\"radio\" name=\"criterion\" value=\"" + metricKeys[i]  + "\" id=\"" + metricKeys[i] + "Metric\""
				+ " onclick=\"gridiron.instance.pickCriterion(this)\" /><span>" + gridiron.resources.metric[metricKeys[i]] + "</span><br/>" + eol);
			}

			document.write("</div>" + eol + "</div>");
		} catch (e) {
			throw ("MetricGroupTag: " + e);
		}
	},
	showResults: function(recruiter) {
		var recruits = recruiter.getRecruits();
		var matched = recruits.length;
		var html = "";
		for (var i = 0; i < matched * 1; i++) {
			var player = recruits[i/1];
			var hgt = Math.round(player.getMetricValue("height"));
			html += '<div class="break" style="line-height:1px;"><br/></div>';
			html += '<div class="player"><p>';
			html += '<span class="pid"> ' +(i+1) + '</span>\n';
			html += '<span class="player">' + player.getMetricValue("firstName") + " " + player.getMetricValue("lastName") + '</span>\n';
			html += '<span class="name">' + player.getMetricValue("highSchool") + '</span>\n';
			html += '<span class="year">&rsquo;' + player.getMetricValue("gradYear") + '</span>\n';
			html += '<span class="name">' + player.getMetricValue("headCoach") + '</span>\n';
			html += '<span class="zip">' + player.getMetricValue("zipCode") + '</span>\n';
			html += '<span class="height">' + Math.floor(hgt/12)+"' " + (hgt%12) + '"' + '</span>\n';
			html += '<span class="weight">' + player.getMetricValue("weight") + '</span>\n';
			html += '<span class="pos">' + player.getMetricValue("offPosition") + '</span>\n';
			html += '<span class="pos">' + player.getMetricValue("defPosition") + '</span>\n';
			html += '<span class="time">' + player.getMetricValue("time10") + '</span>\n';
			html += '<span class="time">' + player.getMetricValue("time20") + '</span>\n';
			html += '<span class="time">' + player.getMetricValue("time40") + '</span>\n';
			html += '<span class="time">' + player.getMetricValue("timeShttl") + '</span>\n';
			html += '<span class="power">' + player.getMetricValue("squat") + ' / ' + player.getMetricValue("squatReps") + '</span>\n';
			html += '<span class="power">' + player.getMetricValue("bench") + ' / ' + player.getMetricValue("benchReps") + '</span>\n';
			html += '<span class="expl">' + player.getMetricValue("broadJmp") + '</span>\n';
			html += '<span class="expl">' + player.getMetricValue("vertJmp") + '</span>\n';
			html += "</p></div>";
		}
		return html;
	}
}

gridiron.util = {
	loadXmlDoc : function (xmlSource) {
		var xmlDoc;
		// code for IE
		if (window.ActiveXObject) {
			 xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		}
		// code for Mozilla, Firefox, Opera, etc.
		else if (document.implementation && document.implementation.createDocument) {
			xmlDoc = document.implementation.createDocument("", "", null);
		}
		
		try {
			if (xmlDoc && xmlDoc.load) {
				xmlDoc.async = false;
				xmlDoc.load(xmlSource);
			} else {
				// fall back to ajax
				var xmlhttp = new window.XMLHttpRequest();
				xmlhttp.open("GET", xmlSource, false);
				xmlhttp.send(null);
				xmlDoc = xmlhttp.responseXML.documentElement;
			}
		} catch (e) {
			alert('Your browser cannot load does not support this application.\n' + e);
			throw e;
		}
		return xmlDoc;
	}
}

gridiron.resources = {
	metric: {
		time10: "10 Yards",
		time20: "20 Yards",
		time40: "40 Yards",
		timeShttl: "Pro Shuttle",
		squat: "Squat",
		squatReps: "Squat Reps",
		bench: "Bench",
		benchReps: "Bench Reps",
		broadJmp: "Broad Jump",
		vertJmp: "Vertical Jump",
		firstName: "First Name",
		lastName: "Last Name",
		height: "Height",
		weight: "Weight",
		gradYear: "Graduation Year",
		highSchool: "High School",
		headCoach: "Head Coach",
		zipCode: "Zip Code",
		offPosition: "Offense Position",
		defPosition: "Defense Position",
	},
	metricGroup : {
		power: "Power",
		speed: "Speed",
		explode: "Explosiveness",
		player: "Player",
		team: "Team",
		position: "Position",
	},
	metricValue: {
		speed: "{0} <span> <= </span> {1} seconds",
		reps: "{0} <span> >= </span> {1}",
		jump: "{0} <span> <= </span> {1} inches",
		weight: "{0} <span> >= </span> {1} pounds",
		height: "{0} <span> >= </span> {1} inches",
		meta: "{0} <span> begins with </span> {1}",
		match: "{0} <span> is </span> {1}",
	},
	metricHtml: {
		editor: '<input type="text" name="value" size="{0}" value="{2}" />',
		yreditor: '20<input type="text" name="value" size="{0}" value="{2}" />',
		display: '<span name="criterion">{0}</span>',
	}
}
