<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:variable name="empty_string"/>
<!-- references -->
	<xsl:template match="refs">
		<xsl:if test="parent::content|parent::deftask">
			<h4 class="decreaseTopBottom">
				<xsl:value-of select="$ref_text"/>
			</h4>
			<table border="0" width="100%" class="lineTopAndBottom" cellspacing="0" cellpadding="3">
				<tr class="lineBottom">
					<xsl:call-template name="generalTblHeader">
						<xsl:with-param name="label" select="'Title'"></xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="generalTblHeader">
						<xsl:with-param name="label" select="'DMC'"></xsl:with-param>
					</xsl:call-template>
				</tr>
				<xsl:apply-templates/>
			</table>
		</xsl:if>
		
		<xsl:if test="parent::spare|parent::supply|parent::supequi">
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="reftp">
		<xsl:choose>
			<xsl:when test="ancestor::refs[parent::content]">
				<tr>
					<td><xsl:apply-templates/></td><td/>
				</tr>
			</xsl:when>
			<xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="refs[norefs]">
		<!--suppress-->
	</xsl:template>

	<xsl:template match="norefs">
		<!-- suppress
		<tr><td><xsl:value-of select="$none_text"/></td></tr>
		-->
	</xsl:template>

<!--
	<xsl:template match="reqdm">
-->
	<xsl:template match="reqcondm/refdm">
		<xsl:variable name="reqdm"><xsl:apply-templates mode="ref"/></xsl:variable>
		<td>
			<a>	
				<xsl:attribute name="id"><xsl:number format="1" value="count(preceding::xref|preceding::refdm|preceding::reqdm) + 1"/></xsl:attribute>
				<xsl:attribute name="href">
					javascript:parent.frames[0].goToLink('<xsl:value-of select="document($urn_resource_file)//target[parent::urn[contains(@name, $reqdm)]]"/>', '<xsl:number format="1" value="count(preceding::xref|preceding::refdm|preceding::reqdm) + 1"/>')
				</xsl:attribute>
				<xsl:value-of select="$reqdm"/>
		</a>
		</td>
	</xsl:template>

<!-- Added 050717/SE -->
	<xsl:template match="reqcontp/reftp">
		<td>
			<a>
				<xsl:apply-templates/>
			</a>
		</td>
	</xsl:template>

	<xsl:template match="refdms">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="refdm">
		<xsl:variable name="refname">
			<xsl:apply-templates mode="ref"/>
		</xsl:variable>
		<xsl:variable name="dmFileName">
			<xsl:call-template name="getUrnTarget">
				<xsl:with-param name="urn" select="@xlink:href"/>
				<xsl:with-param name="linkType" select="'DM'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="linkName">
			<xsl:call-template name="getDmTitle">
				<xsl:with-param name="dmFileName" select="$dmFileName"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="ancestor::refs[parent::content]|ancestor::refs[parent::deftask]">
				<tr>
					<td><xsl:value-of select="$linkName"/></td>
					<td>
						<a><xsl:attribute name="id"><xsl:number format="1" value="count(preceding::xref|preceding::refdm|preceding::reqdm) + 1"/></xsl:attribute><xsl:attribute name="href">javascript:parent.frames[0].goToLink('<xsl:value-of select="$dmFileName"/>', '<xsl:number format="1" value="count(preceding::xref|preceding::refdm|preceding::reqdm) + 1"/>')</xsl:attribute><xsl:value-of select="$refname"/></a>
					</td>
				</tr>
			</xsl:when>
			<xsl:when test="parent::pmentry">            
				<a target="content">
					<xsl:attribute name="href">javascript:parent.frames[0].goToLink('<xsl:value-of select="$dmFileName"/>', '0')<!--#<xsl:value-of select="$pmTitle"/--></xsl:attribute>
					<xsl:value-of select="$linkName"/>
				</a>
			</xsl:when>
			<xsl:when test="parent::refs[parent::spare]|parent::refs[parent::supply]|parent::refs[parent::supequi]">
				<td>
					<a><xsl:attribute name="id"><xsl:number format="1" value="count(preceding::xref|preceding::refdm|preceding::reqdm) + 1"/></xsl:attribute><xsl:attribute name="href">javascript:parent.frames[0].goToLink('<xsl:value-of select="$dmFileName"/>', '<xsl:number format="1" value="count(preceding::xref|preceding::refdm|preceding::reqdm) + 1"/>')</xsl:attribute><xsl:value-of select="$refname"/></a>
				</td>
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="id">
						<xsl:number format="1" value="count(preceding::xref|preceding::refdm|preceding::reqdm) + 1"/>
					</xsl:attribute>
					<xsl:attribute name="href">
						javascript:parent.frames[0].goToLink('<xsl:value-of select="$dmFileName"/>', '<xsl:number format="1" value="count(preceding::xref|preceding::refdm|preceding::reqdm) + 1"/>');
					</xsl:attribute>
					<xsl:value-of select="$linkName"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getDmTitle">
		<xsl:param name="dmFileName"/>
		<xsl:choose>
			<xsl:when test="child::dmtitle">
				<xsl:value-of select="dmtitle/techname"/>
				<xsl:if test="child::dmtitle/infoname">
				- <xsl:value-of select="child::dmtitle/infoname"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="document($dmFileName)//dmtitle/techname"/> - <xsl:value-of select="document($dmFileName)//dmtitle/infoname"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="age|avee">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="modelic|subsect|discodev|incodev|supeqvc|ecscs|eidc|cidc|sdc|chapnum|subject" mode="ref">
		<xsl:value-of select="text()"/>-</xsl:template><!--Cannot be intendented because occurence of spaces-->

	<xsl:template match="discode|incode|section|itemloc" mode="ref">
		<xsl:value-of select="text()"/>
	</xsl:template>

	<xsl:template match="xref">
		<xsl:variable name="xrefid" select="@xrefid"/>
		<a>
			<xsl:attribute name="id"><xsl:number format="1" value="count(preceding::xref|preceding::refdm|preceding::reqdm) + 1"/></xsl:attribute>
			<xsl:attribute name="href">javascript:parent.frames[0].goToLink('<xsl:value-of select="@xlink:href"/>', '<xsl:number format="1" value="count(preceding::xref|preceding::refdm|preceding::reqdm) + 1"/>');</xsl:attribute>
			
			<xsl:choose>
				<xsl:when test="@xidtype = 'table'">
					<xsl:value-of select="$table_text"/>&#160;
					<xsl:for-each select="//table">
						<xsl:if test="$xrefid = @id">
							<xsl:value-of select="position()"/>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="@xidtype = 'para'">
					<xsl:value-of select="//para0[@id=$xrefid]/title|
						//subpara1[@id=$xrefid]/title|
						//subpara2[@id=$xrefid]/title|
						//subpara3[@id=$xrefid]/title|
						//subpara4[@id=$xrefid]/title"/>
				</xsl:when>
				<xsl:when test="@xidtype='step'">
					<xsl:value-of select="//step1[@id=$xrefid]/para[1]|
					//step2[@id=$xrefid]/para[1]|
					//step3[@id=$xrefid]/para[1]|
					//step4[@id=$xrefid]/para[1]|
					//step5[@id=$xrefid]/para[1]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="//supequi[@id=$xrefid]/pretext | //supply[@id=$xrefid]/pretext"/>
					<xsl:value-of select="//supequi[@id=$xrefid]/nomen | //spare[@id=$xrefid]/nomen | //nomen[preceding-sibling::supply[@id=$xrefid]]|//supply[@id=$xrefid]/nomen"/>
					<xsl:value-of select="//supequi[@id=$xrefid]/postext | //supply[@id=$xrefid]/postext"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>

	<!--added 06/12/09 STW-->
  <xsl:template name="dmref" match="dmRef">
    <xsl:variable name="actuateMode" select="@xlink:actuate"/>
    <xsl:variable name="showMode" select="@xlink:show"/>
    <xsl:variable name="xlinkurn" select="@xlink:href"/>
    <xsl:variable name="xlinkhref">
      <xsl:value-of select="document('urn_resource_map.xml')//target[parent::urn[@name=$xlinkurn]]"/>
    </xsl:variable>    
    
    <xsl:variable name="temp_id" select="@id"/>
    
    <xsl:variable name="refassycode" select="./dmRefIdent/dmCode/@assyCode" />
    <xsl:variable name="refdisassycode" select="./dmRefIdent/dmCode/@disassyCode" />
    <xsl:variable name="refdisassycodevariant" select="./dmRefIdent/dmCode/@disassyCodeVariant" />
    <xsl:variable name="refinfocode" select="./dmRefIdent/dmCode/@infoCode" />
    <xsl:variable name="refinfocodevariant" select="./dmRefIdent/dmCode/@infoCodeVariant" />
    <xsl:variable name="refitemlocationcode" select="./dmRefIdent/dmCode/@itemLocationCode" />
    <xsl:variable name="reflearncode" select="./dmRefIdent/dmCode/@learnCode" />
    <xsl:variable name="reflearneventcode" select="./dmRefIdent/dmCode/@learnEventCode" />
    <xsl:variable name="refmic" select="./dmRefIdent/dmCode/@modelIdentCode" />
    <xsl:variable name="refsubsubsyscode" select="./dmRefIdent/dmCode/@subSubSystemCode" />
    <xsl:variable name="refsubsyscode" select="./dmRefIdent/dmCode/@subSystemCode" />
    <xsl:variable name="refsyscode" select="./dmRefIdent/dmCode/@systemCode" />
    <xsl:variable name="refsysdif" select="./dmRefIdent/dmCode/@systemDiffCode" />

    <xsl:variable name="ref_dmcode" >
      <xsl:choose>
        <xsl:when test="string-length($reflearncode) = 0 and string-length($reflearneventcode) = 0">
          <xsl:value-of select="concat($refmic,'-',$refsysdif,'-',
      $refsyscode,'-',$refsubsyscode,$refsubsubsyscode,'-',$refassycode,'-',$refdisassycode,$refdisassycodevariant,'-',
      $refinfocode,$refinfocodevariant,'-',$refitemlocationcode)" />
        </xsl:when>
        <xsl:when test="string-length($reflearncode) > 0 and string-length($reflearneventcode) = 0">
          <xsl:value-of select="concat($refmic,'-',$refsysdif,'-',
      $refsyscode,'-',$refsubsyscode,$refsubsubsyscode,'-',$refassycode,'-',$refdisassycode,$refdisassycodevariant,'-',
      $refinfocode,$refinfocodevariant,'-',$refitemlocationcode,'-',$reflearncode)" />
        </xsl:when>
        <xsl:when test="string-length($reflearncode) = 0 and string-length($reflearneventcode) > 0">
          <xsl:value-of select="concat($refmic,'-',$refsysdif,'-',
      $refsyscode,'-',$refsubsyscode,$refsubsubsyscode,'-',$refassycode,'-',$refdisassycode,$refdisassycodevariant,'-',
      $refinfocode,$refinfocodevariant,'-',$refitemlocationcode,'-',$reflearneventcode)" />
        </xsl:when>
        <xsl:when test="string-length($reflearncode) > 0 and string-length($reflearneventcode) > 0">
          <xsl:value-of select="concat($refmic,'-',$refsysdif,'-',
      $refsyscode,'-',$refsubsyscode,$refsubsubsyscode,'-',$refassycode,'-',$refdisassycode,$refdisassycodevariant,'-',
      $refinfocode,$refinfocodevariant,'-',$refitemlocationcode,'-',$reflearncode,$reflearneventcode)" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name ="urn_prefix">
        <xsl:value-of select="'URN:S1000D:DMC-'" />
    </xsl:variable>
    <xsl:variable name="urn_string">
        <xsl:value-of select="concat($urn_prefix, $ref_dmcode)" />
    </xsl:variable>

    <xsl:variable name="ref_dmc">
      <xsl:value-of select="document('./urn_resource_map.xml')//target[parent::urn[@name=$urn_string]]" />
    </xsl:variable>
     
     <!--ref_dmc[<xsl:value-of select="$ref_dmc"/>]-->
     
      <xsl:choose>
        <xsl:when test="ancestor::learning or ancestor::crewDrillStep">
          <xsl:variable name ="infoname">
            <xsl:value-of select ="./dmRefAddressItems/dmTitle/infoName"></xsl:value-of>
          </xsl:variable>
          <xsl:variable name ="techname">
            <xsl:value-of select ="./dmRefAddressItems/dmTitle/techName"></xsl:value-of>
          </xsl:variable>
          <a href="javascript:void(window.open('{$ref_dmc}'))">
            <xsl:choose>
                <xsl:when test="$infoname = $empty_string and $techname = $empty_string">
                    <xsl:value-of select="$ref_dmcode" />
                </xsl:when>
                <xsl:when test="$infoname != $empty_string and $techname = $empty_string">
                    <xsl:value-of select="$infoname"/>
                </xsl:when>
                <xsl:when test="$infoname = $empty_string and $techname != $empty_string">
                    <xsl:value-of select="$techname"/>
                </xsl:when>                
                <xsl:otherwise>
                    <xsl:value-of select="$techname" /> - <xsl:value-of select="$infoname" />
                </xsl:otherwise>                
            </xsl:choose>
          </a>
        </xsl:when>
        <xsl:when test="ancestor::trainingStep or ancestor::para">
            <a href="javascript:void(window.open('{$ref_dmc}'))">
                <xsl:value-of select="$ref_dmcode" />
            </a> 
        </xsl:when>      
        <xsl:when test="parent::refs">
          <xsl:variable name ="xlinkactuate">
            <xsl:value-of select ="@xlink:actuate"></xsl:value-of>
          </xsl:variable>
          <xsl:variable name ="xlinkshow">
            <xsl:value-of select ="@xlink:show"></xsl:value-of>
          </xsl:variable>
          <xsl:variable name ="xlinktype">
            <xsl:value-of select ="@xlink:type"></xsl:value-of>
          </xsl:variable>
          <xsl:variable name ="infoname">
            <xsl:value-of select ="//ancestor::refs/dmRef[@xlink:href=$xlinkurn]/dmRefAddressItems/dmTitle/infoName" />
          </xsl:variable>
          <xsl:variable name ="techname">
            <xsl:value-of select ="//ancestor::refs/dmRef[@xlink:href=$xlinkurn]/dmRefAddressItems/dmTitle/techName" />
          </xsl:variable>
          <!-- 8/28/14 issue 26 no reference anchor -->
          <xsl:variable name="referredFragment">
            <xsl:value-of select="@referredFragment"></xsl:value-of>
          </xsl:variable>
          <tr>
            <td>
              <xsl:apply-templates />
            </td>
            <td>
              <xsl:call-template name="createXLink">
                <xsl:with-param name="actuateMode" select="$actuateMode"></xsl:with-param>
                <xsl:with-param name="showMode" select="$showMode"></xsl:with-param>
                <xsl:with-param name="xlinkhref" select="$xlinkhref"></xsl:with-param>
                <xsl:with-param name="refDmc" select="$ref_dmc"></xsl:with-param>
                <xsl:with-param name="ref_dmcode" select="$ref_dmcode"></xsl:with-param>
                <!-- 8/28/14 issue 26 no reference anchor -->
                <xsl:with-param name="ref_frag" select="$referredFragment"></xsl:with-param>
              </xsl:call-template>
            </td>
          </tr>
        </xsl:when>
      </xsl:choose>
	</xsl:template>
    

	<xsl:template match="dmRefAddressItems">
		<xsl:value-of select="./dmTitle/techName" /> - <xsl:value-of select="./dmTitle/infoName" />
	</xsl:template>

	<!--added 06/12/09 STW-->
	<xsl:template name="createXLink">
		<xsl:param name="actuateMode" />
		<xsl:param name="showMode" />
		<xsl:param name="xlinkhref" />
		<xsl:param name="refDmc" />
        <xsl:param name="ref_dmcode"/>
        <!-- 8/28/14 issue 26 no reference anchor -->
        <xsl:param name="ref_frag"/>
		<xsl:variable name ="infoname">
			<xsl:value-of select ="./dmRefAddressItems/dmTitle/infoName"></xsl:value-of>
		</xsl:variable>
		<xsl:variable name ="techname">
			<xsl:value-of select ="./dmRefAddressItems/dmTitle/techName"></xsl:value-of>
		</xsl:variable>
		
		<!-- <xsl:choose>
			<xsl:when test="$actuateMode='onRequest'">-->
			
			<!-- Ignoring showMode for SCORM output usability -->
<!-- 				<xsl:choose>
					<xsl:when test="$showMode='replace'">
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$xlinkhref" />
							</xsl:attribute>
							<xsl:value-of select="$xlinkhref" />
						</a>
					</xsl:when>
				</xsl:choose> -->
				<!--add conditons for new window here-->
<!-- 				<xsl:choose>
					<xsl:when test="$showMode='new'">
						<a href="javascript:void(window.open('{$xlinkhref}'))">
							<xsl:value-of select="$techname" /> - <xsl:value-of select="$infoname" />
						</a>
					</xsl:when>
				</xsl:choose> -->
				<xsl:choose>
				    <xsl:when test="xlinkhref=''">
				        <a href="javascript:void(window.open('{$xlinkhref}'))">
		                    <xsl:value-of select="$techname" /> - <xsl:value-of select="$infoname" />
		                </a>
				    </xsl:when>
                    <!-- 8/28/14 issue 26 no reference anchor -->
                    <xsl:when test="$ref_frag = $empty_string">
                        <a href="javascript:void(window.open('{$refDmc}'))">
                            <xsl:choose>
                                <xsl:when test="$techname = ''">
                                    <xsl:value-of select="$ref_dmcode"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$techname" /> - <xsl:value-of select="$infoname" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </a>                    
                    </xsl:when>
				    <xsl:otherwise>
                        <!-- 8/28/14 issue 26 no reference anchor -->                        
				        <a href="javascript:void(window.open('{$refDmc}#{$ref_frag}'))">
                            <xsl:choose>
                                <xsl:when test="$techname = ''">
                                    <xsl:value-of select="$ref_dmcode"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$techname" /> - <xsl:value-of select="$infoname" />
                                </xsl:otherwise>
                            </xsl:choose>
		                </a>
				    </xsl:otherwise>
				</xsl:choose>
				
				
				
				
			<!-- </xsl:when>
		</xsl:choose>-->
		
		
	</xsl:template>
	
	<xsl:template match="//internalRef">
		<xsl:variable name="type" select="@internalRefTargetType" />
		<xsl:variable name="actuate" select="@xlink:actuate" />
		<xsl:variable name="show" select="@xlink:show" />
		<xsl:variable name="refid" select="@internalRefId" />
		<xsl:choose>
		<xsl:when test="$type = 'spares'">
								<xsl:variable name="val" select="//*[@id=$refid]" />
								<b><xsl:value-of select="$val" /></b>
							</xsl:when>
			<xsl:when test="$actuate = 'onLoad'">
				<xsl:choose>
					<xsl:when test="$show = 'embed'">
						<xsl:choose>
							<xsl:when test="$type = 'text'">
								<xsl:variable name="val" select="//*[@id=$refid]" />
								<b><xsl:value-of select="$val" /></b>
							</xsl:when>
							
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
							
	</xsl:template>
	
	<!--end added-->	
	
	<!-- Phase 2: Issue 6 -->
	<!-- Figure counting not working. -->
	<!-- When you encounter a figure (irtt01), determine the figure number to use in the refernece to the figure -->
    <xsl:template match="internalRef[@internalRefTargetType='irtt01']">
       
       <!-- The reference id to place at the end of the URL -->
       <xsl:variable name="intrefid" select="@internalRefId"/>
       
       <!-- Identify the figure with the internalRefID and determine the figure number to reference -->
       <xsl:variable name="identifiedFig" select="//figure[@id=$intrefid]"/>
       <xsl:variable name="countOfFig" select="count(//figure[@id=$intrefid])"/>
       <xsl:choose>
          <!-- Determine if you are dealing with a <figure> -->
          <xsl:when test="$countOfFig=1">
             <xsl:variable name="precedingFigCount" select="count($identifiedFig/preceding::figure)+1"/>
             <a href="#{$intrefid}">Fig <xsl:value-of select="$precedingFigCount" /></a>
          </xsl:when>
          <!-- Determine if you are dealing with a <figureAlts> -->
          <xsl:when test="count(//figureAlts[@id=$intrefid])=1">      
             <xsl:variable name="identifiedAltFig" select="//figureAlts[@id=$intrefid]"/>
             <xsl:variable name="xxxfigAltId" select="$identifiedAltFig/figure/@id"/>
             <xsl:variable name="precedingFigCount2" select="count($identifiedAltFig/preceding::figure)+1"/>
             <a href="#{$xxxfigAltId}">Fig <xsl:value-of select="$precedingFigCount2" /></a>
          </xsl:when>
          <xsl:otherwise>  <!--  Do nothing --> </xsl:otherwise>
       </xsl:choose>
    </xsl:template> 
    
    <!-- Table references = irtt02 -->
    <xsl:template match="internalRef[@internalRefTargetType='irtt02']">
        <xsl:variable name="intrefid" select="@internalRefId"/>
        
        <!-- Phase 2 similar changes to tables as figures to get the count and number of table references correct. -->
        <xsl:variable name="identifiedTable" select="//table[@id=$intrefid]"/>
        <xsl:variable name="countOfTable" select="count(//table[@id=$intrefid])"/>
        <xsl:choose>
          <!-- Determine if you are dealing with a <table> -->
          <xsl:when test="$countOfTable=1">
             <xsl:variable name="precedingTableCount" select="count($identifiedTable/preceding::table)+1"/>
             <a href="#{$intrefid}">Table <xsl:value-of select="$precedingTableCount" /></a>
          </xsl:when>
          <xsl:otherwise>  <!--  Do nothing --> </xsl:otherwise>
       </xsl:choose>
      <!--   
        <xsl:variable name="tableCounter">
             <xsl:value-of select="count(preceding::internalRef)+1"/>
        </xsl:variable>
        <a href="#{$intrefid}">Table <xsl:value-of select="$tableCounter" /></a>
         -->
    </xsl:template>   
    
     <xsl:template match="internalRef[@internalRefTargetType='irtt08']">
        <xsl:variable name="intrefid" select="@internalRefId"/>
        <xsl:variable name="stepCounter">
             <xsl:value-of select="count(preceding::isolationStep)+1"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="ancestor::isolationStep or ancestor::isolationProcedureEnd or ancestor::proceduralStep">
                <xsl:variable name="hideRefId">
                    <xsl:value-of select="../../@id"/>
                </xsl:variable>
                <a href="#{$intrefid}" onclick="show_hide_div('{$intrefid}','{$hideRefId}')">Step <xsl:value-of select="$stepCounter" /></a>
            </xsl:when>
            <xsl:otherwise>
                <a href="#{$intrefid}">Step <xsl:value-of select="$stepCounter" /></a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>      
	<xsl:template match="internalRef[@internalRefTargetType='figure']">
		<xsl:variable name="href" select="@xlink:href"/>
		<xsl:variable name="intrefid" select="@internalRefId"/>
		<xsl:variable name ="urn" select="//figure[@id=$intrefid]" />
		<xsl:variable name="link_text" select="//figure[@id=$intrefid]/title" />
		<a href="{$href}">
			<xsl:value-of select="$link_text" />
		</a>
	</xsl:template>  
 	<xsl:template match="internalRef[@internalRefTargetType='supply']">
		<xsl:variable name="href" select="@xlink:href"/>
		<xsl:variable name="intrefid" select="@internalRefId"/>
		<xsl:variable name ="urn" select="//figure[@id=$intrefid]" />
		<xsl:variable name="link_text" select="//preliminaryRqmts/reqSupplies/supplyDescrGroup/supplyDescr[@id=$intrefid]/name" />
		<xsl:value-of select="$link_text" />
	</xsl:template>
	<xsl:template match="internalRef[@internalRefTargetType='supequip']">
		<xsl:variable name="href" select="@xlink:href"/>
		<xsl:variable name="intrefid" select="@internalRefId"/>
		<xsl:variable name ="urn" select="//figure[@id=$intrefid]" />
		<xsl:variable name="link_text" select="//preliminaryRqmts/reqSupportEquips/supportEquipDescrGroup/supportEquipDescr[@id=$intrefid]/name" />
		<xsl:value-of select="$link_text" />
	</xsl:template>
	<xsl:template match="internalRef[@internalRefTargetType='para']">
		<xsl:variable name="xrefid" select="@xrefid"/>
		<xsl:variable name="href" select="@xlink:href"/>
		<xsl:variable name="intrefid" select="@internalRefId"/>
		<xsl:variable name="link_text" select="//levelledPara[@id=$intrefid]/title" />
		<a href="#{$href}">
			<xsl:value-of select="$link_text" />
		</a>
	</xsl:template>
	
	<xsl:template match="internalRef[@internalRefTargetType='hotspot']">
		<xsl:variable name="href" select="@xlink:href"/>
		<xsl:variable name="intrefid" select="@internalRefId"/>
		<!-- <xsl:variable name ="urn" select="//figure[@id=$intrefid]" /> -->
		<xsl:variable name="link_text" select="//figure/graphic/hotspot[@id=$intrefid]/@hotspotTitle" />
		<xsl:value-of select="$link_text" />
	</xsl:template>

	<!-- Doesn't want to work -->
	<!-- <xsl:template match="internalRef">
		<xsl:variable name="intrefid" select="@internalRefId"/>
		<xsl:variable name="href" select="@xlink:href"/>
		<xsl:variable name="link_text" select="/root/descendant::node[@id=$intrefid]/title" />
		<a href="{$href}">
			<xsl:value-of select="$link_text" />
		</a>
	</xsl:template> -->
    
    <xsl:template match="externalPubRefIdent">
        <xsl:variable name="code" select="./externalPubCode"/>
        <xsl:variable name ="urn_prefix">
            <xsl:value-of select="'URN:S1000D:'" />
        </xsl:variable>
        <xsl:variable name="urn_string">
            <xsl:value-of select="concat($urn_prefix, $code)" />
        </xsl:variable>
        <xsl:variable name="theFileName">
          <xsl:value-of select="document('./urn_resource_map.xml')//target[parent::urn[@name=$urn_string]]" />
        </xsl:variable>  
       

             <a href="javascript:void(window.open('{$theFileName}'))">
                <xsl:value-of select="$theFileName" />
            </a> 
    
              
    </xsl:template>

</xsl:stylesheet>

  