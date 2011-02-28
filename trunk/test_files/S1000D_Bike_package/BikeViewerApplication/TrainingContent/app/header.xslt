<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dc="http://www.purl.org/dc/elements/1.1/"
    version="1.0">

	<xsl:template match="rdf:Description">
		<!--<xsl:apply-templates select="dmaddres/dmtitle" mode="dm_title"/>-->
		<span id="metadataPane">
			<table class="metadataPane">
				<tr>
					<td>
						<b><xsl:value-of select ="dc:identifier" /></b>
					</td>
					<td>
					
					</td>
				</tr>
				<tr>
					<td><xsl:value-of select ="dc:subject" /></td>
				</tr>
			</table>
		</span>
		<p>
			<a href="javascript:void(toggle_visibility('metadataPane'))">Additional Information</a>
		</p>
	</xsl:template>

	<!--<xsl:template name ="dmc" match="dmodule/identAndtStatusSection/dmAddress/dmIdent/dmCode" mode="globalDmc">
		<xsl:variable name="mic" select="@modelIdentCode" />
		<xsl:variable name="sysdif" select="@systemDiffCode" />
		<xsl:variable name="syscode" select="@systemCode" />
		<xsl:variable name="subsyscode" select="@subSystemCode" />
		<xsl:variable name="subsubsyscode" select="@subSubSystemCode" />
		<xsl:variable name="assycode" select="@assyCode" />
		<xsl:variable name="disassycode" select="@disassyCode" />
		<xsl:variable name="disassycodevariant" select="@disassyCodeVariant" />
		<xsl:variable name="infocode" select="@infoCode" />
		<xsl:variable name="infocodevariant" select="@infoCodeVariant" />
		<xsl:variable name="itemlocationcode" select="@itemLocationCode" />
		<xsl:variable name="learncode" select="@learnCode" />
		<xsl:variable name="learneventcode" select="@learnEventCode" />
		<xsl:variable name="lang_country" select="@countryIsoCode" />
		<xsl:variable name="lang_code" select="@languageIsoCode" />
		<xsl:variable name="issno" select="@issueNumber" />
		<xsl:variable name="inwork" select="@inWork" />

		<xsl:variable name="the_dmc" select="concat('DMC','-',$mic,'-',$sysdif,'-',
						  $syscode,'-',$subsyscode,$subsubsyscode,'-',$assycode,'-',$disassycode,$disassycodevariant,'-',
						  $infocode,$infocodevariant,'-',$itemlocationcode,'-',$learncode,'-',
						  $learneventcode,'_','001','-','00','_','en','-','US','.xml')" />
		<xsl:value-of select="$the_dmc" />
	</xsl:template>-->

	<!--<xsl:template match="pmstatus">
		<xsl:apply-templates/>
	</xsl:template>-->

	
	<xsl:template match="dmc" mode="globalDmc">
		<xsl:apply-templates mode="ref"/>
	</xsl:template>

	<!--<xsl:template match="dmaddres/dmc">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'DMC'"/>
			<xsl:with-param name="value">
				<xsl:value-of select="$dataModuleCode"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>-->

	<!--<xsl:template match="dmtitle" mode="dm_title">
		<xsl:if test="not(ancestor::pm)">
			--><!--<span id="pmTitle"><script>parent.frames[0].start()</script></span>--><!--
		</xsl:if>
		<h3 class="nomarginbottom"><xsl:apply-templates mode="dm_title"/></h3>
	</xsl:template>

	<xsl:template match="techname" mode="dm_title">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="infoname" mode="dm_title">
		- <xsl:apply-templates/>
	</xsl:template>-->
	<!-- Metadata section -->
	<!--<xsl:template match="issno">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Issno and type'"/>
			<xsl:with-param name="value"><xsl:value-of select="@issno"/>&#160;

				<xsl:choose>
					<xsl:when test="@type = 'new'">
						New Data Module
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@type"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>-->

	<!--<xsl:template match="issdate">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Issdate'"/>
			<xsl:with-param name="value">
				<xsl:value-of select="@year"/>-<xsl:value-of select="@month"/>-<xsl:value-of select="@day"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>-->

	<!--<xsl:template match="security">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Security'"/>
			<xsl:with-param name="value" select="@class"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="distrib">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Distribution'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="expcontent">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Export control'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="handling">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Handling'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="destruct">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Destruction'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="disclose">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Disclosure'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>-->

	<xsl:template match="techname">
		<!--Suppress-->
	</xsl:template>

	<!--<xsl:template match="copyright//para">
		<tr>
			<td valign="top" nowrap="">
				<xsl:if test="not(preceding-sibling::para)">
					Copyright:&#160;
				</xsl:if>
			</td>
			<td>
				<xsl:apply-templates/>
			</td>
		</tr>
	</xsl:template>-->

<!-- Obsolete!!
	<xsl:template match="holder">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Copyright holder'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="firstyear">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Copyright came into force'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="lastyear">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Copyright expires'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="registeredwith">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Copyright registered with'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="govtlicense">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Copyright government license'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>
-->

	<!--<xsl:template match="polref">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Security policy information'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="datacond">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Special conditions'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="techstd">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Technical standard'"/>
			<xsl:with-param name="value">
				<xsl:if test="descendant::authblk!=''">
					Authority:&#160;<xsl:value-of select="descendant::authblk"/>;
				</xsl:if>
				<xsl:if test="descendant::tpbase!=''">
					Baseline number:&#160;<xsl:value-of select="descendant::tpbase"/>;
				</xsl:if>
				<xsl:if test="descendant::addmod!=''">
					Additional:&#160;<xsl:value-of select="descendant::addmod"/>;
				</xsl:if>
				<xsl:if test="descendant::exmod!=''">
					Excluded:&#160;<xsl:value-of select="descendant::exmod"/>;
				</xsl:if>
				<xsl:if test="descendant::mod/attribute::authno!=''">
					Retrofit order:&#160;<xsl:value-of select="descendant::mod/attribute::authno"/>;
				</xsl:if>
				<xsl:if test="descendant::modtitle!=''">
					Modification title:&#160;<xsl:value-of select="descendant::modtitle"/>;
				</xsl:if>
				<xsl:if test="descendant::notes!=''">
					Notes:&#160;<xsl:value-of select="descendant::notes"/>;
				</xsl:if>
			</xsl:with-param>	
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="dmsize">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Dmsize'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="status/rpc">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="$rpc"/>
			<xsl:with-param name="value"><xsl:value-of select="@rpcname"/> = <xsl:value-of select="text()"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="orig">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Originator'"/>
			<xsl:with-param name="value"><xsl:value-of select="@origname"/> = <xsl:value-of select="text()"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="status/brexref/refdm">
		<tr>
			<td valign="top" nowrap="">
					Business rules DM:&#160;
			</td>
			<td>
				<xsl:apply-templates mode="ref"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="status/applic">
		<xsl:call-template name="applic"/>
	</xsl:template>

	<xsl:template match="qa">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Quality Assurance Status'"/>
			<xsl:with-param name="value">
				<xsl:if test="child::unverif">
					Draft
				</xsl:if>
				<xsl:if test="child::firstver">
					First verification&#160;(<xsl:value-of select="child::firstver/@type"/>)
				</xsl:if>
				<xsl:if test="child::secver">
					Second verification&#160;(<xsl:value-of select="child::firstver/@type"/>)
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="sbc">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'System Breakdown Code'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>
	


	<xsl:template match="fic">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Functional Item Code'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="modelic">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Model'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="pmissuer">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Issuer'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="pmnumber">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Number'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="pmvolume">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Volume'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="pmstatus/rpc">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="$rpc"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="pmaddres/pmtitle">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Title'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="pmstatus/effect">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Effectivity'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="status//remarks">
		<xsl:call-template name="addMetadataRow">
			<xsl:with-param name="label" select="'Description'"/>
			<xsl:with-param name="value" select="text()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="addMetadataRow">
		<xsl:param name="label"/>
		<xsl:param name="value"/>
		<tr>
			<td valign="top" nowrap="">
				<xsl:value-of select="$label"/>:&#160;
			</td>
			<td valign="top">
				<xsl:value-of select="$value"/>
			</td>
		</tr>
	</xsl:template>
-->
</xsl:stylesheet>

  

