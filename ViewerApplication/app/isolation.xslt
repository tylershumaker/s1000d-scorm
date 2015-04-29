<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://www.purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
	<xsl:template match="faultDescr">
        <h5>
            <xsl:value-of select="./descr"/>
        </h5>
	</xsl:template>
	
    <xsl:template match="isolationStep">
        <xsl:variable name="stepCounter">
             <xsl:value-of select="count(preceding::isolationStep)+1"/>
        </xsl:variable>
        <xsl:variable name="step_id" select="./@id"/>
        <xsl:variable name="yesRefId" select="./isolationStepAnswer/yesNoAnswer/yesAnswer/@nextActionRefId"/>
        <xsl:variable name="noRefId" select="./isolationStepAnswer/yesNoAnswer/noAnswer/@nextActionRefId"/>
<!--  <p>SET_StepCounter: <xsl:value-of select="$stepCounter" /></p> 
<p>SET_step_id: <xsl:value-of select="$step_id" /></p>
<p>SET-yesRefId: <xsl:value-of select="$yesRefId" /></p>
<p>SET-noRefId: <xsl:value-of select="$noRefId" /> </p>-->        
        <xsl:choose>
            <xsl:when test="$stepCounter = 1">
                <div id="{$step_id}" style="display: block;">
                    Step <xsl:value-of select="$stepCounter" />
                    <br></br>
                    <xsl:text> </xsl:text>
                    <xsl:for-each select="./action">
<!-- <p>SET-found a action child element</p>-->
                        <xsl:choose>
                            <xsl:when test="./internalRef">
<!-- <p>SET-found a internalRef child element</p>-->
                                <xsl:apply-templates />
                            </xsl:when>
                            <xsl:otherwise>
                      <!--            <xsl:value-of select="text()"/><br/>-->
                                <xsl:apply-templates /><br/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <br/>
                    <xsl:if test="./isolationStepQuestion">
                        <div>
                            <xsl:value-of select="./isolationStepQuestion"/><br/>
                            <a href="#{$yesRefId}" onclick="show_hide_div('{$step_id}','{$yesRefId}')">Yes</a><br/>
                            <a href="#{$noRefId}" onclick="show_hide_div('{$step_id}','{$noRefId}')">No</a><br/>
                        </div>
                    </xsl:if>
                </div>                
            </xsl:when>
            <xsl:otherwise>
                <div id="{$step_id}" style="display: none;">
                    <xsl:if test="*">
                        Step <xsl:value-of select="$stepCounter" />
                        <br></br>
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="./action">
                            <xsl:choose>
                                <xsl:when test="./internalRef">
                                    <xsl:apply-templates />
                                </xsl:when>
                                <xsl:otherwise>
                      <!--               <xsl:value-of select="text()"/><br/> -->
                                    <xsl:apply-templates /><br/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                        <br/>
                        <xsl:if test="./isolationStepQuestion">
                            <div>
                                <xsl:value-of select="./isolationStepQuestion"/><br/>
                                <a href="#{$yesRefId}" onclick="show_hide_div('{$step_id}','{$yesRefId}')">Yes</a><br/>
                                <a href="#{$noRefId}" onclick="show_hide_div('{$step_id}','{$noRefId}')">No</a><br/>
                            </div>
                        </xsl:if>
                    </xsl:if>
                </div>
            </xsl:otherwise>
        </xsl:choose>
     </xsl:template>
     
     <xsl:template match="isolationProcedureEnd">
         <xsl:variable name="stepCounter">
            <xsl:value-of select="count(preceding::isolationStep)+1"/>
         </xsl:variable>
         <xsl:variable name="isProcEnd_id" select="./@id"/>
         <div id="{$isProcEnd_id}" style="display: none;">
            Step <xsl:value-of select="$stepCounter" />
            <xsl:text> </xsl:text>
            <xsl:for-each select="./action">
                <xsl:choose>
                    <xsl:when test="./internalRef">
                        <xsl:apply-templates />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="text()"/><br/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
         </div>
     </xsl:template>
     
     <xsl:template match="proceduralStep">
                
        <!--  NEW CODE ADDED FOR Phase 2 - ISSUE 27 -->
        <xsl:choose>
           <!--  See if there is a child <proceduralStep> for the <proceduralStep> element being processed -->
           <xsl:when test="child::proceduralStep">
              <!-- Count the preceding siblings <proceduralStep> elements to determine the Step number -->
              <xsl:variable name="stepCounter" select="count(preceding-sibling::proceduralStep)+1" />
              
              <!-- Select the current step_id -->
              <!-- <xsl:variable name="step_id" select="./@id" />-->
              <xsl:variable name="step_id">
                 <xsl:value-of select="@id"></xsl:value-of>
              </xsl:variable>
              
              <!-- Since there is a child <proceduralStep> element, must get the child's id for the next reference id -->              
              <!--  <xsl:variable name="nextRefId" select="child::proceduralStep/@id" />--> 
              <xsl:variable name="nextRefId">
                 <xsl:value-of select="child::proceduralStep[1]/@id"/>
              </xsl:variable>
              <!-- For output (block vs. none), need to determine if this is the first <proceduralStep> -->
              <xsl:choose>
                 <!-- If first <proceduralStep>, stepCounter will = 1, display: block -->
                 <xsl:when test="$stepCounter = 1">
                    <div id="{$step_id}" style="display: block;">	
                       Step <xsl:value-of select="$stepCounter" />
                       <xsl:text> </xsl:text>
                       <xsl:apply-templates /> 
                       <br/>
                       <div>
                          <a href="#{$nextRefId}" onclick="show_hide_div('{$step_id}','{$nextRefId}')">Next</a><br/>
                       </div>
                    </div>                
                 </xsl:when>
                 <xsl:otherwise>
                    <!-- otherwise, this is not the first <proceduralStep>, hide the <div> tag by setting display : none -->
                    <div id="{$step_id}" style="display: none;">
                       Step <xsl:value-of select="$stepCounter" />
                       <xsl:text> </xsl:text>
                       <xsl:apply-templates select ="para | note | table" />
                       <br />
                       <div>
                          <a href="#{$nextRefId}" onclick="show_hide_div('{$step_id}','{$nextRefId}')">Next</a>
                          <br/> 
                       </div>
                     </div>
   
                     <xsl:apply-templates select="proceduralStep" />
                  
                  </xsl:otherwise>
              </xsl:choose>
           </xsl:when>
           <xsl:otherwise>
              <!-- <proceduralStep> element does not have any nested <proceduralStep> elements  -->
              
              <!-- Count the number of preceding <proceduralStep> elements  -->
              <xsl:variable name="stepCounter" select="count(preceding-sibling::proceduralStep)+1"/> 
              
              <xsl:variable name="step_id">
                 <xsl:value-of select="@id"></xsl:value-of>
              </xsl:variable>
              <!-- Get the current <proceduralStep> element's id  -->                     
              <!-- <xsl:variable name="step_id" select="./@id"/>-->
              
              <!-- Since the current <proceduralStep> does not have any children, get the following <proceduralStep> sibling id -->
              <!-- <xsl:variable name="nextRefId" select="following-sibling::proceduralStep[1]/@id"/>-->
              <xsl:variable name="nextRefId">
                 <xsl:value-of select="following-sibling::proceduralStep[1]/@id"/>
              </xsl:variable>
              <xsl:choose>
                 <!-- Must check to see if the $nextRefId is empty (end of a nested child list or end of main proceduralStep list  -->
                 <xsl:when test="$nextRefId !=''">
                    <xsl:choose>
                       <!-- If this is the first <proceduralStep> element create the <div>  -->
                       <xsl:when test="$stepCounter = 1">
                 
                          <!-- first time encountering a step, check to see if it is the first nested <proceduralStep> -->
                          <xsl:choose>
                             <xsl:when test="parent::proceduralStep">                         
                                <xsl:variable name="parentCount"> 
                                   <xsl:value-of select="count(parent::node()/preceding-sibling::proceduralStep)+1" />
                                </xsl:variable>
                             
                                <xsl:variable name="tempCount" select="concat($parentCount,'.')" />   
                                <xsl:variable name="finalCount" select="concat($tempCount,$stepCounter)" />
                          
                                <div id="{$step_id}" style="display: none;">
                                   Step <xsl:value-of select="$finalCount" />
                                   <xsl:text> </xsl:text>
                                   <xsl:apply-templates select ="para | note | table | figure" />
                                   <br/>
                                
                                   <div>
                                      <a href="#{$nextRefId}" onclick="show_hide_div('{$step_id}','{$nextRefId}')">Next</a><br/>
                                   </div>
                                </div> 
                                <xsl:apply-templates select="proceduralStep" />                
                             </xsl:when>
                             <xsl:otherwise>                             
                                <div id="{$step_id}" style="display: block;">
                                   Step <xsl:value-of select="$stepCounter" />
                                   <xsl:text> </xsl:text>
                                   <xsl:apply-templates select ="para | note | table | figure" />
                      
                                   <br/>
                             
                                   <div>
                                      <a href="#{$nextRefId}" onclick="show_hide_div('{$step_id}','{$nextRefId}')">Next</a><br/>
                                   </div>
                                </div>
                             </xsl:otherwise>
                          </xsl:choose>             
                       </xsl:when>
                       <xsl:otherwise>
                          <xsl:choose>
                             <xsl:when test = "parent::proceduralStep" >
                                <xsl:variable name="parentCount"> 
                                   <xsl:value-of select="count(parent::node()/preceding-sibling::proceduralStep)+1" />
                                </xsl:variable>
                             
                                <xsl:variable name="tempCount" select="concat($parentCount,'.')" />   
                                <xsl:variable name="finalCount" select="concat($tempCount,$stepCounter)" />
                    
                                <div id="{$step_id}" style="display: none;">
                                   Step <xsl:value-of select="$finalCount" />
                                   <xsl:text> </xsl:text>
                                   <xsl:apply-templates select ="para | note | table | figure" />
                                   <br/>
                                   <div>
                                      <a href="#{$nextRefId}" onclick="show_hide_div('{$step_id}','{$nextRefId}')">Next</a><br/>
                                   </div>
                                </div>
                             </xsl:when>
                             <xsl:otherwise>
                                <div id="{$step_id}" style="display: none;">
                                   Step <xsl:value-of select="$stepCounter" />
                                   <xsl:text> </xsl:text>
                                   <xsl:apply-templates select ="para | note | table | figure" />
                                   <br/>
                                   <div>
                                      <a href="#{$nextRefId}" onclick="show_hide_div('{$step_id}','{$nextRefId}')">Next</a><br/>
                                   </div> 
                                </div>   
                             </xsl:otherwise>
                          </xsl:choose>
                          
                       </xsl:otherwise>
                    </xsl:choose>      
                 </xsl:when>
                 <xsl:otherwise>
                    <!-- Last element of a nested procedureStep -->

                    <!--  Check to see if my parent <procedureStep> element has a sibling <proceduralStep> element -->
                    <!--   <xsl:apply-templates />-->
                    <xsl:choose>
                       <xsl:when test="../following-sibling::*[position()=1][name()='proceduralStep']">
                          <xsl:variable name="nextElementNode" select="parent::node()/following-sibling::proceduralStep/@id" />
                          <xsl:variable name="parentCount"> 
                             <xsl:value-of select="count(parent::node()/preceding-sibling::proceduralStep)+1" />
                          </xsl:variable>
                             
                          <xsl:variable name="tempCount" select="concat($parentCount,'.')" />   
                          <xsl:variable name="finalCount" select="concat($tempCount,$stepCounter)" />
                    
                          <div id="{$step_id}" style="display: none;">
                             Step <xsl:value-of select="$finalCount" />
                             <xsl:text> </xsl:text>
                             <xsl:apply-templates select ="para | note | table | figure" />
                             <br/>
                             <div>
                                <a href="#{$nextElementNode}" onclick="show_hide_div('{$step_id}','{$nextElementNode}')">Next</a><br/>
                             </div>
                          </div>
                       </xsl:when>
                       <xsl:otherwise>
                          <div id="{$step_id}" style="display: none;">
                             Step <xsl:value-of select="$stepCounter" />
                             <xsl:text> </xsl:text>
                             <xsl:apply-templates select ="para | note | table | figure" />
                             <br/>
                          </div>
                       </xsl:otherwise>
                    </xsl:choose>
                    
                 </xsl:otherwise> 
                 </xsl:choose>  
              </xsl:otherwise>
           </xsl:choose>                     
     </xsl:template>
</xsl:stylesheet>