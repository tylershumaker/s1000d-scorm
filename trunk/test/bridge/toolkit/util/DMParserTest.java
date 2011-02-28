/**
 * This file is part of the S1000D-SCORM Bridge Toolkit 
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
        File scpm = new File(System.getProperty("user.dir") + File.separator + 
                    "test_files\\scpm_slim\\SMC-S1000DBIKE-06RT9-00001-00.xml");
        Document test = null;
        try
        {
            test = dmp.getDoc(scpm);
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
        
        List<String> expected = new ArrayList<String>();
        expected.add("DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H30A");
        expected.add("DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H10A");
        expected.add("DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H11A");
        expected.add("DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H18A");
        expected.add("DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H19A");
        expected.add("DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H20A");
        expected.add("DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H40A");
        expected.add("DMC-S1000DBIKE-AAA-DA0-00-00-00AA-932A-T-H14B");
        expected.add("DMC-S1000DBIKE-AAA-DA2-00-00-00AA-028A-T-T28C");
        expected.add("DMC-S1000DBIKE-AAA-DA2-00-00-00AA-041A-T-T88E");
        
        assertEquals(expected, dmp.searchForDmRefs(test));
    }
}


