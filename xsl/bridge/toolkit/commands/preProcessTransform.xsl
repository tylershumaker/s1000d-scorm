<?xml version="1.0" encoding="UTF-8"?>
<!--  * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses. -->
<!--Version Summary 1.1 MODIFIED STW 10/06/2010 This version handles variance 
	of DMC in URN_RESOURCE mapping file. Also, namespace errors handled through 
	use of XSL literals. Compiled transform successfully tested against full 
	S1000D Bike SCPPM. Templates altered to remove some "for-each" processing 
	in cases where only one element exists. -->
<!--Version Summary 1.2 MODIFIED STW 10/20/2010 Added LOM processing -->
<!-- TODO: develop XSL to reach into dms listed in manifest file produced 
	through this transform to include ICN dependencies and other resource elements. -->
<xsl:stylesheet version="1.0" xmlns:lom="http://ltsc.ieee.org/xsd/LOM"
                xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_v1p3" xmlns="http://www.imsglobal.org/xsd/imscp_v1p1"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
        <!--Configure the manifest id -->
        <xsl:variable name="id">
            <xsl:value-of
                    select="scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageIdent/scormContentPackageCode/@modelIdentCode"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of
                    select="scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageIdent/scormContentPackageCode/@scormContentPackageNumber"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of
                    select="scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageIdent/scormContentPackageCode/@scormContentPackageIssuer"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of
                    select="scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageIdent/scormContentPackageCode/@scormContentPackageVolume"/>
        </xsl:variable>
        <xsl:variable name="version">
            <xsl:value-of
                    select="scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageIdent/issueInfo/@issueNumber"/>
        </xsl:variable>
        <manifest identifier="MANIFEST-{$id}" version="{$version}"
                  xmlns="http://www.imsglobal.org/xsd/imscp_v1p1" xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_v1p3"
                  xmlns:adlnav="http://www.adlnet.org/xsd/adlnav_v1p3"
                  xmlns:imsss="http://www.imsglobal.org/xsd/imsss"
                  xmlns:adlseq="http://www.adlnet.org/xsd/adlseq_v1p3"
                  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:lom="http://ltsc.ieee.org/xsd/LOM"
                  xsi:schemaLocation="http://www.imsglobal.org/xsd/imscp_v1p1 imscp_v1p1.xsd http://www.adlnet.org/xsd/adlcp_v1p3 adlcp_v1p3.xsd http://www.adlnet.org/xsd/adlnav_v1p3 adlnav_v1p3.xsd http://www.imsglobal.org/xsd/imsss imsss_v1p0.xsd http://www/imsglobal.org/xsd/adlseq_v1p3 adlseq_v1p3.xsd http://ltsc.ieee.org/xsd/LOM lom.xsd">
            <metadata>
                <schema>ADL SCORM</schema>
                <schemaversion>2004 3rd Edition</schemaversion>
            </metadata>
            <!--Add organizations tree element -->
            <xsl:element name="organizations">
                <xsl:attribute name="default">
                    <xsl:text>ORG-</xsl:text>
                    <xsl:copy-of select="$id"/>
                </xsl:attribute>
                <!--Add organization tree element. NOTE: this SCPM and transform support
                    only a single organization tree for all scos. -->
                <xsl:element name="organization">
                    <xsl:attribute name="identifier">
                        <xsl:text>ORG-</xsl:text>
                        <xsl:copy-of select="$id"/>
                    </xsl:attribute>
                    <xsl:attribute name="structure">
                        <xsl:text>hierarchical</xsl:text>
                    </xsl:attribute>
                    <xsl:element name="title">
                        <xsl:value-of
                                select="scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageAddressItems/scormContentPackageTitle"/>
                    </xsl:element>

                    <!--Add organization tree items (SCOs) -->
                    <!--Business rule: scoEntryType attribute value 'scot01' reserved for
                        sco type assets -->
                    <xsl:for-each select="scormContentPackage/content/scoEntry[@scoEntryType='scot01']">
                        <xsl:variable name="mic">
                            <xsl:value-of select="scoEntryContent/dmRef/dmRefIdent/dmCode/@modelIdentCode"/>
                            <xsl:text>-</xsl:text>
                        </xsl:variable>

                        <xsl:variable name="sysdif">
                            <xsl:value-of select="scoEntryContent/dmRef/dmRefIdent/dmCode/@systemDiffCode"/>
                            <xsl:text>-</xsl:text>
                        </xsl:variable>

                        <xsl:variable name="syscode">
                            <xsl:value-of select="scoEntryContent/dmRef/dmRefIdent/dmCode/@systemCode"/>
                            <xsl:text>-</xsl:text>
                        </xsl:variable>

                        <xsl:variable name="subsyscode"
                                      select="scoEntryContent/dmRef/dmRefIdent/dmCode/@subSystemCode"/>
                        <xsl:variable name="subsubsyscode">
                            <xsl:value-of select="scoEntryContent/dmRef/dmRefIdent/dmCode/@subSubSystemCode"/>
                            <xsl:text>-</xsl:text>
                        </xsl:variable>

                        <xsl:variable name="assycode">
                            <xsl:value-of select="scoEntryContent/dmRef/dmRefIdent/dmCode/@assyCode"/>
                            <xsl:text>-</xsl:text>
                        </xsl:variable>

                        <xsl:variable name="disassycode" select="scoEntryContent/dmRef/dmRefIdent/dmCode/@disassyCode"/>
                        <xsl:variable name="disassycodevariant">
                            <xsl:value-of select="scoEntryContent/dmRef/dmRefIdent/dmCode/@disassyCodeVariant"/>
                            <xsl:text>-</xsl:text>
                        </xsl:variable>

                        <xsl:variable name="infocode" select="scoEntryContent/dmRef/dmRefIdent/dmCode/@infoCode"/>
                        <xsl:variable name="infocodevariant">
                            <xsl:value-of select="scoEntryContent/dmRef/dmRefIdent/dmCode/@infoCodeVariant"/>
                            <xsl:text>-</xsl:text>
                        </xsl:variable>

                        <xsl:variable name="itemlocationcode">
                            <xsl:value-of select="scoEntryContent/dmRef/dmRefIdent/dmCode/@itemLocationCode"/>
                            <xsl:if test='string-length(scoEntryContent/dmRef/dmRefIdent/dmCode/@learnEventCode)&gt;0'>
                                <xsl:text>-</xsl:text>
                            </xsl:if>
                        </xsl:variable>

                        <xsl:variable name="learncode">
                            <xsl:if test='string-length(scoEntryContent/dmRef/dmRefIdent/dmCode/@learnCode)&gt;0'>
                                <xsl:value-of select="scoEntryContent/dmRef/dmRefIdent/dmCode/@learnCode"/>
                            </xsl:if>
                        </xsl:variable>

                        <xsl:variable name="learneventcode">
                            <xsl:value-of select="scoEntryContent/dmRef/dmRefIdent/dmCode/@learnEventCode"/>
                            <xsl:if test='string-length(scoEntryContent/dmRef/dmRefIdent/dmCode/@learnEventCode)&gt;0'>

                            </xsl:if>
                        </xsl:variable>

                        <xsl:variable name="issno">
                            <xsl:value-of select="scoEntryContent/dmRef/dmRefIdent/issueInfo/@issueNumber" />
                            <xsl:if test='string-length(scoEntryContent/dmRef/dmRefIdent/issueInfo/@issueNumber)&gt;0'>
                                <xsl:text>-</xsl:text>
                            </xsl:if>
                        </xsl:variable>

                        <xsl:variable name="inwork">
                            <xsl:value-of select="scoEntryContent/dmRef/dmRefIdent/issueInfo/@inWork" />
                            <xsl:if test='string-length(scoEntryContent/dmRef/dmRefIdent/issueInfo/@inWork)&gt;0 '>
                                <xsl:text>_</xsl:text>
                            </xsl:if>
                        </xsl:variable>

                        <xsl:variable name="lang_code">
                            <xsl:text></xsl:text>
                            <xsl:value-of select="scoEntryContent/dmRef/dmRefIdent/language/@languageIsoCode"/>
                            <xsl:if test='string-length(scoEntryContent/dmRef/dmRefIdent/language/@languageIsoCode)&gt;0'>
                                <xsl:text>-</xsl:text>
                            </xsl:if>
                        </xsl:variable>

                        <xsl:variable name="lang_country">
                            <xsl:value-of select="scoEntryContent/dmRef/dmRefIdent/language/@countryIsoCode"/>
                            <xsl:if test='string-length(scoEntryContent/dmRef/dmRefIdent/language/@countryIsoCode)&gt;0'>
                                <!-- 			<xsl:text>-</xsl:text> -->
                            </xsl:if>
                        </xsl:variable>

                        <!--concat the variables from the scoentryAddress to form the map urn
                            element value -->
                        <xsl:variable name="actInfoIdent"
                                      select="concat('DMC-',$mic,$sysdif,
								  $syscode,$subsyscode,$subsubsyscode,$assycode,$disassycode,$disassycodevariant,
								  $infocode,$infocodevariant,$itemlocationcode,$learncode,
								  $learneventcode)"/>

                        <!-- added ,$issno,$inwork,$lang_code,$lang_country-->
                        <xsl:variable name="actInfoIdent2"
                                      select="concat('DMC-',$mic,$sysdif,
						  $syscode,$subsyscode,$subsubsyscode,$assycode,$disassycode,$disassycodevariant,
						  $infocode,$infocodevariant,$itemlocationcode,$learncode,
						  $learneventcode, '_', $issno, $inwork, $lang_code, $lang_country)"/>

                        <xsl:element name="item">
                            <xsl:attribute name="identifier">
                                <xsl:text>ACT-</xsl:text>
                                <xsl:value-of select="$actInfoIdent"/>
                            </xsl:attribute>
                            <xsl:attribute name="identifierref">
                                <xsl:text>RES-</xsl:text>
                                <!-- scoEntryAddress: removed, element does NOT exist -->
                                <xsl:value-of select="generate-id(scoEntryAddress/scoEntryTitle)"/>
                            </xsl:attribute>
                            <xsl:element name="title">
                                <xsl:value-of select="scoEntryAddress/scoEntryTitle"/>
                            </xsl:element>
                            <xsl:element name="adlcp:dataFromLMS">
                               <xsl:text> {
                                  "lrs":{
                                  "endpoint":"https://lrs.arttproject.org/test/xapi/",
                                  "user":"bosoka",
                                  "password":"luwger"
                                   },
                                  "courseId":"http://lms.arttproject.org/courses/</xsl:text><xsl:value-of
                                    select="normalize-space(translate(../../../scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageAddressItems/scormContentPackageTitle, ' ', ''))"/><xsl:text>",
                                  "lmsHomePage":"https://lms.arttproject.org",
                                  "isScorm2004":true,
                                  "activityId":"http://lms.arttproject.org/courses/</xsl:text><xsl:value-of
                                    select="normalize-space(translate(../../../scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageAddressItems/scormContentPackageTitle, ' ', ''))"/><xsl:text>/</xsl:text><xsl:value-of
                                    select="normalize-space(translate(scoEntryAddress/scoEntryTitle, ' ', ''))"/><xsl:text>",
                                  "groupingContextActivity":{
                                  "definition": {
                                  "name": {
                                  "en-US": "</xsl:text><xsl:value-of
                                    select="lom:lom/lom:general/lom:title/lom:string"/><xsl:text>"
                                  },
                                  "description": {
                                  "en-US": "</xsl:text><xsl:value-of
                                    select="lom:lom/lom:general/lom:title/lom:string"/><xsl:text>"
                                  }
                                  },
                                  "id": "urn:s1000d:</xsl:text><xsl:value-of
                                    select="$actInfoIdent2"/><xsl:text>",
                                  "objectType": "Activity"
                                  }
                                  }
                            </xsl:text>
                            </xsl:element>
                            <!-- 9/1/14 issue 23 fix -->
                            <xsl:element name="adlnav:presentation" namespace="http://www.adlnet.org/xsd/adlnav_v1p3">
                                <xsl:element name="adlnav:navigationInterface"
                                             namespace="http://www.adlnet.org/xsd/adlnav_v1p3">
                                    <xsl:element name="adlnav:hideLMSUI"
                                                 namespace="http://www.adlnet.org/xsd/adlnav_v1p3">continue
                                    </xsl:element>
                                    <xsl:element name="adlnav:hideLMSUI"
                                                 namespace="http://www.adlnet.org/xsd/adlnav_v1p3">previous
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                            <!-- 7/16/2019 -->
                            <xsl:if test="not(contains($learncode, 'T28'))">
                                <xsl:element name="imsss:sequencing" namespace="http://www.imsglobal.org/xsd/imsss">
                                    <xsl:element name="imsss:rollupRules"
                                                 namespace="http://www.imsglobal.org/xsd/imsss">
                                        <xsl:attribute name="objectiveMeasureWeight">0</xsl:attribute>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:if>

                        </xsl:element>
                    </xsl:for-each>
                    <metadata>
                        <xsl:copy-of select="scormContentPackage/identAndStatusSection/lom:lom"/>
                    </metadata>
                    <!-- 9/1/14 issue 23 fix -->
                    <xsl:element name="imsss:sequencing" namespace="http://www.imsglobal.org/xsd/imsss">
                        <xsl:element name="imsss:controlMode" namespace="http://www.imsglobal.org/xsd/imsss">
                            <xsl:attribute name="flow">true</xsl:attribute>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <!--Add resources tree section -->
            <xsl:element name="resources">
                <xsl:for-each
                        select="scormContentPackage/content/scoEntry[@scoEntryType='scot01']">
                    <xsl:apply-templates select="scoEntryContent"/>
                </xsl:for-each>
            </xsl:element>
        </manifest>
    </xsl:template>

    <!--Add indivual resources to sco type assets in resources tree -->
    <xsl:template match="scoEntryContent">
        <xsl:variable name="res_ident">
            <xsl:value-of select="generate-id(../scoEntryAddress/scoEntryTitle)"/>

        </xsl:variable>
        <!--TODO: devise means to extract launch page value -->
        <xsl:variable name="launchPage">
            <xsl:text>TODO:ref_to_SCO_goes_here</xsl:text>
        </xsl:variable>
        <resource identifier="RES-{$res_ident}" type="webcontent"
                  adlcp:scormType="sco" href="{$launchPage}">
            <xsl:element name="metadata">
                <xsl:copy-of select="../lom:lom"/>
            </xsl:element>
            <file href="{$launchPage}"/>
            <xsl:for-each select="dmRef/dmRefIdent">
                <xsl:variable name="mic">
                    <xsl:value-of select="dmCode/@modelIdentCode"/>
                    <xsl:text>-</xsl:text>
                </xsl:variable>

                <xsl:variable name="sysdif">
                    <xsl:value-of select="dmCode/@systemDiffCode"/>
                    <xsl:text>-</xsl:text>
                </xsl:variable>

                <xsl:variable name="syscode">
                    <xsl:value-of select="dmCode/@systemCode"/>
                    <xsl:text>-</xsl:text>
                </xsl:variable>

                <xsl:variable name="subsyscode" select="dmCode/@subSystemCode"/>
                <xsl:variable name="subsubsyscode">
                    <xsl:value-of select="dmCode/@subSubSystemCode"/>
                    <xsl:text>-</xsl:text>
                </xsl:variable>

                <xsl:variable name="assycode">
                    <xsl:value-of select="dmCode/@assyCode"/>
                    <xsl:text>-</xsl:text>
                </xsl:variable>

                <xsl:variable name="disassycode" select="dmCode/@disassyCode"/>
                <xsl:variable name="disassycodevariant">
                    <xsl:value-of select="dmCode/@disassyCodeVariant"/>
                    <xsl:text>-</xsl:text>
                </xsl:variable>

                <xsl:variable name="infocode" select="dmCode/@infoCode"/>
                <xsl:variable name="infocodevariant">
                    <xsl:value-of select="dmCode/@infoCodeVariant"/>
                    <xsl:text>-</xsl:text>
                </xsl:variable>

                <xsl:variable name="itemlocationcode">
                    <xsl:value-of select="dmCode/@itemLocationCode"/>
                    <xsl:if test='string-length(dmCode/@learnEventCode)&gt;0'>
                        <xsl:text>-</xsl:text>
                    </xsl:if>
                </xsl:variable>

                <xsl:variable name="learncode">
                    <xsl:if test='string-length(dmCode/@learnCode)&gt;0'>
                        <xsl:value-of select="dmCode/@learnCode"/>
                    </xsl:if>
                </xsl:variable>

                <xsl:variable name="learneventcode">
                    <xsl:value-of select="dmCode/@learnEventCode"/>
                    <!-- <xsl:if test='string-length(issueInfo/@issueNumber)&gt;0'>
                        <xsl:text>_</xsl:text>
                    </xsl:if> -->
                </xsl:variable>

                <xsl:variable name="issno">
                    <xsl:value-of select="issueInfo/@issueNumber" />
                    <xsl:if test='string-length(issueInfo/@issueNumber)&gt;0'>
                        <xsl:text>-</xsl:text>
                    </xsl:if>
                </xsl:variable>

                <xsl:variable name="inwork">
                    <xsl:value-of select="issueInfo/@inWork" />
                    <xsl:if test='string-length(/language/@languageIsoCode)&gt;0 '>
                        <xsl:text>_</xsl:text>
                    </xsl:if>
                </xsl:variable>

                <xsl:variable name="lang_code">
                    <xsl:value-of select="/language/@languageIsoCode"/>
                    <xsl:if test='string-length(/language/@languageIsoCode)&gt;0'>
                        <xsl:text>-</xsl:text>
                    </xsl:if>
                </xsl:variable>

                <xsl:variable name="lang_country">
                    <xsl:value-of select="/language/@countryIsoCode"/>
                    <xsl:if test='string-length(/language/@countryIsoCode)&gt;0'>
                        <xsl:text>-</xsl:text>
                    </xsl:if>
                </xsl:variable>

                <!--concat the variables from the scoentryAddress to form the map urn
                    element value -->
                <xsl:variable name="infoIdent"
                              select="concat('DMC-',$mic,$sysdif,
						  $syscode,$subsyscode,$subsubsyscode,$assycode,$disassycode,$disassycodevariant,
						  $infocode,$infocodevariant,$itemlocationcode,$learncode,
						  $learneventcode,$lang_code,$lang_country)"/>

                <!-- added ,$issno,$inwork-->
                <xsl:variable name="infoIdent2"
                              select="concat('DMC-',$mic,$sysdif,
						  $syscode,$subsyscode,$subsubsyscode,$assycode,$disassycode,$disassycodevariant,
						  $infocode,$infocodevariant,$itemlocationcode,$learncode,
						  $learneventcode, '_', $issno, '-', $inwork,'_', $lang_code, '-', $lang_country)"/>

                <!--Add the resource file element -->
                <dependency identifierref="{$infoIdent}"/>
            </xsl:for-each>
        </resource>
    </xsl:template>

    <xsl:template match="identAndStatusSection/lom:lom">
        <xsl:copy-of select="."/>
    </xsl:template>
</xsl:stylesheet>