/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

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
        System.out.println(this.getClass().getSimpleName());

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
            System.out.println(cp.getAbsolutePath());

            CopyDirectory cd = new CopyDirectory();
            cd.copyDirectory(temp, cp);

            InputStream xsd = this.getClass().getResourceAsStream("lom.xsd");
            
            try
            {
                File xsd_loc = new File(convertStreamToString(xsd));
                cd.copyDirectory(xsd_loc, cp);
            }
            catch (Exception e)
            {
                // TODO Auto-generated catch block
                e.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            //temp.delete();
            temp.deleteOnExit();
            
            ZipCreator zipCreator = new ZipCreator();
            zipCreator.setPackageLocation(cp.getAbsolutePath());
            zipCreator.zipFiles();
            
            cp.deleteOnExit();
            System.out.println("zip up package");
        }
        else
        {
            System.out.println("Keys.XML_SOURCE was null");
        }

        return CONTINUE_PROCESSING;
    }

    public static String convertStreamToString(InputStream is) throws Exception 
    {
        BufferedReader reader = new BufferedReader(new InputStreamReader(is));
        StringBuilder sb = new StringBuilder();
        String line = null;
        while ((line = reader.readLine()) != null) 
        {
          sb.append(line + "\n");
        }
        is.close();
        return sb.toString();
      }

}
