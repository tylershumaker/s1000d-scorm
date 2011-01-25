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
	
	<!--global vars-->
	<xsl:variable name="global_dmc">
		<xsl:value-of select="//dc:identifier" />_en-US.xml
	</xsl:variable>
	<xsl:template match="/">
	
		<html>
			<head>
				<!-- Detailed layout -->
				<meta http-equiv="X-UA-Compatible" content="IE=7" />
				<link rel="stylesheet" href="app/common.css" type="text/css" /> 
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
