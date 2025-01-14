
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xt="http://www.jclark.com/xt"
                extension-element-prefixes="xt">

<xsl:output method="html"/>

<!-- basic html rendering-->

<xsl:import href="uidocument-html.xsl"/>

<!-- remainder is special for small screens-->

<xsl:template match="tasklist">
	<ul>
		<xsl:apply-templates select="task|anchor"/>
	</ul>
</xsl:template>


<xsl:template match="task">

	<xsl:if test="child::fieldlist">
		<xsl:variable name="myhref"><xsl:apply-templates select="." mode="myhref"/>
		</xsl:variable>
		<a name="{$myhref}"/>
	</xsl:if>
	<li>
		<xsl:apply-templates/>
	</li>

</xsl:template>


<xsl:template match="fieldlist">

	<xsl:if test="ancestor::tasklist">
		<xsl:variable name="myhref">
			<xsl:apply-templates select="../task" mode="myhref"/>
		</xsl:variable>
		<a name="{$myhref}"/>
	</xsl:if>

	<xsl:choose>
		<xsl:when test="./field/*">

			<b>
				<xsl:value-of select="@name"/>
				<xsl:if test="ancestor::tasklist">
					<xsl:text> </xsl:text><xsl:apply-templates select="parent::task" mode="number"/>
				</xsl:if>
			</b>
			<xsl:text>: </xsl:text>

			<xsl:for-each select="child::field">
				<xsl:call-template name="field-anchor"/>
			</xsl:for-each>
			<br/>
			<xsl:for-each select="child::field">
				<xsl:call-template name="field"/>
				<br/>
			</xsl:for-each>
			<!-- xsl:apply-templates select="field"/> -->

		</xsl:when>

		<xsl:otherwise>

			<b>
				<xsl:value-of select="@name"/>
				<xsl:if test="ancestor::tasklist">
					<xsl:text> </xsl:text><xsl:apply-templates select="parent::task" mode="number"/>
				</xsl:if>
			</b>

			<xsl:text>: </xsl:text>

			<xsl:for-each select="child::field">
				<xsl:call-template name="field"/>
				<xsl:if test="not(position()=last())"> 
					<xsl:text>&#xA0;&#183;&#xA0;</xsl:text>
				</xsl:if>
			</xsl:for-each>
			<br/>

		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template name="field">
		<a name="{@name}-{generate-id()}"/>
		<b><xsl:value-of select="@name"/></b>
		<xsl:text disable-output-escaping="yes">:&amp;nbsp;</xsl:text>
		<xsl:apply-templates/>
</xsl:template>


<xsl:template name="field-anchor">

	<xsl:choose>
		<xsl:when test="child::tasklist">
			<a href="#{@name}-{generate-id()}"> <xsl:value-of select="@name"/></a>
			<xsl:text> [</xsl:text>
			<xsl:for-each select="./tasklist/task">
				<xsl:variable name="myhref">
					<xsl:apply-templates select="." mode="myhref"/>
				</xsl:variable>
				<a href="#{normalize-space($myhref)}">
						<xsl:apply-templates select="." mode="number"/>
				</a>
				<xsl:if test="not(position()=last())"> 
					<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:for-each>
			<xsl:text>] </xsl:text>
		</xsl:when>

		<xsl:otherwise>

			<a href="#{@name}-{generate-id()}"> <xsl:value-of select="@name"/></a>
			
			<xsl:if test="not(position()=last())"> 
				<xsl:text>&#xA0;|&#xA0;</xsl:text>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="*" name="anchorid" mode="anchorid">

	<xsl:value-of select="concat(@name, generate-id())"/>

</xsl:template>


<xsl:template match="*" mode="myhref">

	<xsl:choose>
		<xsl:when test="ancestor::tasklist">
			<xsl:value-of select="generate-id()"/>
			<!-- <xsl:apply-templates select="parent::task" mode="number"/> -->
		</xsl:when>

		<xsl:otherwise>
			<xsl:value-of select="generate-id()"/>
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>


</xsl:stylesheet>


