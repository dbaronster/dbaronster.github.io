<%@ page language="java" import="com.midas.gridiron.model.Player"%>
<%@ taglib uri="/tags/struts-html" prefix="html" %>

<jsp:useBean id="recruiter" scope="session" class="com.midas.gridiron.model.Recruiter"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%
	Player[] recruits = recruiter.getRecruits();
	String action=com.midas.gridiron.action.ActionUtil.getAction(request);
	boolean printing = "print".equals(action);
	//int matched = Math.min(recruits.length, com.midas.gridiron.model.Recruiter.MAX_MATCHES);
	int matched = recruits.length;
%>

<html:html xhtml="true">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Gridiron Recruits</title>
		<link type="text/css" href="<%=request.getContextPath()%>/style/print.css" rel="stylesheet">
		<link type="text/css" href="<%=request.getContextPath()%>/style/gridiron.css" rel="stylesheet">
	</head>
	
	<body <%=printing?"":"background=\"images/background.jpg\""%> >

		<% if (printing) { %>
			<div><html:img src="images/gridiron.jpg"/></div>
			<div class="break"><br/></div>
		<% } else { %>
			<h1>GridIron Recruits&nbsp;&mdash;&nbsp;<%=matched%> players selected</h1>
		<% } %>
		
		<div class="<%=printing?"print-zone":"zone"%>">
		
		<%
		if (matched == 0) { %>
			<p>&nbsp;No players have been selected.</p>
		<% } else { %>
		
			<div class="players">
				<p class="header">
					<span class="pid">#</span>
					<span class="player">&nbsp;Name</span>
					<span class="name">High School</span>
					<span class="year">Grad Year</span>
					<span class="name">Head Coach</span>
					<span class="zip">Zip</span>
					<span class="height">Height</span>
					<span class="weight">Weight</span>
					<span class="pos">Position Offense</span>
					<span class="pos">Position Defense</span>
					<span class="time">Time 10</span>
					<span class="time">Time 20</span>
					<span class="time">Time 40</span>
					<span class="time">Time Shttle</span>
					<span class="power">Squat / Reps</span>
					<span class="power">Bench / Reps</span>
					<span class="expl">Broad Jump</span>
					<span class="expl">Vert Jump</span>
				</p>
			<%
				for (int i = 0; i < matched *2; i++) {
					Player recruit = recruits[i/2];
			%>
				<div class=break style="line-height:1px;"><br/></div>
				<div class="player"><p>
					<span class="pid"><%=""+(i+1)%></span>
					<span class="player"><%=recruit.getMetric("firstName").getValue()%> <%=recruit.getMetric("lastName").getValue()%></span>
					<span class="name"><%=recruit.getMetric("highSchool").getValue()%></span>
					<span class="year">&rsquo;<%=recruit.getMetric("gradYear").getValue()%></span>
					<span class="name"><%=recruit.getMetric("headCoach").getValue()%></span>
					<span class="zip"><%=recruit.getMetric("zipCode").getValue()%></span>
					<span class="height"><%int hgt = ((Number)recruit.getMetric("height").getValue()).intValue();%><%=""+hgt/12+"' " + (hgt%12) + "\""%></span>
					<span class="weight"><%=recruit.getMetric("weight").getValue()%></span>
					<span class="pos"><%=recruit.getMetric("offPosition").getValue()%></span>
					<span class="pos"><%=recruit.getMetric("defPosition").getValue()%></span>
					<span class="time"><%=recruit.getMetric("time10").toString().split(" ", 2)[1]%></span>
					<span class="time"><%=recruit.getMetric("time20").toString().split(" ", 2)[1]%></span>
					<span class="time"><%=recruit.getMetric("time40").toString().split(" ", 2)[1]%></span>
					<span class="time"><%=recruit.getMetric("timeShttl").toString().split(" ", 2)[1]%></span>
					<span class="power"><%=recruit.getMetric("squat").getValue()%> / <%=recruit.getMetric("squatReps").getValue()%></span>
					<span class="power"><%=recruit.getMetric("bench").getValue()%> / <%=recruit.getMetric("benchReps").getValue()%></span>
					<span class="expl"><%=recruit.getMetric("broadJmp").getValue()%></span>
					<span class="expl"><%=recruit.getMetric("vertJmp").getValue()%></span>
				</p></div>
			<%
				}
			%>
			</div>
		<% } %>
		</div>
		<div style="padding: 0em; padding-left: 1em; white-space:nowrap; font-size: x-small;">
			<html:form action="/recruit">
			<% if (printing) { %>
				<div style="float:left;">
					<input type="button" value="Back" onclick="history.back()" />
					<input type="button" value="Print" name="PrintBtn" onclick="window.print()"/>
					<span style="font-size:x-large;">&nbsp;&nbsp;</span><span>For best results, Print in Landscape orientation.</span>
				</div>
			<% } else { %>
				<div style="float:left; padding-top:1em;"><span>&nbsp;</span>
					<html:button property="action" value="Back" onclick="history.back()" />
					<html:submit property="action" value="Start Over"/>
					<% if (matched > 0) { %>
						<html:submit property="action" value="Print Friendly Display"/>
					<% } %>
				</div>
			<% } %>
			</html:form>
		</div>
	<div class="break"><hr/></div>
	<div class="copyright">Copyright &copy; 2004 Midas Networks, Inc. &amp; Douglas Baron</div>

	</body>
</html:html>
