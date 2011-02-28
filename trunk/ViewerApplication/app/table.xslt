<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="table">
	<xsl:choose>
	<xsl:when test="ancestor::training">
		<div align="center">
			<a name="{@id}"><xsl:apply-templates/></a>
		</div>
	</xsl:when>
		<xsl:otherwise>
			<a name="{@id}">
				<xsl:apply-templates/>
			</a>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="table[preceding-sibling::step1 or preceding-sibling::step2 or preceding-sibling::step3 
							or preceding-sibling::step4 or preceding-sibling::step5 or following-sibling::step1
							or following-sibling::step2 or following-sibling::step3 or following-sibling::step4
							or following-sibling::step5]">
	<tr>
		<td>
		</td>
		<td>
		<a name="{@id}"><xsl:apply-templates/></a>
		</td>
	</tr>
</xsl:template>
<xsl:template match="table/title">
	
	<p class="decreaseBottom">
		<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				<i><xsl:value-of select="$table_text"/>
					&#160;<xsl:number format="1." value="count(preceding::table) + 1"/>&#160;
				
				</i>
				</td>
				<td><i><xsl:apply-templates/></i></td>
			</tr>
		</table>
	
	</p>
	
</xsl:template>

<xsl:template match="tgroup">
	<xsl:variable name="colcount" select="@cols"/>
	<table cellpadding="5" border="1" cellspacing="0">
	<xsl:if test="child::thead">
		<xsl:attribute name="class">
			<xsl:value-of select="'line_topbot'"/>
		</xsl:attribute>
	</xsl:if>
	<xsl:apply-templates/>
	</table>
</xsl:template>

<xsl:template match="capgrp">
	<xsl:variable name="colcount" select="@cols"/>
	<table cellpadding="5" border="0" cellspacing="10" align="center">
		<xsl:apply-templates/>
	</table>
</xsl:template>

<xsl:template match="row|caprow">
	<tr>
		<xsl:apply-templates/>
	</tr>
</xsl:template>
<xsl:template match="capentry">
	<td class="tableCell" bgcolor="lightgrey" width="50%">
		<xsl:call-template name="addAttr"/>
		<xsl:apply-templates/>
	</td>
</xsl:template>

<xsl:template match="entry">
	<td class="tableCell">
		<xsl:call-template name="drawRuler"/>
		<xsl:call-template name="addAttr"/>
		<xsl:apply-templates/>
	</td>
</xsl:template>

<xsl:template match="entry[not(para)]">
	<td class="tableCell">
		<xsl:call-template name="drawRuler"/>
		<xsl:call-template name="addAttr"/>
		<xsl:apply-templates/>
		<xsl:if test="string-length(text()) &lt; 1">&#160;</xsl:if>
	</td>
</xsl:template>

<xsl:template match="thead/row/entry">
	<th class="lineBottom">
		<xsl:call-template name="addAttr"/>
		<xsl:apply-templates/>
	</th>
</xsl:template>

<xsl:template match="entry/para">
	<xsl:choose>
		<xsl:when test="string-length(text()) &lt; 1"><xsl:apply-templates/>&#160;</xsl:when>
		<xsl:otherwise><p><xsl:apply-templates/></p></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="drawRuler">
	<xsl:attribute name="class">
		<xsl:choose>
			<xsl:when test="@colsep = 1 and @rowsep = 1">line_rightbottom</xsl:when>
			<xsl:when test="(@colsep = 1) and (parent::row/@rowsep = 1)">line_rightbottom</xsl:when>
			<xsl:when test="(parent::row/@rowsep = 1) or (@rowsep = 1)">line_bottom</xsl:when>
			<xsl:when test="(@colsep = 1)">line_right</xsl:when>
			<xsl:when test="(@rowsep=0)">no_line</xsl:when>
		</xsl:choose>
	</xsl:attribute>
</xsl:template>

<xsl:template name="addAttr">
	<xsl:if test="@namest and @nameend">
		<xsl:attribute name="colspan">
			<xsl:value-of select="(@nameend - @namest) + 1"/>
		</xsl:attribute>
	</xsl:if>
	<xsl:if test="@morerows">
		<xsl:attribute name="rowspan">
			<xsl:value-of select="@morerows + 1"/>
		</xsl:attribute>
	</xsl:if>
	<xsl:if test="ancestor::tbody/@valign">
		<xsl:attribute name="valign">
			<xsl:value-of select="ancestor::tbody/@valign"/>
		</xsl:attribute>
	</xsl:if>
	<xsl:if test="ancestor::thead/@valign">
		<xsl:attribute name="valign">
			<xsl:value-of select="ancestor::thead/@valign"/>
		</xsl:attribute>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>

  