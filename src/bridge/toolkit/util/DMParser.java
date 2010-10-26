/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.util;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.jdom.input.SAXBuilder;
import org.jdom.output.XMLOutputter;

/**
 * Parses an S1000D DM file for any referenced ICN.
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
     * Map that associates all the DM files that have a referenced DM to a list 
     * of DMs.
     */
    private Map<String, List<String>> referencedDMs;
    
    
    /**
     * Constructor
     */
    public DMParser()
    {
        printer = new XMLOutputter();
        parser = new SAXBuilder();
        media = new HashMap<String, List<String>>();
    }
    
    /**
     * Gets all the references of the ICN files found in the validated 
     * resources.
     * 
     * @param iDMFiles List of the DM files to be parsed.
     */
    public void getICNFiles(List<File> iDMFiles)
    {
        int numberOfFiles = 0;
        int filesAdded = 0;
        Iterator<File> filesIterator = iDMFiles.iterator();
        while(filesIterator.hasNext())
        {
            File currentDM = filesIterator.next();
            //search through all the possible elements that could have an infoEntityIdent attribute
            getAttribute(currentDM, "graphic", "infoEntityIdent");
            getAttribute(currentDM, "symbol", "infoEntityIdent");
            getAttribute(currentDM, "multimediaObject", "infoEntityIdent");
            //add to a hashMap
            if(getValue().size()>numberOfFiles)
            {
                List<String> icn = new ArrayList<String>();
                for(int i = numberOfFiles; getValue().size() > i; i++)
                {
                    //TODO: don't add if already is in list 
                    if(!icn.contains(getValue().get(i)))
                    {
                        icn.add(getValue().get(i)); 
                    }
                    
                }
                media.put(currentDM.getName(), icn);
                numberOfFiles = getValue().size();
            }
            
            //TODO: Steve start here with the resRef
            
            //populate referencedDMs
            
        }
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
    
    /**
     */
    public Map<String, List<String>> getReferencedDMs()
    {
        return referencedDMs;
    }

}
