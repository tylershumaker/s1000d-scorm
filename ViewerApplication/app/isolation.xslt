<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:dc="http://www.purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">

    <!-- ********************************************************************************************************** -->
    <!-- faultDescr template                                                                                        -->
    <!-- ********************************************************************************************************** -->
    <xsl:template match="faultDescr">
        <h5>
            <xsl:value-of select="./descr"/>
        </h5>
    </xsl:template>

    <!-- ********************************************************************************************************** -->
    <!-- isolationStep template                                                                                     -->
    <!-- ********************************************************************************************************** -->
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
                    Step
                    <xsl:value-of select="$stepCounter"/>
                    <br></br>
                    <xsl:text> </xsl:text>
                    <xsl:for-each select="./action">
                        <xsl:choose>
                            <xsl:when test="./internalRef">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                                <br/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <br/>
                    <xsl:if test="./isolationStepQuestion">
                        <div>
                            <xsl:value-of select="./isolationStepQuestion"/>
                            <br/>
                            <a href="#{$yesRefId}" onclick="show_hide_div('{$step_id}','{$yesRefId}')">Yes</a>
                            <br/>
                            <a href="#{$noRefId}" onclick="show_hide_div('{$step_id}','{$noRefId}')">No</a>
                            <br/>
                        </div>
                    </xsl:if>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div id="{$step_id}" style="display: none;">
                    <xsl:if test="*">
                        Step
                        <xsl:value-of select="$stepCounter"/>
                        <br></br>
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="./action">
                            <xsl:choose>
                                <xsl:when test="./internalRef">
                                    <xsl:apply-templates/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates/>
                                    <br/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                        <br/>
                        <xsl:if test="./isolationStepQuestion">
                            <div>
                                <xsl:value-of select="./isolationStepQuestion"/>
                                <br/>
                                <a href="#{$yesRefId}" onclick="show_hide_div('{$step_id}','{$yesRefId}')">Yes</a>
                                <br/>
                                <a href="#{$noRefId}" onclick="show_hide_div('{$step_id}','{$noRefId}')">No</a>
                                <br/>
                            </div>
                        </xsl:if>
                    </xsl:if>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ********************************************************************************************************** -->
    <!-- isolationProcedureEnd template                                                                             -->
    <!-- ********************************************************************************************************** -->
    <xsl:template match="isolationProcedureEnd">
        <xsl:variable name="stepCounter">
            <xsl:value-of select="count(preceding::isolationStep)+1"/>
        </xsl:variable>
        <xsl:variable name="isProcEnd_id" select="./@id"/>
        <div id="{$isProcEnd_id}" style="display: none;">
            Step
            <xsl:value-of select="$stepCounter"/>
            <xsl:text> </xsl:text>
            <xsl:for-each select="./action">
                <xsl:choose>
                    <xsl:when test="./internalRef">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                        <!--  <xsl:value-of select="text()"/><br/>-->
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </div>
    </xsl:template>

    <xsl:template match="mainProcedure">
        <ol id="mp">
            <xsl:apply-templates/>
        </ol>
    </xsl:template>

    <xsl:template match="proceduralStep[not(@id)]">
        <xsl:variable name="step_id">
            <xsl:value-of select="generate-id(para)"/>
        </xsl:variable>

        <xsl:variable name="active">
            <xsl:choose>
                <xsl:when test="parent::mainProcedure and position()=1">
                    <xsl:text>active</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>inactive</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="child::proceduralStep">
                <xsl:variable name="nextRefId">
                    <xsl:value-of select="generate-id(child::proceduralStep/child::para)"/>
                </xsl:variable>
                <li id="{$step_id}" class="{$active}">

                    <a class="{$active}" href="#{$nextRefId}" onclick="show_hide_div('{$step_id}','{$nextRefId}')">
                        Next
                    </a>
                    <br/>
                    <div>
                        <p>
                            <strong>
                                <xsl:value-of select="title"/>
                            </strong>
                        </p>
                    </div>
                    <div>
                        <p>
                            <xsl:value-of select="para"/>
                        </p>

                    </div>
                    <ol>
                        <xsl:apply-templates/>
                    </ol>
                </li>

            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="nextRefId">
                    <xsl:choose>
                        <xsl:when test="position() = last()">
                            <xsl:choose>
                                <xsl:when test="parent::node()/following-sibling::proceduralStep/child::para != ''">
                                    <xsl:value-of
                                            select="generate-id(parent::node()/following-sibling::proceduralStep/child::para)"/>
                                </xsl:when>
                                <xsl:when
                                        test="parent::node()/parent::node()/following-sibling::proceduralStep/child::para != ''">
                                    <xsl:value-of
                                            select="generate-id(parent::node()/parent::node()/following-sibling::proceduralStep/child::para)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                            select="generate-id(parent::node()/parent::node()/parent::node()/following-sibling::proceduralStep/child::para)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="generate-id(following-sibling::proceduralStep/child::para)"/>
                        </xsl:otherwise>
                    </xsl:choose>

                </xsl:variable>


                <li id="{$step_id}" class="{$active}">

                    <a class="{$active}" href="#{$nextRefId}" onclick="show_hide_div('{$step_id}','{$nextRefId}')">
                        Next
                    </a>
                    <br/>
                    <div>
                        <p>
                            <xsl:value-of select="para"/>
                        </p>

                    </div>
                    <ol>
                        <xsl:apply-templates/>
                    </ol>
                </li>

                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="proceduralStep">
        <xsl:variable name="step_id">
            <xsl:value-of select="@id"></xsl:value-of>
        </xsl:variable>

        <xsl:variable name="active">
            <xsl:choose>
                <xsl:when test="parent::mainProcedure and position()=1">
                    <xsl:text>active</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>inactive</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="child::proceduralStep">
                <xsl:variable name="nextRefId">
                    <xsl:value-of select="child::proceduralStep[1]/@id"/>
                </xsl:variable>
                <li id="{$step_id}" class="{$active}">
                    <a class="{$active}" href="#{$nextRefId}" onclick="show_hide_div('{$step_id}','{$nextRefId}')">
                        Next
                    </a>
                    <br/>
                    <div>
                        <p>
                            <strong>
                                <xsl:value-of select="title"/>
                            </strong>
                        </p>
                    </div>
                    <div>
                        <p>
                            <xsl:value-of select="para"/>
                        </p>

                    </div>
                    <ol>
                        <xsl:apply-templates/>
                    </ol>
                </li>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="nextRefId">
                    <xsl:choose>
                        <xsl:when test="position() = last()">
                            <xsl:choose>
                                <xsl:when test="parent::node()/following-sibling::proceduralStep/@id != ''">
                                    <xsl:value-of select="parent::node()/following-sibling::proceduralStep/@id"/>
                                </xsl:when>
                                <xsl:when
                                        test="parent::node()/parent::node()/following-sibling::proceduralStep/@id  != ''">
                                    <xsl:value-of
                                            select="parent::node()/parent::node()/following-sibling::proceduralStep/@id"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                            select="parent::node()/parent::node()/parent::node()/following-sibling::proceduralStep/@id"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="following-sibling::proceduralStep[1]/@id"/>
                        </xsl:otherwise>
                    </xsl:choose>

                </xsl:variable>
                <xsl:apply-templates/>

                <li id="{$step_id}" class="{$active}">
                    <a href="#{$nextRefId}"
                       class="{$active}"
                       onclick="show_hide_div('{$step_id}','{$nextRefId}')">Next
                    </a>
                    <br/>
                    <div>
                        <p>
                            <xsl:value-of select="para"/>
                        </p>
                    </div>
                </li>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>