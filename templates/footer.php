</div>
<div id="footer">
<p>
<hr size=1>
<div align=right class=normal>"<i><?=$CFG->slogan?></i>"</div>
</div>
<div class="small" style="break:all">
<?
	$today = date("M d, Y");

	$debug = $debug . "Today is $today.";
?>
Thanks for visiting<br>
Copyright 2007, Chilehead Software. All rights reserved.
<div class="debug" id="debug"><? echo $debug ?></div>
</div>
</body>
</html>