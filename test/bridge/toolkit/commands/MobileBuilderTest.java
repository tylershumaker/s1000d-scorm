/**
 * This file is part of the S1000D-SCORM Bridge Toolkit 
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

import bridge.toolkit.util.CopyDirectory;
import bridge.toolkit.util.Keys;

public class MobileBuilderTest
{

    Context ctx;
    Command mobileBuilder;
    File dstPath;
    
    public void setUp(String src)
    {
        ctx = new ContextBase();
        ctx.put(Keys.SCPM_FILE, System.getProperty("user.dir") + File.separator
                + "examples\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml");
        
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
        mobileBuilder = new MobileBuilder();
    }

    @After
    public void tearDown() throws Exception
    {
       deleteDirectory(dstPath);
    }

    @Test
    public void testExecute()
    {
        setUp(System.getProperty("user.dir") + File.separator +
        "examples\\bike_resource_package");
        try
        {
            mobileBuilder.execute(ctx);
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
