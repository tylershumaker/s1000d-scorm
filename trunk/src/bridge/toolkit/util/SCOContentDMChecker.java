/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.util;

import java.io.File;
import java.io.IOException;

import org.jdom.Document;
import org.jdom.JDOMException;
import org.jdom.xpath.XPath;

/**
 * Checks to see if a S1000D data module is a 4.1 SCO content data module.
 */
public class SCOContentDMChecker
{

    /**
     * Parses a data module to see if the infoCode is 960 which indicates a 
     * SCO content data module.
     * @param dataModule File that represents a data module file.
     * @return boolean Boolean that indicates if the data module was a SCO content data module.
     * @throws IOException 
     * @throws JDOMException 
     */
    public static boolean isSCOContentDM(File dataModule) throws JDOMException, IOException 
    {
        boolean isSCOContentDM = false;
        XMLParser xp = new XMLParser();
        
            Document dmDoc = xp.getDoc(dataModule);
            XPath xpath = XPath.newInstance("//identAndStatusSection/dmAddress/dmIdent/dmCode[@infoCode='960']");
            if(xpath.selectSingleNode(dmDoc)!=null)
                isSCOContentDM = true;


        return isSCOContentDM;
    }
}
