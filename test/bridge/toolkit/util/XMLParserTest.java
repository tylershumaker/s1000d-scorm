/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.util;

import static org.junit.Assert.*;

import java.io.File;
import java.io.IOException;

import org.jdom.Document;
import org.jdom.JDOMException;
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

    }


    @Test
    public void testGetDoc()
    {
        test = new File(
            System.getProperty("user.dir")
            + File.separator
            + "test_files"
            + File.separator
            + "imsmanifest.xml"
        );
        Document doc = null;
        try
        {
            doc = mp.getDoc(test);
        }
        catch (JDOMException jde)
        {
            jde.printStackTrace();
        }
        catch (IOException ioe)
        {
            ioe.printStackTrace();
        }
        System.out.println(doc.getContent().toString());
        System.out.println(doc.getRootElement().getChildren().toString());
    }

    @Test
    public void testGetInvalidDoc()
    {
        test = new File(
            System.getProperty("user.dir")
            + File.separator
            + "test_files"
            + File.separator
            + "DMC-S1000DBIKE-AAA-DA0-00-00-00AA-041A-A-T61E_001-00_EN-US.xml"
        );
        Document doc = null;
        try
        {
            doc = mp.getDoc(test);
        }
        catch (JDOMException jde)
        {
            jde.printStackTrace();
        }
        catch (IOException ioe)
        {
            ioe.printStackTrace();
        }
    }
}
