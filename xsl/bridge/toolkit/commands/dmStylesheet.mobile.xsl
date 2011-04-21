<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://www.purl.org/dc/elements/1.1/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    version="1.0">
    <xsl:output method="html" indent="yes" />
    <xsl:include href="ViewerApplication/app/params.xslt" />
    <xsl:include href="ViewerApplication/app/funcs.xslt" />
    <xsl:include href="ViewerApplication/app/common.xslt" />
    <xsl:include href="ViewerApplication/app/lists.xslt" />
    <xsl:include href="xsl/bridge/toolkit/commands/graphics.mobile.xslt" />
    <xsl:include href="ViewerApplication/app/assessment.xslt" />
    <!--<xsl:include href="header.xslt"/> -->
    <xsl:include href="ViewerApplication/app/table.xslt" />
    <!--<xsl:include href="steps.xslt"/> -->
    <xsl:include href="xsl/bridge/toolkit/commands/refs.mobile.xslt" />
    <!--For future use module specific elements inclusions -->

    <!--global vars -->
    <xsl:variable name="mic"
        select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@modelIdentCode" />
    <xsl:variable name="sysdif"
        select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@systemDiffCode" />
    <xsl:variable name="syscode"
        select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@systemCode" />
    <xsl:variable name="subsyscode"
        select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@subSystemCode" />
    <xsl:variable name="subsubsyscode"
        select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@subSubSystemCode" />
    <xsl:variable name="assycode"
        select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@assyCode" />
    <xsl:variable name="disassycode"
        select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@disassyCode" />
    <xsl:variable name="disassycodevariant"
        select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@disassyCodeVariant" />
    <xsl:variable name="infocode"
        select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@infoCode" />
    <xsl:variable name="infocodevariant"
        select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@infoCodeVariant" />
    <xsl:variable name="itemlocationcode"
        select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@itemLocationCode" />
    <xsl:variable name="learncode"
        select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@learnCode" />
    <xsl:variable name="learneventcode"
        select="dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@learnEventCode" />
    <xsl:variable name="infoname"
        select="dmodule/identAndStatusSection/dmAddress/dmAddressItems/dmTitle/infoName" />

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
    <xsl:template match="/">

        <html>
            <head>
                <meta name="HandheldFriendly" content="true" />
                <meta name="viewport"
                    content="width=device-width, height=device-height, user-scalable=no" />
                <meta http-equiv="X-UA-Compatible" content="IE=8"/>    
                <title>JQueryMobileTest</title>
                <link rel="stylesheet"
                    href="../jquery.mobile-1.0a4.1.min.css" />
                <link rel="stylesheet" href="../common.css" type="text/css" />
                <link rel="stylesheet" href="../mobile.css" type="text/css"
                    media="screen" />
                <script type="text/javascript"
                    src="../jquery-1.5.2.min.js"></script>
                <script type="text/javascript"
                    src="../jquery.mobile-1.0a4.1.min.js"></script>
            </head>
            <body>
                <div data-role="page">
                    <div data-role="header" data-position="fixed">
                        <h1><xsl:value-of select="$infoname"></xsl:value-of></h1>
                        <a href="#" data-icon="home" data-iconpos="notext" class="ui-btn-right" id="home">Menu</a>
                    </div><!-- /header -->
                    <div data-role="content">
                        <xsl:apply-templates />                            
                    </div><!-- /content -->
            		<div data-role="footer" data-position="fixed">
            			<div data-role="navbar"> 
            				<ul> 
            					<li><a href="#" data-icon="arrow-l" class="ui-btn-left" id="last" /></li> 
            					<li><a href="#" data-icon="arrow-r" class="ui-btn-right" id="next" /></li> 
            				</ul> 
            			</div><!-- /navbar --> 
            		</div><!-- /footer -->
                </div><!-- /page -->
            </body>
        </html>
    </xsl:template>
    <xsl:template match="identAndStatusSection">
        <!--suppress -->
    </xsl:template>

    <xsl:template match="LEARNING|learning">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="rdf:Description">
        <!-- <xsl:variable name="section_pane_state">block</xsl:variable> 
            <div id="metadataDiv" style="display:{$section_pane_state}"> <table class="metadataPane"> 
            <tr> <td> <b> <xsl:value-of select ="dc:identifier" /> </b> </td> <td> </td> 
            </tr> <tr> <td> <h5> <xsl:value-of select ="dc:subject" /> </h5> </td> </tr> 
            </table> </div> <p> <a href="javascript:void(toggle_visibility('metadataDiv'))">Additional 
            Information</a> </p> -->
    </xsl:template>

</xsl:stylesheet>
