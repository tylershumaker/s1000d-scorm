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
        Command toolkit = sampleCatalog.getCommand("SCORM");
        Context ctx = new ContextBase();
        
        //hardcoded files for iitsec demo, replace with args[0] and args[1] or other hardcoded files
        //ctx.put(Keys.SCPM_FILE, "c:\\toolkit_demo\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml");
        //ctx.put(Keys.RESOURCE_PACKAGE, "c:\\toolkit_demo\\bike_resource_package\\");
//        ctx.put(Keys.SCPM_FILE, "c:\\toolkit_demo\\scpm_slim\\SMC-S1000DBIKE-06RT9-00001-00.xml");
//        ctx.put(Keys.RESOURCE_PACKAGE, "c:\\toolkit_demo\\resource_package_slim\\");
        ctx.put(Keys.SCPM_FILE, args[0]);
        ctx.put(Keys.RESOURCE_PACKAGE, args[1]);
        try
        {
        
        	if (args.length > 2)
        	{
        		if (args[2] != null && args[2].equalsIgnoreCase("-scormflash"))
  				{
        			toolkit = sampleCatalog.getCommand("SCORM");
        			ctx.put(Keys.OUTPUT_TYPE, null);
   				}
        		else if (args[2] != null && args[2].equalsIgnoreCase("-scormhtml"))
  				{
        			toolkit = sampleCatalog.getCommand("SCORM");
        			ctx.put(Keys.OUTPUT_TYPE, "SCORMHTML");
   				}
        		else if (args[2] != null && args[2].equalsIgnoreCase("-mobile"))
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
        		
        		if (args.length > 4 && args[3] != null)
        		{
        			ctx.put(Keys.OUTPUT_DIRECTORY, args[3]);
        		}
        	}
        	
        	/*
            if(args.length>2 && args[2] != null && args[2].equals("-mobile"))
                toolkit = sampleCatalog.getCommand("Mobile");
            else if(args.length>2 && args[2] != null && args[2].equals("-pdfstudent"))
            {
                toolkit = sampleCatalog.getCommand("PDF");
                ctx.put(Keys.PDF_OUTPUT_OPTION,"-student");
            }
            else if(args.length>2 && args[2] != null && args[2].equals("-pdfinstructor"))
            {
                toolkit = sampleCatalog.getCommand("PDF");
                ctx.put(Keys.PDF_OUTPUT_OPTION,"-instructor");
            }
            else if(args.length>3 && args[3] != null && args[3].equals("-mobile"))
            {
                toolkit = sampleCatalog.getCommand("Mobile");
                ctx.put(Keys.OUTPUT_DIRECTORY, args[2]);
            }
            else if(args.length>3 && args[3] != null && args[3].equals("-pdfstudent"))
            {
                toolkit = sampleCatalog.getCommand("PDF");
                ctx.put(Keys.PDF_OUTPUT_OPTION,"-student");
                ctx.put(Keys.OUTPUT_DIRECTORY, args[2]);
            }
            else if(args.length>3 && args[3] != null && args[3].equals("-pdfinstructor"))
            {
                toolkit = sampleCatalog.getCommand("PDF");
                ctx.put(Keys.PDF_OUTPUT_OPTION,"-instructor");
                ctx.put(Keys.OUTPUT_DIRECTORY, args[2]);
            }
            else if(args.length>2 && args[2] != null)
            	ctx.put(Keys.OUTPUT_DIRECTORY, args[2]);
            
        	*/
            toolkit.execute(ctx);
        }
        catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
            System.out.println(e.getCause().toString());
        }
    }

}
