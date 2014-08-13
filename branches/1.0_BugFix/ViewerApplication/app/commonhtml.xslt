<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="preliminaryRqmts">
		<h4>
			Preliminary Requirements
		</h4>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="reqCondGroup">
		<xsl:choose>
			<xsl:when test="./noConds">
				<!--suppress-->
			</xsl:when>
			<xsl:otherwise>
				<table border="0" width="100%" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<table border="0" width="100%" class="prelreq_table"  cellspacing="0" cellpadding="3">
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
											<xsl:value-of select="./reqCond" />
										</td>
										<td>-----</td>
									</tr>
								</xsl:for-each>
								<xsl:for-each select="./reqCondDm">
									<tr>
										<td>
											<!--<xsl:value-of select="'FOOO'" />-->
										</td>
										<!--<td>DMC</td>-->
									</tr>
								</xsl:for-each>
							</table>
						</td>
					</tr>
				</table>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>

	
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

	<xsl:template match="applic">
		<xsl:call-template name="applic"/>
	</xsl:template>

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

	<xsl:template match="applic[ancestor::supplies]">
		<td>
			<xsl:call-template name="applic"/>
		</td>
	</xsl:template>

	<xsl:template match="applics">
		<td>
			<xsl:for-each select="applic">
				<xsl:call-template name="applic"/><br/>
			</xsl:for-each>
		</td>
	</xsl:template>

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
								<i><xsl:value-of select="$model_text"/></i>:<xsl:value-of select="child::model/@model"/>;
							</xsl:if>
							<xsl:if test="self::model">
								<i><xsl:value-of select="$model_text"/></i>:<xsl:value-of select="@model"/>;
							</xsl:if>
							<xsl:choose>
								<xsl:when test="descendant::versrank">
									<i>Version</i>:<xsl:value-of select="descendant::range/@from"/><i>-</i><xsl:value-of select="descendant::range/@to"/>;
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
						<i><xsl:value-of select="$model_text"/></i>:<xsl:value-of select="child::model/@model"/>;
					</xsl:if>
					<xsl:if test="self::model">
						<i><xsl:value-of select="$model_text"/></i>:<xsl:value-of select="@model"/>;
					</xsl:if>
					<xsl:choose>
						<xsl:when test="descendant::versrank">
							<i>Version</i>:<xsl:value-of select="descendant::range/@from"/><i>-</i><xsl:value-of select="descendant::range/@to"/>;
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
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="supportEquipDescrGroup">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="supportEquipDescr">
		<tr>
			<td>
				<xsl:value-of select="./name" />
			</td>
			<td>
				<xsl:value-of select="./identNumber/manufacturerCode" />
			</td>
			<td>
				<xsl:value-of select="./reqQuantity" /> : <xsl:value-of select="./reqQuantity/@unitOfMeasure" />
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
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="supplyDescr">
		<tr>
			<td>
				<xsl:value-of select="./name" />
			</td>
			<td>
				<xsl:value-of select="./identNumber/manufacturerCode" />
			</td>
			<td>
				<xsl:value-of select="./reqQuantity" /> : <xsl:value-of select="./reqQuantity/@unitOfMeasure" />
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
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="spareDescr">
		<tr>
			<td>
				<xsl:value-of select="./name" />
			</td>
			<td>
				<xsl:value-of select="./identNumber/manufacturerCode" />
			</td>
			<td>
				<xsl:value-of select="./reqQuantity" /> : <xsl:value-of select="./reqQuantity/@unitOfMeasure" />
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
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="closeRqmts">
		<xsl:apply-templates />
	</xsl:template>
				  

	<xsl:template match="safetyRqmts">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="supeqli|sparesli|supplyli">
		<xsl:call-template name="part_table"/>
	</xsl:template>

	<xsl:template match="supequi|supply|spare">
		<tr>
			<a name="{@id}"><xsl:apply-templates/></a>
		</tr>
	</xsl:template>
	
	<xsl:template match="nsn">
		<td valign="top">
			<xsl:value-of select="@nsn"/>
		</td>
	</xsl:template>

	<xsl:template match="mfc[not(ancestor::dfault)]|mfc[not(ancestor::ifault)]|mfc[not(ancestor::ofault)]|pnr[not(ancestor::ifault)]|pnr[not(ancestor::dfault)]|pnr[not(ancestor::ofault)]|serialno">
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
			    <br/><xsl:value-of select="following-sibling::remarks"/>
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
			<xsl:when test="parent::supequi|parent::spare|parent::supply|preceding-sibling::applic|parent::lru[not(ancestor::dfault|ancestor::ifault|ancestor::ofault)]|preceding-sibling::supply[not(parent::supplyli[child::applic])]">
				<td valign="top">
					<xsl:apply-templates/>
				</td>
			</xsl:when>
			<xsl:when test="parent::lru[(ancestor::dfault)]|parent::lru[(ancestor::ifault)]|parent::lru[(ancestor::ofault)]">
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

	<xsl:template match="warning|caution">
		<xsl:choose>
			<xsl:when test="ancestor::step1|ancestor::step2|ancestor::step3|ancestor::step4|ancestor::step5">
				<xsl:call-template name="createAttention"/>
			</xsl:when>
			<xsl:otherwise>
				<td colspan="2">
					<xsl:call-template name="createAttention"/>
				</td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
<!-- Fotnote implemented as mouseover function -->
	<xsl:template match="ftnote">
		<a class="ftnote">
		<xsl:attribute name="title">
			<xsl:value-of select="text()"/>
		</xsl:attribute>
		(*)&#160;</a>
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
		(*)&#160;</a>
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
    <xsl:choose>
      <xsl:when test="ancestor::lcQuestion">
        <div class="question">
          <p><xsl:value-of select="."/></p>
        </div>
      </xsl:when>
      <xsl:when test="ancestor::lcAnswerOptionContent">
        <p><xsl:value-of select="."/></p>
      </xsl:when>
      <xsl:when test="ancestor::lcFeedbackIncorrect">
        <p><xsl:value-of select="."/></p>
      </xsl:when>
      <xsl:when test="ancestor::lcFeedbackCorrect">
        <p><xsl:value-of select="."/></p>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:apply-templates/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
	</xsl:template>

	<xsl:template match="listItem/para">
		<xsl:apply-templates/>
	</xsl:template>

    <xsl:template match="levelledPara/title">
        <xsl:variable name="counter">
             <xsl:value-of select="count(preceding::levelledPara)+1"/>
        </xsl:variable>
        <h3>
            <xsl:value-of select="$counter"/>.
            <xsl:apply-templates/>
        </h3>
    </xsl:template>

	<xsl:template match="levelledPara">

			<xsl:variable name="para_id">
				<xsl:value-of select="./@id"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="para_id=''">
					<xsl:apply-templates />
				</xsl:when>
				<xsl:otherwise>
				<div id="{$para_id}">
					<xsl:apply-templates />
				</div>
				</xsl:otherwise>
			<!-- </xsl:choose>
			</xsl:otherwise>-->
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="title">
        <xsl:variable name="counter">
             <xsl:value-of select="count(preceding::internalRef[@internalRefTargetType='irtt01'])"/>
        </xsl:variable>
		<xsl:choose>
			<xsl:when test="parent::figure">
                <xsl:variable name="fig_id">
                    <xsl:value-of select="../@id"/>
                </xsl:variable>
				<div align="center">
					<p class ="imageTitle" id="{$fig_id}">Fig <xsl:value-of select="$counter" /><xsl:text> </xsl:text><xsl:apply-templates/></p>
				</div>
			</xsl:when>
			<xsl:when test="parent::learningAssessment | parent::learningContent | parent::learningSummary | parent::learningOverview">
				<div align="center">
					<p class ="branchTitle" >
						<xsl:apply-templates/>
					</p>
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="emphasis">
		<xsl:choose>
			<xsl:when test="@emph = 'em01'"><!-- bold -->
				<strong><xsl:apply-templates/>&#160;</strong>
			</xsl:when>
			<xsl:when test="@emph = 'em02'"><!-- italic -->
				<i><xsl:apply-templates/>&#160;</i>
			</xsl:when>
			<xsl:when test="@emph = 'em03'"><!-- underline -->
				<u><xsl:apply-templates/>&#160;</u>
			</xsl:when>
			<xsl:otherwise><!-- bold -->
				<strong><xsl:apply-templates/>&#160;</strong>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- call templates -->
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

<!-- Added support for remarks in supplies, spares and support equipment -->
	<xsl:template name="generalTblHeader">
		<xsl:param name="label"/>
		<th style='border-top:none;border-left:none;border-bottom:solid black 0.75pt;
			border-right:none;'>
			<xsl:value-of select="$label"/>
			<xsl:if test="descendant::remarks">
				<br/><xsl:value-of select="$remarks_text"/>
</xsl:if>
		</th>
	</xsl:template>

	<xsl:template name="createNote">
		<p>
			<table  width="100%"  class="note_line" >
				<tr>
					<td>
						<font class="note_text"><strong><xsl:value-of select="$note_text"/></strong></font>
					</td>
				</tr>
				<tr>
					<td><font class="indentMarginLeft"><xsl:apply-templates/></font>
					</td>
				</tr>
			</table>
		</p>
	</xsl:template>

	<xsl:template name="createAttention">
		<xsl:variable name="type">
			<xsl:choose>
				<xsl:when test="self::warning">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="title">
			<xsl:choose>
				<xsl:when test="$type='true'">
					<xsl:choose>
						<xsl:when test="@type = 'danger'">
							<xsl:value-of select="$danger_text"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$warning_text"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$caution_text"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="$type='true'">red</xsl:when>
				<xsl:otherwise>blue</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<table border="1" width="100%" cellspacing="0" class="noteandwarning">
			<xsl:attribute name="bordercolor">
				<xsl:choose>
					<xsl:when test="$color='red'">red</xsl:when>
					<xsl:otherwise>black</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<tr>
				<td align="center">
					<xsl:attribute name="style">
						<xsl:choose>
							<xsl:when test="$color='red'">background-color:red</xsl:when>
							<xsl:otherwise>background-color:yellow</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<strong>
						<xsl:attribute name="style">
							<xsl:choose>
									<xsl:when test="$color='red'">color:white</xsl:when>
									<xsl:otherwise>color:black</xsl:otherwise>
								</xsl:choose>
						</xsl:attribute>
						<xsl:value-of select="$title"/>
					</strong>
				</td>
			</tr>
			<tr><td><strong><xsl:apply-templates/></strong></td></tr>
		</table>
	</xsl:template>

	<xsl:template match="subscrpt">
		<sub><xsl:apply-templates/></sub>
	</xsl:template>

	<xsl:template match="supscrpt">
		<sup><xsl:apply-templates/></sup>
	</xsl:template>

	<xsl:template name="getUrnTarget">
		<xsl:param name="urn"/>
		<xsl:param name="linkType"/>
		<xsl:choose>
			<xsl:when test="$external_urn_resolver='enabled'">
				<xsl:value-of select="$external_resource_url_prefix"/><xsl:value-of select="$urn"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$document_resource_url_prefix"/><xsl:value-of select="document($urn_resource_file)//urn[@name=$urn]/target[@type=$linkType]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>

  