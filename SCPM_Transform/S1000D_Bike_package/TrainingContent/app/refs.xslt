<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
	File:    refs.xslt
	Version: 2005-07-18

	Part of S1000D xslt/css baseline stylesheets

	This file constitutes one part of a set of xslt/css stylesheets for 
	rendering of information complying to 
	S1000D Issue 2.2 XML Neutral Repository Format.
    
	Copyright (C) 2005  Swedish Defence Material Administration

	The stylesheets are free resources; you can redistribute them and/or modify
	them under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	The stylesheets are distributed in the hope that they will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this file; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

	The stylesheets have been developed by Sörman Information & Media on 
	behalf of the copyright holder. Questions and comments should be directed to
	svante.ericsson@sorman.se and/or EPWG Chairman/Co-chairmen (see www.s1000d.org).
    

	Revisions:									
	Date    Author		Code/ref	Description	
	050717	Svante Ericsson			Show hotspot apsname
	050717	Svante Ericsson			Limited spare/refs support	
-->
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

	<!--<xsl:template match="dmRef">
		<xsl:variable name ="xlinkactuate">
			<xsl:value-of select ="@xlink:actuate"></xsl:value-of>
		</xsl:variable>
		<xsl:variable name ="xlinkshow">
			<xsl:value-of select ="@xlink:show"></xsl:value-of>
		</xsl:variable>
		<xsl:variable name ="xlinktype">
			<xsl:value-of select ="@xlink:type"></xsl:value-of>
		</xsl:variable>
		<xsl:variable name ="xlinkhref">
			<xsl:value-of select ="@xlink:href"></xsl:value-of>
		</xsl:variable>
		<xsl:variable name ="infoname">
			<xsl:value-of select ="./dmRefAddressItems/dmTitle/infoName"></xsl:value-of>
		</xsl:variable>
		<xsl:variable name ="techname">
			<xsl:value-of select ="./dmRefAddressItems/dmTitle/techName"></xsl:value-of>
		</xsl:variable>
		<xsl:variable name="theFileName">
			<xsl:value-of select="document('./urn_resource_map.xml')//target[parent::urn[@name=$xlinkhref]]"/>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$xlinkactuate = 'onRequest' and xlinkshow ='new'">
				<a href="" onclick="openWindow('{$theFileName}')">
					<xsl:value-of select="$techname" /> - <xsl:value-of select="$infoname" />
				</a>
				
			</xsl:when>
		</xsl:choose>
		
	</xsl:template>-->

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
	
	

	<!--<xsl:template match="xref[@xidtype='hotspot']">
		<xsl:variable name="xrefid" select="@xlink:href"/>
		<xsl:call-template name="createFigureLink">
			<xsl:with-param name="xmode">hotspot</xsl:with-param>
			<xsl:with-param name="xrefid" select="$xrefid"/>
			<xsl:with-param name="urn" select="//graphic[child::hotspot[@id=$xrefid]]/@xlink:href"/>
			<xsl:with-param name="destitle" select="@destitle"/>
		</xsl:call-template>
	</xsl:template>-->

	<!--added 06/12/09 STW-->
	<xsl:template name="dmref" match="dmRef">
		<xsl:variable name="actuateMode" select="@xlink:actuate"/>
		<xsl:variable name="showMode" select="@xlink:show"/>
		<xsl:variable name="xlinkurn" select="@xlink:href"/>
		<xsl:variable name="xlinkhref">
			<xsl:value-of select="document('urn_resource_map.xml')//target[parent::urn[@name=$xlinkurn]]"/>
		</xsl:variable>
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
		<xsl:choose>
			<xsl:when test="ancestor::learning">
				<xsl:variable name="ref_dmc" select="concat('DMC','-',$mic,'-',$sysdif,'-',
						  $syscode,'-',$subsyscode,$subsubsyscode,'-',$assycode,'-',$disassycode,$disassycodevariant,'-',
						  $infocode,$infocodevariant,'-',$itemlocationcode,'-',$learncode,
						  $learneventcode,'_','001','-','00','_','en','-','US','.xml')" />
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
			<xsl:otherwise>
				<xsl:variable name ="xlinkactuate">
					<xsl:value-of select ="@xlink:actuate"></xsl:value-of>
				</xsl:variable>
				<xsl:variable name ="xlinkshow">
					<xsl:value-of select ="@xlink:show"></xsl:value-of>
				</xsl:variable>
				<xsl:variable name ="xlinktype">
					<xsl:value-of select ="@xlink:type"></xsl:value-of>
				</xsl:variable>
				<!--<xsl:variable name ="xlinkhref">
					<xsl:value-of select ="@xlink:href"></xsl:value-of>
				</xsl:variable>-->
				<xsl:variable name ="infoname">
				<xsl:value-of select ="//ancestor::refs/dmRef[@xlink:href=$xlinkurn]/dmRefAddressItems/dmTitle/infoName" />
				</xsl:variable>
				<!--<xsl:variable name ="infoname">
					<xsl:value-of select ="./dmRefAddressItems/dmTitle/infoName"></xsl:value-of>
				</xsl:variable>-->
				<xsl:variable name ="techname">
					<xsl:value-of select ="//ancestor::refs/dmRef[@xlink:href=$xlinkurn]/dmRefAddressItems/dmTitle/techName" />
				</xsl:variable>
				<a href="javascript:void(window.open('{$xlinkhref}'))">
					<xsl:value-of select="$techname" /> - <xsl:value-of select="$infoname" />
				</a>


			</xsl:otherwise>
		</xsl:choose>
		
			

		<xsl:if test="parent::refs">
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
		</xsl:if>
		<!--<xsl:if test="parent::para">
			<xsl:call-template name="createXLink">
				<xsl:with-param name="actuateMode" select="$actuateMode"></xsl:with-param>
				<xsl:with-param name="showMode" select="$showMode"></xsl:with-param>
				<xsl:with-param name="xlinkhref" select="$xlinkhref"></xsl:with-param>
			</xsl:call-template>
		</xsl:if>-->
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
				<xsl:choose>
					<xsl:when test="$showMode='replace'">
						<!--<xsl:variable name="dmc">
							<xsl:value-of select="substring-before($xlinkhref,'.xml')" />;
						</xsl:variable>-->
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$xlinkhref" />
							</xsl:attribute>
							<xsl:value-of select="$xlinkhref" />
						</a>
					</xsl:when>
				</xsl:choose>
				<!--add conditons for new window here-->
				<xsl:choose>
					<xsl:when test="$showMode='new'">
						<a href="javascript:void(window.open('{$xlinkhref}'))">
							<xsl:value-of select="$techname" /> - <xsl:value-of select="$infoname" />
						</a>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="//internalRef">
		<!--<xsl:choose>
			<xsl:when test="">-->
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

	<!--<xsl:template name="createFigureLink">
		<xsl:param name="xmode"/>
		<xsl:param name="xrefid"/>
		<xsl:param name="urn"/>
		<xsl:param name="destitle"/>
		<a>
			<xsl:attribute name="href">#<xsl:value-of select="$urn"/></xsl:attribute>
			<xsl:value-of select="$figure_text"/>&#160;
			<xsl:for-each select="//figure">
				<xsl:if test="@id = $xrefid or descendant::hotspot/@id = $xrefid">
					<xsl:value-of select="position()"/>&#160;
					<xsl:choose>
						<xsl:when test="$destitle != ''">
							<xsl:value-of select="$destitle"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="child::title"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
		</a>
	</xsl:template>-->

</xsl:stylesheet>

  