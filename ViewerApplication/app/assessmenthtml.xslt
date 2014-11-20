<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://www.purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">

    <xsl:variable name="lcInteractionIdArray">
    	<xsl:for-each select="//dmodule/content/learning/learningAssessment/lcInteraction">
			<xsl:value-of select="@id"/>
    	</xsl:for-each>
    </xsl:variable>

  	<xsl:template name="assessment" match="learningAssessment">
  	  	<xsl:variable name="quizType">
			<xsl:value-of select="//title/."/>
  		</xsl:variable>
  		<div class="content">
  			<div class="header">
		    	<!-- <h1 class="knowledgeCheckHeader"><xsl:value-of select="//title/." /></h1> -->
		    	<div class="knowledgeCheckHeader"><xsl:value-of select="//title/." /></div>
		    	<div class="fancySmallLine fancySmallLineGradient" />
		    	<div class="fancyLine fancyLineGradient" />
		    </div>
			<xsl:choose>
				<xsl:when test="//title/.='Knowledge Check'">
					<form name="answerOptionsForm">
					    <ol>
							<xsl:apply-templates select="lcInteraction" />
					    </ol>
				    </form>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="lcInteraction">
						<xsl:variable name="position">
							<xsl:value-of select="position()"/>
						</xsl:variable>
						<xsl:variable name="count">
							<xsl:value-of select="count(//lcInteraction)"/>
						</xsl:variable>
						<form name="answerOptionsForm{$position}">
							<div class="questionNumber" id="questionNumber{$position}">
								<p class="questionCount">Question <xsl:value-of select="$position"/> of <xsl:value-of select="$count"/></p><br/>
								<ol>
									<xsl:apply-templates/>
									<xsl:for-each select="lcSingleSelect">
										<input type="submit" class="checkButton" value="Next" onClick="javascript:checkIfSingleTrue(document.forms['answerOptionsForm{$position}'], '{$quizType}'); return false;"/>
									</xsl:for-each>
									<xsl:for-each select="lcTrueFalse">
										<input type="submit" class="checkButton" value="Next" onClick="javascript:checkIfSingleTrue(document.forms['answerOptionsForm{$position}'], '{$quizType}'); return false;"/>
									</xsl:for-each>
									<xsl:for-each select="lcMultipleSelect">
										<input type="submit" class="checkButton" value="Next" onClick="javascript:checkIfMultipleTrue(document.forms['answerOptionsForm{$position}'], '{$quizType}'); return false;"/>
									</xsl:for-each>
									<xsl:for-each select="lcSequencing">
										<script type="text/javascript">
											$(function()
											{
												shuffle($("#questionNumber" + <xsl:value-of select="$position"/>).find( "li" ));
											});
										</script>
										<input type="submit" class="checkButton" value="Next" onClick="javascript:checkSortableCorrect({$position}); return false;"/>
									</xsl:for-each>
									<xsl:for-each select="lcHotspot">
										<!-- <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
											codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0"
											WIDTH="745"
											HEIGHT="600" id="col_master.swf">
											<param NAME="movie" VALUE="Assessment_templates/Hotspot.swf" />
											<param NAME="FlashVars" VALUE="theFileName={$global_dmc}" />
											<param NAME="quality" VALUE="high"/>
											<param NAME="bgcolor" VALUE="#FFFFFF" />
										</object> -->
									</xsl:for-each>
								</ol>
							</div>
						</form>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			<div id="grade">
			</div>
		</div>
    </xsl:template>
    
	<xsl:template match="lcInteraction">
		<xsl:if test="position()=1">
			<xsl:apply-templates />
		</xsl:if>
	</xsl:template>
	
	  <xsl:template match="lcTrueFalse">
    <xsl:apply-templates />
  </xsl:template>
  
  <xsl:template match="lcMultipleSelect">
    <xsl:apply-templates />
  </xsl:template>
  
  <xsl:template match="lcSingleSelect">
    <xsl:apply-templates />
  </xsl:template>
  
  <xsl:template match="lcSequencing">
      <xsl:apply-templates />
  </xsl:template>
  
  <xsl:template match="lcQuestion">
    <xsl:apply-templates />
  </xsl:template>
  
<xsl:template match="lcAnswerOptionGroup">
  	<xsl:variable name="quizType">
		<xsl:value-of select="//title/."/>
  	</xsl:variable>
    <div class="answerList">
	    <ul>
	  	<xsl:for-each select="lcAnswerOption">
			<xsl:variable name="id">
		    	<xsl:value-of select="position()"/>
		    </xsl:variable>
		    <xsl:variable name="correct">
		    	<xsl:if test="lcCorrectResponse">
		    		<!-- <xsl:value-of select="$id"/> -->
                    <xsl:value-of select="//@lcValue"/>
		    	</xsl:if>
		    </xsl:variable>
		    <xsl:choose>
				<xsl:when test="ancestor::lcSingleSelect or ancestor::lcTrueFalse">
					<div class="radioButtonClass">
					    <input type="radio" id="{$id}" name="answerChoiceRadio" value="{$id}, {$correct}"/>
			  	 	 		<label for="answerChoiceRadio"><xsl:value-of select="normalize-space(lcAnswerOptionContent/description/para/.)"/></label>
			    		<!-- </input> -->
		    		</div>
		    		<br />
				 </xsl:when>
				 <xsl:when test="ancestor::lcMultipleSelect">
				 	<div class="checkboxClass">
			    		<input type="checkbox" id="{$id}" name="answerChoiceCheckbox" value="{$id}, {$correct}"/>
			  	 	 		<label for="answerChoiceCheckbox"><xsl:value-of select="normalize-space(lcAnswerOptionContent/description/para/.)"/></label>
			    		<!-- </input> -->
		    		</div>
		    		<br />
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
		<xsl:choose>
	 		<xsl:when test="//title/.='Knowledge Check'">
				<xsl:choose>
					<xsl:when test="ancestor::lcMultipleSelect">
						<input type="submit" class="checkButton" value="Check" onClick="javascript:checkIfMultipleTrue(document.forms['answerOptionsForm'], '{$quizType}'); return false;"/>
					</xsl:when>
			 		<xsl:when test="ancestor::lcSingleSelect or ancestor::lcTrueFalse">
						<input type="submit" class="checkButton" value="Check" onClick="javascript:checkIfSingleTrue(document.forms['answerOptionsForm'], '{$quizType}'); return false;"/>
					</xsl:when>
<!--  					<xsl:when test="'//lcMatchingPair'">
						<input type="submit" class="checkButton" value="Check" onClick="javascript:checkIfMatchingTrue(document.forms['answerOptionsForm'], '{$quizType}'); return false;"/>
					</xsl:when> -->
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	    </ul>
    </div>
    <br />
    <br />
  </xsl:template>
  
  <xsl:template match="lcFeedbackIncorrect">
  	<div id="feedbackIncorrect">
  		<div class="line"/>
  	  	<xsl:apply-templates />
  		<div class="line"/>
  	</div>
  </xsl:template>

  <xsl:template match="lcFeedbackCorrect">
    <div id="feedbackCorrect">
    	<div class="line"/>
  	  	<xsl:apply-templates />
  		<div class="line"/>
  	</div>
  </xsl:template>
  
  <xsl:template match="lcAnswerOption">
        <li>
          <xsl:apply-templates />
        </li>
  </xsl:template>

  <xsl:template match="lcAnswerOptionContent">
	  <xsl:variable name="id">
	  	<xsl:value-of select="description/para/."/>
	  </xsl:variable>
	  <xsl:apply-templates/>
  </xsl:template>
    
  <xsl:template match="lcSequenceOptionGroup">
    <script>
   		$(function()
		{
			$( ".sortable" ).sortable();
			$( ".sortable" ).disableSelection();
		});
	</script>
    <ol class="seqAnswerList">
    	<ul class="sortable">
      		<xsl:apply-templates />
      	</ul>
    </ol>
    <br />
    <br />
  </xsl:template>
  
  <xsl:template match="lcSequenceOption">
  	<xsl:variable name="id">
  		<xsl:value-of select="lcSequence/@lcValue"/>
  	</xsl:variable>
   	<!-- <xsl:apply-templates /> -->
    <li id="{$id}" class="correct ui-state-default">
      <span class="ui-icon ui-icon-arrowthick-2-n-s"/>
      <xsl:value-of select="lcAnswerOptionContent/description/para/."/>
    </li>
  </xsl:template>
  
  <xsl:template match="lcMatchTable">
  	<xsl:variable name="count">
 		<xsl:value-of select="count(lcMatchingPair)"/>
	</xsl:variable>
	<!-- NOTE:  This most likely will NOT work in assessments...would need to go be question number or something -->
	<form name="matchingPairForm">
		<div id="matchingQuestion">
		    <ul>
		      <xsl:apply-templates />
		    </ul>
			<script type="text/javascript">
				$(function()
				{
					shuffle($("#matchingQuestion").find( "li" ));
				});
			</script>
		</div>
	    <input type="submit" class="checkButton" value="Check" onClick="javascript:checkIfMatchingTrue(document.forms['matchingPairForm'], '{$count}'); return false;"/>
    </form>
  </xsl:template>
  
  <xsl:template match="lcMatchingPair">
	<!-- I had to do some math here to make the position show up as 1, 2, 3...but this might change depending on the problem -->
  	<xsl:variable name="matchPosition">
		<xsl:value-of select="position() - 1"/>
	</xsl:variable>
	<xsl:variable name="correctAnswer">
		<xsl:value-of select="./lcMatchingItem/description/para"/>
	</xsl:variable>
    <p>
	    <li class="answerList" >
  	     	<xsl:value-of select="./lcItem/description/para"/>
		    <select name="{$correctAnswer}" id="matchChoice{$matchPosition}">
			    <xsl:for-each select="//lcMatchTable/lcMatchingPair/lcMatchingItem">
			    	<option><xsl:value-of select="./description/para"/></option>
			    </xsl:for-each>
		    </select>
	    </li>
    </p>
  </xsl:template>
  
  
</xsl:stylesheet>
