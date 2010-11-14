<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://www.purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">

<xsl:template name="graphic" match="GRAPHIC|graphic">
	
		<xsl:variable name ="infoIdent">
			<xsl:value-of select ="@infoEntityIdent"></xsl:value-of>
		</xsl:variable>
	<xsl:variable name ="urn_prefix">
		<xsl:value-of select="'URN:S1000D:'" />
	</xsl:variable>
	<xsl:variable name="urn_string">
		<xsl:value-of select="concat($urn_prefix, $infoIdent)" />
	</xsl:variable>  
	<xsl:variable name="theFileName">
		<xsl:value-of select="document('./urn_resource_map.xml')//target[parent::urn[@name=$urn_string]]"/>
	</xsl:variable>
	<xsl:variable name="graphWidth">
		<xsl:value-of select="./@reproductionWidth"/>
		<xsl:value-of select="'640'"/>
	</xsl:variable>
	<xsl:variable name="graphHeight">
		<xsl:value-of select="./@reproductionHeight"/>
		<xsl:value-of select="'480'"/>
	</xsl:variable>
	
	<xsl:variable name="fig_id">
		<xsl:value-of select="./@id"/>
	</xsl:variable>

	<xsl:variable name="theExt">
		<xsl:value-of select="substring($theFileName,string-length($theFileName) - 2,string-length($theFileName))"/>
	</xsl:variable>
	<!--<p>
		
		The DMC: <xsl:value-of select="$global_dmc" />
	</p>-->
	<xsl:variable name="hotspots">
		<xsl:value-of select="count(./hotspot)" />
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$theExt ='swf'">
			<div align="center" id="{$fig_id}">
				<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" 
						codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0" 
						WIDTH="{$graphWidth}" HEIGHT="{$graphHeight}" id="{$theFileName}">
					<param NAME="movie" VALUE="{$theFileName}" />
					<param NAME="FlashVars" VALUE="theFileName=DMC-{$global_dmc}" />
					<param NAME="quality" VALUE="high"/>
					<param NAME="bgcolor" VALUE="#FFFFFF" />
				</object>
			</div>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="$hotspots = 0">
					<div align="center">
						<img src="{$theFileName}" class="imageBorder" />
					</div>
				</xsl:when>
				<xsl:when test="$hotspots > 0">
					<div align="center">
						<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
								codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0"
								WIDTH="750"
								HEIGHT="600" id="col_master.swf">
							<param NAME="movie" VALUE="Assessment_templates/dm_content_hs.swf" />
							<param NAME="FlashVars" VALUE="theFileName=DMC-{$global_dmc}" />
							<param NAME="quality" VALUE="high"/>
							<param NAME="bgcolor" VALUE="#FFFFFF" />
						</object>
					</div>
				</xsl:when>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	<xsl:template match="multimediaObject">
	
	<xsl:variable name ="infoIdent">
			<xsl:value-of select ="@infoEntityIdent"></xsl:value-of>
		</xsl:variable>
	<xsl:variable name ="urn_prefix">
		<xsl:value-of select="'URN:S1000D:'" />
	</xsl:variable>
	<xsl:variable name="urn_string">
		<xsl:value-of select="concat($urn_prefix, $infoIdent)" />
	</xsl:variable>  
	<xsl:variable name="theFileName">
		<xsl:value-of select="document('./urn_resource_map.xml')//target[parent::urn[@name=$urn_string]]"/>
	</xsl:variable>

	<div align="center">
						<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" 
						codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0" 
						WIDTH="500" HEIGHT="600" id="{$theFileName}">
					<param NAME="movie" VALUE="{$theFileName}.swf" />
					<param NAME="quality" VALUE="high"/>
					<param NAME="bgcolor" VALUE="#FFFFFF" />
				</object>
					</div>
	</xsl:template>
	<!--<xsl:template name="return_dmc" match="dmodule/identAndtStatusSection/dmAddress/dmIdent/dmCode">
		<xsl:variable name="mic" select="./dmRefIdent/dmCode/@modelIdentCode" />
		<xsl:variable name="sysdif" select="./dmRefIdent/dmCode/@systemDiffCode" />
		<xsl:variable name="syscode" select="./dmRefIdent/dmCode/@systemCode" />
		<xsl:variable name="subsyscode" select="./dmRefIdent/dmCode/@subSystemCode" />
		<xsl:variable name="subsubsyscode" select="./dmRefIdent/dmCode/@subSubSystemCode" />
		<xsl:variable name="assycode" select="./dmRefIdent/dmCode/@assyCode" />
		<xsl:variable name="disassycode" select="./dmRefIdent/dmCode/@disassyCode" />
		<xsl:variable name="disassycodevariant" select="./dmRefIdent/dmCode/@disassyCodeVariant" />
		<xsl:variable name="infocode" select="./dmRefIdent/dmCode/@infoCode" />
		<xsl:variable name="infocodevariant" select="./dmRefIdent/dmCode/@infoCodeVariant" />
		<xsl:variable name="itemlocationcode" select="./dmRefIdent/dmCode/@itemLocationCode" />
		<xsl:variable name="learncode" select="./dmRefIdent/dmCode/@learnCode" />
		<xsl:variable name="learneventcode" select="./dmRefIdent/dmCode/@learnEventCode" />
		<xsl:variable name="lang_country" select="./dmRefIdent/language/@countryIsoCode" />
		<xsl:variable name="lang_code" select="./dmRefIdent/language/@languageIsoCode" />
		<xsl:variable name="issno" select="./dmRefIdent/issueInfo/@issueNumber" />
		<xsl:variable name="inwork" select="./dmRefIdent/issueInfo/@inWork" />

		<xsl:variable name="the_dmc" select="concat('DMC','-',$mic,'-',$sysdif,'-',
						  $syscode,'-',$subsyscode,$subsubsyscode,'-',$assycode,'-',$disassycode,$disassycodevariant,'-',
						  $infocode,$infocodevariant,'-',$itemlocationcode,'-',$learncode,'-',
						  $learneventcode,'_','001','-','00','_','en','-','US','.xml')" />
	</xsl:template>-->
	
</xsl:stylesheet>

  