<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
<xsl:output method="html" version="4.0" />

<xsl:template match="/ | node() | @*">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="gridiron">
	<xsl:apply-templates select="players"/>
</xsl:template>

<xsl:template match="player">
    <div class="player">
    	<div class="who">
	   	<span class="Edit"><img src="images/wfb/edit.gif" border="0" onclick="document.location='editPerson.do?action=edit&amp;pid={position()}'"></img></span>
    	<span class="name"><xsl:value-of select=".//ph:who"/></span>
    	</div>
    	<xsl:if test=".//ph:email">
	    	<div class="email"><xsl:apply-templates select=".//ph:email"/></div></xsl:if>
    	<xsl:if test=".//ph:street|.//ph:city|.//ph:state|.//ph:zip|.//ph:country">
    		<div class="address"><xsl:apply-templates select=".//ph:street|.//ph:city|.//ph:state|.//ph:zip|.//ph:country" /></div></xsl:if>
    	<xsl:if test=".//ph:notes"><div class="notes"><xsl:apply-templates select=".//ph:notes" /></div></xsl:if>
    </div>
</xsl:template>

<xsl:template match="ph:street | ph:city | ph:state | ph:country | ph:zip" >
    <span><xsl:attribute name="class"><xsl:value-of select="name()"/>
    </xsl:attribute><xsl:value-of select="text()" /></span>
</xsl:template>

<xsl:template match="ph:phone">
    <span class="pn">
    	<xsl:if test="@where"><xsl:attribute name="where">w</xsl:attribute></xsl:if><xsl:apply-templates select="*" /></span>
</xsl:template>

<xsl:template match="ph:email">
	<span class="em"><xsl:apply-templates select="*" /></span>
</xsl:template>

<xsl:template match="ph:pString|ph:eString|ph:notes">
  	<xsl:value-of select="text()" />
</xsl:template>

</xsl:stylesheet>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>GridIron Recruiter</title>
		<link type="text/css" href="<%=request.getContextPath()%>/style/classic.css" rel="stylesheet">
	</head>

	<style>
	<![CDATA[
		td>div {font-size: smaller; font-face: verdana, helvetica, sans-serif;
			text-align: center; vertical-align: bottom; }
		.zone {
			border: 1px solid #220022; 
			padding: 3px;
			margin-left: 0em;
			margin-right: 1em;
			background-color: #eeffee; 
			width: 100%; }
 		.row { margin: 0em; diplay: block; padding: 0px; width:100%; }
		.header { margin-left: 0.8em; border-bottom: 1px solid black; }
		.name { write-space: nowrap; width: 150px;}
		.name,
		.headcoach { text-align: left; }
		.height { }
		.weight { }
		.gradYear { }
		.highSchool { }
		.offPosition { text-align: center }
		.defPosition { }
		.zipCode { }
		.time10 { }
		.time20 { }
		.time40 { }
		.timeShttl { }
		.squat { }
		.squatReps { }
		.bench { }
		.benchReps { }
		.broadJmp { }
		.vertJmp { }
	]]>
	</style>
	
	<body  background="images/background.jpg" link="#023264" alink="#023264" vlink="#023264">

<table border="0" width="100%" cellspacing="0" cellpadding="0" width="100%">
<tr>
	<td><h1>GridIron Recruiter<%=recruits.length%> players selected</p>	</h1></td>
</tr>
<tr>
	<td>
		<div class="zone">
		<%
			if (recruits.length == 0) {
		%>
			<p>No players have been selected.</p>
			<button onclick="location="recruit.jsp">Go To Sector Page</button>
			
		<% } else {
		%>
		
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr class="header">
				<td><div class="header name">&nbsp;Name</div></td>
				<td><div class="header highSchool">High School</div></td>
				<td><div class="header gradYear">Grad Year</div></td>
				<td><div class="header headCoach">Head Coach</div></td>
				<td><div class="header zipCode">Zip Code</div></td>
				<td><div class="height">Height</div></td>
				<td><div class="weight">Weight</div></td>
				<td><div class="offPosition">Position Offense</div></td>
				<td><div class="defPosition">Position Defense</div></td>
				<td><div class="time10">Time 10</div></td>
				<td><div class="time20">Time 20</div></td>
				<td><div class="time40">Time 40</div></td>
				<td><div class="timeShttl">Time Shuttle</div></td>
				<td><div class="squat">Squat<br/> / Reps</div></td>
				<td><div class="bench">Bench<br/> / Reps</div></td>
				<td><div class="broadJmp">Broad Jump</div></td>
				<td><div class="vertJmp">Vertical Jump</div></td>
			</tr>
			
			<%
				for (int i = 0; i < recruits.length; i++) {
					Player recruit = recruits[i];
			%>
				<tr>
					<td><div class="name"><%=i+1 + " " + recruit.getMetric("firstName").getValue()%> <%=recruit.getMetric("lastName").getValue()%></div></td>
					<td><div class="highSchool"><%=recruit.getMetric("highSchool").getValue()%></div></td>
					<td><div class="gradYear"><%=recruit.getMetric("gradYear").getValue()%></div></td>
					<td><div class="headCoach"><%=recruit.getMetric("headCoach").getValue()%></div></td>
					<td><div class="zipCode"><%=recruit.getMetric("zipCode").getValue()%></div></td>
					<td><div class="height"><%int hgt = ((Number)recruit.getMetric("height").getValue()).intValue();%><%=""+hgt/12+"' " + (hgt%12) + "\""%></div></td>
					<td><div class="weight"><%=recruit.getMetric("weight").getValue()%></div></td>
					<td><div class="offPosition"><%=recruit.getMetric("offPosition").getValue()%></div></td>
					<td><div class="defPosition"><%=recruit.getMetric("defPosition").getValue()%></div></td>
					<td><div class="time10"><%=recruit.getMetric("time10").toString()%></div></td>
					<td><div class="time20"><%=recruit.getMetric("time20").getValue()%></div></td>
					<td><div class="time40"><%=recruit.getMetric("time40").getValue()%></div></td>
					<td><div class="timeShttl"><%=recruit.getMetric("timeShttl").getValue()%></div></td>
					<td><div class="squat"><%=recruit.getMetric("squat").getValue()%> / <%=recruit.getMetric("squatReps").getValue()%></div></td>
					<td><div class="bench"><%=recruit.getMetric("bench").getValue()%> / <%=recruit.getMetric("benchReps").getValue()%></div></td>
					<td><div class="broadJmp"><%=recruit.getMetric("broadJmp").getValue()%></div></td>
					<td><div class="vertJmp"><%=recruit.getMetric("vertJmp").getValue()%></div></td>
				</tr>
			<%
				}
			%>
			</table>
		<% } %>
		</div>
		<div>
		<html:form action="/recruit">
			<html:submit property="action" value="Start Over"/>
		</html:form>
		</div>
	</td>
</tr>
<tr>
	<td>
		<hr>
	</td>
</tr>
<tr>
	<td>
	footer
	</td>
</tr>
</table>

	</body>
</html>
