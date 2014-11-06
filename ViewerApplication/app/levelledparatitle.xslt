<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="levelledPara/title">
<!--         <xsl:choose>
            <xsl:when test="ancestor::descrCrew or ../../self::levelledPara"> -->
                <h3><xsl:value-of select="."></xsl:value-of></h3>
<!--              </xsl:when>
            <xsl:otherwise> 
                <xsl:variable name="counter">
                     <xsl:value-of select="count(parent::node()/preceding-sibling::levelledPara)+1"/>
                </xsl:variable>
                <h3>
                    <xsl:value-of select="$counter"/>.
                    <xsl:apply-templates/>
                </h3>
            </xsl:otherwise>
        </xsl:choose> -->
    </xsl:template>

</xsl:stylesheet>  