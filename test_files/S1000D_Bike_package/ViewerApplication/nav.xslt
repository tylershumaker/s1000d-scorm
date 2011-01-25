<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://www.purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<xsl:template match="dita/topic">
		<html>
			<head>
				<!-- Detailed layout -->
				<meta http-equiv="X-UA-Compatible" content="IE=7" />
				<link rel="stylesheet" href="common.css" type="text/css" />
				<script type="text/javascript" src="common.js"></script>
			</head>
			<body bgcolor="#FFFFFF" class="bodyText">
				<p>
					<xsl:apply-templates/>
				</p>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="topic">
		<hr></hr>
		<p>
		<xsl:apply-templates />
		</p>
		
	</xsl:template>
	<xsl:template match="title" >
		<p class="{@outputclass}">
			<b><xsl:apply-templates /></b>
		</p>
	</xsl:template>
	
	<xsl:template match="reference">
		<xsl:variable name="var_list">
			<xsl:value-of select="@id" />
		</xsl:variable>
		<p>
			<a href="javascript:void(toggle_visibility('{$var_list}'))" class="{@outputclass}">
				<xsl:apply-templates />
			</a>
		</p>
	</xsl:template>
	
	<xsl:template match="linklist">
		<xsl:variable name="var_list">
			<xsl:value-of select="parent::reference/attribute::id" />
		</xsl:variable>
		<xsl:variable name="section_pane_state">none</xsl:variable>
		<table id="{$var_list}" border="0" style="display:{$section_pane_state}" class="{@outputclass}">
			<xsl:apply-templates />
		</table>
	</xsl:template>
	
	<xsl:template match="link">
		<xsl:variable name="content_url">
			<xsl:value-of select="@href" />
		</xsl:variable>
		<tr>
			<td>
				<a href="{$content_url}" target="content">
					<xsl:value-of select="@linktext" />
				</a>
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
