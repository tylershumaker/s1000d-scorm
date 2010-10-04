/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;

import bridge.toolkit.util.Keys;

/**
 * The first module in the toolkit that transforms the SCPM into a XML structur
 * to be used by the rest of the toolkit modules.
 */
public class PreProcess implements Command
{
    /**
     * Location of the XSLT transform file.
     */
    private static final String TRANFORM_FILE = System.getProperty("user.dir") + File.separator
            + "xsl\\preProcessTransform.xsl";

    /**
     * The unit of processing work to be performed for the PreProcess module.
     * 
     * @see org.apache.commons.chain.Command#execute(org.apache.commons.chain.Context)
     */
    @Override
    public boolean execute(Context ctx) throws TransformerException,
            TransformerConfigurationException, FileNotFoundException, IOException
    {

        if (ctx.get(Keys.SCPM_FILE)!= null)
        {
            TransformerFactory tFactory = TransformerFactory.newInstance();
    
            Transformer transformer = tFactory.newTransformer(new StreamSource(TRANFORM_FILE));
    
            File manifest = new File("imsmanifest.xml");
            
            transformer.transform(new StreamSource((String) ctx.get(Keys.SCPM_FILE)), 
                    new StreamResult(new FileOutputStream(manifest)));
    
            ctx.put(Keys.XML_SOURCE, manifest);
        }
        else
        {
            System.out.println("One of the required Context entries for the " +
                    this.getClass().getSimpleName()+" command to be executed was null");
            return PROCESSING_COMPLETE;
        }
        return CONTINUE_PROCESSING;
    }
}
