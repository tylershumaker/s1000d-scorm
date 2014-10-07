<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://www.purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">

<xsl:template name="graphic" match="GRAPHIC|graphic">	
	
	<!-- Get the entity title for the graphic -->
	<xsl:variable name ="infoIdent">
	   <xsl:value-of select ="@infoEntityIdent"></xsl:value-of>
	</xsl:variable>
	
	<!-- Build the URN of the graphic to retrieve the appropriate file -->
	<xsl:variable name ="urn_prefix">
		<xsl:value-of select="'URN:S1000D:'" />
	</xsl:variable>
	<xsl:variable name="urn_string">
		<xsl:value-of select="concat($urn_prefix, $infoIdent)" />
	</xsl:variable>  
	
	<!-- Using the urn_resource_map.xml file, retrieve the file name of the graphic to display -->
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
		    <!-- Not a SWF or TIF, determine figure type to ouput -->
			<xsl:choose>
			    <!-- No hostspots, must be a image (e.g., JPEF) -->
				<xsl:when test="$hotspots = 0"> 
				    <!-- Center align the image -->
					<div align="center">
						<img src="{$theFileName}" class="imageBorder" />
					</div>
				</xsl:when>
				<xsl:when test="$hotspots > 0">
					<div id="hotspotContent">
						<img id="hotspotImage" src="{$theFileName}" usemap="#hotspotMap" class="imageBorder hotspotImage"/>
                        <!-- moved variables outside of map to fix transformation error -->
                            <xsl:variable name="correctAnswer">
                                <xsl:if test="hotspot/lcCorrectResponse">
                                    <xsl:value-of select="hotspot/@id"/>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:variable name="countTotalHotspots">
                                <xsl:value-of select="count(hotspot)"/>
                            </xsl:variable>                            
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
	
	<!-- Phase 2 Issue 5 & 6.  -->
	<!-- Created <figure> template to address these issues. -->
	<xsl:template match = "figure">
	
	   <!-- 
	         When a <figure> is encountered, create a figurecounter variable to determine the Figure number by counting up the preceding
	         <figure>s.  The total number of preceding figures will indicate the figure number for the figure you are dealing with.  A 1
	         is being added to account for the currently matched figure
	    -->
	   <xsl:variable name="figurecounter">
          <xsl:value-of select="count(preceding::figure)+1"/>
       </xsl:variable>
     
       <!--  Get figure ID -->
	   <xsl:variable name="figure_id">
          <xsl:value-of select="@id"/>
       </xsl:variable> 
       
       <!-- 
          Create a <div> for the figure.  THis is being done because the figure can hold multiple <graphic> elements, so a <div> is created
          to place the id of the figure for jumping to when the Figure number link is selected in the content.
        -->
       <div id="{$figure_id}">
	   
	      <!--  Apply templates to pick up the children of <figure>, i.e., <graphic> -->
	      <xsl:apply-templates/>
	   
	      <!--  Phase 2 Issue 5 & 6 -->
	      <!--  Center align the Figure and its label --> 
	      <div align="center">
	         <p class ="imageTitle">Fig <xsl:value-of select="$figurecounter" /> <xsl:text> </xsl:text> <xsl:value-of select="title" /><xsl:text> </xsl:text></p>
	      </div>
	   </div>
	
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

  