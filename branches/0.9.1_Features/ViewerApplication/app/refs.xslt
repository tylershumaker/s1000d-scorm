<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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
    <xsl:variable name="refmic" select="./dmRefIdent/dmCode/@modelIdentCode" />
    <xsl:variable name="refsysdif" select="./dmRefIdent/dmCode/@systemDiffCode" />
    <xsl:variable name="refsyscode" select="./dmRefIdent/dmCode/@systemCode" />
    <xsl:variable name="refsubsyscode" select="./dmRefIdent/dmCode/@subSystemCode" />
    <xsl:variable name="refsubsubsyscode" select="./dmRefIdent/dmCode/@subSubSystemCode" />
    <xsl:variable name="refassycode" select="./dmRefIdent/dmCode/@assyCode" />
    <xsl:variable name="refdisassycode" select="./dmRefIdent/dmCode/@disassyCode" />
    <xsl:variable name="refdisassycodevariant" select="./dmRefIdent/dmCode/@disassyCodeVariant" />
    <xsl:variable name="refinfocode" select="./dmRefIdent/dmCode/@infoCode" />
    <xsl:variable name="refinfocodevariant" select="./dmRefIdent/dmCode/@infoCodeVariant" />
    <xsl:variable name="refitemlocationcode" select="./dmRefIdent/dmCode/@itemLocationCode" />
    <xsl:variable name="reflearncode" select="./dmRefIdent/dmCode/@learnCode" />
    <xsl:variable name="reflearneventcode" select="./dmRefIdent/dmCode/@learnEventCode" />

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

    <xsl:variable name="ref_dmc">
      <xsl:value-of select="document('./urn_resource_map.xml')//target[parent::urn[contains(@name, $ref_dmcode)]]" />
    </xsl:variable>
      <xsl:choose>
        <xsl:when test="ancestor::learning">
          <xsl:variable name ="infoname">
            <xsl:value-of select ="./dmRefAddressItems/dmTitle/infoName"></xsl:value-of>
          </xsl:variable>
          <xsl:variable name ="techname">
            <xsl:value-of select ="./dmRefAddressItems/dmTitle/techName"></xsl:value-of>
          </xsl:variable>
          <a href="javascript:void(window.open('{$ref_dmc}'))">
            <xsl:value-of select="$techname" /> - <xsl:value-of select="$infoname" />
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
          <tr>
            <td>
              <xsl:apply-templates />
            </td>
            <td>
              <xsl:call-template name="createXLink">
                <xsl:with-param name="actuateMode" select="$actuateMode"></xsl:with-param>
                <xsl:with-param name="showMode" select="$showMode"></xsl:with-param>
                <xsl:with-param name="xlinkhref" select="$xlinkhref"></xsl:with-param>
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
		<xsl:variable name ="infoname">
			<xsl:value-of select ="./dmRefAddressItems/dmTitle/infoName"></xsl:value-of>
		</xsl:variable>
		<xsl:variable name ="techname">
			<xsl:value-of select ="./dmRefAddressItems/dmTitle/techName"></xsl:value-of>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$actuateMode='onRequest'">
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
				<a href="javascript:void(window.open('{$xlinkhref}'))">
					<xsl:value-of select="$techname" /> - <xsl:value-of select="$infoname" />
				</a>
			</xsl:when>
		</xsl:choose>
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

	<xsl:template match="internalRef[@internalRefTargetType='figure']">
		<xsl:variable name="href" select="@xlink:href"/>
		<xsl:variable name="intrefid" select="@internalRefId"/>
		<!--<xsl:variable name ="urn" select="//figure[@id=$intrefid]" />-->
		<xsl:variable name="link_text" select="//figure[@id=$intrefid]/title" />
		<a href="{$href}">
			<xsl:value-of select="$link_text" />
		</a>
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

</xsl:stylesheet>

  