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
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.jdom.xpath.XPath;
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
                + "test_files\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml");
        
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
            "test_files\\bike_resource_package");
            preProcess.execute(ctx);
            Document returned = (Document)ctx.get(Keys.XML_SOURCE);

            XMLParser parser = new XMLParser();
            Document expected = parser.getDoc(new File(System.getProperty("user.dir") + File.separator +
            "test_files\\bike_imsmanifest_after_preprocess.xml"));

//          XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
//          String output = outputter.outputString(returned);
//          System.out.println(output);
            
            assertEquals(expected.getRootElement().getName(), 
                         returned.getRootElement().getName());
            assertEquals(expected.getRootElement().getChildren().size(), 
                         returned.getRootElement().getChildren().size());
            assertEquals(expected.getRootElement().getChild("resources", null).getChildren().size(),
                         returned.getRootElement().getChild("resources", null).getChildren().size());
            assertEquals(expected.getRootElement().getChild("organizations", null).getChild("organization", null).getChildren().size(),
                         returned.getRootElement().getChild("organizations", null).getChild("organization", null).getChildren().size());
            XPath xp = XPath.newInstance("//ns:resource[@identifier='RES-N66055']");
            xp.addNamespace("ns", "http://www.imsglobal.org/xsd/imscp_v1p1");
            assertEquals(((Element)xp.selectSingleNode(expected)).getChildren().size(),
                         ((Element)xp.selectSingleNode(returned)).getChildren().size());
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
            "test_files\\resource_package_slim");
            ctx.put(Keys.SCPM_FILE, null);
            assertTrue(preProcess.execute(ctx));
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
    public void testExecuteSlimPackage()
    {
        try
        {
            setUp(System.getProperty("user.dir") + File.separator +
            "test_files\\resource_package_slim");
            ctx.put(Keys.SCPM_FILE, System.getProperty("user.dir") + File.separator +
            "test_files\\scpm_slim\\SMC-S1000DBIKE-06RT9-00001-00.xml");
            assertFalse(preProcess.execute(ctx));
            
//            Document returned = (Document)ctx.get(Keys.XML_SOURCE);
//          XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
//          String output = outputter.outputString(returned);
//          System.out.println(output);            
        }
        catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }    

    @Test
    public void createResourceMapIncorrect()
    {
        try
        {
            setUp(System.getProperty("user.dir") + File.separator +
            "test_files\\resource_package_collision");
            ctx.put(Keys.SCPM_FILE, System.getProperty("user.dir") + File.separator +
            "test_files\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml");
            assertTrue(preProcess.execute(ctx));
        }
        catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
    
    @Test
    public void createResourcePackageEmpty()
    {
        try
        {
//            File emptyResPackage = new File(System.getProperty("user.dir") + File.separator +
//                    "test_files\\resource_package_empty");
//            emptyResPackage.mkdir();
            setUp(System.getProperty("user.dir") + File.separator +
            "test_files\\resource_package_empty");
            ctx.put(Keys.SCPM_FILE, System.getProperty("user.dir") + File.separator +
            "test_files\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml");
            assertTrue(preProcess.execute(ctx));
//            deleteDirectory(emptyResPackage);
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
