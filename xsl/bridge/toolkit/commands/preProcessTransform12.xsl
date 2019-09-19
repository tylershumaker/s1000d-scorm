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
<!--Version Summary 1.3 MODIFIED STW 07/22/2019 Added SCORM 1.2 support -->
<!-- TODO: develop XSL to reach into dms listed in manifest file produced
	through this transform to include ICN dependencies and other resource elements. -->
<xsl:stylesheet xmlns:lom="http://ltsc.ieee.org/xsd/LOM" xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_v1p3"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns="http://www.imsglobal.org/xsd/imscp_v1p1">
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
        <manifest xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_v1p3"
                  xmlns:adlnav="http://www.adlnet.org/xsd/adlnav_v1p3"
                  xmlns:imsss="http://www.imsglobal.org/xsd/imsss" xmlns:adlseq="http://www.adlnet.org/xsd/adlseq_v1p3"
                  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                  xmlns:lom="http://ltsc.ieee.org/xsd/LOM"
                  identifier="MANIFEST-{$id}"
                  version="{$version}" xmlns="http://www.imsglobal.org/xsd/imscp_v1p1"
                  xsi:schemaLocation="http://www.imsglobal.org/xsd/imscp_v1p1 imscp_v1p1.xsd http://www.adlnet.org/xsd/adlcp_v1p3 adlcp_v1p3.xsd http://www.adlnet.org/xsd/adlnav_v1p3 adlnav_v1p3.xsd http://www.imsglobal.org/xsd/imsss imsss_v1p0.xsd http://www/imsglobal.org/xsd/adlseq_v1p3 adlseq_v1p3.xsd http://ltsc.ieee.org/xsd/LOM lom.xsd">
            <metadata>
                <schema>ADL SCORM</schema>
                <schemaversion>1.2</schemaversion>
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
                    <xsl:element name="item">
                        <xsl:attribute name="identifier">
                            <xsl:text>ACT-</xsl:text>
                            <xsl:copy-of select="$id"/>
                        </xsl:attribute>
                        <xsl:attribute name="identifierref">
                            <xsl:text>RES-</xsl:text>
                            <xsl:value-of
                                    select="generate-id(scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageAddressItems/scormContentPackageTitle)"/>
                        </xsl:attribute>
                        <xsl:element name="title">
                            <xsl:value-of
                                    select="scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageAddressItems/scormContentPackageTitle"/>
                        </xsl:element>
                        <xsl:element name="adlcp:dataFromLMS">
                               <xsl:text> {
                                  "lrs":{
                                  "endpoint":"https://lrs.arttproject.org/test/xapi/",
                                  "user":"bosoka",
                                  "password":"luwger"
                                   },
                                  "courseId":"http://adlnet.gov/courses/</xsl:text><xsl:value-of
                                select="normalize-space(translate(scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageAddressItems/scormContentPackageTitle, ' ', ''))"/><xsl:text>",
                                  "lmsHomePage":"https://lms.arttproject.org",
                                  "isScorm2004":false,
                                  "activityId":"http://adlnet.gov/courses/</xsl:text><xsl:value-of
                                select="normalize-space(translate(scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageAddressItems/scormContentPackageTitle, ' ', ''))"/><xsl:text>/</xsl:text><xsl:value-of
                                select="normalize-space(translate(scormContentPackage/content/scoEntry/scoEntryAddress/scoEntryTitle, ' ', ''))"/><xsl:text>",
                                  "groupingContextActivity":{
                                  "definition": {
                                  "name": {
                                  "en-US": "</xsl:text><xsl:value-of
                                select="scormContentPackage/content/lom:lom/lom:general/lom:title/lom:string"/><xsl:text>"
                                  },
                                  "description": {
                                  "en-US": "</xsl:text><xsl:value-of
                                select="scormContentPackage/content/lom:lom/lom:general/lom:description/lom:string"/><xsl:text>"
                                  }
                                  },
                                  "id": "http://adlnet.gov/event/</xsl:text><xsl:value-of
                                select="$id"/><xsl:text>",
                                  "objectType": "Activity"
                                  }
                                  }
                            </xsl:text>
                        </xsl:element>
                    </xsl:element>

                    <!--Add organization tree items (SCOs) -->
                    <!--Business rule: scoEntryType attribute value 'scot01' reserved for
                        sco type assets -->
                    <metadata>
                        <xsl:copy-of select="scormContentPackage/identAndStatusSection/lom:lom"/>
                    </metadata>

                </xsl:element>
            </xsl:element>
            <!--Add resources tree section -->
            <xsl:element name="resources">
                <xsl:variable name="res_ident">
                    <xsl:value-of
                            select="generate-id(scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageAddressItems/scormContentPackageTitle)"/>

                </xsl:variable>
                <!--TODO: devise means to extract launch page value -->
                <xsl:variable name="launchPage">
                    <xsl:text>resources/shared/launchpage.html</xsl:text>
                </xsl:variable>
                <resource identifier="RES-{$res_ident}" type="webcontent"
                          adlcp:scormtype="sco" href="{$launchPage}">
                    <xsl:element name="file">
                        <xsl:attribute name="href">
                            <xsl:copy-of select="$launchPage"/>
                        </xsl:attribute>
                    </xsl:element>
                    <xsl:element name="metadata">
                        <xsl:copy-of select="scormContentPackage/identAndStatusSection/lom:lom"/>
                    </xsl:element>
                    <xsl:for-each
                            select="scormContentPackage/content/scoEntry[@scoEntryType='scot01']">
                        <xsl:apply-templates select="scoEntryContent"/>
                    </xsl:for-each>
                </resource>
            </xsl:element>
        </manifest>
    </xsl:template>

    <!--Add individual resources to sco type assets in resources tree -->
    <xsl:template match="scoEntryContent">
        <!--        <xsl:variable name="res_ident">-->
        <!--            <xsl:value-of select="generate-id(../scoEntryAddress/scoEntryTitle)" />-->

        <!--        </xsl:variable>-->
        <!--        &lt;!&ndash;TODO: devise means to extract launch page value &ndash;&gt;-->
        <!--        <xsl:variable name="launchPage">-->
        <!--            <xsl:text>TODO:ref_to_SCO_goes_here</xsl:text>-->
        <!--        </xsl:variable>-->
        <!--        <resource identifier="RES-{$res_ident}" type="webcontent"-->
        <!--                  adlcp:scormtype="sco" href="{$launchPage}">-->
        <!--            <xsl:element name="metadata">-->
        <!--                <xsl:copy-of select="../lom:lom" />-->
        <!--            </xsl:element>-->
        <!--            <file href="{$launchPage}" />-->
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
            <!-- removed  ,$issno,$inwork-->
            <!--Add the resource file element -->
            <dependency identifierref="{$infoIdent}"/>
        </xsl:for-each>
        <!--        </resource>-->
    </xsl:template>

    <xsl:template match="identAndStatusSection/lom:lom">
        <xsl:copy-of select="."/>
    </xsl:template>
</xsl:stylesheet>