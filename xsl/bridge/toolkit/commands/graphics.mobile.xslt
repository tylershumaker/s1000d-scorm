<?xml version="1.0" encoding="UTF-8" ?>
<!--  * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses. -->
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
		<xsl:value-of select="document('../../../../ViewerApplication/app/urn_resource_map.xml')//target[parent::urn[@name=$urn_string]]"/>
	</xsl:variable>
	<xsl:variable name="graphWidth">
		<xsl:value-of select="./@reproductionWidth"/>
		<xsl:value-of select="'100%'"/>
	</xsl:variable>
	<xsl:variable name="graphHeight">
		<xsl:value-of select="./@reproductionHeight"/>
		<xsl:value-of select="'100%'"/>
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
		<!-- I do not want the swf files to show up -->
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="$hotspots = 0"> 
					<div align="center">
						<img src="{$theFileName}" class="imageBorder" />
					</div>
				</xsl:when>
				<xsl:when test="$hotspots > 0">
					<xsl:variable name="correctAnswer">
				    	<xsl:if test="hotspot/lcCorrectResponse">
				    		<xsl:value-of select="hotspot/@id"/>
				    	</xsl:if>
					</xsl:variable>
					<xsl:variable name="countTotalHotspots">
						<xsl:value-of select="count(hotspot)"/>
					</xsl:variable>
					<div id="hotspotContent">
						<img id="hotspotImage" src="{$theFileName}" usemap="#hotspotMap" class="imageBorder hotspotImage"/>
						<map name="hotspotMap">
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
 								<div id="div{$hotspotID}" class="hotspotDiv" onClick="highlightArea('{$hotspotID}', '{$coordinates}', '{$countTotal}')"> <!-- onClick="selectArea('{$hotspotID}')"> -->
  									<area shape="poly" name="{$hotspotID}" id="{$hotspotID}" coords="{$coordinates}"/>
  								</div>
 							</xsl:for-each>
						</map>
					</div>
					<script type="text/javascript">
				   		//$(function()
						//$(document).ready()
						//$(window).load( function()
						
						function pageScript(func) {
							var $context = $("div:jqmData(role='page'):last");
							func($context);
						}						
						
						pageScript(function($context)
						{
							//$context.bind("pagecreate", function(event, ui)
							$context.bind("pageshow", function(event, ui)
							{
								initializeHotspots(<xsl:value-of select="$countTotalHotspots"/>);
							});
						});
					</script>
					<input type="submit" class="checkButton hotspotCheckButton" value="Check" onClick="checkHotspotCorrect('{$correctAnswer}', '{$countTotalHotspots}'); return false;"/>
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
		<xsl:value-of select="document('../../../../ViewerApplication/app/urn_resource_map.xml')//target[parent::urn[@name=$urn_string]]"/>
	</xsl:variable>
            <div align="center" >
                <object WIDTH="100%" HEIGHT="100%" id="{$theFileName}">
                    <param NAME="movie" VALUE="{$theFileName}"></param>
                    <embed src="{$theFileName}" WIDTH="100%" HEIGHT="100%" flashvars="theFileName={$global_dmc}"></embed>
                </object>
            </div>
	</xsl:template>
</xsl:stylesheet>
  