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
import java.util.Iterator;
import java.util.List;

import org.jdom.JDOMException;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

/**
 *
 */
public class URNMapperTest
{

    /**
     * @throws java.lang.Exception
     */
    @Before
    public void setUp() throws Exception
    {
        
    }

    /**
     * @throws java.lang.Exception
     */
    @After
    public void tearDown() throws Exception
    {
    }

    /**
     * Test method for {@link bridge.toolkit.util.URNMapper#getSourceFiles(java.lang.String)}.
     */
    @Test
    public void testGetSourceFiles()
    {
        List<File> resourceFiles = new ArrayList<File>();
        try
        {
            resourceFiles = URNMapper.getSourceFiles(System.getProperty("user.dir") +"\\examples\\bike_resource_package_4.1");
        }
        catch (JDOMException e)
        {
            e.printStackTrace();
            fail();
        }
        catch (IOException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
            fail();
        }
        
        Iterator<File> iterator = resourceFiles.iterator();
        while(iterator.hasNext())
        {
            System.out.println(iterator.next().getName());
        }
    }

    /**
     * Test method for {@link bridge.toolkit.util.URNMapper#writeURNMap(java.util.List, java.lang.String)}.
     */
    @Test
    public void testWriteURNMap()
    {
        //fail("Not yet implemented");
    }

}
