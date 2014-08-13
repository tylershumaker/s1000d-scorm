<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://www.purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
	<xsl:output method="html" indent="yes"/>
	<xsl:include href="params.xslt"/>
	<xsl:include href="funcs.xslt" />
	<xsl:include href="common.xslt"/>
	<xsl:include href="lists.xslt"/>
	<xsl:include href="graphics.xslt"/>
	<xsl:include href="assessment.xslt"/>
	<!--<xsl:include href="header.xslt"/>-->
	<xsl:include href="table.xslt"/>
	<!--<xsl:include href="steps.xslt"/>-->
	<xsl:include href="refs.xslt"/>
	<!--For future use 
	 module specific elements inclusions-->
    <xsl:include href="isolation.xslt"/>
	
	<!--global vars-->
  <xsl:variable name="mic" select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@modelIdentCode" />
  <xsl:variable name="sysdif" select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@systemDiffCode" />
  <xsl:variable name="syscode" select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@systemCode" />
  <xsl:variable name="subsyscode" select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@subSystemCode" />
  <xsl:variable name="subsubsyscode" select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@subSubSystemCode" />
  <xsl:variable name="assycode" select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@assyCode" />
  <xsl:variable name="disassycode" select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@disassyCode" />
  <xsl:variable name="disassycodevariant" select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@disassyCodeVariant" />
  <xsl:variable name="infocode" select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@infoCode" />
  <xsl:variable name="infocodevariant" select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@infoCodeVariant" />
  <xsl:variable name="itemlocationcode" select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@itemLocationCode" />
  <xsl:variable name="learncode" select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@learnCode" />
  <xsl:variable name="learneventcode" select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@learnEventCode" />

  <xsl:variable name="this_dmc" >
    <xsl:choose>
      <xsl:when test="string-length($learncode) = 0 and string-length($learneventcode) = 0">
        <xsl:value-of select="concat($mic,'-',$sysdif,'-',
      $syscode,'-',$subsyscode,$subsubsyscode,'-',$assycode,'-',$disassycode,$disassycodevariant,'-',
      $infocode,$infocodevariant,'-',$itemlocationcode)" />
      </xsl:when>
      <xsl:when test="string-length($learncode) > 0 and string-length($learneventcode) = 0">
        <xsl:value-of select="concat($mic,'-',$sysdif,'-',
      $syscode,'-',$subsyscode,$subsubsyscode,'-',$assycode,'-',$disassycode,$disassycodevariant,'-',
      $infocode,$infocodevariant,'-',$itemlocationcode,'-',$learncode)" />
      </xsl:when>
      <xsl:when test="string-length($learncode) = 0 and string-length($learneventcode) > 0">
        <xsl:value-of select="concat($mic,'-',$sysdif,'-',
      $syscode,'-',$subsyscode,$subsubsyscode,'-',$assycode,'-',$disassycode,$disassycodevariant,'-',
      $infocode,$infocodevariant,'-',$itemlocationcode,'-',$learneventcode)" />
      </xsl:when>
      <xsl:when test="string-length($learncode) > 0 and string-length($learneventcode) > 0">
        <xsl:value-of select="concat($mic,'-',$sysdif,'-',
      $syscode,'-',$subsyscode,$subsubsyscode,'-',$assycode,'-',$disassycode,$disassycodevariant,'-',
      $infocode,$infocodevariant,'-',$itemlocationcode,'-',$learncode,$learneventcode)" />
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

    <xsl:variable name ="urn_prefix">
        <xsl:value-of select="'URN:S1000D:DMC-'" />
    </xsl:variable>
    <xsl:variable name="urn_string">
        <xsl:value-of select="concat($urn_prefix, $this_dmc)" />
    </xsl:variable>

  <xsl:variable name="global_dmc">
    <xsl:value-of select="document('./urn_resource_map.xml')//target[parent::urn[@name=$urn_string]]" />
  </xsl:variable>
	<xsl:template match="/">
	
		<html>
			<head>
				<!-- Detailed layout -->
				<meta http-equiv="X-UA-Compatible" content="IE=7" />
				<link rel="stylesheet" href="app/common.css" type="text/css" /> 
				<link rel="stylesheet" href="app/assessment.css" type="text/css" />
				<script type="text/javascript" src="app/common.js"></script>
			</head>
			<body bgcolor="#FFFFFF" class="bodyText">
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	<xsl:template match ="identAndStatusSection">
		<!--suppress-->
	</xsl:template>

	<xsl:template match="LEARNING|learning">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match ="rdf:Description">
		<xsl:variable name="section_pane_state">block</xsl:variable>
		<div id="metadataDiv" style="display:{$section_pane_state}">
			<table class="metadataPane">
				<tr>
					<td>
						<b>
							<xsl:value-of select ="dc:identifier" />
						</b>
					</td>
					<td>

					</td>
				</tr>
				<tr>
					<td>
						<h5>
							<xsl:value-of select ="dc:subject" />
							
						</h5>
					</td>
				</tr>
			</table>
		</div>
		<p>
			<a href="javascript:void(toggle_visibility('metadataDiv'))">Additional Information</a>
		</p>
	</xsl:template>

</xsl:stylesheet>
