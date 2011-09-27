/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import static org.junit.Assert.*;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;
import org.apache.commons.chain.impl.ContextBase;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import bridge.toolkit.util.CopyDirectory;
import bridge.toolkit.util.Keys;
import bridge.toolkit.util.XMLParser;

/**
 *
 */
public class S1000DConverterTest
{
    Context ctx;
    Command rb;
    File tempRes;
    List<String> commonFiles = new ArrayList<String>();
    XMLParser parser;

    /**
     * @throws java.lang.Exception
     */
    @Before
    public void setUp() throws Exception
    {
        ctx = new ContextBase();
        parser = new XMLParser();
        ctx.put(Keys.SCPM_FILE, System.getProperty("user.dir") + File.separator
                + "examples\\bike_SCPM_4.1\\SMC-S1000DBIKE-06RT9-00001-00.xml");
        String resources = System.getProperty("user.dir") + File.separator +
        "examples\\bike_resource_package_4.1";
        
        File srcPath = new File(resources);
        tempRes = new File(System.getProperty("user.dir") + File.separator +
                "test_files\\tempRes");
        tempRes.mkdir();
        CopyDirectory cd = new CopyDirectory();
        
        try
        {
            cd.copyDirectory(srcPath, tempRes);
            File svn = new File(tempRes.getAbsolutePath()+ File.separator + ".svn");
            if (svn.exists())
            {
                deleteDirectory(svn);
            }

        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
        
        ctx.put(Keys.RESOURCE_PACKAGE, tempRes.getAbsolutePath());
        rb = new S1000DConverter();
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
     * Test method for {@link bridge.toolkit.commands.PreProcess41#execute(org.apache.commons.chain.Context)}.
     */
    @Test
    public void testExecute()
    {
        try
        {
            assertFalse(rb.execute(ctx));
            
//          Document returned = (Document)ctx.get(Keys.XML_SOURCE);
//          XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
//          String output = outputter.outputString(returned);
//          System.out.println(output);               
        }
        catch (Exception e)
        {
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
