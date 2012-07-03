<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://www.purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
	<xsl:output method="html" indent="yes"/>
	<xsl:include href="lists.xslt"/>
	<xsl:template match="/">
		<HTML>
			<HEAD>
				<meta http-equiv="X-UA-Compatible" content="IE=7" />
				<link rel="STYLESHEET" type="text/css" href="app/LearnPlan.css" />
				<title>
					S1000D Bike Sample Learning Plan
				</title>
				<script type="text/javascript">function toggle_visibility(id)
				{
					var e = document.getElementById(id);
					<!--alert(e.id);-->
					if(e.style.display == 'block' | e.style == null)
					{
						e.style.display = 'none';
						return false;
					}
					else
					{
						e.style.display = 'block';
						return true;
					}
					
				}
				</script>
			</HEAD>
			<BODY bgcolor="#FFFFFF" class="bodyText">
				<div class="documentHeader">
					<p>
						<b>S1000D Bike Sample Learning Plan</b>
					</p>
				</div>
				<div class="content">
					<hr/>
						<xsl:apply-templates/>
					<hr/>
				</div>
			</BODY>
		</HTML>
	</xsl:template>
	<xsl:template match="identAndStatusSection">
		<!--suppress-->
	</xsl:template>
	<xsl:template match="rdf:Description">
		<!--suppress-->
	</xsl:template>
	<xsl:template match="lcProject|lcNeedsAnalysis|lcGapAnalysis|lcIntervention|lcTechnical">
		<xsl:variable name="section_pane_state">none</xsl:variable>
		<xsl:choose>
			<xsl:when test="name()='lcProject'">
				<span class="branchTitle">
					<a href="javascript:void(toggle_visibility('project_data'))">
						<p>Project Information:</p>
					</a>
				</span>
				<div id="project_data">
					<ul class="square">
						<xsl:apply-templates />
					</ul>
				</div>
			</xsl:when>
			<xsl:when test="name()='lcNeedsAnalysis'">
					<span class="branchTitle">
						<a href="javascript:void(toggle_visibility('needs_data'))">
							<p>Needs Analysis</p>
						</a>
					</span>	
				<div id="needs_data" >
					<!--style="display:{$section_pane_state}"-->
					<!--<ul>-->
						<xsl:apply-templates />
					<!--</ul>-->
				</div>
			</xsl:when>
			<xsl:when test="name()='lcGapAnalysis'">
					<span class="branchTitle">
						<a href="javascript:void(toggle_visibility('gap_data'))">
							<p>Gap Analysis:</p>
						</a>
					</span>
				<div id="gap_data">
					<!--<ul>-->
						<xsl:apply-templates />
					<!--</ul>-->
				</div>
			</xsl:when>
			<xsl:when test="name()='lcIntervention'">
				<span class="branchTitle">
					<a href="javascript:void(toggle_visibility('intervention_data'))">
						<p>Intervention:</p>
					</a>
				</span>
				<div id="intervention_data">
					<ul>
						<xsl:apply-templates />
					</ul>
				</div>
			</xsl:when>
			<xsl:when test="name()='lcTechnical'">
				<span class="branchTitle">
					<p>
						<a href="javascript:void(toggle_visibility('technical_data'))"> Technical Information: </a>
					</p>
				</span>
				<div id="technical_data">
					<ul>
						<xsl:apply-templates />
					</ul>
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="description">
			<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="title">
		<!--<li> -->
			<p class="title">
				<xsl:apply-templates />
			</p>
		<!--</li>-->
	</xsl:template>
	
	<xsl:template match="para">
		<p>
			<xsl:apply-templates />
		</p>
	</xsl:template>
	
	<xsl:template match="lcGeneralDescription">
		<p class="bold">General Description:</p>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="lcTask">
		<p>
			<b>
				<u>
					<xsl:value-of select="title" />
				</u>
			</b>
		</p>
		<ul class="square">
			<xsl:for-each select="./lcTaskItem/description/para">
				<li>
					<xsl:value-of select="." />
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	
	<xsl:template match="emphasis">
		<b>
			<u>
				<xsl:value-of select="." />
			</u>
		</b>
	</xsl:template>
</xsl:stylesheet>
