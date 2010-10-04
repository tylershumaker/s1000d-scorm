<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:lom="http://ltsc.ieee.org/xsd/LOM" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output method="xml" indent="yes" />

   <xsl:strip-space elements="*" />
   <xsl:variable name="id">
	  <xsl:for-each select="/scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageIdent/scormContentPackageCode">
      		<xsl:value-of select="@modelIdentCode"/>
      		<xsl:text>-</xsl:text>
      		<xsl:value-of select="@scormContentPackageNumber"/>
      		<xsl:text>-</xsl:text>
      		<xsl:value-of select="@scormContentPackageIssuer"/>
      		<xsl:text>-</xsl:text>
      		<xsl:value-of select="@scormContentPackageVolume"/>
      </xsl:for-each>
   </xsl:variable>
   <xsl:template match="/scormContentPackage">
      <xsl:element name="manifest">
	     <xsl:attribute name="identifier">
	        <xsl:text>MANIFEST-</xsl:text>
			<xsl:copy-of select="$id"/>
	     </xsl:attribute>
      	 <xsl:for-each select="identAndStatusSection/scormContentPackageAddress/scormContentPackageIdent/issueInfo">
      	 	<xsl:attribute name="version">
      	 		<xsl:value-of select="@issueNumber"/>
      	 	</xsl:attribute>
      	 </xsl:for-each>
      	 <!-- errors when running the compiler -->
      	 <!-- <xsl:attribute name="xmlns">
      	 	<xsl:text>http://www.imsglobal.org/xsd/imscp_v1p1</xsl:text>
      	 </xsl:attribute>
      	 <xsl:attribute name="xmlns:adlcp">
      	 	<xsl:text>http://www.adlnet.org/xsd/adlcp_v1p3</xsl:text>
      	 </xsl:attribute>
      	 <xsl:attribute name="xmlns:lom">
      	 	<xsl:text>http://ltsc.ieee.org/xsd/LOM</xsl:text>
      	 </xsl:attribute>
      	 <xsl:attribute name="xmlns:xsi">
      	 	<xsl:text>http://www.w3.org/2001/XMLSchema-instance</xsl:text>
      	 </xsl:attribute>
      	 <xsl:attribute name="xsi:schemaLocation">
      	 	<xsl:text>http://www.imsglobal.org/xsd/imscp_v1p1 imscp_v1p1.xsd</xsl:text>
      	 	<xsl:text>http://www.adlnet.org/xsd/adlcp_v1p3 adlcp_v1p3.xsd</xsl:text>
      	 	<xsl:text>http://ltsc.ieee.org/xsd/LOM lom.xsd</xsl:text>
      	 </xsl:attribute>-->
      	 <xsl:element name="metadata">
      	 	<xsl:element name="schema">
      	 		<xsl:text>ADL SCORM</xsl:text>
      	 	</xsl:element>
      	 	<xsl:element name="schemaversion">
      	 		<xsl:text>2004 3rd Edition</xsl:text>
      	 	</xsl:element>
      	 </xsl:element>
         <xsl:element name="organizations">
         	<xsl:attribute name="default">
         	    <xsl:text>ORG-</xsl:text>
         		<xsl:copy-of select="$id"/>
         	</xsl:attribute>
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
	                  select="identAndStatusSection/scormContentPackageAddress/scormContentPackageAddressItems/scormContentPackageTitle" />
	            </xsl:element>
	            <xsl:apply-templates select="content" />
	            <!-- commented out all lom for testing 
	            <xsl:element name="metadata">
		            <xsl:for-each select="identAndStatusSection/lom:lom">
		               <xsl:element name="lom">
		                  <xsl:copy-of select="*" />
		               </xsl:element>
		            </xsl:for-each>
	            </xsl:element>-->
            </xsl:element>
         </xsl:element>
         <xsl:for-each select="content">
         <xsl:element name="resources">
	         <xsl:for-each select="scoEntry">
	         	<xsl:apply-templates select="scoEntryContent"/>
	         </xsl:for-each>
         </xsl:element>
         </xsl:for-each>
      </xsl:element>
   </xsl:template>

   <xsl:template match="content">
         <xsl:for-each select="scoEntry">
	       <xsl:element name="item">
	          <xsl:attribute name="identifier">
	             <xsl:text>ACT-</xsl:text>
	             <xsl:value-of select="generate-id(scoEntryAddress/scoEntryTitle)" />
	          </xsl:attribute>
	          <xsl:attribute name="identifierref">
	          	 <xsl:text>RES-</xsl:text>
	          	 <xsl:value-of select="generate-id(scoEntryAddress/scoEntryTitle)"/>
	          </xsl:attribute>
	          <xsl:element name="title">
	             <xsl:value-of select="scoEntryAddress/scoEntryTitle" />
	          </xsl:element>
	          <!-- commented out all lom for testing
	          <xsl:element name="metadata">
	           <xsl:for-each select="lom:lom">
	              <xsl:element name="lom">
	                 <xsl:copy-of select="*" />
	              </xsl:element>
	           </xsl:for-each>
	          </xsl:element>-->
	       </xsl:element>	
         </xsl:for-each>

   </xsl:template>

	<xsl:template match="scoEntryContent">
		<xsl:element name="resource">
			<xsl:attribute name="identifier">
	          	 <xsl:text>RES-</xsl:text>
	          	 <xsl:value-of select="generate-id(../scoEntryAddress/scoEntryTitle)"/>			
			</xsl:attribute>
			<xsl:attribute name="type">
				<xsl:text>webcontent</xsl:text>
			</xsl:attribute>
			<!-- ERROR: Namespace for prefix 'adlcp' has not been declared  -->
			<!-- need to figure out how todo this so attribute can be 
			     'adlcp:scormType -->
			<xsl:attribute name="scormType">
				<xsl:text>sco</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="href">
				<xsl:text>TODO:ref_to_SCO_goes_here</xsl:text>
			</xsl:attribute>
			<xsl:element name="file">
				<xsl:attribute name="href">
					<xsl:text>TODO:ref_to_SCO_goes_here</xsl:text>
				</xsl:attribute>
			</xsl:element>
			<xsl:for-each select="dmRef/dmRefIdent/dmCode">
				<xsl:element name="file">
					<xsl:attribute name="href">
		               <xsl:value-of select="@modelIdentCode" />
		               <xsl:text>-</xsl:text>
		               <xsl:value-of select="@systemDiffCode" />
		               <xsl:text>-</xsl:text>
		               <xsl:value-of select="@systemCode" />
		               <xsl:text>-</xsl:text>
		               <xsl:value-of select="@subSystemCode" />
		               <xsl:value-of select="@subSubSystemCode" />
		               <xsl:text>-</xsl:text>
		               <xsl:value-of select="@assyCode" />
		               <xsl:text>-</xsl:text>
		               <xsl:value-of select="@disassyCode" />
		               <xsl:value-of select="@disassyCodeVariant" />
		               <xsl:text>-</xsl:text>
		               <xsl:value-of select="@infoCode" />
		               <xsl:value-of select="@infoCodeVariant" />
		               <xsl:text>-</xsl:text>
		               <xsl:value-of select="@itemLocationCode" />
		               <xsl:text>-</xsl:text>
		               <xsl:value-of select="@learnCode" />
		               <xsl:value-of select="@learnEventCode" />
	               </xsl:attribute>
	            </xsl:element>
	            <!-- removed, don't think it maps into manifest file -->
				<!-- <xsl:for-each select="../language">
					<xsl:element name="country">
						<xsl:value-of select="@countryIsoCode" />
					</xsl:element>
					<xsl:element name="language">
						<xsl:value-of select="@languageIsoCode" />
					</xsl:element>
				</xsl:for-each>
				<xsl:for-each select="../issueInfo">
					<xsl:element name="issueNumber">
						<xsl:value-of select="@issueNumber" />
					</xsl:element>
					<xsl:element name="inWork">
						<xsl:value-of select="@inWork" />
					</xsl:element>
				</xsl:for-each>-->
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
   
</xsl:stylesheet>