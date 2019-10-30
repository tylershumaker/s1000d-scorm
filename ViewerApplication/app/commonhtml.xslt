<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


    <!-- *************************************************************** -->
    <!-- Template for prelimnaryRqmts element                            -->
    <!-- *************************************************************** -->
    <xsl:template match="preliminaryRqmts">
        <h4>
            Preliminary Requirements
        </h4>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- *************************************************************** -->
    <!-- Template for reqCondGroup element                               -->
    <!-- *************************************************************** -->
    <xsl:template match="reqCondGroup">
        <xsl:choose>
            <xsl:when test="./noConds">
                <!--suppress-->
            </xsl:when>
            <xsl:otherwise>

                <table border="0" width="100%" cellspacing="0" cellpadding="0">
                    <br></br>
                    <br></br>
                    <tr>
                        <td>
                            <p></p>
                            <table border="0" width="100%" class="prelreq_table" cellspacing="0" cellpadding="3">

                                <tr>
                                    <xsl:call-template name="generalTblHeader">
                                        <xsl:with-param name="label" select="'Condition'"></xsl:with-param>
                                    </xsl:call-template>
                                    <xsl:call-template name="generalTblHeader">
                                        <xsl:with-param name="label" select="'Reference'"></xsl:with-param>
                                    </xsl:call-template>
                                </tr>
                                <xsl:for-each select="./reqCondNoRef">
                                    <tr>
                                        <td>
                                            <xsl:value-of select="./reqCond"/>
                                        </td>
                                        <td>-----</td>
                                    </tr>
                                </xsl:for-each>
                                <xsl:for-each select="./reqCondDm">
                                    <tr>
                                        <td>
                                            <xsl:apply-templates select="reqCond"/>
                                        </td>
                                        <td>
                                            <xsl:apply-templates select="dmRef"/>
                                        </td>

                                    </tr>
                                </xsl:for-each>
                            </table>
                        </td>
                    </tr>
                </table>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- *************************************************************** -->
    <!-- Template for reqCond element                                    -->
    <!-- *************************************************************** -->
    <xsl:template match="reqCond">
        <xsl:apply-templates/>
    </xsl:template>


    <!-- *************************************************************** -->
    <!-- Template for reqPersons element                                 -->
    <!-- *************************************************************** -->
    <xsl:template match="reqPersons">
        <h5>Required Persons</h5>
        <xsl:choose>
            <xsl:when test="not(asrequir)">
                <table border="0" width="100%" class="prelreq_table" cellspacing="0" cellpadding="3">
                    <tbody>
                        <tr>
                            <xsl:call-template name="generalTblHeader">
                                <xsl:with-param name="label" select="'Person'"></xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="generalTblHeader">
                                <xsl:with-param name="label" select="'Category'"></xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="generalTblHeader">
                                <xsl:with-param name="label" select="'Trade'"></xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="generalTblHeader">
                                <xsl:with-param name="label" select="'Estimated Time'"></xsl:with-param>
                            </xsl:call-template>
                        </tr>
                    </tbody>
                    <xsl:for-each select="person">
                        <tr>
                            <td width="10%">
                                <xsl:value-of select="@man"/>
                            </td>
                            <td width="20%">

                                <xsl:value-of select="./personCategory/@personCategoryCode"/>
                            </td>
                            <!--<td width="20%">
                                <xsl:value-of select="$level_text"/>: <xsl:value-of select="./personSkill/@skillLevelCode"/>
                            </td>-->
                            <td width="20%">
                                <xsl:value-of select="./trade"/>
                            </td>
                            <td width="10%">
                                <xsl:value-of select="./estimatedTime"/>
                            </td>

                        </tr>
                    </xsl:for-each>
                </table>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- *************************************************************** -->
    <!-- Template for applic element                                     -->
    <!-- *************************************************************** -->
    <xsl:template match="applic">
        <xsl:call-template name="applic"/>
    </xsl:template>

    <!-- *************************************************************** -->
    <!-- Template for applic[ancestor::content] element                  -->
    <!-- *************************************************************** -->
    <xsl:template match="applic[ancestor::content]">
        <xsl:choose>
            <xsl:when test="not (ancestor::step1 or ancestor::schedule or parent::deftask or parent::wire)">
                <tr>
                    <td/>
                    <td>
                        <xsl:call-template name="applic"/>
                    </td>
                </tr>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="applic"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- *************************************************************** -->
    <!-- Template for applic[ancestor::supplies] element                 -->
    <!-- *************************************************************** -->
    <xsl:template match="applic[ancestor::supplies]">
        <td>
            <xsl:call-template name="applic"/>
        </td>
    </xsl:template>

    <!-- *************************************************************** -->
    <!-- Template for applics                                            -->
    <!-- *************************************************************** -->
    <xsl:template match="applics">
        <td>
            <xsl:for-each select="applic">
                <xsl:call-template name="applic"/>
                <br/>
            </xsl:for-each>
        </td>
    </xsl:template>

    <!-- *************************************************************** -->
    <!-- Template for applic                                             -->
    <!-- *************************************************************** -->
    <xsl:template name="applic">
        <xsl:choose>
            <xsl:when test="parent::status">
                <xsl:for-each select="model">
                    <tr>
                        <td valign="top" nowrap="">
                            <xsl:if test="not(preceding-sibling::model)">
                                Applicability:&#160;
                            </xsl:if>
                        </td>
                        <td>
                            <xsl:if test="not (ancestor::idstatus)">
                                <b>[</b>
                            </xsl:if>
                            <xsl:if test="child::type">
                                <i>Type</i>:<xsl:value-of select="type"/>;
                            </xsl:if>
                            <xsl:if test="preceding-sibling::type">
                                <i>Type</i>:<xsl:value-of select="preceding-sibling::type"/>;
                            </xsl:if>
                            <xsl:if test="child::model">
                                <i>
                                    <xsl:value-of select="$model_text"/>
                                </i>
                                :<xsl:value-of select="child::model/@model"/>;
                            </xsl:if>
                            <xsl:if test="self::model">
                                <i>
                                    <xsl:value-of select="$model_text"/>
                                </i>
                                :<xsl:value-of select="@model"/>;
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="descendant::versrank">
                                    <i>Version</i>:<xsl:value-of select="descendant::range/@from"/>
                                    <i>-</i>
                                    <xsl:value-of select="descendant::range/@to"/>;
                                </xsl:when>
                                <xsl:otherwise>
                                    <i>Version</i>:<xsl:value-of select="child::version/@version"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="not (ancestor::idstatus)">
                                <b>]</b>
                            </xsl:if>
                        </td>
                    </tr>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="model">
                    <xsl:if test="not (ancestor::idstatus)">
                        <b>[</b>
                    </xsl:if>
                    <xsl:if test="child::type">
                        <i>Type</i>:<xsl:value-of select="type"/>;
                    </xsl:if>
                    <xsl:if test="preceding-sibling::type">
                        <i>Type</i>:<xsl:value-of select="preceding-sibling::type"/>;
                    </xsl:if>
                    <xsl:if test="child::model">
                        <i>
                            <xsl:value-of select="$model_text"/>
                        </i>
                        :<xsl:value-of select="child::model/@model"/>;
                    </xsl:if>
                    <xsl:if test="self::model">
                        <i>
                            <xsl:value-of select="$model_text"/>
                        </i>
                        :<xsl:value-of select="@model"/>;
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="descendant::versrank">
                            <i>Version</i>:<xsl:value-of select="descendant::range/@from"/>
                            <i>-</i>
                            <xsl:value-of select="descendant::range/@to"/>;
                        </xsl:when>
                        <xsl:otherwise>
                            <i>Version</i>:<xsl:value-of select="child::version/@version"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="not (ancestor::idstatus)">
                        <b>]</b>
                    </xsl:if>
                    <br/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="person|perskill|trade|esttime">
    </xsl:template>


    <xsl:template match="reqcondm">
        <tr>
            <xsl:apply-templates/>
            <!-- Changed reqdm to refdm 050717/SE -->
            <xsl:if test="not(following-sibling::refdm)">
                <td/>
            </xsl:if>
        </tr>
    </xsl:template>

    <!-- Added 050717/SE -->
    <xsl:template match="reqcontp">
        <tr>
            <xsl:apply-templates/>
            <xsl:if test="not(following-sibling::reftp)">
                <td/>
            </xsl:if>
        </tr>
    </xsl:template>

    <!--<xsl:template match="reqcond">
        <xsl:choose>-->
    <!--Changed reqdm to refdm for 2.2-->
    <!--<xsl:when test="following-sibling::refdm">
        <td>
            <xsl:apply-templates/>
        </td>
    </xsl:when>
    <xsl:when test="following-sibling::reftp">
        <td>
            <xsl:apply-templates/>
        </td>
    </xsl:when>
    <xsl:otherwise>
        <tr>
            <td>
                <xsl:apply-templates/>
            </td>
            <td>XXXX</td>
        </tr>
    </xsl:otherwise>
</xsl:choose>
</xsl:template>-->

    <xsl:template match="reqSupportEquips">
        <xsl:choose>
            <xsl:when test="./noSupportEquips">
                <!--suppress-->
            </xsl:when>
            <xsl:otherwise>
                <h5>
                    <xsl:value-of select="$sup_equ_text"/>
                </h5>

                <table border="0" width="100%" class="prelreq_table" cellspacing="0" cellpadding="3">
                    <tbody>
                        <tr>
                            <xsl:call-template name="generalTblHeader">
                                <xsl:with-param name="label" select="'Name'"></xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="generalTblHeader">
                                <xsl:with-param name="label" select="'Manufacturer'"></xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="generalTblHeader">
                                <xsl:with-param name="label" select="'Quantity'"></xsl:with-param>
                            </xsl:call-template>
                        </tr>
                        <xsl:apply-templates/>
                    </tbody>
                </table>
                <br></br>
                <br></br>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="supportEquipDescrGroup">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- **********************************************************************************-->
    <!-- <supportEquipmentDescr> template                                                  -->
    <!--                                       											   -->
    <!-- 4/9/2015:  Added the choosing of the <name> element if available, if not the      -->
    <!--            the template will use the <shortName> element                          -->
    <!--            Added support for displaying the <manufacturerCode> element if         -->
    <!--            available and if not the <partNumber> element                          -->
    <!-- **********************************************************************************-->
    <xsl:template match="supportEquipDescr">
        <tr>
            <td>
                <!-- Added to choose betwee the name element or the shortName element -->
                <xsl:choose>
                    <xsl:when test="./name">

                        <xsl:variable name="suppEquipName" select="./name"/>

                        <xsl:value-of select="$suppEquipName"/>
                    </xsl:when>
                    <xsl:otherwise>

                        <xsl:variable name="suppEquipName" select="./shortName"/>

                        <xsl:value-of select="$suppEquipName"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <td>
                <xsl:variable name="manCode">
                    <xsl:value-of select="./identNumber/manufacturerCode"></xsl:value-of>
                </xsl:variable>

                <xsl:choose>
                    <xsl:when test="$manCode = $empty_string">
                        <xsl:value-of select="./identNumber/partAndSerialNumber/partNumber"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="./identNumber/manufacturerCode"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <td>
                <xsl:value-of select="./reqQuantity"/> :
                <xsl:value-of select="./reqQuantity/@unitOfMeasure"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="reqSupplies">
        <xsl:choose>
            <xsl:when test="./noSupplies">
                <!--suppress-->
            </xsl:when>
            <xsl:otherwise>
                <h5>
                    <xsl:value-of select="$consumables_text"/>
                </h5>
                <table border="0" width="100%" class="prelreq_table" cellspacing="0" cellpadding="3">
                    <tbody>
                        <tr>
                            <xsl:call-template name="generalTblHeader">
                                <xsl:with-param name="label" select="$name_text"></xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="generalTblHeader">
                                <xsl:with-param name="label" select="$manfac"></xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="generalTblHeader">
                                <xsl:with-param name="label" select="$qty_text"></xsl:with-param>
                            </xsl:call-template>
                        </tr>
                        <xsl:apply-templates/>
                    </tbody>
                </table>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="supplyDescrGroup">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="supplyDescr">
        <tr>
            <td>
                <xsl:value-of select="./name"/>
            </td>
            <td>
                <xsl:value-of select="./identNumber/manufacturerCode"/>
            </td>
            <td>
                <xsl:value-of select="./reqQuantity"/> :
                <xsl:value-of select="./reqQuantity/@unitOfMeasure"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="reqSpares">
        <xsl:choose>
            <xsl:when test="./noSpares">
                <!--suppress-->
            </xsl:when>
            <xsl:otherwise>
                <h5>
                    <xsl:value-of select="$spares_text"/>
                </h5>

                <table border="0" width="100%" class="prelreq_table" cellspacing="0" cellpadding="3">
                    <tbody>
                        <tr>
                            <xsl:call-template name="generalTblHeader">
                                <xsl:with-param name="label" select="$name_text"></xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="generalTblHeader">
                                <xsl:with-param name="label" select="$manfac"></xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="generalTblHeader">
                                <xsl:with-param name="label" select="$qty_text"></xsl:with-param>
                            </xsl:call-template>
                        </tr>
                        <xsl:apply-templates/>
                    </tbody>
                </table>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="spareDescrGroup">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="spareDescr">
        <tr>
            <td>
                <xsl:value-of select="./name"/>
            </td>
            <td>
                <xsl:value-of select="./identNumber/manufacturerCode"/>
            </td>
            <td>
                <xsl:value-of select="./reqQuantity"/> :
                <xsl:value-of select="./reqQuantity/@unitOfMeasure"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="reqSafety">
        <xsl:choose>
            <xsl:when test="./noSafety">
                <!--suppress-->

            </xsl:when>
            <xsl:otherwise>
                <h5>
                    <xsl:value-of select="$saf_con_text"/>
                </h5>
                <br/>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ********************************************************************************************************* -->
    <!-- closeRqmts template                                                                                       -->
    <!--                                                                                                           -->
    <!-- 6/16/2015: Added a test to make sure the closeRqmts element is not placed in the transform data twice.    -->
    <!--            The main template match="/" was picking it up along with the procedureStep processing.         -->
    <!--            Only want to output the closeRqmts in the last procedureStep (see isolation.xslt)              -->
    <!-- ********************************************************************************************************* -->
    <xsl:template match="closeRqmts">
        <xsl:choose>
            <xsl:when test="preceding-sibling::mainProcedure">
                <!--  do nothing -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="safetyRqmts">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="supeqli|sparesli|supplyli">
        <xsl:call-template name="part_table"/>
    </xsl:template>

    <xsl:template match="supequi|supply|spare">
        <tr>
            <a name="{@id}">
                <xsl:apply-templates/>
            </a>
        </tr>
    </xsl:template>

    <xsl:template match="nsn">
        <td valign="top">
            <xsl:value-of select="@nsn"/>
        </td>
    </xsl:template>

    <xsl:template
            match="mfc[not(ancestor::dfault)]|mfc[not(ancestor::ifault)]|mfc[not(ancestor::ofault)]|pnr[not(ancestor::ifault)]|pnr[not(ancestor::dfault)]|pnr[not(ancestor::ofault)]|serialno">
        <td valign="top">
            <xsl:apply-templates/>
        </td>
    </xsl:template>

    <xsl:template match="csnref">
        <td>
            <xsl:value-of select="@refcsn"/>/<xsl:value-of select="@refisn"/>
        </td>
    </xsl:template>

    <!-- Added support for remarks in supplies, spares and support equipment -->
    <xsl:template match="supequi/qty|supply/qty|spare/qty">
        <td valign="top">
            <xsl:apply-templates/>
            <xsl:if test="following-sibling::remarks">
                <br/>
                <xsl:value-of select="following-sibling::remarks"/>
                <br/>
            </xsl:if>
        </td>
    </xsl:template>

    <xsl:template match="supequi/remarks|supply/remarks|spare/remarks">
        <!-- suppress -->
    </xsl:template>

    <xsl:template match="supequi/remarks/p|supply/remarks/p|spare/remarks/p">
        <!-- suppress -->
    </xsl:template>

    <xsl:template match="nomen">
        <xsl:choose>
            <xsl:when
                    test="parent::supequi|parent::spare|parent::supply|preceding-sibling::applic|parent::lru[not(ancestor::dfault|ancestor::ifault|ancestor::ofault)]|preceding-sibling::supply[not(parent::supplyli[child::applic])]">
                <td valign="top">
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:when
                    test="parent::lru[(ancestor::dfault)]|parent::lru[(ancestor::ifault)]|parent::lru[(ancestor::ofault)]">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <td valign="top"/>
                <td valign="top">
                    <xsl:apply-templates/>
                </td>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="noconds|nosupeq|nosupply|nospares|nosafety|asrequir">
        ---
    </xsl:template>

    <xsl:template match="warning">
        <td colspan="2">
            <xsl:call-template name="createAttention">
                <xsl:with-param name="text" select="warningAndCautionPara"/>
                <xsl:with-param name="type">warning</xsl:with-param>
            </xsl:call-template>
        </td>
    </xsl:template>

    <xsl:template match="caution">
        <td colspan="2">
            <xsl:call-template name="createAttention">
                <xsl:with-param name="text" select="warningAndCautionPara"/>
                <xsl:with-param name="type">caution</xsl:with-param>
            </xsl:call-template>
        </td>
    </xsl:template>

    <!-- Fotnote implemented as mouseover function -->
    <xsl:template match="ftnote">
        <a class="ftnote">
            <xsl:attribute name="title">
                <xsl:value-of select="text()"/>
            </xsl:attribute>
            (*)&#160;
        </a>
    </xsl:template>

    <!-- Fotnote reference implemented as mouseover function -->
    <xsl:template match="ftnref">
        <xsl:variable name="thisxrefid">
            <xsl:value-of select="@xrefid"/>
        </xsl:variable>
        <a>
            <xsl:attribute name="title">
                <xsl:value-of select="//ftnote[@id = $thisxrefid]"/>
            </xsl:attribute>
            (*)&#160;
        </a>
    </xsl:template>

    <xsl:template match="note">
        <xsl:choose>
            <xsl:when test="ancestor::step1|ancestor::step2|ancestor::step3|ancestor::step4|ancestor::step5">
                <tr>
                    <td/>
                    <td>
                        <xsl:call-template name="createNote"/>
                    </td>
                </tr>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="createNote"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="dmtitle|infoname">
        <!-- suppress title in metadata information pane -->
    </xsl:template>

    <xsl:template match="refdm/dmtitle">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="legend">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="term|def">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="deflist/title">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="para">
        <!-- Issue 13 Emphasis not showing in Assessments -->
        <xsl:choose>
            <xsl:when test="parent::proceduralStep"></xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="acronym">
        <!--  <p>FOUND AN Acronym</p>-->
        <xsl:variable name="acronym_def">
            <xsl:value-of select="acronymDefinition"/>
        </xsl:variable>
        <xsl:variable name="acronym_val">
            <xsl:value-of select="acronymTerm"/>
        </xsl:variable>

        <!--  <p>Acro Def: <xsl:value-of select="$acronym_def" /></p> -->
        <!--  <p>Acro Term: <xsl:value-of select="$acronym_val" /></p> -->

        <span title="{$acronym_def}">
            <u>
                <xsl:value-of select="$acronym_val"/>
            </u>
        </span>
    </xsl:template>

    <xsl:template match="listItem/para">
        <xsl:apply-templates/>
        <br></br>
    </xsl:template>

    <xsl:template match="levelledPara/title">
        <!--         <xsl:choose>
                    <xsl:when test="ancestor::descrCrew or ../../self::levelledPara"> -->
        <h3>
            <xsl:value-of select="."></xsl:value-of>
        </h3>
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

    <xsl:template match="levelledPara/para">
        <xsl:variable name="para_id">
            <xsl:value-of select="./@id"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="para_id=''">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <div id="{$para_id}">
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="levelledPara/crewDrill/crewDrillStep/para[1]">

        <xsl:variable name="counter">
            <xsl:value-of select="count(parent::node()/preceding-sibling::crewDrillStep)+1"/>
        </xsl:variable>
        <h4>
            <xsl:value-of select="$counter"/>.
            <xsl:apply-templates/>
        </h4>

    </xsl:template>

    <!-- 9/9/14 added to handle notes in sub crewDrillStep -->
    <xsl:template match="levelledPara/crewDrill/crewDrillStep/crewDrillStep">
        <xsl:variable name="note">
            <xsl:value-of select="note"/>
        </xsl:variable>
        <ul style="list-style-type:none">
            <li>
                <xsl:number format="a. "/>
                <xsl:value-of select="para"/>
            </li>
            <xsl:if test="not($note ='')">
                <p>
                    <table width="100%" class="note_line">
                        <tr>
                            <td>
                                <font class="note_text">
                                    <strong>
                                        <xsl:value-of select="$note_text"/>
                                    </strong>
                                </font>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <font class="indentMarginLeft">
                                    <xsl:value-of select="$note"/>
                                </font>
                            </td>
                        </tr>
                    </table>
                </p>
            </xsl:if>
        </ul>
    </xsl:template>

    <!-- ******************************************************************************************************************* -->
    <!-- Template to process descrCrew, description, levelledPara, levellPara/crewDrill and                                  -->
    <!--    levelledPara/crewDrill/crewDrillStep                                                                             -->
    <!--                                                                                                                     -->
    <!-- 9/9/14 issue 33 added to handle warningRefs and cautionRefs                                                         -->
    <!-- 4/6/15 issue 42 added support for processing warningRefs where the warning had more than just text (other elements) -->
    <!-- ******************************************************************************************************************* -->
    <xsl:template
            match="descrCrew | description  | levelledPara | levelledPara/crewDrill | levelledPara/crewDrill/crewDrillStep">

        <!-- Assign the para_id local variable the value of the id attribute -->
        <xsl:variable name="para_id">
            <xsl:value-of select="./@id"/>
        </xsl:variable>

        <!-- Assign the warnRef local variable the value of the warningRefs attribute -->
        <xsl:variable name="warnRef">
            <xsl:value-of select="./@warningRefs"/>
        </xsl:variable>

        <!-- Assign the cautionRef local variable the value of the cautionRefs attribute -->
        <xsl:variable name="cautionRef">
            <xsl:value-of select="./@cautionRefs"></xsl:value-of>
        </xsl:variable>

        <xsl:choose>
            <!-- If the para_id local variable is empty, just apply-templates -->
            <xsl:when test="para_id=''">
                <xsl:apply-templates/>
            </xsl:when>

            <!-- If the is a warning reference, process the warning -->
            <xsl:when test="not($warnRef ='')">
                <div id="{$para_id}">
                    <xsl:apply-templates/>

                    <!-- Build the warning output -->
                    <xsl:variable name="borderClass">redBorder</xsl:variable>
                    <xsl:variable name="color">redFont</xsl:variable>
                    <xsl:variable name="title">WARNING</xsl:variable>
                    <table width="100%" cellspacing="0" class="{$borderClass}">
                        <tr>
                            <td align="center">
                                <font class="{$color}">
                                    <strong>
                                        <xsl:value-of select="$title"/>
                                    </strong>
                                </font>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <font class="indentMarginLeft">
                                    <strong>
                                        <xsl:apply-templates select="//warning[@id=$warnRef]/warningAndCautionPara"/>
                                    </strong>
                                </font>
                            </td>
                        </tr>
                    </table>
                </div>
            </xsl:when>

            <!-- If the cautionRef local variable is not empty, process the cautions -->
            <xsl:when test="not($cautionRef ='')">

                <div id="{$para_id}">
                    <xsl:apply-templates/>

                    <!-- Build the warning output -->
                    <xsl:variable name="borderClass">yellowBorder</xsl:variable>
                    <xsl:variable name="color">blackFont</xsl:variable>
                    <xsl:variable name="title">CAUTION</xsl:variable>
                    <table width="100%" cellspacing="0" class="{$borderClass}">
                        <tr>
                            <td align="center">
                                <font class="{$color}">
                                    <strong>
                                        <xsl:value-of select="$title"/>
                                    </strong>
                                </font>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <font class="indentMarginLeft">
                                    <strong>
                                        <xsl:apply-templates select="//caution[@id=$cautionRef]/warningAndCautionPara"/>
                                    </strong>
                                </font>
                            </td>
                        </tr>
                    </table>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div id="{$para_id}">
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- ****************************************************************** -->
    <!-- Template for titles for levelledPara/crewDrill                     -->
    <!-- ****************************************************************** -->
    <xsl:template match="levelledPara/crewDrill/title">
        <h3>
            <xsl:value-of select="."></xsl:value-of>
        </h3>
    </xsl:template>

    <xsl:template match="title">
        <xsl:variable name="counter">
            <xsl:value-of select="count(preceding::internalRef[@internalRefTargetType='irtt01'])"/>
        </xsl:variable>
        <xsl:choose>
            <!--  removed for phase 2 changes.  Moved elsewhere to determine figure ids and counts -->
            <!--  <xsl:when test="parent::figure">/
                <xsl:variable name="fig_id">
                    <xsl:value-of select="../@id"/>
                </xsl:variable>
                <div align="center">
                    <p class ="imageTitle" id="{$fig_id}">Fig <xsl:value-of select="$counter" /><xsl:text> </xsl:text><xsl:apply-templates/></p>
                </div>
            </xsl:when> -->
            <xsl:when
                    test="parent::learningAssessment | parent::learningContent | parent::learningSummary | parent::learningOverview">
                <div align="center">
                    <p class="branchTitle">
                        <xsl:apply-templates/>
                    </p>
                </div>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="emphasis">
        <xsl:choose>
            <xsl:when test="@emph = 'em01'"><!-- bold -->
                <strong><xsl:apply-templates/>&#160;
                </strong>
            </xsl:when>
            <xsl:when test="@emph = 'em02'"><!-- italic -->
                <i><xsl:apply-templates/>&#160;
                </i>
            </xsl:when>
            <xsl:when test="@emph = 'em03'"><!-- underline -->
                <u><xsl:apply-templates/>&#160;
                </u>
            </xsl:when>
            <xsl:otherwise><!-- bold -->
                <strong><xsl:apply-templates/>&#160;
                </strong>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="subscrpt">
        <sub>
            <xsl:apply-templates/>
        </sub>
    </xsl:template>

    <xsl:template match="supscrpt">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>

    <xsl:template match="warningAndCautionPara">

    </xsl:template>

    <!-- ***************************************************************************************************************** -->
    <!-- Call templates                                                                                                    -->
    <!-- ***************************************************************************************************************** -->

    <!-- ************************************************************************ -->
    <!-- part_table                                                               -->
    <!-- ************************************************************************ -->
    <xsl:template name="part_table">
        <table border="0" width="100%" class="lineTopAndBottom" cellspacing="0" cellpadding="3">
            <tr class="lineBottom">
                <xsl:if test="descendant::applic">
                    <xsl:call-template name="generalTblHeader">
                        <xsl:with-param name="label" select="'Applic'"></xsl:with-param>
                    </xsl:call-template>
                </xsl:if>

                <xsl:call-template name="generalTblHeader">
                    <xsl:with-param name="label" select="$name_text"></xsl:with-param>
                </xsl:call-template>

                <xsl:if test="descendant::nsn">
                    <xsl:call-template name="generalTblHeader">
                        <xsl:with-param name="label" select="'Stock number'"></xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="descendant::identno/mfc">
                    <xsl:call-template name="generalTblHeader">
                        <xsl:with-param name="label" select="$manfac"></xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="descendant::identno/pnr">
                    <xsl:call-template name="generalTblHeader">
                        <xsl:with-param name="label" select="$part_nr"></xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="descendant::serialno">
                    <xsl:call-template name="generalTblHeader">
                        <xsl:with-param name="label" select="$serialnr"></xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="descendant::csnref|descendant::refs">
                    <xsl:call-template name="generalTblHeader">
                        <xsl:with-param name="label" select="$ref_id_text"></xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="descendant::qty">
                    <xsl:call-template name="generalTblHeader">
                        <xsl:with-param name="label" select="$qty_text"></xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </tr>
            <xsl:apply-templates/>
        </table>
        <br/>
    </xsl:template>

    <!-- ************************************************************************ -->
    <!-- generalTblHeader                                                         -->
    <!-- Added support for remarks in supplies, spares and support equipment      -->
    <!-- ************************************************************************ -->
    <xsl:template name="generalTblHeader">
        <xsl:param name="label"/>
        <th style='border-top:none;border-left:none;border-bottom:solid black 0.75pt;
			   border-right:none;'>
            <xsl:value-of select="$label"/>
            <xsl:if test="descendant::remarks">
                <br/>
                <xsl:value-of select="$remarks_text"/>
            </xsl:if>
        </th>
    </xsl:template>

    <xsl:template match="notePara">
        <p style="text-align: center">
            <strong>
                <xsl:apply-templates/>
            </strong>
        </p>
    </xsl:template>

    <!-- ************************************************************************ -->
    <!-- createNote                                                               -->
    <!-- ************************************************************************ -->
    <xsl:template name="createNote">
        <p>
            <table width="100%" class="note_line">
                <tr>
                    <td align="center">
                        <font class="note_text">
                            <strong>
                                <xsl:value-of select="$note_text"/>
                            </strong>
                        </font>
                    </td>
                </tr>
                <tr>
                    <td>
                        <font class="indentMarginLeft">
                            <xsl:apply-templates/>
                        </font>
                    </td>
                </tr>
            </table>
        </p>
    </xsl:template>

    <!-- ************************************************************************ -->
    <!-- createAttention                                                          -->
    <!-- 9/8/14 updated to handle warnings and errors                             -->
    <!-- ************************************************************************ -->
    <xsl:template name="createAttention">
        <xsl:param name="text"/>
        <xsl:param name="type"/>
        <xsl:variable name="title">
            <xsl:choose>
                <xsl:when test="$type='warning'">
                    <xsl:choose>
                        <xsl:when test="@type = 'danger'">
                            <xsl:value-of select="$danger_text"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$warning_text"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$caution_text"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="borderClass">
            <xsl:choose>
                <xsl:when test="$type='warning'">redBorder</xsl:when>
                <xsl:otherwise>yellowBorder</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="color">
            <xsl:choose>
                <xsl:when test="$type='warning'">redFont</xsl:when>
                <xsl:otherwise>yellowFont</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- this may have to be moved based on a warning or caution -->
        <xsl:apply-templates/>
        <table width="100%" cellspacing="0" class="{$borderClass}">
            <tr>
                <td align="center">
                    <font class="{$color}">
                        <strong>
                            <xsl:value-of select="$title"/>
                        </strong>
                    </font>
                </td>
            </tr>
            <tr>
                <td style="text-align: center">
                    <font class="indentMarginLeft">
                        <strong>
                            <xsl:value-of select="$text"></xsl:value-of>
                        </strong>
                    </font>
                </td>
            </tr>
        </table>
    </xsl:template>


    <!-- ************************************************************************ -->
    <!-- getUrnTarget                                                             -->
    <!-- ************************************************************************ -->
    <xsl:template name="getUrnTarget">
        <xsl:param name="urn"/>
        <xsl:param name="linkType"/>
        <xsl:choose>
            <xsl:when test="$external_urn_resolver='enabled'">
                <xsl:value-of select="$external_resource_url_prefix"/><xsl:value-of select="$urn"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$document_resource_url_prefix"/><xsl:value-of
                    select="document($urn_resource_file)//urn[@name=$urn]/target[@type=$linkType]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>

  