/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit;

import java.io.File;
import java.net.MalformedURLException;

import org.apache.commons.chain.Catalog;
import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;
import org.apache.commons.chain.config.ConfigParser;
import org.apache.commons.chain.impl.CatalogFactoryBase;
import org.apache.commons.chain.impl.ContextBase;

import bridge.toolkit.util.Keys;

/**
 * The core of the toolkit that handles the execution of the modules.
 * 
 */
public class Controller
{
    /**
    * Location of the XML configuration file that defines and configures 
    * commands and command chains to be registered in a Catalog. 
    */
    private static final String CONFIG_FILE = System.getProperty("user.dir")
            + File.separator + "conf\\chain-config.xml";

    /**
     * Class to parse the contents of an XML configuration file 
     * (using Commons Digester) that defines and configures commands and 
     * command chains to be registered in a Catalog.
     */
    private ConfigParser parser;

    /**
     * Collection of named Commands (or Chains) that can be used to retrieve 
     * the set of commands that should be performed.
     */
    private Catalog catalog;

    /**
	 * Constructor
	 */
    public Controller()
    {
        parser = new ConfigParser();
    }

    /**
     * Creates the Catalog object based off of the configuration file. 
     * @return Catalog object that contains the set of commands to be performed.
     */
    public Catalog createCatalog()
    {
        if (catalog == null)
        {
            try
            {
                parser.parse(new File(CONFIG_FILE).toURI().toURL());
            }
            catch (MalformedURLException e)
            {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            catch (Exception e)
            {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        catalog = CatalogFactoryBase.getInstance().getCatalog();
        return catalog;
    }

    /**
     * @param args
     */
    public static void main(String[] args)
    {
        Controller loader = new Controller();
        Catalog sampleCatalog = loader.createCatalog();
        Command toolkit = sampleCatalog.getCommand("Toolkit");
        Context ctx = new ContextBase();
        ctx.put(Keys.SCPM_FILE, System.getProperty("user.dir") + File.separator
                + "test_files\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml");
        ctx.put(Keys.RESOURCE_PACKAGE, System.getProperty("user.dir") + File.separator +
                "test_files\\bike_resource_package");
        try
        {
            toolkit.execute(ctx);
        }
        catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

    }

}
