<?
if (!empty($errormsg)) {
	echo "<h2 style='color: #ff0000'>Errors</h2>";
	echo "<div class=errors>";
	echo $errormsg;
	echo "</div>";
}
?>

<?
if (!empty($noticemsg)) {
	echo "<div class=notice>";
	echo $noticemsg;
	echo "</div>";
}
?>