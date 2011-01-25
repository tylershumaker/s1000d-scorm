<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
	File:    pm.xslt
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


    <xsl:variable name="pmTitle" select="//pmtitle"/>
    
    <xsl:template match="pm">
        <h3 Id="titlepm"><xsl:value-of select="$pmTitle"/></h3>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="pmentry">
        <xsl:call-template name="buildTreeRecursive"/>
    </xsl:template>
    
    <xsl:template match="content/pmentry[1]">
        <xsl:call-template name="buildTreeRecursive"/>
    </xsl:template>
    
    <xsl:template match="pmentry/title">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template name="buildTreeRecursive">
        <xsl:variable name="nodeid" select="generate-id(self::pmentry)"/>
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td nowrap="">
                    <a name="bm{$nodeid}"/><a href="#bm{$nodeid}" onclick="toggleTreeNode('img{$nodeid}', '{$nodeid}')"><img id="img{$nodeid}" src="ie/plus.bmp" border="0"/></a>
                </td>
                <td>
                    <xsl:value-of select="title"/>
                    <div id="{$nodeid}" style="display:none">
                        <xsl:apply-templates select="pmentry"/>
                        <table border="0" cellpadding="0" cellspacing="0">
                            <xsl:for-each select="refdm">
                                <tr>
                                    <td>
                                       <xsl:apply-templates select="self::refdm"/> 
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </xsl:template>
    
</xsl:stylesheet>

  