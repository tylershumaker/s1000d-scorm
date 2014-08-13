<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://www.purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
	<xsl:template match="faultDescr">
        <h5>
            <xsl:value-of select="./descr"/>
        </h5>
	</xsl:template>
    <xsl:template match="isolationStep">
        <xsl:variable name="stepCounter">
             <xsl:value-of select="count(preceding::isolationStep)+1"/>
        </xsl:variable>
        <xsl:variable name="step_id" select="./@id"/>
        <xsl:variable name="yesRefId" select="./isolationStepAnswer/yesNoAnswer/yesAnswer/@nextActionRefId"/>
        <xsl:variable name="noRefId" select="./isolationStepAnswer/yesNoAnswer/noAnswer/@nextActionRefId"/>
        <xsl:choose>
            <xsl:when test="$stepCounter = 1">
                <div id="{$step_id}" style="display: block;">
                    Step <xsl:value-of select="$stepCounter" />
                    <xsl:text> </xsl:text>
                    <xsl:for-each select="./action">
                        <xsl:choose>
                            <xsl:when test="./internalRef">
                                <xsl:apply-templates />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="text()"/><br/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <br/>
                    <xsl:if test="./isolationStepQuestion">
                        <div>
                            <xsl:value-of select="./isolationStepQuestion"/><br/>
                            <a href="#{$yesRefId}" onclick="show_hide_div('{$step_id}','{$yesRefId}')">Yes</a><br/>
                            <a href="#{$noRefId}" onclick="show_hide_div('{$step_id}','{$noRefId}')">No</a><br/>
                        </div>
                    </xsl:if>
                </div>                
            </xsl:when>
            <xsl:otherwise>
                <div id="{$step_id}" style="display: none;">
                    <xsl:if test="*">
                        Step <xsl:value-of select="$stepCounter" />
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="./action">
                            <xsl:choose>
                                <xsl:when test="./internalRef">
                                    <xsl:apply-templates />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="text()"/><br/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                        <br/>
                        <xsl:if test="./isolationStepQuestion">
                            <div>
                                <xsl:value-of select="./isolationStepQuestion"/><br/>
                                <a href="#{$yesRefId}" onclick="show_hide_div('{$step_id}','{$yesRefId}')">Yes</a><br/>
                                <a href="#{$noRefId}" onclick="show_hide_div('{$step_id}','{$noRefId}')">No</a><br/>
                            </div>
                        </xsl:if>
                    </xsl:if>
                </div>
            </xsl:otherwise>
        </xsl:choose>
     </xsl:template>
     
     <xsl:template match="isolationProcedureEnd">
         <xsl:variable name="stepCounter">
            <xsl:value-of select="count(preceding::isolationStep)+1"/>
         </xsl:variable>
         <xsl:variable name="isProcEnd_id" select="./@id"/>
         <div id="{$isProcEnd_id}" style="display: none;">
            Step <xsl:value-of select="$stepCounter" />
            <xsl:text> </xsl:text>
            <xsl:for-each select="./action">
                <xsl:choose>
                    <xsl:when test="./internalRef">
                        <xsl:apply-templates />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="text()"/><br/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
         </div>
     </xsl:template>
     
     <xsl:template match="proceduralStep">
        <xsl:variable name="stepCounter">
             <xsl:value-of select="count(preceding::proceduralStep)+1"/>
        </xsl:variable>
        <xsl:variable name="step_id" select="./@id"/>
        <xsl:variable name="nextRefId" select="following::proceduralStep/@id"/>
        <xsl:choose>
            <xsl:when test="$stepCounter = 1">
                <div id="{$step_id}" style="display: block;">
                    Step <xsl:value-of select="$stepCounter" />
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates />
                    <br/>
                    <div>
                        <a href="#{$nextRefId}" onclick="show_hide_div('{$step_id}','{$nextRefId}')">Next</a><br/>
                    </div>
                </div>                
            </xsl:when>
            <xsl:otherwise>
                <div id="{$step_id}" style="display: none;">
                    <xsl:if test="*">
                        Step <xsl:value-of select="$stepCounter" />
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates />
                        <xsl:choose>
                            <xsl:when test="count($nextRefId) &lt; 1 ">
                                <!--  display nothing -->
                            </xsl:when>
                            <xsl:otherwise>
                                <div>
                                    <a href="#{$nextRefId}" onclick="show_hide_div('{$step_id}','{$nextRefId}')">Next</a><br/>
                                </div>
                            </xsl:otherwise>
                        </xsl:choose>
                        <br/>
                    </xsl:if>
                </div>
            </xsl:otherwise>
        </xsl:choose>     
     </xsl:template>
</xsl:stylesheet>