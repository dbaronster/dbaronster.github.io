<?php
include("../application.php");

$DOC_TITLE = "Chilehead Yoga Page";
$SEL_TAB = 3;
include("$CFG->templatedir/header.php");

$debug = "";

if (!session_is_registered('counted')) {
	db_query("UPDATE hits SET count=(count + 1) WHERE count_id=2"); 
    session_register("counted");
    $counted = 0;
}
else {
    $counted++;
}
/*
if (!isset( $_SESSION['counted'] )) {
	mysql_query("UPDATE hits SET count=(count + 1) WHERE count_id=2"); 
	$_SESSION['counted'] = 1;
}
*/
$result = db_query("SELECT count FROM hits WHERE count_id=2");

if ($result) {
	if ($row = mysql_fetch_array($result)) {
		$debug = $debug . $row["count"] . ' Hits';
	}
}
else die ("didn't work");
?>

<h1>Yoga!</h1>
<div style="margin-bottom:9">
<p>I have been practicing Yoga for about eleven years, and am starting
to teach. But the learning is ongoing, a lifelong endeavor.
</p>
<p>My first and long time teacher was <a href="http://www.yogainpaloalto.com/larry.php">Larry Hatlett</a>, 
who inspired me to develop my practice at the <a href="http://www.californiayoga.com/">Yoga Center of Palo Alto</a>. He always infuses the class with energy, humor and delight</p>
Also at the Center, Catherine De Los Santos led me though many Yoga challenges, insights and growth. 
Catherine recently opened a new studio in Palo Alto, <a href="http://www.darshanayoga.com">Darshana Yoga</a>, with a wonderful
cast of teachers.</p>
<p>In Texas I have met and studied with a number of outstanding teachers, as I've progressed through
my teacher training at <a href="http://www.yogayoga.com">Yoga Yoga</a> here in Austin. </p>
<p>Some Yoga pages of note<ul>
<li><a href="http://www.bradpriddy.com/yoga/">Brad's Iyengar Style Yoga Page</a>  Very nice personal site
<li><a href="http://www.yogajournal.com/index.cfm">Yoga Journal</a> Fine magazine, quality site
<li><a href="http://www.austinyogateachers.com/">Yoga in Austin</a>
<li><a href="http://www.yogacards.com/yoga_postures.html">Yoga Postures</a> Tough variations, Good pictures, Sanskrit translations
<li><a href="http://www.clearspringstudio.com/Instructors/Devon_Dederich/devon_dederich.html">Devon Dederich</a> An outstanding guide and teacher of the Iyengar tradition here in Austin
<li><a href="http://moryoga.com/">David Moreno</a>, another great teacher
</ul></p>
<p>&nbsp;</p>
</div>
<? include("$CFG->templatedir/footer.php"); ?>
