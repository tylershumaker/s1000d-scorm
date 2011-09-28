/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.jdom.xpath.XPath;

import bridge.toolkit.packaging.ZipCreator;
import bridge.toolkit.util.CopyDirectory;
import bridge.toolkit.util.Keys;

/**
 * The last module in the toolkit that applys the SCORM Runtime files and 
 * creates the PIF file.  
 */
public class PostProcess implements Command
{
    /**
     * The unit of processing work to be performed for the PostProcess module.
     * @see org.apache.commons.chain.Command#execute(org.apache.commons.chain.Context)
     */
    @Override
    public boolean execute(Context ctx)
    {
    	System.out.println("Executing Post Process");
        if ((ctx.get(Keys.XML_SOURCE) != null) &&
            (ctx.get(Keys.CP_PACKAGE) != null))
        {
            File cpPackage = (File)ctx.get(Keys.CP_PACKAGE);
            
            Document manifest = (Document)ctx.get(Keys.XML_SOURCE);
            
            XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
            File temp = new File(cpPackage + File.separator +"imsmanifest.xml");
            try 
            {
                //writes the imsmanfest.xml file out to the content package
                FileWriter writer = new FileWriter(temp,false);
                outputter.output(manifest, writer);
                writer.flush();
                writer.close();
                
                //copies the required xsd files over to the content package
                CopyDirectory cd = new CopyDirectory();
                //check if the directory exists if it does use it else copy it from the jar
                File xsd_loc = new File(System.getProperty("user.dir") + File.separator + "xsd");
                if (xsd_loc.exists())
                {
                	cd.copyDirectory(xsd_loc, cpPackage);
                }
                else
                {
                	cd.CopyJarFiles(this.getClass(), "xsd", cpPackage.getAbsolutePath());
                }
            } 
            catch (java.io.IOException e) 
            {
                System.out.println("Content Package creation was unsuccessful");
                e.printStackTrace();
                return PROCESSING_COMPLETE;
            }

            //get the organization title from the manifest file 
            //replace any white spaces with 
            Element title = null;
            XPath xp = null;
            try
            {
                xp = XPath.newInstance("//ns:organization//ns:title");
                xp.addNamespace("ns", "http://www.imsglobal.org/xsd/imscp_v1p1");
                title = (Element) xp.selectSingleNode(manifest);
            }
            catch (JDOMException e)
            {
                System.out.println("Content Package creation was unsuccessful");
                e.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            String outputPath = "";
            if (ctx.get(Keys.OUTPUT_DIRECTORY) != null)
            {
            	outputPath = (String)ctx.get(Keys.OUTPUT_DIRECTORY);
            	if (outputPath.length() > 0)
            	{
            		outputPath = outputPath + File.separator;
            	}
            }
            File outputDir = new File(outputPath);
            if(!outputDir.exists())
            {
                outputDir.mkdirs();
            }    
            
            String zipName = title.getValue();
            zipName = zipName.replace(" ", "_").trim();
            zipName = zipName.replace("\n", "").trim();            
            File zip = new File(outputDir + File.separator + zipName + ".zip");
           
            ZipCreator zipCreator = new ZipCreator();
            try
            {
                zipCreator.zipFiles(cpPackage, zip);
            }
            catch (IOException e)
            {
                System.out.println("Content Package creation was unsuccessful");
                e.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            
            cpPackage.deleteOnExit();
            System.out.println("Content Package creation was successful");
        }
        else
        {
            System.out.println("Content Package creation was unsuccessful");
            System.out.println("One of the required Context entries for the " + this.getClass().getSimpleName()
                    + " command to be executed was null");
            return PROCESSING_COMPLETE;
        }
        return CONTINUE_PROCESSING;
    }

}
