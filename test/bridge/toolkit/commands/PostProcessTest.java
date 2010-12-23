/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import static org.junit.Assert.*;

import java.io.File;
import java.io.IOException;

import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;
import org.apache.commons.chain.impl.ContextBase;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import bridge.toolkit.packaging.ContentPackageCreator;
import bridge.toolkit.util.CopyDirectory;
import bridge.toolkit.util.Keys;
import bridge.toolkit.util.XMLParser;

/**
 *
 */
public class PostProcessTest
{
    Context ctx;
    Command postProcess;
    XMLParser parser;
    File tempRes;
    
    /**
     * @throws java.lang.Exception
     */
    @Before
    public void setUp() throws Exception
    {
        ctx = new ContextBase();
        parser = new XMLParser();
        ctx.put(Keys.XML_SOURCE, parser.getDoc(new File(System.getProperty("user.dir") + File.separator
                + "test_files\\bike_imsmanifest_after_preprocess.xml")));
        String resources = System.getProperty("user.dir") + File.separator +
        "test_files\\bike_resource_package";
        
        
        File srcPath = new File(resources);
        tempRes = new File(System.getProperty("user.dir") + File.separator +
                "test_files\\tempRes");
        CopyDirectory cd = new CopyDirectory();
        
        try
        {
            cd.copyDirectory(srcPath, tempRes);
            File svn = new File(tempRes.getAbsolutePath()+ File.separator + ".svn");
            if (svn.exists())
            {
                deleteDirectory(svn);
            }
            File mediaSvn = new File(tempRes.getAbsolutePath()+ File.separator + "media" + File.separator + ".svn");
            if (mediaSvn.exists())
            {
                deleteDirectory(mediaSvn);
            }

        }
        catch (IOException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
        ctx.put(Keys.RESOURCE_PACKAGE, tempRes.getAbsolutePath());
        
        ContentPackageCreator cpc = new ContentPackageCreator((String) ctx.get(Keys.RESOURCE_PACKAGE));
        File cpPackage = cpc.createPackage();
        ctx.put(Keys.CP_PACKAGE, cpPackage);
        
        postProcess = new PostProcess();
    }

    /**
     * @throws java.lang.Exception
     */
    @After
    public void tearDown() throws Exception
    {
        deleteDirectory(tempRes);
    }

    /**
     * Test method for {@link bridge.toolkit.commands.PostProcess#execute(org.apache.commons.chain.Context)}.
     */
    @Test
    public void testExecute()
    {

        try
        {
            assertFalse(postProcess.execute(ctx));
        }
        catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
    
    @Test
    public void testNullXMLSource()
    {
        try
        {
            ctx.put(Keys.XML_SOURCE, null);
            assertTrue(postProcess.execute(ctx));
        }
        catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
    
    @Test
    public void testNullCPPackage()
    {
        try
        {
            ctx.put(Keys.CP_PACKAGE, null);
            assertTrue(postProcess.execute(ctx));
        }
        catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
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
