/**
 * This file is part of the S1000D Transformation Toolkit 
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
import org.junit.Before;
import org.junit.Test;

/**
 *
 */
public class DMParserTest
{

    DMParser dmp;
    @Before
    public void setUp() throws Exception
    {
        dmp = new DMParser();
    }

    @Test
    public void testSearchForDMRefsSCPM()
    {
        File scpm = new File(
            System.getProperty("user.dir")
            + File.separator
            + "test_files"
            + File.separator
            + "scpm_slim"
            + File.separator
            + "SMC-S1000DBIKE-06RT9-00001-00.xml"
        );
        Document test = null;
        try
        {
            test = dmp.getDoc(scpm);
        }
        catch (JDOMException e)
        {
            e.printStackTrace();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
        
        List<String> expected = new ArrayList<String>();
        expected.add("DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-A-H30A");
        expected.add("DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-A-H10A");
        expected.add("DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-A-H11A");
        expected.add("DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-A-H18A");
        expected.add("DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-A-H19A");
        expected.add("DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-A-H20A");
        expected.add("DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-A-H40A");
        expected.add("DMC-S1000DBIKE-AAA-DA0-00-00-00AA-932A-A-H14B");
        expected.add("DMC-S1000DBIKE-AAA-DA2-00-00-00AA-028A-A-T28C");
        expected.add("DMC-S1000DBIKE-AAA-DA2-00-00-00AA-041A-A-T88E");
        
        assertEquals(expected, dmp.searchForDmRefs(test));
    }
}