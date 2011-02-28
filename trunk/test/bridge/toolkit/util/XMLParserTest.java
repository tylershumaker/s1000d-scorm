/**
 * This file is part of the S1000D-SCORM Bridge Toolkit 
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
        test = new File(System.getProperty("user.dir") + File.separator
                + "test_files\\imsmanifest.xml");
    }


    @Test
    public void testGetDoc()
    {
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

}
