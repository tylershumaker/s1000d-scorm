/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import java.io.File;
import java.io.FileWriter;
import java.util.List;

import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;
import org.jdom.Document;
import org.jdom.JDOMException;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

import bridge.toolkit.packaging.ContentPackageCreator;
import bridge.toolkit.util.Keys;
import bridge.toolkit.util.XMLParser;

/**
 * Builds the launchable learning resources (SCOs) from the DMs found in the 
 * SCPM.
 */
public class SCOBuilder implements Command
{


    /**
     * The unit of processing work to be performed for the SCOBuilder module.
     * 
     * @see org.apache.commons.chain.Command#execute(org.apache.commons.chain.Context)
     */
    @Override
    public boolean execute(Context ctx) throws Exception
    {

        if ((ctx.get(Keys.XML_SOURCE) != null) &&
            (ctx.get(Keys.RESOURCE_PACKAGE) != null))
        {
            //check to see if a cp_package directory exist yet
            if(ctx.get(Keys.CP_PACKAGE)== null)
            {
                
                ContentPackageCreator cpc = new ContentPackageCreator((String) ctx.get(Keys.RESOURCE_PACKAGE));
                File cpPackage = cpc.createPackage();
                ctx.put(Keys.CP_PACKAGE, cpPackage);
            }

            Document doc = (Document)ctx.get(Keys.XML_SOURCE);
            XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
            File temp = new File(System.getProperty("user.dir") + File.separator + "xsl//imsmanifest.xml");
            try
            {
                FileWriter writer = new FileWriter(temp, false);
                outputter.output(doc, writer);
                writer.flush();
                writer.close();
            }
            catch (java.io.IOException e)
            {
                e.printStackTrace();
            }                

            
        }
        else
            System.out.println("Keys.XML_SOURCE was null");

        //ctx.put(Keys.XML_SOURCE, "the xml doc from " + this.getClass().getSimpleName());

        return CONTINUE_PROCESSING;
    }

}
