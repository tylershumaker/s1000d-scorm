<?xml version="1.0" encoding="UTF-8"?>
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
	<xsl:output method="xml" indent="yes" />
	<xsl:strip-space elements="*" />
	<xsl:template match="/">
		<!--Configure the manifest id -->
		<xsl:variable name="id">
			<xsl:value-of
				select="scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageIdent/scormContentPackageCode/@modelIdentCode" />
			<xsl:text>-</xsl:text>
			<xsl:value-of
				select="scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageIdent/scormContentPackageCode/@scormContentPackageNumber" />
			<xsl:text>-</xsl:text>
			<xsl:value-of
				select="scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageIdent/scormContentPackageCode/@scormContentPackageIssuer" />
			<xsl:text>-</xsl:text>
			<xsl:value-of
				select="scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageIdent/scormContentPackageCode/@scormContentPackageVolume" />
		</xsl:variable>
		<xsl:variable name="version">
			<xsl:value-of
				select="scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageIdent/issueInfo/@issueNumber" />
		</xsl:variable>
		<manifest identifier="MANIFEST-{$id}"
			xmlns="http://www.imsglobal.org/xsd/imscp_v1p1" xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_v1p3"
			xmlns:lom="http://ltsc.ieee.org/xsd/LOM" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:schemaLocation="http://www.imsglobal.org/xsd/imscp_v1p1 imscp_v1p1.xsd http://www.adlnet.org/xsd/adlcp_v1p3 adlcp_v1p3.xsd http://ltsc.ieee.org/xsd/LOM lom.xsd"
			version="{$version}">
			<metadata>
				<schema>ADL SCORM</schema>
				<schemaversion>2004 3rd Edition</schemaversion>
         <!--  <xsl:copy-of select="scormContentPackage/identAndStatusSection/lom:lom" /> -->
			</metadata>
			<!--Add organizations tree element -->
			<xsl:element name="organizations">
				<xsl:attribute name="default">
           <xsl:text>ORG-</xsl:text>
           <xsl:copy-of select="$id" />
         </xsl:attribute>
				<!--Add organization tree element. NOTE: this SCPM and transform support 
					only a single organization tree for all scos. -->
				<xsl:element name="organization">
					<xsl:attribute name="identifier">
             <xsl:text>ORG-</xsl:text>
             <xsl:copy-of select="$id" />
           </xsl:attribute>
					<xsl:attribute name="structure">
             <xsl:text>hierarchical</xsl:text>
           </xsl:attribute>
					<xsl:element name="title">
						<xsl:value-of
							select="scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageAddressItems/scormContentPackageTitle" />
					</xsl:element>

					<!--Add organization tree items (SCOs) -->
					<!--Business rule: scoEntryType attribute value 'scot01' reserved for 
						sco type assets -->
					<xsl:for-each
						select="scormContentPackage/content/scoEntry[@scoEntryType='scot01']">
						<xsl:element name="item">
							<xsl:attribute name="identifier">
                   <xsl:text>ACT-</xsl:text>
                   <xsl:value-of
								select="generate-id(scoEntryAddress/scoEntryTitle)" />
                 </xsl:attribute>
							<xsl:attribute name="identifierref">
                   <xsl:text>RES-</xsl:text>
                   <xsl:value-of
								select="generate-id(scoEntryAddress/scoEntryTitle)" />
                 </xsl:attribute>
							<xsl:element name="title">
								<xsl:value-of select="scoEntryAddress/scoEntryTitle" />
							</xsl:element>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
			<!--Add resources tree section -->
			<xsl:element name="resources">
				<xsl:for-each
					select="scormContentPackage/content/scoEntry[@scoEntryType='scot01']">
					<xsl:apply-templates select="scoEntryContent" />
				</xsl:for-each>
			</xsl:element>
		</manifest>
	</xsl:template>

	<!--Add indivual resources to sco type assets in resources tree -->
	<xsl:template match="scoEntryContent">
		<xsl:variable name="res_ident">
			<xsl:value-of select="generate-id(../scoEntryAddress/scoEntryTitle)" />
		</xsl:variable>
		<!--TODO: devise means to extract launch page value -->
		<xsl:variable name="launchPage">
			<xsl:text>index.htm</xsl:text>
		</xsl:variable>
    <resource identifier="RES-{$res_ident}" type="webcontent"
			adlcp:scormtype="sco" href="{$launchPage}">

      <xsl:element name="metadata">
        
         <!-- <xsl:copy-of select="../lom:lom" />-->
  
      </xsl:element>
      <xsl:for-each select="dmRef/dmRefIdent">
        <xsl:variable name="mic">
          <xsl:value-of select="dmCode/@modelIdentCode" />
          <xsl:text>-</xsl:text>
        </xsl:variable>

        <xsl:variable name="sysdif">
          <xsl:value-of select="dmCode/@systemDiffCode" />
          <xsl:text>-</xsl:text>
        </xsl:variable>

        <xsl:variable name="syscode">
          <xsl:value-of select="dmCode/@systemCode" />
          <xsl:text>-</xsl:text>
        </xsl:variable>

        <xsl:variable name="subsyscode" select="dmCode/@subSystemCode" />
        <xsl:variable name="subsubsyscode">
          <xsl:value-of select="dmCode/@subSubSystemCode" />
          <xsl:text>-</xsl:text>
        </xsl:variable>

        <xsl:variable name="assycode">
          <xsl:value-of select="dmCode/@assyCode" />
          <xsl:text>-</xsl:text>
        </xsl:variable>

        <xsl:variable name="disassycode" select="dmCode/@disassyCode" />
        <xsl:variable name="disassycodevariant">
          <xsl:value-of select="dmCode/@disassyCodeVariant" />
          <xsl:text>-</xsl:text>
        </xsl:variable>

        <xsl:variable name="infocode" select="dmCode/@infoCode" />
        <xsl:variable name="infocodevariant">
          <xsl:value-of select="dmCode/@infoCodeVariant" />
          <xsl:text>-</xsl:text>
        </xsl:variable>

        <xsl:variable name="itemlocationcode">
          <xsl:value-of select="dmCode/@itemLocationCode" />
          <xsl:if test='string-length(dmCode/@learnEventCode)>0'>
            <xsl:text>-</xsl:text>
          </xsl:if>
        </xsl:variable>

        <xsl:variable name="learncode">
          <xsl:if test='string-length(dmCode/@learnCode)>0'>
            <xsl:value-of select="dmCode/@learnCode" />
          </xsl:if>
        </xsl:variable>

        <xsl:variable name="learneventcode">
          <xsl:value-of select="dmCode/@learnEventCode" />
          <xsl:if test='string-length(issueInfo/@issueNumber)>0'>
            <xsl:text>_</xsl:text>
          </xsl:if>
        </xsl:variable>

        <xsl:variable name="issno">
          <xsl:value-of select="issueInfo/@issueNumber" />
          <xsl:if test='string-length(issueInfo/@issueNumber)>0'>
            <xsl:text>-</xsl:text>
          </xsl:if>
        </xsl:variable>

        <xsl:variable name="inwork">
          <xsl:value-of select="issueInfo/@inWork" />
          <xsl:if test='string-length(/language/@languageIsoCode)>0 '>
            <xsl:text>_</xsl:text>
          </xsl:if>
        </xsl:variable>

        <xsl:variable name="lang_code">
          <xsl:value-of select="/language/@languageIsoCode" />
          <xsl:if test='string-length(/language/@languageIsoCode)>0'>
            <xsl:text>-</xsl:text>
          </xsl:if>
        </xsl:variable>

        <xsl:variable name="lang_country">
          <xsl:value-of select="/language/@countryIsoCode" />
          <xsl:if test='string-length(/language/@countryIsoCode)>0'>
            <xsl:text>-</xsl:text>
          </xsl:if>
        </xsl:variable>

        <!--concat the variables from the scoentryAddress to form the map urn 
					element value -->
        <xsl:variable name="infoIdent"
					select="concat('DMC-',$mic,$sysdif,
						  $syscode,$subsyscode,$subsubsyscode,$assycode,$disassycode,$disassycodevariant,
						  $infocode,$infocodevariant,$itemlocationcode,$learncode,
						  $learneventcode,$issno,$inwork,$lang_code,$lang_country)" />
        <!--Configure the conformant resource mapping URN for queried document 
					search in urn_resource_map file -->
        <xsl:variable name="urn_prefix">
          <xsl:value-of select="'URN:S1000D:'" />
        </xsl:variable>

        <xsl:variable name="urn_string">
          <xsl:value-of select="concat($urn_prefix, $infoIdent)" />
        </xsl:variable>
        <!--query the external urn map file to resolve the DM (file) urn string. 
					NOTE: all relative paths to URN resource map must equate! -->
        <xsl:variable name="theFileName">
          <xsl:value-of
						select="document('./urn_resource_map.xml')//target[parent::urn[@name=$urn_string]]" />
        </xsl:variable>
        <!--Show comment to identify missing or faulty DM resources -->
        <xsl:if test='string-length($theFileName)=0'>
          <xsl:comment>
            Unable to locate resource:
            <xsl:value-of select='$infoIdent' />
          </xsl:comment>
        </xsl:if>
        <!--Add the resource file element -->
        <dependency identifierref="{$infoIdent}" />
      </xsl:for-each>
    </resource>
	</xsl:template>

  <xsl:template match="identAndStatusSection/lom:lom">
    <xsl:copy-of select="." />
  </xsl:template>
</xsl:stylesheet>