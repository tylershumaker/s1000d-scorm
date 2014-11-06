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
        <!-- 9/9/14 issue 33 handling warningRefs and cautionRefs to entry elements -->
        <xsl:variable name="warnRef">
            <xsl:value-of select="./@warningRefs"/>
        </xsl:variable>
        <xsl:variable name="cautionRef">
            <xsl:value-of select="./@cautionRefs"></xsl:value-of>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not($warnRef ='')">
                <xsl:variable name="warningtext">
                    <xsl:value-of select="//warning[@id=$warnRef]/warningAndCautionPara"></xsl:value-of>
                </xsl:variable>                  
                <xsl:variable name="type">warning</xsl:variable>                  
                <div>
                    <xsl:call-template name="createAttention">
                        <xsl:with-param name="text" select="$warningtext"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>
                    <!-- <xsl:apply-templates /> -->
                </div>
            </xsl:when>
            <xsl:when test="not($cautionRef ='')">
                <xsl:variable name="cautiontext">
                    <xsl:value-of select="//caution[@id=$cautionRef]/warningAndCautionPara"></xsl:value-of>
                </xsl:variable>                 
                <xsl:variable name="type">caution</xsl:variable>                 
                 <div >
                    <xsl:call-template name="createAttention">
                        <xsl:with-param name="text" select="$cautiontext"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>                     
                    <!-- <xsl:apply-templates /> -->
                </div>               
            </xsl:when>
            <xsl:otherwise>                
                <div>
                    <xsl:apply-templates />
                </div>
            </xsl:otherwise>
        </xsl:choose>                 
<!-- 		<xsl:apply-templates/> -->
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

<!-- Phase 2: Issue 37 - Table formatting - Data is not spanning cells correctly -->
<xsl:template name="addAttr">
	<xsl:if test="@namest and @nameend">
	    <!-- Create a variable, endColName, to hold the value of the @nameend attribute on the row/entry -->
	    <xsl:variable name="endColName" select="@nameend"/>
	    
	    <!-- Create a variable, endColName, to hold the value of the @nameend attribute on the row/entry -->
	    <xsl:variable name="startColName" select="@namest"/>
	    
<!-- <p>endColName: <xsl:value-of select="$endColName"/></p>-->
	    <!-- Create a variable, endingCol, to hold the place of the matching @nameend column with the column specification (colspec)  -->
	    <xsl:variable name="endingCol" select="../../../colspec[@colname=$endColName]"/>
	    <!-- Create a variable, startingCol, to hold the place of the matching @namest column with the column specification (colspec)  -->
	    <xsl:variable name="startingCol" select="../../../colspec[@colname=$startColName]"/>
	    
	    <xsl:variable name="lenStartingCol" select="count($startingCol/preceding-sibling::colspec)"/>
	    <xsl:variable name="lenEndingCol" select="count($endingCol/preceding-sibling::colspec)"/>
	    <xsl:variable name ="col_len" select="($lenEndingCol - $lenStartingCol)+1"/>
<!-- <p>endingCol: <xsl:value-of select="$endingCol/@colname"/></p>-->
	    <!-- Create a variable, col_len, to hold the value of the col_len to span, counting previous colspecs until @namest element is found to determine place -->
	    <xsl:variable name ="col_len1" select="count($endingCol/preceding-sibling::colspec)+1"/>
	    
<!-- <p>Col_len = <xsl:value-of select="$col_len"/></p>-->
        <!-- Set the colspan attribute on the table row -->
		<xsl:attribute name="colspan">
			<!--  <xsl:value-of select="(@nameend - @namest) + 1"/>-->
			<xsl:value-of select="$col_len"/>
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

  