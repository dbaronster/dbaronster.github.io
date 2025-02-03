// Centering Stuff
var screenWidth = screen.availWidth;
var screenHeight = screen.availHeight;


// Pop-Up Window Script
function goUrl(url,title) {
	w = 640;
	h = 451;
	window.open( url, "title",'resizable=1,scrollbars,width=' + w + ',top=20,left=10,height=' + h + ',left=' + ((screenWidth - w - 10) * .5) + ',top=' + ((screenHeight - h - 30) * .5)).focus();
}
function goUrlFull(url,title,w,h) {
	window.open( url, "title",'resizable=yes,scrollbars,width=' + w + ',height=' + h + ',left=' + ((screenWidth - w - 10) * .5) + ',top=' + ((screenHeight - h - 30) * .5)).focus();
}
