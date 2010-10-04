/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.util;

import static org.junit.Assert.*;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

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
    /**
     * Test method for {@link bridge.toolkit.util.DMParser#getICNFiles(java.lang.String, java.util.List)}.
     */
    @Test
    public void testGetICNFiles()
    {
        //C:\workspace2\bridge_open_toolkit\test_files\Keys.RESOURCE_PACKAGE
        String location = System.getProperty("user.dir") + File.separator + "test_files\\resource_package\\";
        List<File> dmFiles = new ArrayList<File>();
        dmFiles.add(new File(location +"DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H30A_001-00_en-us.xml"));
        dmFiles.add(new File(location +"DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H10A_001-00_en-us.xml"));
        dmFiles.add(new File(location +"DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H11A_001-00_en-us.xml"));
        dmFiles.add(new File(location +"DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H18A_001-00_en-us.xml"));
        dmFiles.add(new File(location +"DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H19A_001-00_en-us.xml"));
        dmFiles.add(new File(location +"DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H20A_001-00_en-us.xml"));
        dmFiles.add(new File(location +"DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H40A_001-00_en-us.xml"));
        dmFiles.add(new File(location +"DMC-S1000DBIKE-AAA-DA0-00-00-00AA-932A-T-H14B_001-00_EN-us.xml"));
        dmFiles.add(new File(location +"DMC-S1000DBIKE-AAA-DA2-00-00-00AA-028A-T-T28C_001-00_en-US.xml"));
        dmFiles.add(new File(location +"DMC-S1000DBIKE-AAA-DA2-00-00-00AA-041A-T-T88E_001-00_en-US.xml"));
        
        List<String> expected = new ArrayList<String>();
        expected.add("ICN-S1000DBIKE-AAA-DA20000-A-06RT9-00028-A-001-01");
        expected.add("ICN-S1000DBIKE-AAA-DA20000-A-06RT9-00029-A-001-01");
        expected.add("ICN-S1000DBIKE-AAA-DA20000-A-06RT9-00029-A-001-01");
        
        dmp.getICNFiles(dmFiles);
        
        assertEquals(expected, dmp.getValue());
        
    }

}
