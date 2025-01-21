<%@ page language="java" import="com.midas.gridiron.model.Player"%>
<%@ page language="java" import="com.midas.gridiron.model.Recruiter"%>
<%@ taglib uri="/tags/struts-html" prefix="html" %>

<jsp:useBean id="players" scope="session" type="com.midas.gridiron.model.Player[]"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html:html xhtml="true">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Gridiron Recruits</title>
		<link type="text/css" href="<%=request.getContextPath()%>/gridiron/style/gridiron.css" rel="stylesheet">
		<script language="javascript">
		<!-- start hiding
			function doExit() {
				if (confirm("Shut down the Gridiron Server?")) {
					document.location=document.location.pathname+"?action=shutdown";
				}
			}
		// -->
		</script>
	</head>

	<body background="images/background.jpg">
		<html:form action="/recruit">
		<h1>Gridiron Recruits</h1>
		<%=request.getContextPath()%>/style/gridiron.css
		<table border="0" width="100%" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td width="55%"><div id="panel">
					<p style="margin-top:0em;"><b>The Player database is online</b>. Players have been tested for:</p>
					<p><b>Power</b><ul>
						<li>Bench - Weight and Repetitions</li>
						<li>Squats - Weight and Repetitions</li></ul></p>
					<p><b>Explosiveness</b><ul>
						<li>Broad Jump - Distance</li>
						<li>Vertical Jump - Distance</li></ul></p>
					<p style="display:inline"><b>Speed</b><ul>
						<li>10, 20 and 40 Yards - Seconds</li>
						<li>Pro Shuttle - Seconds</li></ul></p>
					<p>The player's <b>positions</b>, <b>height</b> &amp; <b>weight</b>, <b>high school</b>, 
					<b>coach</b> and <b>graduation year</b> are also recorded.</p>
					<!--p>To recruit, you can specify minimum or maximum values for any of these criteria.</p-->
					<p><html:submit property="action" value="Start Recruiting"/>&nbsp;
					<html:button property="action" value="Exit" onclick="doExit();"/></p>
				</div></td>
				<td><div class="panel" style="font-size: x-small">
					<p><b>Dear Coach</b>,</p>
					<p>Welcome to the Gridiron Recruits recruiting database.  Gridiron Recruits evaluates high school athletes 
					using standard tests.  We provide a web site to help the student athletes with the recruiting process and 
					then we distribute the data in an easy to access form to Colleges and Universities across the United States. 
					&nbsp; Our primary goal is to help the student athlete find a program in which they can excel, both academically 
					and athletically.  If you need additional copies of this program or have any suggestions on how we may improve 
					our services to the athlete or to you please contact us.</p>
					<p>Chuck Rowsey<br/>President</p>
					<p>Phone (512) 299-9603<br/><a href="http://www.gridironrecruits.com" target="_new">www.gridironrecruits.com</a></p>
				</div></td>
			</tr>
		</table>
		</html:form>
		<hr/>
		<div class="copyright">Copyright &copy; 2004 Midas Networks, Inc. &amp; Douglas Baron</div>
	</body>
</html:html>
