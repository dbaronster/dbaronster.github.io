<?
/* application.php (c) 2000 Ying Zhang (ying@zippydesign.com)
 *
 * TERMS OF USAGE:
 * This file was written and developed by Ying Zhang (ying@zippydesign.com)
 * for educational and demonstration purposes only.  You are hereby granted the
 * rights to use, modify, and redistribute this file as you like.  The only
 * requirement is that you must retain this notice, without modifications, at
 * the top of your source code.  No warranties or guarantees are expressed or
 * implied. DO NOT use this code in a production environment without
 * understanding the limitations and weaknesses pretaining to or caused by the
 * use of these scripts, directly or indirectly. USE AT YOUR OWN RISK!
 */

/* turn on verbose error reporting (15) to see all warnings and errors */
error_reporting(15);

/* define a generic object */
class object {};

/* setup the configuration object */
$CFG = new object;

$CFG->appname = "Chilehead";
$CFG->slogan = "ah, the slow burn...";
$CFG->dbhost = "localhost";
$CFG->dbname = "dbaron_chilehead";
$CFG->dbuser1 = "gopher";
$CFG->dbpass1 = "whatever";
$CFG->dbuser = "dbaron";
$CFG->dbpass = "d3puty9";

$CFG->wwwroot     = "/";
$CFG->dirroot     = "/home/dbaron/public_html";
$CFG->templatedir = "$CFG->dirroot/templates";
$CFG->libdir      = "$CFG->dirroot/lib";
$CFG->imagedir    = "/images";

$CFG->wordlist    = "$CFG->libdir/wordlist.txt";
$CFG->support     = "support@chilehead.com";

/* define database error handling behavior, since we are in development stages
 * we will turn on all the debugging messages to help us troubleshoot */
$DB_DEBUG = true;
$DB_DIE_ON_FAIL = true;

/* load up standard libraries */
require("$CFG->libdir/stdlib.php");
require("$CFG->libdir/dblib.php");
require("$CFG->dirroot/users/authenticate.php");

/* setup some global variables */
$ME = qualified_me();

/* start up the sessions, to keep things clean and manageable we will just
 * use one array called SESSION to store our persistent variables */
session_start();
session_register("SESSION");

/* connect to the database */
db_connect($CFG->dbhost, $CFG->dbname, $CFG->dbuser, $CFG->dbpass);
?>
