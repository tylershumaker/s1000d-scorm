/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.util;

import static org.junit.Assert.*;

import java.io.File;
import java.io.IOException;

import org.jdom.JDOMException;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

/**
 *
 */
public class SCOContentDMCheckerTest
{
    SCOContentDMChecker checker;

    /**
     * @throws java.lang.Exception
     */
    @Before
    public void setUp() throws Exception
    {
        checker = new SCOContentDMChecker();
    }

    /**
     * @throws java.lang.Exception
     */
    @After
    public void tearDown() throws Exception
    {
    }

    /**
     * Test method for {@link bridge.toolkit.util.SCOContentDMChecker#isSCOContentDM(java.io.File)}.
     * @throws IOException 
     * @throws JDOMException 
     */
    @Test
    public void testIsSCOContentDM() throws JDOMException, IOException
    {


        File lDM = new File(System.getProperty("user.dir") + File.separator + "examples\\bike_resource_package_4.1"
                + File.separator + "DMC-S1000DBIKE-AAA-D00-00-00-00AA-151A-A-T45C_001-00_EN-US.xml");
        
        assertFalse(checker.isSCOContentDM(lDM));
        
        File scDM = new File(System.getProperty("user.dir") + File.separator + "examples\\bike_resource_package_4.1"
                + File.separator + "DMC-S1000DBIKE-AAA-D00-00-00-00AA-960A-T_001-00_EN-US.xml");
        
        assertTrue(checker.isSCOContentDM(scDM));
    }

}
