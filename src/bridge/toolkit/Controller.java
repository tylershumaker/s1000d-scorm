/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit;

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
    private static final String CONFIG_FILE = "chain-config.xml";

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
                parser.parse(this.getClass().getResource(CONFIG_FILE));
            }
            catch (MalformedURLException e)
            {
                e.printStackTrace();
            }
            catch (Exception e)
            {
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
        Command toolkit = sampleCatalog.getCommand("SCORM");
        Context ctx = new ContextBase();
        
        ctx.put(Keys.SCPM_FILE, args[0]);
        ctx.put(Keys.RESOURCE_PACKAGE, args[1]);
        ctx.put(Keys.MIN_SCORE, "80");
        try
        {
        
        	if (args.length > 2)
        	{

                if (args[2] != null && args[2].equalsIgnoreCase("-scorm12"))
                {
                    toolkit = sampleCatalog.getCommand("SCORM");
                    //flash output is being depricated - always use html output
                    ctx.put(Keys.OUTPUT_TYPE, "SCORM12");
                }
        		else if (args[2] != null && args[2].equalsIgnoreCase("-scormflash"))
  				{
        			toolkit = sampleCatalog.getCommand("SCORM");
        			//flash output is being depricated - always use html output
        			ctx.put(Keys.OUTPUT_TYPE, "SCORMHTML");
   				}
        		else if (args[2] != null && args[2].equalsIgnoreCase("-scormhtml"))
  				{
        			toolkit = sampleCatalog.getCommand("SCORM");
        			ctx.put(Keys.OUTPUT_TYPE, "SCORMHTML");
   				}
        		else if (args[2] != null && args[2].equalsIgnoreCase("-scormLevelledParaNum"))
  				{
        			toolkit = sampleCatalog.getCommand("SCORM");
        			ctx.put(Keys.OUTPUT_TYPE, "SCORMLEVELLEDPARANUM");
   				}        		
        	    else if(args.length>2 && args[2] != null && (args[2].equalsIgnoreCase("-mobileCourse")))
        	    {
        	        toolkit = sampleCatalog.getCommand("Mobile"); 
        	        ctx.put(Keys.OUTPUT_TYPE, "mobileCourse");
        	    }
        	    else if(args.length>2 && args[2] != null && (args[2].equalsIgnoreCase("-mobilePerformanceSupport")))
        	    {
        	        toolkit = sampleCatalog.getCommand("Mobile");
        	    }
        		else if (args[2] != null && args[2].equalsIgnoreCase("-pdfinstructor"))
  				{
        			toolkit = sampleCatalog.getCommand("PDF");
                    ctx.put(Keys.PDF_OUTPUT_OPTION,"-instructor");
   				}
        		else if (args[2] != null && args[2].equalsIgnoreCase("-pdfstudent"))
  				{
        			toolkit = sampleCatalog.getCommand("PDF");
                    ctx.put(Keys.PDF_OUTPUT_OPTION,"-student");
   				}
        		
        		if (args.length > 3 && args[3] != null)
        		{
        			ctx.put(Keys.OUTPUT_DIRECTORY, args[3]);
        		}
        	}

            toolkit.execute(ctx);
        }
        catch (Exception e)
        {
            e.printStackTrace();
            System.out.println(e.getCause().toString());
        }
    }

}
