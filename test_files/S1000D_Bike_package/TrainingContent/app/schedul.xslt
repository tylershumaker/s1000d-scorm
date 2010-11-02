<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
	File:    schedule.xslt
	Version: 2005-07-18

	Part of S1000D xslt/css baseline stylesheets

	This file constitutes one part of a set of xslt/css stylesheets for 
	rendering of information complying to 
	S1000D Issue 2.2 XML Neutral Repository Format.
    
	Copyright (C) 2005  Swedish Defence Material Administration

	The stylesheets are free resources; you can redistribute them and/or modify
	them under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	The stylesheets are distributed in the hope that they will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this file; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

	The stylesheets have been developed by Sörman Information & Media on 
	behalf of the copyright holder. Questions and comments should be directed to
	svante.ericsson@sorman.se and/or EPWG Chairman/Co-chairmen (see www.s1000d.org).
    

	Revisions:									
	Date    Author		Code/ref	Description	

-->


    <xsl:template match="schedule">
        <xsl:choose>
            <xsl:when test="child::deftask">
                <h3>
                    <xsl:value-of select="$task_def_title"/>
                </h3>
                <table border="0" width="100%" class="lineTopAndBottom" cellspacing="0" cellpadding="3">
                    <tr>
                        <xsl:call-template name="generalTblHeader">
                            <xsl:with-param name="label" select="'No'"/>
                        </xsl:call-template>
                        <xsl:call-template name="generalTblHeader">
                            <xsl:with-param name="label" select="'Name'"/>
                        </xsl:call-template>
                        <xsl:call-template name="generalTblHeader">
                            <xsl:with-param name="label" select="'Equip'"/>
                        </xsl:call-template>
                        <xsl:call-template name="generalTblHeader">
                            <xsl:with-param name="label" select="'Time limit'"/>
                        </xsl:call-template>
                        <xsl:call-template name="generalTblHeader">
                            <xsl:with-param name="label" select="'Applicability'"/>
                        </xsl:call-template>
                    </tr>
                    <xsl:apply-templates/>
                </table>
            </xsl:when>
            <xsl:when test="child::timelim">
                <table border="0" width="100%" class="lineTopAndBottom" cellspacing="0" cellpadding="3">
                    <tr>
                        <xsl:call-template name="generalTblHeader">
                            <xsl:with-param name="label" select="'No'"/>
                        </xsl:call-template>
                        <xsl:call-template name="generalTblHeader">
                            <xsl:with-param name="label" select="'Equip'"/>
                        </xsl:call-template>
                        <xsl:call-template name="generalTblHeader">
                            <xsl:with-param name="label" select="$qty_text"/>
                        </xsl:call-template>
                        <xsl:call-template name="generalTblHeader">
                            <xsl:with-param name="label" select="'Time limit'"/>
                        </xsl:call-template>
                        <xsl:call-template name="generalTblHeader">
                            <xsl:with-param name="label" select="'Applicability'"/>
                        </xsl:call-template>
                    </tr>
                    <xsl:apply-templates/>
                </table>
            </xsl:when>
            <xsl:when test="definspec">
                <xsl:apply-templates/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="timelim">
        <tr>
            <td>
                <xsl:value-of select="@identifier"/>
            </td>
            <td>
                <xsl:apply-templates select="equip"/>
            </td>
            <td align="center">
                <xsl:apply-templates select="qty"/>
            </td>
            <td nowrap="">
                <xsl:apply-templates select="timelimit"/>
            </td>
            <td>
                <xsl:apply-templates select="applic"/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="deftask">
        <tr>
            <td>
                <xsl:value-of select="@taskid"/>&#160;(<xsl:value-of select="@airworthlim"/>)<br/>
				<xsl:value-of select="$reduced_maintaince"/>:&#160;<xsl:value-of select="@reducem"/><br/>
				<xsl:if test="@skill">
						<xsl:value-of select="$req_skill_lev"/>:&#160;<xsl:value-of select="@skill"/><br/>
				</xsl:if>
				<a href="javascript:void(toggleLayer('{@taskid}'));">prelreqs/refs</a>
			</td>
            <td>
                <xsl:apply-templates select="child::task"/>
            </td>
            <td nowrap="">
                <xsl:apply-templates select="child::equip"/>
            </td>
            <td nowrap="">
                <xsl:apply-templates select="child::limit"/>
            </td>
            <td>
                <xsl:apply-templates select="child::applic"/>
            </td>
        </tr>
        <tr>
            <td colspan="5">
                <div id="{@taskid}" style="display:none">
                    <table border="0" width="100%" cellspacing="0" cellpadding="5">
                        <tr>
                            <td width="100%">
                                <table border="0" width="100%" cellspacing="0" cellpadding="5">
                                    <tr>
                                        <td width="100%" class="metadataPane" colspan="2">
                                            <xsl:apply-templates select="child::prelreqs"/>
                                            <xsl:apply-templates select="refs"/>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </xsl:template>
    
    <xsl:template match="task">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!--EQUIPMENT-->
    <xsl:template match="deftask/equip|timelim/equip">
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td nowrap="">
                    <xsl:apply-templates/>
                </td>
            </tr>
        </table>
    </xsl:template>
    
    <xsl:template match="deftask/equip/nomen|timelim/equip/nomen">
		Name: <xsl:apply-templates/><br/>
	</xsl:template>
	
    <xsl:template match="deftask/equip/nsn|timelim/equip/nsn">
		National stock number: <xsl:apply-templates/>
	</xsl:template>
	
    <xsl:template match="deftask/equip/identno/mfc|timelim/equip/identno/mfc">
		Manufacturer: <xsl:apply-templates/><br/>
	</xsl:template>
	
    <xsl:template match="deftask/equip/identno/pnr|timelim/equip/identno/pnr">
		Part number: <xsl:apply-templates/>
	</xsl:template>
	
    <xsl:template match="deftask/equip/identno/serialno|/equip/identno/serialno">
        <br/>Serial number: 
		<xsl:choose>
            <xsl:when test="singel">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="range">from <xsl:value-of select="range/@from"/> to <xsl:value-of select="range/@to"/></xsl:when>
        </xsl:choose>
	</xsl:template>
    <!--END EQUIPMENT-->
    
    <xsl:template match="definspec">
        <h4>
            <xsl:value-of select ="$definspec_title"/>
        </h4>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tasklist">
        <h4>
            <xsl:value-of select ="$tasklst_title"/>
        </h4>
        <table border="0" width="100%" class="lineTopAndBottom" cellspacing="0" cellpadding="3">
            <tr>
                <xsl:call-template name="generalTblHeader">
                    <xsl:with-param name="label" select="'No'"/>
                </xsl:call-template>
                <xsl:call-template name="generalTblHeader">
                    <xsl:with-param name="label" select="'Name'"/>
                </xsl:call-template>
                <xsl:if test="child::taskitem/refs">
                    <xsl:call-template name="generalTblHeader">
                        <xsl:with-param name="label" select="'Reference'"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="child::taskitem/task">
                    <xsl:call-template name="generalTblHeader">
                        <xsl:with-param name="label" select="'Task'"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="child::taskitem/applic">
                    <xsl:call-template name="generalTblHeader">
                        <xsl:with-param name="label" select="'Applicability'"/>
                    </xsl:call-template>
                </xsl:if>
            </tr>
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    
    <xsl:template match="taskitem">
        <tr>
            <td>
                <xsl:value-of select="@seqnum"/>
            </td>
            <td>
                <xsl:value-of select="@taskname"/>
            </td>
            <xsl:if test="child::refs">
                <td><xsl:apply-templates select="refs"/></td>
            </xsl:if>
            <xsl:if test="child::task">
                <td><xsl:apply-templates select="task"/></td>
            </xsl:if>
            <xsl:if test="child::applic">
                <td><xsl:apply-templates select="applic"/></td>
            </xsl:if>
        </tr>
    </xsl:template>
    
    <xsl:template match="timelimit">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="timelim/qty">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="limit">
        <xsl:if test="@condition">
            <xsl:value-of select="$condition_text"/>: <xsl:value-of select="@condition"/><br/>
	    </xsl:if>
        <xsl:if test="@typex">
            <xsl:value-of select="$typex_text"/>: <xsl:value-of select="@typex"/><br/>
	    </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="inspection/limit">
        <table border="0" width="100%" class="lineTopAndBottom" cellspacing="0" cellpadding="3">
            <tr>
                <xsl:if test="sampling">
                    <xsl:call-template name="generalTblHeader">
                        <xsl:with-param name="label" select="'Sampling'"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="threshold">
                    <xsl:call-template name="generalTblHeader">
                        <xsl:with-param name="label" select="'Threshold'"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="refinspec">
                    <xsl:call-template name="generalTblHeader">
                        <xsl:with-param name="label" select="'Reference inspection'"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="trigger">
                    <xsl:call-template name="generalTblHeader">
                        <xsl:with-param name="label" select="'Trigger'"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="limrange">
                    <xsl:call-template name="generalTblHeader">
                        <xsl:with-param name="label" select="'Limit range'"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="remarks">
                    <xsl:call-template name="generalTblHeader">
                        <xsl:with-param name="label" select="'Remarks'"/>
                    </xsl:call-template>
                </xsl:if>
            </tr>
            <tr>
                <xsl:if test="sampling">
                    <td><xsl:apply-templates select="sampling"/></td>
                </xsl:if>
                <xsl:if test="threshold">
                    <td nowrap=""><xsl:apply-templates select="threshold"/></td>
                </xsl:if>
                <xsl:if test="refinspec">
                    <td><xsl:apply-templates select="refinspec"/></td>
                </xsl:if>
                <xsl:if test="trigger">
                    <td><xsl:apply-templates select="trigger"/></td>
                </xsl:if>
                <xsl:if test="limrange">
                    <td nowrap=""><xsl:apply-templates select="limrange"/></td>
                </xsl:if>
                <xsl:if test="remarks">
                    <td><xsl:apply-templates select="remarks"/></td>
                </xsl:if>
            </tr>
        </table>
    </xsl:template>
    
    <xsl:template match="sampling">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="threshold">
        <xsl:value-of select="@uom"/> = <xsl:apply-templates/>
    </xsl:template>	
    
    <xsl:template match="value">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>
    
    <xsl:template match="limrange//threshold">
        <xsl:value-of select="@uom"/> = <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="limrange">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="from">
        <xsl:value-of select="$from_text"/>
        <br/>&#160;<xsl:apply-templates/>
	</xsl:template>
	
    <xsl:template match="to">
        <xsl:value-of select="$to_text"/>
        <br/>&#160;<xsl:apply-templates/> 
	</xsl:template>
	
    <xsl:template match="tolerance">
        <xsl:value-of select="$tolerance_text"/>: 
        <xsl:if test="@plus">
            +<xsl:value-of select="@plus"/>&#160;
        </xsl:if>
        <xsl:if test="@minus">
            -<xsl:value-of select="@minus"/>
        </xsl:if><br/>
	</xsl:template>
	
    <xsl:template match="refinspec">
        <xsl:value-of select="$inspec_type"/>: <xsl:value-of select="@insptype"/><br/>
	</xsl:template>
	
    <xsl:template match="trigger">
        <xsl:apply-templates/>
    </xsl:template>
    
</xsl:stylesheet>
