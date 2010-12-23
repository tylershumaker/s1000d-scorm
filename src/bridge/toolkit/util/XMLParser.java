/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.util;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.jdom.Document;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.XMLOutputter;

/**
 * Provides a way to find the any values in an
 * XML document using JDOM.
 */
public class XMLParser
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
     * Constructor
     */
    public XMLParser()
    {
        printer = new XMLOutputter();
        parser = new SAXBuilder();
    }
    
    /**
     * Parses a File object and returns a JDOM Document object.
     * 
     * @param anXmlDocFile File object that represents an XML file.
     * @return Document JDOM Document object that represents the DOM of the XML 
     * file.
     * @throws IOException 
     * @throws JDOMException 
     */
    public Document getDoc(File anXmlDocFile) throws JDOMException, IOException
    {
        Document doc = parser.build(anXmlDocFile);
            
        return doc;
    }

}
