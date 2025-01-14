
window.artistPreviewer = new Object();

function ArtistPreviewer() {
	this.band = null;
	this.timer = null;
	this.loader = document.getElementById("loader");
	this.preview = document.getElementById("preview");
	this.artistTable = document.getElementById("artistTable");
};

ArtistPreviewer.prototype = {
	reset: function() {
		if (this.timer != null) {
			window.clearTimeout(this.timer);
			this.timer = null;
		}
		this.band = null;
		try {
			this.loader.contentDocument.body.innerHTML('<html/>');
		} catch (e) {}
	},
	leave: function() {
		if (this.timer != null) {
			window.clearTimeout(this.timer);
			this.timer = null;
		}
	},
	loadPreview: function(artistLinkDiv, band) {
		if (band != this.band) {
			this.reset();
			this.band = band;
			this.artistUrl = artistLinkDiv.getElementsByTagName('a')[0].href;
			this.loader.src = "http://www.chilehead.com/sxsw/music/showcases/band/" + band + ".html";
		}
		this.timer = window.setTimeout("window.artistPreviewer.showPreview()", 500);
	},
	showPreview: function() {
		var artist = this.loader.contentDocument.getElementById('showcasing_artist');
		if (artist == undefined) {
			this.timer = window.setTimeout("window.artistPreviewer.showPreview()", 500);
			return this.timer;
		}
		
		var artistInfo = artist.getElementsByTagName('tbody')[0].getElementsByTagName('tr')[0];
		this.artistTable.innerHTML = artistInfo.innerHTML;
		//hook this add-to-calendar link
		var calendarLink = document.getElementById("calendarlink");
		var addLink = calendarLink.getElementsByTagName('p')[0].getElementsByTagName('a')[0];
		var oldClick = addLink.onclick;
		addLink.onclick = function() {window.artistPreviewer.close();oldClick()};
		
		//create extra row
		var row = document.createElement('tr');
		var cell = document.createElement('td');
		cell.align = "right";
		cell.style.fontSize = "smaller";
		cell.style.verticalAlign = "bottom";
		cell.innerHTML = '<div style="float:left"><a href="javascript:window.artistPreviewer.zoom();">View Full Page</a></div>' +
		'<div style="float:right"><a href="javascript:window.artistPreviewer.close();">Close This Preview</a></div>';
		row.appendChild(cell);
		this.artistTable.appendChild(row);
		this.preview.style.display = "block";
	},
	zoom : function () {
		this.preview.style.display = "none";
		//document.body.innerHTML = this.loader.contentDocument.body.innerHTML;
		window.location = this.artistUrl;
	},
	close : function () {
		this.preview.style.display = "none";
	}
}

