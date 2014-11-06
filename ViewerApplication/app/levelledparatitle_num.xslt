<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   <!--  Phase 2 Issue 7, numbering of levelledPara elements for some instances.  This files
         was introduced to address this issue. -->
         
   <xsl:template match="levelledPara/title">
      <xsl:variable name="counter">
         <!--  Get the <title> element's parent (levelledPara in this case) and count 
         the previous sibling <levelledPara> elements.  Add 1 because counting 
         starts at 0 (root levelledPara will return a value of 0 so it is really
         the 1st <levelledPara> element -->
         <xsl:value-of select="count(parent::node()/preceding-sibling::levelledPara)+1"/>
      </xsl:variable>
      
      <!-- Variable to hold the number of levelledPara elements of a child in order to determine outher number for the count -->
      <xsl:variable name="parent_counter" select="count(parent::node()/parent::node()/preceding-sibling::levelledPara)" />
                
      <xsl:choose>   
            <!-- Determine if the current levelledPara/title is a child of another levelledPara -->
            <xsl:when test="$parent_counter > 0">
               <h3>
                  <xsl:value-of select="$parent_counter + 1"/>.<xsl:value-of select="$counter"/>.
                  <xsl:apply-templates/>
               </h3>   
            </xsl:when>
            <xsl:otherwise>
               <h3>
                  <xsl:value-of select="$counter"/>.
                  <xsl:apply-templates/>
               </h3>
            </xsl:otherwise>
         </xsl:choose>
                    
    </xsl:template>

</xsl:stylesheet>  