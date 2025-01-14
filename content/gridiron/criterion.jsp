<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page language="java" import="com.midas.gridiron.model.Player"%>
<%@ taglib uri="/tags/struts-html" prefix="html" %>
<%@ taglib uri="/tags/struts-bean" prefix="bean" %>
<%@ taglib uri="/tags/struts-logic" prefix="logic" %>
<%@ taglib uri="/tags/midas-gridiron" prefix="gridiron" %>


<bean:define id="key" name="playerForm" property="criterion" type="java.lang.String"/>

<%
	String action = com.midas.gridiron.action.ActionUtil.getAction(request);
	com.midas.gridiron.model.Metric[] criteria = com.midas.gridiron.model.recruiter.getSearchSpec().getCriteria();
	Player[] recruits = recruiter.getRecruits();

	String[] SPEED_KEYS = Player.SPEED_KEYS;
	String[] POWER_KEYS = { Player.PLAYER_SQUAT, Player.PLAYER_SQUATREPS, Player.PLAYER_BENCH, Player.PLAYER_BENCHREPS };
	String[] EXPLOSIVE_KEYS = {	Player.PLAYER_BROADJUMP, Player.PLAYER_VERTJUMP };
	String[] PLAYER_KEYS = { Player.PLAYER_FIRSTNAME, Player.PLAYER_LASTNAME, Player.PLAYER_HEIGHT, Player.PLAYER_WEIGHT /*PLAYER_ID*/ };
	String[] TEAM_KEYS = { Player.PLAYER_GRADYEAR, Player.PLAYER_HIGHSCHOOL, Player.PLAYER_HEADCOACH, Player.PLAYER_ZIPCODE };
	String[] POSITION_KEYS = { Player.PLAYER_OFFPOSITION, Player.PLAYER_DEFPOSITION };
%>

<html:html xhtml="true">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Gridiron Recruits - Select Criterion</title>
		<link type="text/css" href="<%=request.getContextPath()%>/gridiron/style/gridiron.css" rel="stylesheet">
		<script language="javascript" type="text/javascript">
		<!-- start hiding
			function getit(sel) {
				//alert(sel.value);
				document.location=document.location.pathname+"?action=pick&criterion=" + sel.value;
			}
		// -->
		</script>
	</head>

	<body background="images/background.jpg" link="#023264" alink="#023264" vlink="#023264">

	<html:form action="/recruit">
	<h1>Gridiron Recruits - Select Criterion</h1>
	
		<table cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td valign="top">
					<div class="left-side">
					<div class="metric-results">

					<% if (criteria.length > 0) { %>
				
						<p class="title">Filtering on:<ol>
						
						<% for (int i = 0; i < criteria.length; i++) { %>
						
							<li><gridiron:metricValue edit="false" key="<%=criteria[i].getKey()%>" value="<%=criteria[i].getValue().toString()%>" /></li>
						
						<% } %>
						
						</ol></p>
						<p>
						<%
							int matched = recruits.length;
							int max = com.midas.gridiron.model.Recruiter.MAX_MATCHES;
							String s = "No";
							if (matched > 0)
								s = (matched > max) ? ("Over " + max) : (""+matched);
							out.print("<p><b>" + s + "</b> " + (matched == 1?"player meets" : "players meet") + " these criteria.");
						%>
						</p>
						
						<%if (!"pick".equals(action)) {	%>
						<p><html:submit property="action" value="Start Over"/>
						
							<% if (recruits.length > 0) { %>
						
								<html:submit property="action" value="View Results"/>
								<!--html:submit property="action" value="Select Another Criterion"/-->
							<% } %>
						
							<html:button property="action" value="Back" onclick="history.back()" />
						</p>
						<% } %>
					
					<% } else { %>
					
						<p class="title">No filters have been set.</p>
						<p><em>To establish a filter:</em><ol>
							<li>Click on a criterion to the right</li>
							<li>Enter a value for that metric</li>
							<li>Click the Add Criterion button</li></ol></p>						
					
						<%if (!"pick".equals(action)) {	%>
							<html:submit property="action" value="Quit"/>
						<% } %>
					<% } %>
					</div>
				
				<% if ("pick".equals(action)) { %>
				
					<logic:present name="playerForm" property="criterion">

					<div class="metric-edit">
						<!--<p class="title">Set metric value</p>-->
						<html:errors/>
						<gridiron:metricValue edit="true" key="<%=key%>" value="<%=""%>" />
						<div style="margin-left:7em;padding-top:1em;">
						<html:submit property="action" value="Add Criterion"/>
						<html:submit property="action" value="Cancel"/>
						</div>
					</div>
					<script language="javascript" type="text/javascript">
					<!-- start hiding
						var focusControl = document.forms["playerForm"].elements["value"];
						if (focusControl && focusControl.type != "hidden") {
							focusControl.focus();
						}
					// -->
					</script>
					</logic:present>
				<%	} %>
				
					</div>
				</td>
				<td valign="top"><div class="right-side">
					<table cellspacing="0" cellpadding="0" border="0">
						<tr>
							<td><gridiron:metricGroup title="speed" keys="<%=SPEED_KEYS%>" /></td>
							<td><gridiron:metricGroup title="player" keys="<%=PLAYER_KEYS%>" /></td>
						</tr><tr>
							<td><gridiron:metricGroup title="power" keys="<%=POWER_KEYS%>" /></td>
							<td><gridiron:metricGroup title="team" keys="<%=TEAM_KEYS%>" /></td>
						</tr><tr>
							<td><gridiron:metricGroup title="explode" keys="<%=EXPLOSIVE_KEYS%>" /></td>
							<td><gridiron:metricGroup title="position" keys="<%=POSITION_KEYS%>" /></td>
						</tr>
					</table>
				
					</div>
				</td>
			</tr>
		</table>
	</html:form>
	<hr/>
	<div class="copyright">Copyright &copy; 2004 Midas Networks, Inc. &amp; Douglas Baron</div>
	
	</body>
</html:html>
