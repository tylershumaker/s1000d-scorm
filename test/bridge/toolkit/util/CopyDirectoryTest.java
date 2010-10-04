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
import java.util.Iterator;
import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

/**
 *
 */
public class CopyDirectoryTest
{

    CopyDirectory cd;
    File srcPath;
    File dstPath;
    /**
     * @throws java.lang.Exception
     */
    @Before
    public void setUp() throws Exception
    {
        cd = new CopyDirectory();
    }

    @After
    public void tearDown() throws Exception
    {
        deleteDirectory(dstPath);
    }
    /**
     * Test method for {@link bridge.toolkit.util.CopyDirectory#copyDirectory(java.io.File, java.io.File)}.
     */
    @Test
    public void testCopyDirectory()
    {
        srcPath = new File(System.getProperty("user.dir") + File.separator +
                "test_files\\resource_package");
        dstPath = new File(System.getProperty("user.dir") + File.separator +
                "test_files\\copy_test");
        try
        {
            cd.copyDirectory(srcPath, dstPath);
        }
        catch (IOException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
        assertTrue(dstPath.exists());
        String dest = dstPath.getAbsolutePath();
        assertTrue(new File(dstPath + File.separator + 
                "DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H10A_001-00_en-us.xml").exists());
        assertTrue(new File(dstPath + File.separator + 
        "ICN-S1000DBIKE-AAA-DA20000-A-06RT9-00028-A-001-01.jpg").exists());
        
    }
    
    /**
     * Test method for {@link bridge.toolkit.util.CopyDirectory#copyDirectory(java.io.File, java.io.File)}.
     */
    @Test
    public void testCopyDirectoryList()
    {
        //builds test validated resources list
        List<File> vr = new ArrayList<File>();
        
        File [] testVR = new File(System.getProperty("user.dir") + File.separator +
                                  "test_files\\resource_package").listFiles();
        for(File file : testVR)
        {
            if(file.getName().endsWith(".xml")||(file.getName().endsWith(".jpg")))
            vr.add(file);
        }

        dstPath = new File(System.getProperty("user.dir") + File.separator +
                "test_files\\copy_test");


        // have to make the destination path so that it is read as an directory
        dstPath.mkdirs();
        //cd.copyFileList(vr, dstPath);
        Iterator<File> iterator = vr.iterator();
        for(;iterator.hasNext();)
        {
            try
            {
                cd = new CopyDirectory();
                cd.copyDirectory(iterator.next(), dstPath);
            }
            catch (IOException e)
            {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        
        }

        assertTrue(dstPath.exists());
        String dest = dstPath.getAbsolutePath();
        assertTrue(new File(dstPath + File.separator + 
                "DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H10A_001-00_en-us.xml").exists());
        assertTrue(new File(dstPath + File.separator + 
        "ICN-S1000DBIKE-AAA-DA20000-A-06RT9-00028-A-001-01.jpg").exists());
        
    }
    
    static public boolean deleteDirectory(File path) {
        if( path.exists() ) {
          File[] files = path.listFiles();
          for(int i=0; i<files.length; i++) {
             if(files[i].isDirectory()) {
               deleteDirectory(files[i]);
             }
             else {
               files[i].delete();
             }
          }
        }
        return( path.delete() );
      }


}
