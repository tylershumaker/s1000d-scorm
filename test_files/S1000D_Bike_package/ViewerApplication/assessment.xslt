<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://www.purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">

	<xsl:template name="assessment" match="learningAssessment">
		<xsl:apply-templates select="//lcInteraction" />
    </xsl:template>
	<xsl:template match="lcInteraction">
		<xsl:if test="position()=1">
			<!--<xsl:apply-templates />-->
			<xsl:call-template name="show_flash" />
		</xsl:if>
	</xsl:template>
	<xsl:template name="show_flash">
		<xsl:variable name="kc">
			<xsl:value-of select="ancestor::learningAssessment/title" />
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$kc='Knowledge Check'">
			<xsl:variable name="hs">
				<xsl:value-of select="name(*[1])" />
			</xsl:variable>
				<xsl:choose>
					<xsl:when test="$hs = 'lcHotspot'">
						<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
							codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0"
							WIDTH="745"
							HEIGHT="600" id="col_master.swf">
							<param NAME="movie" VALUE="assessment_templates/hotspot.swf" />
							<param NAME="FlashVars" VALUE="theFileName=DMC-{$global_dmc}" />
							<param NAME="quality" VALUE="high"/>
							<param NAME="bgcolor" VALUE="#FFFFFF" />
						</object>
					</xsl:when>
					<xsl:when test="$hs = 'lcMatching'">
						<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
							codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0"
							WIDTH="745"
							HEIGHT="600" id="col_master.swf">
							<param NAME="movie" VALUE="assessment_templates/matching.swf" />
							<param NAME="FlashVars" VALUE="theFileName=DMC-{$global_dmc}" />
							<param NAME="quality" VALUE="high"/>
							<param NAME="bgcolor" VALUE="#FFFFFF" />
						</object>
					</xsl:when>
					<xsl:otherwise>
						<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
						codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0"
						WIDTH="745"
						HEIGHT="600" id="col_master.swf">
							<param NAME="movie" VALUE="assessment_templates/kc_master.swf" />
							<param NAME="FlashVars" VALUE="theFileName=DMC-{$global_dmc}" />
							<param NAME="quality" VALUE="high"/>
							<param NAME="bgcolor" VALUE="#FFFFFF" />
						</object>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
				codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0"
				WIDTH="745"
				HEIGHT="600" id="col_master.swf">
					<param NAME="movie" VALUE="assessment_templates/assessment_master.swf" />
					<param NAME="FlashVars" VALUE="theFileName=DMC-{$global_dmc}" />
					<param NAME="quality" VALUE="high"/>
					<param NAME="bgcolor" VALUE="#FFFFFF" />
				</object>
			</xsl:otherwise>
		</xsl:choose>
		
		
	</xsl:template>
	
</xsl:stylesheet>
