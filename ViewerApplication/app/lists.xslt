<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="randomList">
		<xsl:if test="title">
			<p class="decreaseBottom">
				<xsl:apply-templates select="title"/>
			</p>
		</xsl:if>
		<ul>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>
	
	<!-- 
	   Phase 2 
	     - Changed match="seqlist" to match="sequentialList"
	-->
	<xsl:template match="sequentialList">
		<ol>
			<xsl:apply-templates/>
		</ol>
	</xsl:template>
	<xsl:template match="listItem">
		<xsl:choose>
			<xsl:when test="parent::randomList[@prefix='pf01']">
				<li class="randlistItemHyphen">
					<xsl:if test="ancestor::randlist[not(@prefix='pf01')]">&#8211;&#160;&#160;</xsl:if>
					<xsl:apply-templates/>
				</li>
			</xsl:when>
			<xsl:when test="parent::randomList[not(@prefix='pf01')]">
				<xsl:choose>
					<xsl:when test="count(ancestor::randlist) mod 2 = 1">
							<li class="randListItemHyphen">&#8211;&#160;&#160;<xsl:apply-templates/></li>
					</xsl:when>
				<xsl:otherwise>
					<li class="randListItemBullet"><xsl:apply-templates/></li>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<li><xsl:apply-templates/></li>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="definitionList">
		<xsl:choose>
			<xsl:when test="ancestor::learning">
				<!--suppress-->
			</xsl:when>
			<xsl:otherwise>
				<!-- <ul> -->
					<xsl:apply-templates />
				<!-- </ul> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="definitionListItem">
    <!-- 8/28/14 issue 35 legends not displaying correctly -->
		<!-- <li> -->
<!-- 			<xsl:apply-templates /> -->
		<!-- </li> -->
        <b><xsl:value-of select="listItemTerm"></xsl:value-of></b>
        <xsl:text> </xsl:text>
        <xsl:value-of select="listItemDefinition/para"></xsl:value-of><br/>
	</xsl:template>
<!-- 	<xsl:template match="listItemTerm">
		<b><xsl:apply-templates /></b>
	</xsl:template>
	<xsl:template match="listItemDefinition">
		<xsl:apply-templates />
	</xsl:template> -->
</xsl:stylesheet>