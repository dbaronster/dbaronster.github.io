
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xt="http://www.jclark.com/xt"
                extension-element-prefixes="xt">

<xsl:output method="xml"/>

<xsl:template match="/">

	<vxml version="1.0"> 

		<meta name="scoping" content="new"/> 

		<link next="#options">
			<grammar>[(options)]</grammar>
		</link>

		<help>
			I'm sorry. There's no help available here.
			<goto next="#options"/>
		</help>

		<noinput>
			I'm sorry. I didn't hear anything.
			<reprompt/>
			<!-- goto next="#options"/-->
		</noinput>

		<nomatch>
			I didn't get that. 
			<reprompt/>
		</nomatch>

		<!--xsl:call-template name="init"/>-->

		<xsl:apply-templates/>

		<form id="ender"> 
			<block> 
				<!--debug> done with list </debug> -->
				<goto next="_home"/> 
			</block> 
		</form> 
		
		<xsl:call-template name="footer"/>
		
	</vxml> 

</xsl:template>


<xsl:template name="formid" mode="formid" match="*">

	<xsl:if test="string-length(@name)">
		<xsl:value-of select="concat(translate(@name,' ', ''), '-')"/>
	</xsl:if>
	<xsl:value-of select="generate-id()"/>

</xsl:template>


<xsl:template name="gotonext">

	<xsl:variable name="nextid">
		<xsl:if test="following-sibling::*">
			<xsl:apply-templates select="following-sibling::*[1]" mode="formid"/>
		</xsl:if>
		<xsl:if test="not(following-sibling::*)">options</xsl:if>
	</xsl:variable>
	<block>
		<goto next="#{$nextid}"/>
	</block>

</xsl:template>


<xsl:template name="body">

	<form id="init" dtmf="true">
		<xsl:apply-templates mode="form"/>
		<xsl:call-template name="gotonext"/>
	</form>

</xsl:template>


<xsl:template match="block">

	<menu id="body">
			<prompt><audio>
				<xsl:apply-templates select="." mode="cleanprompt"/>
			</audio></prompt>

			<xsl:apply-templates mode="form" select="anchor"/>
	</menu>

</xsl:template>


<xsl:template match="anchor" mode="prompt">

	<xsl:value-of select="translate(@text, '()[]', '    ')"/>
	<xsl:value-of select="'. '"/>

</xsl:template>


<xsl:template match="anchor[not(ancestor::footer)]" mode="numberedprompt">

	<xsl:text>&#xa;</xsl:text>
	<xsl:number count="anchor"/>
	<xsl:value-of select="'. '"/>
	<xsl:apply-templates select="." mode="prompt"/>
	<break size="small"/>

</xsl:template>


<xsl:template match="anchor[not(ancestor::footer)]" mode="form">
	<xsl:text>&#xa;</xsl:text>

	<xsl:variable name="query">
		<xsl:if test="//@session">
			<xsl:text>?session=</xsl:text><xsl:value-of select="//@session"/>
			<xsl:if test="@input">
				<xsl:text>&amp;input=</xsl:text><xsl:value-of select="attribute::input"/>
			</xsl:if>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="pos">
		<xsl:number count="anchor"/>
	</xsl:variable>

	<choice next="{@href}{$query}" dtmf="{$pos}">
		<xsl:value-of select="translate(@text, '()[]', '    ')"/>
		<xsl:call-template name="do-grammar">
			<xsl:with-param name="text" select="@text"/>
		</xsl:call-template>
	</choice>
</xsl:template>


<xsl:template match="anchor" mode="menu">

	<xsl:variable name="query">
		<xsl:if test="@input">
			<xsl:text>?input=</xsl:text><xsl:value-of select="attribute::input"/>
		</xsl:if>
	</xsl:variable>

	<link next="{@href}{$query}">
		<xsl:apply-templates select="@text" mode="do-grammar"/>
	</link>

</xsl:template>


<xsl:template name="footer">

	<xsl:text>&#xa;</xsl:text>

	<menu id="options">
		<prompt>
			<audio>Please say 
				<xsl:for-each select="//footer/anchor">
					<xsl:if test="position()=last()">
						<xsl:value-of select="' or '"/>
					</xsl:if>

					<xsl:apply-templates select="." mode="prompt"/>
				</xsl:for-each>
				<break size="small"/>
				Or ask for help. Or say exit to quit
			</audio>
		</prompt>

		<xsl:for-each select="//footer/anchor">
			<xsl:text>&#xa;</xsl:text>
			<choice next="{@href}"><xsl:value-of select="@text"/></choice>
		</xsl:for-each>

	</menu>

</xsl:template>


<xsl:template match="p" mode="form">
	<block><audio>
		<xsl:apply-templates select="." mode="cleanprompt"/>
	</audio></block>
</xsl:template>


<xsl:template match="p">

	<!--when preceded by taskslist, we've already been used as prompt-->
	<xsl:if test="not(preceding-sibling::tasklist)">

		<xsl:text>&#xa;</xsl:text>

		<form id="{generate-id()}">
			<xsl:apply-templates select="." mode="form"/>

			<xsl:call-template name="gotonext"/>
		</form>
	</xsl:if>
</xsl:template>


<xsl:template match="tasklist">
	
	<xsl:variable name="currentField">
		<xsl:call-template name="formid"/>
	</xsl:variable>
	
	<xsl:if test="child::anchor">
		<xsl:text>&#xa;</xsl:text>

		<menu id="{$currentField}" dtmf="true">
			<prompt>
				<audio>
					<xsl:if test="not(preceding-sibling::p)">
						<!--if no prompt preceding, generate prompt from choices-->
						Please choose one of the following 
						<xsl:value-of select="count(anchor)"/> options:
					</xsl:if>

					<xsl:apply-templates select="anchor" mode="numberedprompt"/>

					<xsl:if test="following-sibling::p">
						<!--when available, add following <p> to prompt-->
						<!-- <xsl:value-of select="following-sibling::p[1]"/> -->
						<xsl:apply-templates select="following-sibling::p[1]" mode="cleanprompt"/>
					</xsl:if>
				</audio>
			</prompt>

			<xsl:apply-templates select="anchor" mode="form"/>
		</menu>
	</xsl:if>

	<xsl:if test="child::task">
		<xsl:call-template name="xtasklist"/>
	</xsl:if>

</xsl:template>


<xsl:template name="xtasklist">

	<xsl:variable name="currentField"
				select="concat(translate(@name,' ', ''), '-', generate-id())"
	/>
	
	<xsl:text>&#xa;</xsl:text>

	<form id="{$currentField}">
		<block>
			There are <xsl:value-of select="count(task|anchor)"/> 
				elements in the <xsl:value-of select="@name"/> list.
		</block>
		<field name="tasknum" type="number"> 
			<prompt>
				Which one would you like to hear in detail?
			</prompt> 
			<help>
				Please say a number between one and <xsl:value-of select="count(task|anchor)"/> 
			</help> 
			<filled> 
				<prompt>
					Going to item <value expr="tasknum"/>
				</prompt> 
				<goto expr="'#{@name}-{generate-id()}-'  + tasknum"/>
			</filled> 
		</field> 
	</form>

	<xsl:apply-templates select="task|anchor">
		<xsl:with-param name="callerField" select="$currentField"/>
	</xsl:apply-templates>

</xsl:template>


<xsl:template match="task">

	<xsl:param name="callerField"/>

	<xsl:text>&#xa;</xsl:text>

	<form id="{$callerField}-{position()}">
		<block><audio>Item number <xsl:value-of select="position()"/></audio></block>
	</form>

	<xsl:apply-templates/>

</xsl:template>


<xsl:template match="fieldlist">

	<xsl:variable name="currentField">
		<xsl:call-template name="formid"/>
	</xsl:variable>

	<xsl:text>&#xa;</xsl:text>

	<menu id="{$currentField}">
			<prompt>
				<audio>
				We have the following infomational fields on <xsl:value-of select="@name"/>:
					<break size="small"/>
				<xsl:for-each select="child::field">
					<xsl:call-template name="field-anchor"/>
					<break size="small"/>
					<xsl:text>&#xa;</xsl:text>
				</xsl:for-each>
				<!--enumerate/> -->
				</audio>

				<audio>Please name a field to get its detail</audio>

				<xsl:if test="following-sibling::anchor">
					<audio>, or say 
					<xsl:apply-templates select="following-sibling::anchor[1]" mode="prompt"/>
					</audio>
				</xsl:if>

			</prompt>

			<!-- handle the first noinput for this field -->
			<noinput count="1">
				<audio>I'm sorry. I didn't hear you.</audio>
				<audio>Please say 
				<xsl:if test="following-sibling::anchor">
					<xsl:apply-templates select="following-sibling::anchor[1]" mode="prompt"/>
					, or say
				</xsl:if>
				a field name.</audio>
			</noinput>

			<!-- handle the second noinput for this field -->
			<noinput count="2">
				<audio>I'm sorry. I still didn't hear you.</audio>
				<reprompt/>
			</noinput>

			<!-- handle the third noinput for this field -->
			<noinput count="3">
				<goto next="#init"/>
			</noinput>

			<!-- handle all help events for this field -->
			<help>
				<audio>Please say.
					<xsl:for-each select="child::field">
						<xsl:if test="(position()=last())"> 
							<xsl:text> or </xsl:text>
						</xsl:if>
						<xsl:value-of select="@name"/>
						<xsl:if test="not(position()=last())"> 
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</audio>
			</help>

			<!-- handle all nomatch events for this field -->
			<nomatch>
				<audio>I'm sorry. I didn't get that.</audio>
				<reprompt/>
			</nomatch>

			<xsl:for-each select="child::field">
				<xsl:text>&#xa;</xsl:text>
				<choice next="#{$currentField}-{@name}">
					<xsl:value-of select="@name"/>
				</choice>
			</xsl:for-each>

			<xsl:if test="following-sibling::anchor">
				<xsl:apply-templates select="following-sibling::anchor[1]" mode="menu"/>
			</xsl:if>
	</menu>

	<xsl:for-each select="child::field">
		<xsl:call-template name="field">
			<xsl:with-param name="callerField">
				<xsl:value-of select="$currentField"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>

</xsl:template>


<xsl:template name="field">

	<xsl:param name="callerField"/>

	<xsl:text>&#xa;</xsl:text>

	<form id="{$callerField}-{@name}">
		<block> 
			<xsl:if test="not(*)">
				<audio><xsl:value-of select="@name" /> is...</audio> 
				<audio><xsl:value-of select="." /></audio>
				<goto next="#{$callerField}"/>
			</xsl:if>
		</block> 
	</form> 

	<xsl:if test="*">
		<xsl:apply-templates/>
	</xsl:if>

</xsl:template>


<xsl:template name="field-anchor">

	<xsl:value-of select="@name"/>. 

</xsl:template>


<xsl:template match="input">

	<xsl:text>&#xa;</xsl:text>

	<xsl:variable name="currentField">
		<xsl:call-template name="formid"/>
	</xsl:variable>
	
	<form id="{$currentField}">
		<field name="{@prompt}" type="number">
			<prompt>
				<audio><xsl:value-of select="@prompt"/>? </audio>
				<xsl:if test="not(contains(@type, 'string'))">
					<audio>Please say a <xsl:value-of select="@type"/>.</audio>
				</xsl:if>
				<xsl:if test="@default">
					<audio>The default value is <xsl:value-of select="@default"/>.</audio>
					<audio>to accept that value, say "accept"</audio>
					<audio>Otherwise, please say a number to set the 
						<xsl:value-of select="@prompt"/>.
					</audio>
				</xsl:if>
			</prompt>

		<!--
			<grammar>
				[ accept ]
			</grammar>
		 -->
			
			<filled>
				<audio>I heard <value expr="{@prompt}"/></audio>
				<!-- <goto expr="'prescribe-dosage?input=' + value" /> -->
				<submit next="session={//@session}" method="post" namelist="{@prompt}"/>
			</filled>
		</field>
	</form>

</xsl:template>


<xsl:template name="do-replace">

	<xsl:param name="text"/>
	<xsl:param name="replace"/>
	<xsl:param name="with"/>

	<xsl:choose>
		<xsl:when test="contains($text, $replace)">
			<xsl:value-of select="substring-before($text, $replace)"/>
			<xsl:value-of select="$with"/>
			<xsl:call-template name="do-replace">
				<xsl:with-param name="text" select="substring-after($text, $replace)"/>
				<xsl:with-param name="replace" select="$replace"/>
				<xsl:with-param name="with" select="$with"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$text"/>
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>


<xsl:template name="to-lower" mode="to-lower" match="*">
	<xsl:param name="text"/>
	<xsl:value-of select="translate($text, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
										 'abcdefghijklmnopqrstuvwxyz')"/>
</xsl:template>


<xsl:template name="cleanprompt" mode="cleanprompt" match="*">

	<xsl:call-template name="do-replace">
		<xsl:with-param name="text">
			<xsl:call-template name="to-lower">
				<xsl:with-param name="text" select="."/>
			</xsl:call-template>
		</xsl:with-param>
		<xsl:with-param name="replace" select="'click'"/>
		<xsl:with-param name="with" select="'say'"/>
	</xsl:call-template>
	
</xsl:template>


<xsl:template name="do-grammar" mode="do-grammar" match="*">
	
	<!--xt doesn't support attribute nodes for template match, so we need param-->
	<xsl:param name="text"/>

	<grammar>
	[
		<xsl:call-template name="to-lower">
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	]
	</grammar>

</xsl:template>


</xsl:stylesheet>

