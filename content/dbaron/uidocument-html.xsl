
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xt="http://www.jclark.com/xt"
                extension-element-prefixes="xt">

<xsl:output method="html"/>

<xsl:template match="/">

	<html>
		<head>
			<title><xsl:value-of select="//header/@title"/></title>
		</head>
		<body>
			<img src="http://www.webalo.net:8081/images/marinlogo.gif"/><p/>
			<xsl:choose>

				<xsl:when test="//input">
					<form method="post">
						<xsl:apply-templates/>
						
						<xsl:if test="not(//submit)">
							<xsl:call-template name="submit"/>
						</xsl:if>
					</form>
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:call-template name="footer"/>
		</body>
	</html>

</xsl:template>


<xsl:template name="submit">
	<xsl:variable name="title">
		<xsl:choose>
		<xsl:when test="//input/@submitbutton">
			<xsl:value-of select="//input/@submitbutton"/>
		</xsl:when>
		<xsl:otherwise>Submit</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<input type="hidden" name="session" value="{//@session}"/>
	<input type="submit" value="{$title}"/>
</xsl:template>


<xsl:template name="anchor">
	
	<xsl:variable name="query">
		<xsl:if test="//@session">
			<xsl:text>?session=</xsl:text><xsl:value-of select="//@session"/>
			<xsl:if test="@input">
				<xsl:text>&amp;input=</xsl:text><xsl:value-of select="attribute::input"/>
			</xsl:if>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="text" 
		select="normalize-space(translate(@text, '()[]', '    '))"/>
	
	<a href="{@href}{$query}"><xsl:value-of select="$text"/></a>
</xsl:template>


<xsl:template match="anchor[not(ancestor::footer)]">

	<xsl:if test="ancestor::tasklist | ancestor::block">
		<img src="http://www.webalo.net:8081/images/arrow.gif"/>
		<xsl:text>&#xa0;&#xa0;</xsl:text>
	</xsl:if>

		<xsl:call-template name="anchor"/>

	<xsl:if test="ancestor::tasklist | ancestor::block">
		<br/>
	</xsl:if>

</xsl:template>


<xsl:template name="footer">
	<hr/>
	<xsl:for-each select="//footer/anchor">
		<xsl:call-template name="anchor"/>
		<xsl:if test="not(position()=last())"> 
			<xsl:text>&#xA0;|&#xA0;</xsl:text>
		</xsl:if>
	</xsl:for-each>
</xsl:template>


<xsl:template match="block">
	<p>
		<xsl:value-of select="."/>
	</p>

	<ul>
		<xsl:apply-templates select="anchor"/>
	</ul>
</xsl:template>


<xsl:template match="p">
	<p><xsl:apply-templates/></p>
</xsl:template>


<xsl:template match="tasklist">
	<h3><xsl:value-of select="@name"/></h3>
	<ul>
		<xsl:apply-templates select="task|anchor"/>
	</ul>
</xsl:template>


<xsl:template match="task">
	<li>
		<xsl:apply-templates/>
	</li>
</xsl:template>


<xsl:template match="fieldlist">

	<h3>
		<xsl:value-of select="@name"/>
		<xsl:if test="parent::task">
			<xsl:text> </xsl:text><xsl:apply-templates select="parent::task" mode="number"/>
		</xsl:if>
	</h3>

	<table border="1">
		<xsl:apply-templates select="field"/>
	</table>
	<br/>
</xsl:template>


<xsl:template match="field">
	<tr><th>
		<xsl:value-of select="@name"/>
	</th>
	<td>
		<xsl:apply-templates/>
	</td></tr>
</xsl:template>


<xsl:template match="input">
	<br/>
	<xsl:value-of select="@prompt"/>
	<xsl:text> </xsl:text>
	<input type="{@type}" name="{@prompt}" value="{@default}"/>
</xsl:template>


<xsl:template match="input" mode="start">
	<form method="post">
		abcd<xsl:apply-templates select="//fieldlist"/>
	</form>
</xsl:template>


<xsl:template name="number" mode="number" match="*">

	<xsl:number/>

</xsl:template>

</xsl:stylesheet>

