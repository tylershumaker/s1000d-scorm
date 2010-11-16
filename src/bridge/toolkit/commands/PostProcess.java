/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;

import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;

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
            String xml = ctx.get(Keys.XML_SOURCE).toString();
            System.out.println("from " + this.getClass().getSimpleName() + ": " + xml);
            System.out.println("zip up package");
        }
        else
            System.out.println("Keys.XML_SOURCE was null");

        ctx.put(Keys.XML_SOURCE, "the xml doc from " + this.getClass().getSimpleName());

        return CONTINUE_PROCESSING;
    }
}
