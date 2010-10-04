/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.util;

import static org.junit.Assert.*;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.jdom.Document;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

/**
 *
 */
public class XMLParserTest
{

    XMLParser mp;
    File test;
    /**
     * @throws java.lang.Exception
     */
    @Before
    public void setUp() throws Exception
    {
        mp = new XMLParser();
        test = new File(System.getProperty("user.dir") + File.separator
                + "test_files\\imsmanifest.xml");
    }

    /**
     * @throws java.lang.Exception
     */
    @After
    public void tearDown() throws Exception
    {
    }

    /**
     * Test method for {@link bridge.toolkit.util.XMLParser#parseAndFind(java.io.File, java.lang.String)}.
     */
    @Test
    public void testParseAndFind()
    {
        List<String> hrefs = new ArrayList<String>();
        hrefs.add("TODO:ref_to_SCO_goes_here");
        hrefs.add("S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H30A");
        hrefs.add("S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H10A");
        hrefs.add("S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H11A"); 
        hrefs.add("S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H18A");
        hrefs.add("S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H19A"); 
        hrefs.add("S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H20A");
        hrefs.add("S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H40A");
        hrefs.add("TODO:ref_to_SCO_goes_here"); 
        hrefs.add("S1000DBIKE-AAA-DA0-00-00-00AA-932A-T-H14B"); 
        hrefs.add("TODO:ref_to_SCO_goes_here"); 
        hrefs.add("S1000DBIKE-AAA-DA2-00-00-00AA-028A-T-T28C"); 
        hrefs.add("S1000DBIKE-AAA-DA2-00-00-00AA-041A-T-T88E");        
        
        mp.getAttribute(test, "file","href");
        assertEquals(hrefs, mp.getValue());
    }
    
    @Test
    public void testGetDoc()
    {
        Document doc = mp.getDoc(test);
        System.out.println(doc.getContent().toString());
        System.out.println(doc.getRootElement().getChildren().toString());
    }

}
