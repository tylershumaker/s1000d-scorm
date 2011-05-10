/**
 * This file is part of the S1000D-SCORM Bridge Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.jdom.Attribute;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.XMLOutputter;
import org.jdom.xpath.XPath;

import bridge.toolkit.util.XMLParser;



/**
 * Provides a way to find the any referenced data model codes referenced in a
 * file.
 */
public class DMParser extends XMLParser
{

    /**
     * Outputs a JDOM document as a stream of bytes.
     */
    XMLOutputter printer = null;
    
    /**
     * Builds a JDOM document from the XML file.
     */
    SAXBuilder parser;
    
    /**
     * Map that associates the all the DM files that have a referenced ICN to
     * a list of the ICNs found in that file.
     */
    private Map<String, List<String>> media;

    /**
     * Constructor
     */
    public DMParser()
    {
        printer = new  XMLOutputter();
        parser = new SAXBuilder();
        media = new HashMap<String, List<String>>();
    }
    
    /**
     * Searches any document for dmCode elements and returns the attributes 
     * in the data module code format.
     * 
     * @param dmDoc - Document JDOM Document object that represents the DOM of 
     * the XML file being searched.
     * @return List<String> A List of data module code Strings that are found.
     */
    public List<String> searchForDmRefs(Document dmDoc)
    {
        List<String> referencedDMs = new ArrayList<String>();

        XPath xp = null;

        try
        {
            xp = XPath.newInstance("//dmCode");
        }
        catch (JDOMException e1)
        {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
        List<Element> dmc_lst = null;
        try
        {
            dmc_lst = (ArrayList) xp.selectNodes(dmDoc);
        }
        catch (JDOMException e1)
        {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
                
        Iterator<Element> refdms = dmc_lst.iterator();
        while (refdms.hasNext() == true)
        {
            Element e = refdms.next();
            Element theAncestor = (Element) e.getParent().getParent();
            String dmc;
            String modelIdentCode="";
            String systemDiffCode="";
            String systemCode="";
            String subSystemCode="";    
            String subSubSystemCode="";    
            String assyCode="";    
            String disassyCode="";    
            String disassyCodeVariant="";    
            String infoCode="";    
            String infoCodeVariant="";    
            String itemLocationCode="";    
            String learnCode="";    
            String learnEventCode="";              
            
            if (theAncestor.getName() == "dmRef")
            {
            	dmc = "DMC-";
                List<Attribute> atts = e.getAttributes();
                for (int i = 0; i < atts.toArray().length; i++)
                {
                    if (atts.get(i).getName() == "modelIdentCode")
                    {
                    	modelIdentCode=atts.get(i).getValue() + "-";
                    }
                    else if (atts.get(i).getName() == "systemDiffCode")
                    {
                    	systemDiffCode= atts.get(i).getValue() + "-";
                    }
                    else if (atts.get(i).getName() == "systemCode")
                    {
                    	systemCode= atts.get(i).getValue() + "-";
                    }
                    else if (atts.get(i).getName() == "subSystemCode")
                    {
                    	subSystemCode= atts.get(i).getValue();
                    }
                    else if (atts.get(i).getName() == "subSubSystemCode")
                    {
                    	subSubSystemCode= atts.get(i).getValue() + "-";
                    }
                    else if (atts.get(i).getName() == "assyCode")
                    {
                    	assyCode= atts.get(i).getValue() + "-";
                    }
                    else if (atts.get(i).getName() == "disassyCode")
                    {
                    	disassyCode=atts.get(i).getValue();
                    }
                    else if (atts.get(i).getName() == "disassyCodeVariant")
                    {
                    	disassyCodeVariant=atts.get(i).getValue() + "-";
                    }
                    else if (atts.get(i).getName() == "infoCode")
                    {
                    	infoCode= atts.get(i).getValue();
                    }
                    else if (atts.get(i).getName() == "infoCodeVariant")
                    {
                    	infoCodeVariant= atts.get(i).getValue() + "-";
                    }
                    else if (atts.get(i).getName() == "itemLocationCode")
                    {
                        if (atts.toArray().length > 11)
                        {
                        	itemLocationCode= atts.get(i).getValue() + "-";
                        }
                        else
                        {
                        	learnCode= atts.get(i).getValue();
                        }
                    }
                    else if (atts.get(i).getName() == "learnCode")
                    {
                    	learnCode=atts.get(i).getValue();
                    }
                    else if (atts.get(i).getName() == "learnEventCode")
                    {
                    	learnEventCode=atts.get(i).getValue();
                    }

                }// end for
                dmc = dmc +modelIdentCode+systemDiffCode+systemCode+subSystemCode
                +subSubSystemCode+assyCode+disassyCode+disassyCodeVariant+infoCode+infoCodeVariant
                +itemLocationCode+learnCode+learnEventCode;    
                referencedDMs.add(dmc);
                
            }//end if
            

        }// end while
        return referencedDMs;
    }    
    
    /**
     * Gets the map of the DMs that reference the ICNs and the list of ICNs
     * that are referenced in each DM.
     * @return the media
     */
    public Map<String, List<String>> getMedia()
    {
        return media;
    }

}
