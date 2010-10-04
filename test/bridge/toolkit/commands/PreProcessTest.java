/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import static org.junit.Assert.*;

import java.io.File;

import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;
import org.apache.commons.chain.impl.ContextBase;
import org.junit.Before;
import org.junit.Test;

import bridge.toolkit.commands.PreProcess;
import bridge.toolkit.util.Keys;

/**
 *
 */
public class PreProcessTest
{
    Context ctx;
    Command preProcess;

    /**
     * @throws java.lang.Exception
     */
    @Before
    public void setUp() throws Exception
    {
        ctx = new ContextBase();
        ctx.put(Keys.SCPM_FILE, System.getProperty("user.dir") + File.separator
                + "test_files\\SMC-S1000DBIKE-06RT9-00001-00.xml");
        preProcess = new PreProcess();
    }

    /**
     * Test method for {@link bridge.toolkit.PreProcess#execute(org.apache.commons.chain.Context)}.
     */
    @Test
    public void testExecute()
    {
        try
        {
            preProcess.execute(ctx);
            File test = (File)ctx.get(Keys.XML_SOURCE);
            assertEquals("imsmanifest.xml", test.getName());
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
            ctx.put(Keys.SCPM_FILE, null);
            assertTrue(preProcess.execute(ctx));
        }
        catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

}
