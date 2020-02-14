/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import bridge.toolkit.util.DMParser;
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
     * JDOM Document that is used for the S1000D SCPM file.
     */
    Document scpm;

    /**
     * Provides a way to parse S1000D files and to find data model codes.
     */
    DMParser dmp;
    /**
     * The unit of processing work to be performed for the PostProcess module.
     * @see org.apache.commons.chain.Command#execute(org.apache.commons.chain.Context)
     */
    @Override
    public boolean execute(Context ctx)
    {
    	System.out.println("Executing Post Process");
        if ((ctx.get(Keys.XML_SOURCE) != null) &&
            (ctx.get(Keys.CP_PACKAGE) != null) && (ctx.get(Keys.SCPM_FILE) != null))
        {
            File cpPackage = (File)ctx.get(Keys.CP_PACKAGE);
            
            Document manifest = (Document)ctx.get(Keys.XML_SOURCE);
            
            XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
            File temp = new File(cpPackage + File.separator +"imsmanifest.xml");
            try {
                //writes the imsmanfest.xml file out to the content package
                FileWriter writer = new FileWriter(temp, false);
                outputter.output(manifest, writer);
                writer.flush();
                writer.close();

                if (ctx.get(Keys.OUTPUT_TYPE) == "SCORM12") {
                    //copies the required xsd files over to the content package
                    CopyDirectory cd = new CopyDirectory();
                    //check if the directory exists if it does use it else copy it from the jar
                    File xsd_loc = new File(System.getProperty("user.dir") + File.separator + "xsd_12");
                    if (xsd_loc.exists()) {
                        cd.copyDirectory(xsd_loc, cpPackage);
                    } else {
                        cd.CopyJarFiles(this.getClass(), "xsd_12", cpPackage.getAbsolutePath());
                    }
                } else {
                    //copies the required xsd files over to the content package
                    CopyDirectory cd = new CopyDirectory();
                    //check if the directory exists if it does use it else copy it from the jar
                    File xsd_loc = new File(System.getProperty("user.dir") + File.separator + "xsd");
                    if (xsd_loc.exists()) {
                        cd.copyDirectory(xsd_loc, cpPackage);
                    } else {
                        cd.CopyJarFiles(this.getClass(), "xsd", cpPackage.getAbsolutePath());
                    }
                }
            }
            catch (java.io.IOException e) 
            {
                System.out.println("Content Package creation was unsuccessful");
                e.printStackTrace();
                return PROCESSING_COMPLETE;
            }

            dmp = new DMParser();
            File scpmFile = new File((String) ctx.get(Keys.SCPM_FILE));

            XPath xp = null;
            String zipName = "";
            try
            {
                scpm = dmp.getDoc(scpmFile);
                xp = XPath.newInstance("scormContentPackage//identAndStatusSection//scormContentPackageAddress//scormContentPackageIdent//scormContentPackageCode");
                Element scormContentPackageCode = (Element) xp.selectSingleNode(scpm);
                xp = XPath.newInstance("scormContentPackage//identAndStatusSection//scormContentPackageAddress//scormContentPackageIdent//issueInfo");
                Element issueInfo = (Element) xp.selectSingleNode(scpm);
                StringBuilder packageCode = new StringBuilder();
                packageCode.append(scormContentPackageCode.getAttributeValue("modelIdentCode"));
                packageCode.append("-");
                packageCode.append(scormContentPackageCode.getAttributeValue("scormContentPackageNumber"));
                packageCode.append("-");
                packageCode.append(scormContentPackageCode.getAttributeValue("scormContentPackageIssuer"));
                packageCode.append("-");
                packageCode.append(scormContentPackageCode.getAttributeValue("scormContentPackageVolume"));
                packageCode.append("_");
                packageCode.append(issueInfo.getAttributeValue("issueNumber"));
                packageCode.append("-");
                packageCode.append(issueInfo.getAttributeValue("inWork"));
                zipName = packageCode.toString();
            }
            catch (JDOMException e)
            {
                System.out.println("Content Package creation was unsuccessful");
                e.printStackTrace();
                return PROCESSING_COMPLETE;
            }catch (IOException ioe) {
                System.out.println("Content Package creation was unsuccessful");
                ioe.printStackTrace();
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
            
            zipName = zipName.replace(" ", "_").trim();
            zipName = zipName.replace("\n", "").trim();    
            
            File zip = new File(zipName + ".zip");
            if(!outputDir.getName().equals(""))
                zip = new File(outputDir + File.separator + zipName + ".zip");
           
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
