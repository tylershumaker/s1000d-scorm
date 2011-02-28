<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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

  