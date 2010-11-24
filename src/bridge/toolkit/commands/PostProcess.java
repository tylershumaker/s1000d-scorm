/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;

import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;
import org.jdom.Document;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

import bridge.toolkit.packaging.ContentPackageCreator;
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
    public boolean execute(Context ctx) throws TransformerException,
            TransformerConfigurationException, FileNotFoundException, IOException
    {

        if (ctx.get(Keys.XML_SOURCE) != null)
        {
            //check to see if a cp_package directory exist yet
            if(ctx.get(Keys.CP_PACKAGE)== null)
            {
                
                ContentPackageCreator cpc = new ContentPackageCreator((String) ctx.get(Keys.RESOURCE_PACKAGE));
                File cpPackage = cpc.createPackage();
                ctx.put(Keys.CP_PACKAGE, cpPackage);
            }
            
            Document manifest = (Document)ctx.get(Keys.XML_SOURCE);
            
            XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
            File temp = new File("imsmanifest.xml");
            try {
                FileWriter writer = new FileWriter(temp,false);
                outputter.output(manifest, writer);
                writer.flush();
                writer.close();
            } 
            catch (java.io.IOException e) 
            {
                e.printStackTrace();
            }

            File cp = (File)ctx.get(Keys.CP_PACKAGE);

            CopyDirectory cd = new CopyDirectory();
            cd.copyDirectory(temp, cp);

            File xsd_loc = new File(System.getProperty("user.dir") + File.separator +
                   "xsd");
            cd.copyDirectory(xsd_loc, cp);
            
            //temp.delete();
            temp.deleteOnExit();
            
            ZipCreator zipCreator = new ZipCreator();
            zipCreator.setPackageLocation(cp.getAbsolutePath());
            zipCreator.zipFiles();
            
            cp.deleteOnExit();
            System.out.println("CONTENT PACKAGE CREATION SUCCESSFULL");
        }
        else
        {
            System.out.println("Keys.XML_SOURCE was null");
        }

        return CONTINUE_PROCESSING;
    }

    private List<String> getxsdFiles()
    {
        List<String> files = new ArrayList<String>();
        files.add("adlcp_v1p3.xsd");
        files.add("adlnav_v1p3.xsd");
        files.add("adlseq_v1p3.xsd");
        files.add("lom.xsd");
        files.add("lomCustom.xsd");
        files.add("lomLoose.xsd");
        files.add("lomStrict.xsd");
        return files;
    }

}
