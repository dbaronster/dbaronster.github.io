<html>
<head>
<title><? pv($DOC_TITLE) ?></title>
	<meta name="keywords" content="web design, web site development, powerful, cheap web development, consulting, small business, development, web, site, e-commerce">
	<meta name="resource-type" content="document">
	<meta name="revisit-after" content="33 days">
	<meta name="classification" content="Technical and Web Design services - Small Business">
	<meta name="description" content="Technical and Web Consulting, English - HTML, PHP, Java, web site development">
	<meta name="robots" content="ALL">
	<meta name="distribution" content="Global">
	<meta name="author" content="Doug Baron - Chilehead Software">
<link rel="stylesheet" href="/css/chilehead.css" type="text/css">
</head>

<style>
ul { margin:0px; }
li.inline {
  display: inline;
  padding-left: 3px;
  padding-right: 7px;
  border-right: 1px dotted #066;
  }

li.inline p {
  padding-top: 3px;
  padding-left: 3px;
  padding-right: 3px;
  border: 1px solid red;
  } 
</style>

<?
function ptab($title, $selected) {
/* prints $var with HTML characters (like "<", ">", etc.) properly quoted,
 * or if $var is empty, will print an empty string. */

	/*echo ('<li class="inline"> <a href="' . <?=$CFG->wwwroot?> . '"dougbaron/bio.php">Doug</a>');*/
}
?>

<body bgcolor=#ffffff link=#0000ff vlink=#000099 alink=#ff0000>
<div class=h1>
	<span style="float:left"><? pv($DOC_TITLE) ?></span>
	<span class="normal" style="float:right; margin-right:30; margin-bottom:15">
		<? if (is_logged_in()) { ?>
			  <? p($SESSION["user"]["firstname"] . " " . $SESSION["user"]["lastname"]) ?>
		    | <a href="<?=$CFG->wwwroot?>users/change_settings.php">Change Settings</a>
			| <a href="<?=$CFG->wwwroot?>logout.php">Logout</a>
		<? } else { ?>
			  <a href="<?=$CFG->wwwroot?>login.php">Login</a>
			| <a href="<?=$CFG->wwwroot?>users/signup.php">Signup</a>
		<? } ?>
	</span>
</div>
<div style="clear: both; border-top:solid 1; margin-left:20; margin-right:20; width:95%">&nbsp;</div>
<div class="navigator-frome"><div class="navigator">
<ul>
	<li class="inline">
	<? if ($SEL_TAB == 9) { ?>
		<a href="<?=$CFG->wwwroot?>">Home</a>
	<? } else { ?>
		
	<? } ?> </li>
	<li class="inline"> <a href="<?=$CFG->wwwroot?>">Services</a></li>
	<li class="inline"> <a href="<?=$CFG->wwwroot?>dougbaron/bio.php">Doug/Bio</a>/li>
	<li class="inline"> <a href="<?=$CFG->wwwroot?>yoga/index.php">Yoga</a>/li>
<?#	<li class="inline last"> <a href="<?=$CFG->wwwroot?>blogsearch.php">BlogSearch</a>/li> #?>
</ul>
</div></div>
<div id="content">
