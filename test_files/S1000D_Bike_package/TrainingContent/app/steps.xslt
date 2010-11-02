<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
	File:    steps.xslt
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

-->

	<xsl:template match="proceduralStep">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="*/specpara/para|step1|step2|step3|step4|step5">
			<tr valign="top">
				<td width="30px">
					<a name="{parent::*/@id}"/>
					<xsl:number level="multiple" format="1.1." count="step1|step2|step3|step4|step5"/>&#160;&#160;
				</td>
				<td>
					<xsl:apply-templates/>
				</td>
			</tr>
	</xsl:template>

	<xsl:template match="randlist">
		<xsl:if test="title">
			<p class="decreaseBottom">
				<xsl:apply-templates select="title"/>
			</p>
		</xsl:if>
		<ul>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match="isostep">
		<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<a name="{@id}"/>
				<xsl:apply-templates/>
			</tr>
		</table>
	</xsl:template>

	<xsl:template match="deflist">
		<dl class="defList">
			<xsl:apply-templates/>
		</dl>
	</xsl:template>

	<xsl:template match="term">
		<dt class="term">
			<xsl:apply-templates/>
		</dt>
	</xsl:template>

	<xsl:template match="def">
		<dd class="def">
			<xsl:apply-templates/>
		</dd>
	</xsl:template>

	<xsl:template match="question">
		<tr>
			<td/>
			<td valign="top">
				<strong><xsl:value-of select="$question_text"/>:&#160;<xsl:apply-templates/></strong>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="answer">
		<tr>
			<td/>
			<td valign="top">
			<xsl:value-of select="$answer_text"/>:&#160;<xsl:apply-templates/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="seqlist">
		<ol>
			<xsl:apply-templates/>
		</ol>
	</xsl:template>

	<xsl:template match="step1/para[preceding-sibling::applic]|step2/para[preceding-sibling::applic]|step3/para[preceding-sibling::applic]|step4/para[preceding-sibling::applic]|step5/para[preceding-sibling::applic]|step1/para[preceding-sibling::para]|step2/para[preceding-sibling::para]|step3/para[preceding-sibling::para]|step4/para[preceding-sibling::para]|step5/para[preceding-sibling::para]">
		<tr>
			<td>
			</td>
			<td>
				<xsl:apply-templates/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="item">
		<xsl:choose>
			<xsl:when test="parent::randlist[@prefix='pf01']">
				<li class="randlistItemHyphen">
					<xsl:if test="ancestor::randlist[not(@prefix='pf01')]">&#8211;&#160;&#160;</xsl:if>
					<xsl:apply-templates/>
				</li>
			</xsl:when>
			<xsl:when test="parent::randlist[not(@prefix='pf01')]">
				<xsl:choose>
					<xsl:when test="count(ancestor::randlist) mod 2 = 1">
							<li class="randListItemHyphen">&#8211;&#160;&#160;<xsl:apply-templates/></li>
					</xsl:when>
				<xsl:otherwise>
					<li class="randListItemBullet"><xsl:apply-templates/></li>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<li><xsl:apply-templates/></li>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>

  