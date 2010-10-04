/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.util;

import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
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
     * List of all the values found for the attribute being searched in the
     * XML document.
     */
    private List<String> value = new ArrayList<String>();

    /**
     * Constructor
     */
    public XMLParser()
    {
        // lets create an XML Printer!
        printer = new XMLOutputter();
        parser = new SAXBuilder();
    }
    
    /**
     * Gets the list of values found for the attribute searched.
     * @return the List of values
     */
    public List<String> getValue()
    {
        return value;
    }

    /**
     * Sets the list of values.
     * @param value List of the values to set
     */
    public void setValue(List<String> value)
    {
        this.value = value;
    }

    
    /**
     * Parses a File object and returns a JDOM Document object.
     * 
     * @param anXmlDocFile File object that represents an XML file.
     * @return Document JDOM Document object that represents the DOM of the XML 
     * file.
     */
    public Document getDoc(File anXmlDocFile)
    {
        Document doc = null;
        try
        {
            doc = parser.build(anXmlDocFile);
        }
        catch (JDOMException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        catch (IOException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
        return doc;
    }
    
    /**
     * Parses through the entire XML document and gets the value of the desired attribute of
     * the given element.
     * 
     * @param anXmlDocFile File that is the XML file to be parsed.
     * @param element String that represents the given element.
     * @param attribute String that represents the desired attribute of the given element.
     */
    public void getAttribute(File anXmlDocFile, String element, String attribute)
    {
        try
        {
            // get the dom-document
            Document doc = parser.build(anXmlDocFile);

            List<Element> test = doc.getRootElement().getChildren();

            searchForAttribute(test, element, attribute);

        }
        catch (JDOMException ex)
        {
            ex.printStackTrace();
        }
        catch (IOException ex)
        {
            ex.printStackTrace();
        }

    }

    /**
     * Loops through all the elements in the XML file and finds the desired element and value
     * of the searched Attribute.
     *  
     * @param elements  List of elements for the current node in the DOM tree.
     * @param element String that represents the given element.
     * @param attribute String that represents the desired attribute of the given element.
     */
    private void searchForAttribute(List<Element> elements, String element, String attribute)
    {
        try
        {
            StringWriter sw = new StringWriter();
            for (int i = 0; i < elements.size(); i++)
            {
                // System.out.println(test.get(i));
                Object o = elements.get(i);
                Element e = (Element) o;
                this.printer.output(e, sw);
                if (e.getName().equals(element))
                {
                    value.add(e.getAttributeValue(attribute));
                    this.printer.output(e, sw);
                }
                else
                {
                    List<Element> children = e.getChildren();
                    searchForAttribute(children, element, attribute);
                }
            }
        }
        catch (IOException ex)
        {
            ex.printStackTrace();
        }
    }
}
