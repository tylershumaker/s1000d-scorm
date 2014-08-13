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
	
	<xsl:variable name="hotspots">
		<xsl:value-of select="count(./hotspot)" />
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$theExt ='swf'">
			<!-- I do not want the swf files to show up for slide shows. May need to revisit -->
			<xsl:if test="not(../../levelledPara)">
	  			<div align="center" id="{$fig_id}">
					<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" 
							codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0" 
							WIDTH="{$graphWidth}" HEIGHT="{$graphHeight}" id="{$theFileName}">
						<param NAME="movie" VALUE="{$theFileName}" />
						<param NAME="FlashVars" VALUE="theFileName={$global_dmc}" />
						<param NAME="quality" VALUE="high"/>
						<param NAME="bgcolor" VALUE="#FFFFFF" />
					</object>
				</div>
			</xsl:if>
		</xsl:when>
        <xsl:when test="$theExt ='tif'">
            <div align="center" id="{$fig_id}">
                <a href="{$theFileName}">
                    <xsl:value-of select="$theFileName"/>
                    <br/><br/>
                </a>
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
					<div id="hotspotContent">
						<img id="hotspotImage" src="{$theFileName}" usemap="#hotspotMap" class="imageBorder hotspotImage"/>
						<map name="hotspotMap">
							<xsl:variable name="correctAnswer">
						    	<xsl:if test="hotspot/lcCorrectResponse">
						    		<xsl:value-of select="hotspot/@id"/>
						    	</xsl:if>
							</xsl:variable>
							<xsl:variable name="countTotalHotspots">
								<xsl:value-of select="count(hotspot)"/>
							</xsl:variable>
							<xsl:for-each select="hotspot">
  								<xsl:variable name="hotspotID">
  									<xsl:value-of select="position()"/>
									<!-- <xsl:value-of select="@id"/> -->
								</xsl:variable>
 								<xsl:variable name="countTotal">
									<xsl:value-of select="count(//hotspot)"/>
								</xsl:variable>
								<xsl:variable name="coordinates">
									<xsl:value-of select="@objectCoordinates"/>
								</xsl:variable>
							    <xsl:choose>
							    	<xsl:when test="@hotspotType = 'CALLOUT' or @hotspotType = 'callout'">
							    		<div id="div{$hotspotID}" class="hotspotCalloutDiv" onMouseOver="changeCallout('{$hotspotID}', '{$coordinates}', '{$countTotal}')">
		  									<area shape="poly" name="{$hotspotID}" id="{$hotspotID}" coords="{$coordinates}"/>
										</div>
										<div id="callout{$hotspotID}" class="calloutDiv">
		  									<xsl:for-each select="internalRef">
												<xsl:variable name="intrefid" select="@internalRefId"/>
												<xsl:value-of select="//para/definitionList/definitionListItem[@id=$intrefid]/listItemTerm/." /><br/>
												<xsl:value-of select="//para/definitionList/definitionListItem[@id=$intrefid]/listItemDefinition/para/." />
											</xsl:for-each>
		  								</div>
							    	</xsl:when>
								    <xsl:otherwise>
		 								<div id="div{$hotspotID}" class="hotspotDiv" onMouseOver="highlightArea('{$hotspotID}', '{$coordinates}', '{$countTotal}')" onMouseOut="unhighlightArea('{$countTotal}')" onClick="selectArea('{$hotspotID}', '{$countTotal}')">
		  									<area shape="poly" name="{$hotspotID}" id="area{$hotspotID}" coords="{$coordinates}"/>
		  								</div>
	  								</xsl:otherwise>
  								</xsl:choose>
 							</xsl:for-each>
						</map>
						<xsl:if test="not(hotspot/internalRef)">
 							<input type="submit" class="checkButton hotspotCheckButton" value="Check" onClick="checkHotspotCorrect('{$correctAnswer}', '{$countTotalHotspots}'); return false;"/>
 						</xsl:if>
						<xsl:for-each select="hotspot">
							<xsl:if test="lcFeedbackCorrect">
								<div id="feedbackCorrect">
									<div class="line"/>
								  	<xsl:apply-templates select="lcFeedbackCorrect/description/para/."/>
									<div class="line"/>
								</div>
							</xsl:if>
							<xsl:if test="lcFeedbackIncorrect">
							    <div id="feedbackIncorrect">
							    	<div class="line"/>
							  	  	<xsl:apply-templates select="lcFeedbackIncorrect/description/para/."/>
							  		<div class="line"/>
							  	</div>
							</xsl:if>
						</xsl:for-each>
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
					<param NAME="movie" VALUE="{$theFileName}"/>
					<param NAME="quality" VALUE="high"/>
					<param NAME="bgcolor" VALUE="#FFFFFF" />
				</object>
	</div>
	</xsl:template>
</xsl:stylesheet>

  