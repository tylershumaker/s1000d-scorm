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
	    	<div class="knowledgeCheckHeader"><xsl:value-of select="//title/." /></div>
	    	<div class="fancySmallLine fancySmallLineGradient" />
	    	<div class="fancyLine fancyLineGradient" />
			<xsl:choose>
				<xsl:when test="//title/.='Knowledge Check'">
					<form name="answerOptionsForm" class="answerOptionsForm">
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
												shuffle($("#questionNumber" + <xsl:value-of select="$position"/>).find( "tr" ));
											});
										</script>
										<input type="submit" class="checkButton" value="Next" onClick="javascript:checkSortableCorrect(document.forms['answerOptionsForm{$position}'], '{$quizType}'); return false;"/>
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

							</div>
						</form>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			<div id="grade">
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
		    	<xsl:value-of select="lcAnswerOptionContent/description/para/."/>
		    </xsl:variable>
		    <xsl:variable name="correct">
		    	<xsl:if test="lcCorrectResponse">
		    		<xsl:value-of select="$id"/>
		    	</xsl:if>
		    </xsl:variable>
		    <xsl:choose>
				<xsl:when test="ancestor::lcSingleSelect or ancestor::lcTrueFalse">
					<div class="radioButtonClass">
					    <input type="radio" id="{$id}" name="answerChoiceRadio" value="{$id}, {$correct}"/>
					    <label for="{$id}"><xsl:value-of select="lcAnswerOptionContent/description/para/."/></label>
		    		</div>
		    		<br />
				 </xsl:when>
				 <xsl:when test="ancestor::lcMultipleSelect">
				 	<div class="checkboxClass">
			    		<input type="checkbox" id="{$id}" name="answerChoiceCheckbox" value="{$id}, {$correct}"/>
			    		<label for="{$id}"><xsl:value-of select="lcAnswerOptionContent/description/para/."/></label>
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
   	<ul>			  
   		<table class="sortListDiv">		
   			<xsl:apply-templates/>
   		</table>			    	
    </ul>
	    <!-- <input type="submit" class="checkButton" value="Check" onClick="javascript:checkSortableCorrect(document.forms['sequenceForm'], '{$count}'); return false;"/> -->
  </xsl:template>
  
   <xsl:template match="lcSequenceOption">
   	 <xsl:variable name="id">
  		<xsl:value-of select="lcSequence/@lcValue"/>
	 </xsl:variable>
	 <!-- I had to do some math here to make the position show up as 1, 2, 3...but this might change depending on the problem -->
	 <xsl:variable name="position">
  		<xsl:value-of select="position() div 2"/>
	 </xsl:variable>
	 <xsl:variable name="count">
  		<xsl:value-of select="count(../*)"/>
	 </xsl:variable>
     <!-- <table class="sortListDiv"> -->
 		<tr>
 		<td><input type="text" name="order" id="{$id}" class="orderInput" maxlength="2" onKeyUp="javascript:validateInput(this.value, '{$count}')"/></td>
 		<td><label class="orderLabel"><xsl:apply-templates select="lcAnswerOptionContent/description/para/."/></label></td>
 		</tr>
     <!-- </table> -->
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
