<?xml version="1.0" encoding="UTF-8"?>
<!--  * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses. -->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" indent="yes" />
    <xsl:strip-space elements="*" />
    <xsl:variable name="title">
        <xsl:value-of
            select="scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageAddressItems/scormContentPackageTitle"></xsl:value-of>
    </xsl:variable>

    <xsl:variable name="folder" select="0" />

    <xsl:template match="/">
        <html>
            <head>
                <meta name="HandheldFriendly" content="true" />
                <meta name="viewport"
                    content="width=device-width, height=device-height, user-scalable=no" />
                <meta http-equiv="X-UA-Compatible" content="IE=8"/>    
                <title>JQueryMobileTest</title>
                <link rel="stylesheet"
                    href="jquery.mobile-1.0b2.min.css" />
                <link rel="stylesheet" href="common.css" type="text/css" />
                <link rel="stylesheet" href="mobile.css" type="text/css"
                    media="screen" />
                <script type="text/javascript"
                    src="jquery-1.6.2.min.js"></script>
                <script type="text/javascript"
                    src="mobileEvents.js"></script>
                <script type="text/javascript" src="list.js"></script>
                <script type="text/javascript">
                    $(document).bind("mobileinit", function() {
                        $.mobile.page.prototype.options.addBackBtn = true;
                    });
                </script>
                <script type="text/javascript"
                    src="jquery.mobile-1.0b2.min.js"></script>

            </head>
            <body>
                <div data-role="page" data-theme="a">

                    <div data-role="header" data-theme="a">
                        <h1>
                            <xsl:copy-of select="$title"></xsl:copy-of>
                        </h1>
                    </div><!-- /header -->

                    <div data-role="content" data-theme="a">
                        <ul data-role="listview" data-inset="true"
                            data-theme="b" data-dividertheme="b">
                            <xsl:for-each
                                select="scormContentPackage/content/scoEntry[@scoEntryType='scot01']">
                                <xsl:variable name="mic"
                                    select="scoEntryContent/dmRef/dmRefIdent/dmCode/@modelIdentCode" />
                                <xsl:variable name="sysdif"
                                    select="scoEntryContent/dmRef/dmRefIdent/dmCode/@systemDiffCode" />
                                <xsl:variable name="syscode"
                                    select="scoEntryContent/dmRef/dmRefIdent/dmCode/@systemCode" />
                                <xsl:variable name="subsyscode"
                                    select="scoEntryContent/dmRef/dmRefIdent/dmCode/@subSystemCode" />
                                <xsl:variable name="subsubsyscode"
                                    select="scoEntryContent/dmRef/dmRefIdent/dmCode/@subSubSystemCode" />
                                <xsl:variable name="assycode"
                                    select="scoEntryContent/dmRef/dmRefIdent/dmCode/@assyCode" />
                                <xsl:variable name="disassycode"
                                    select="scoEntryContent/dmRef/dmRefIdent/dmCode/@disassyCode" />
                                <xsl:variable name="disassycodevariant"
                                    select="scoEntryContent/dmRef/dmRefIdent/dmCode/@disassyCodeVariant" />
                                <xsl:variable name="infocode"
                                    select="scoEntryContent/dmRef/dmRefIdent/dmCode/@infoCode" />
                                <xsl:variable name="infocodevariant"
                                    select="scoEntryContent/dmRef/dmRefIdent/dmCode/@infoCodeVariant" />
                                <xsl:variable name="itemlocationcode"
                                    select="scoEntryContent/dmRef/dmRefIdent/dmCode/@itemLocationCode" />
                                <xsl:variable name="learncode"
                                    select="scoEntryContent/dmRef/dmRefIdent/dmCode/@learnCode" />
                                <xsl:variable name="learneventcode"
                                    select="scoEntryContent/dmRef/dmRefIdent/dmCode/@learnEventCode" />

                                <xsl:variable name="this_dmc">
                                    <xsl:choose>
                                        <xsl:when
                                            test="string-length($learncode) = 0 and string-length($learneventcode) = 0">
                                            <xsl:value-of
                                                select="concat($mic,'-',$sysdif,'-',
      $syscode,'-',$subsyscode,$subsubsyscode,'-',$assycode,'-',$disassycode,$disassycodevariant,'-',
      $infocode,$infocodevariant,'-',$itemlocationcode)" />
                                        </xsl:when>
                                        <xsl:when
                                            test="string-length($learncode) > 0 and string-length($learneventcode) = 0">
                                            <xsl:value-of
                                                select="concat($mic,'-',$sysdif,'-',
      $syscode,'-',$subsyscode,$subsubsyscode,'-',$assycode,'-',$disassycode,$disassycodevariant,'-',
      $infocode,$infocodevariant,'-',$itemlocationcode,'-',$learncode)" />
                                        </xsl:when>
                                        <xsl:when
                                            test="string-length($learncode) = 0 and string-length($learneventcode) > 0">
                                            <xsl:value-of
                                                select="concat($mic,'-',$sysdif,'-',
      $syscode,'-',$subsyscode,$subsubsyscode,'-',$assycode,'-',$disassycode,$disassycodevariant,'-',
      $infocode,$infocodevariant,'-',$itemlocationcode,'-',$learneventcode)" />
                                        </xsl:when>
                                        <xsl:when
                                            test="string-length($learncode) > 0 and string-length($learneventcode) > 0">
                                            <xsl:value-of
                                                select="concat($mic,'-',$sysdif,'-',
      $syscode,'-',$subsyscode,$subsubsyscode,'-',$assycode,'-',$disassycode,$disassycodevariant,'-',
      $infocode,$infocodevariant,'-',$itemlocationcode,'-',$learncode,$learneventcode)" />
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:variable>

                                <xsl:variable name="global_dmc">
                                    <xsl:value-of
                                        select="document('ViewerApplication/app/urn_resource_map.xml')//target[parent::urn[contains(@name, $this_dmc)]]" />
                                </xsl:variable>
                                    <xsl:choose>
                                        <xsl:when test="$learncode = 'T28'">
                                            <!-- do nothing -->
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <li>
                                            <xsl:element name="a">
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="$folder + position()"></xsl:value-of>
                                                    <xsl:text>/</xsl:text>
                                                    <xsl:value-of select="$global_dmc"></xsl:value-of>
                                                    <xsl:text>.htm</xsl:text>
                                                </xsl:attribute>
                                                <xsl:value-of select="scoEntryAddress/scoEntryTitle" />
                                            </xsl:element>
                                            </li>
                                        </xsl:otherwise>
                                    </xsl:choose>
                            </xsl:for-each>
                        </ul>
                    </div><!-- /content -->

                    <div data-role="footer" data-theme="a">
                    </div><!-- /footer -->
                </div><!-- /page -->



            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>