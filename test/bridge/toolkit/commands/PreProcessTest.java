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
import org.jdom.Document;
import org.jdom.JDOMException;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import bridge.toolkit.ResourceMapException;
import bridge.toolkit.commands.PreProcess;
import bridge.toolkit.util.CopyDirectory;
import bridge.toolkit.util.Keys;
import bridge.toolkit.util.XMLParser;

/**
 *
 */
public class PreProcessTest
{
    Context ctx;
    Command preProcess;
    File dstPath;

    /**
     * @throws java.lang.Exception
     */
    public void setUp(String src)
    {
        ctx = new ContextBase();
        ctx.put(Keys.SCPM_FILE, System.getProperty("user.dir") + File.separator
                + "test_files\\SMC-S1000DBIKE-06RT9-00001-00.xml");
        
        File srcPath = new File(src);
        dstPath = new File(System.getProperty("user.dir") + File.separator +
                "test_files\\resMap");
        CopyDirectory cd = new CopyDirectory();
        
        try
        {
            cd.copyDirectory(srcPath, dstPath);
            File svn = new File(dstPath.getAbsolutePath()+ File.separator + ".svn");
            if (svn.exists())
            {
                deleteDirectory(svn);
            }
            File mediaSvn = new File(dstPath.getAbsolutePath()+ File.separator + "media" + File.separator + ".svn");
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
        
        
        ctx.put(Keys.RESOURCE_PACKAGE, dstPath.getAbsolutePath());
        preProcess = new PreProcess();
    }
    
    @After
    public void tearDown()
    {
        deleteDirectory(dstPath);
    }

    /**
     * Test method for {@link bridge.toolkit.PreProcess#execute(org.apache.commons.chain.Context)}.
     */
    @Test
    public void testExecute()
    {
        try
        {
            setUp(System.getProperty("user.dir") + File.separator +
            "test_files\\resource_package");
            preProcess.execute(ctx);
            File test = (File)ctx.get(Keys.XML_SOURCE);
            assertEquals("imsmanifest.xml", test.getName());
            
            XMLParser parser = new XMLParser();
            Document doc =  parser.getDoc(test);
            XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
            String returned = outputter.outputString(doc);
            System.out.println(returned);
        }
        catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
    
    /**
     * Test method for {@link bridge.toolkit.PreProcess#execute(org.apache.commons.chain.Context)}.
     */
    @Test
    public void testExecuteSCPMNull()
    {
        try
        {
            setUp(System.getProperty("user.dir") + File.separator +
            "test_files\\resource_package");
            ctx.put(Keys.SCPM_FILE, null);
            assertTrue(preProcess.execute(ctx));
        }
        catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
    
    @Test
    public void createResourceMap()
    {
        try
        {
            setUp(System.getProperty("user.dir") + File.separator +
            "test_files\\resource_package");
            ((PreProcess)preProcess).createResourceMap(dstPath.getAbsolutePath());
        }
        catch(JDOMException e)
        {
            e.printStackTrace();
        }
        catch (ResourceMapException rme)
        {
            rme.printTrace();
        }
    }

    @Test
    public void createResourceMapCollision()
    {
        try
        {
            setUp(System.getProperty("user.dir") + File.separator +
            "test_files\\resource_package_collision");
            ((PreProcess)preProcess).createResourceMap(dstPath.getAbsolutePath());
        }
        catch(JDOMException e)
        {
            e.printStackTrace();
        }
        catch (ResourceMapException rme)
        {
            rme.printTrace();
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
