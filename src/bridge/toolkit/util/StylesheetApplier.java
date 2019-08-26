/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.util;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.jdom.DocType;
import org.jdom.Document;
import org.jdom.JDOMException;
import org.jdom.ProcessingInstruction;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

/**
 * Provides the ability to apply style sheets to the data modules. 
 */
public class StylesheetApplier
{

    /**
     * Applies the appropriate XSLT style sheet to the S1000D data modules 
     * so that they will be rendered in a human readable format in the SCORM
     * Content Package SCOs.
     * 
     * @param iBaseDir File that is the base directory for the data modules.
     * @param iStyleSheet String that represents the location of the style sheet to be added.
     * @throws JDOMException
     * @throws IOException
     */
    public void applyStylesheetToDMCs(File iBaseDir, String iStyleSheet) throws JDOMException, IOException
    {
        this.applyStylesheetToDMCs(iBaseDir, iStyleSheet, "xsl" ,"");
    }
    
    /**
     * Applies the appropriate XSLT style sheet to the S1000D data modules 
     * so that they will be rendered in a human readable format in the SCORM
     * Content Package SCOs.
     * 
     * @param iBaseDir File that is the base directory for the data modules.
     * @param iStyleSheet String that represents the location of the style sheet to be added.
     * @param iType String that represents the style sheet type. Either 'xsl' or 'css'.
     * @param iMediaType String that represents the entire media type attribute if needed to be included.
     * @throws JDOMException
     * @throws IOException
     */
    public void applyStylesheetToDMCs(File iBaseDir, String iStyleSheet, String iType, String iMediaType) throws JDOMException, IOException
    {

        File dm = new File(iBaseDir + File.separator + "resources" +
                           File.separator + "s1000d");
        
        File[] resources = dm.listFiles();
        for(File resource: resources)
        {
            if((!resource.isDirectory()) && (resource.getName().toLowerCase().endsWith(".xml")))
                    //(!resource.getName().contains("ICN")) && !resource.getName().endsWith(".ent"))
            {
                SAXBuilder parser = new SAXBuilder();
                parser.setExpandEntities(false);
                Document doc = parser.build(resource);
                String STYLESHEET = "xml-stylesheet";
                String STYLEPROCESSINGINSTRUCTION = "type='text/"+iType +"'"+ iMediaType +" href='";
                
                ProcessingInstruction stylesheet = new ProcessingInstruction(STYLESHEET, STYLEPROCESSINGINSTRUCTION+iStyleSheet+"'\n");
                DocType docType = doc.getDocType();
                if(docType!=null)
                {
                    //The JDOM parser converts the DocType and EntityRef from
                    //relative paths to absolute paths.  So the docType is remove
                    //then formated back to a relative path.
                    doc.removeContent(docType);
                    doc.setDocType(formatDocType(docType, resource));
                }
                doc.addContent(0,stylesheet);
                
                XMLOutputter outputter = new XMLOutputter(Format.getRawFormat());

                File temp = new File(iBaseDir + File.separator +"resources" + 
                                   File.separator + "s1000d" + File.separator +
                                   resource.getName());
                BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(temp), "UTF-8"));
                //FileWriter writer = new FileWriter(temp);
                outputter.output(doc, writer);
                writer.close();
            }
        }
        
    }
    
    
    /**
     * Formats the internal subset of the DocType of the S1000D data modules
     * so that they will render the correct content. 
     * 
     * @param docT DocType object after the JDOM SAXBuilder parses the data
     * module.
     * @param dm File object that represents the location of the data module 
     * file being modified. 
     * @return DocType object with the absolute paths removed from the 
     * internal subset.
     * @throws IOException
     */
    public DocType formatDocType(DocType docT, File dm) throws IOException
    {
         String org = docT.getInternalSubset();
    
         BufferedReader in = new BufferedReader(new StringReader(org));
    
         List<String> lines = new ArrayList<String>();
         String str;
         while ((str = in.readLine()) != null) 
         {
            lines.add(str);
         }
         in.close();
         
         StringBuffer internalSubset = new StringBuffer();
         Iterator<String> iterator = lines.iterator();
         while(iterator.hasNext())
         {
             String line = iterator.next();
             
             if(line.contains("NOTATION") && !line.contains("swf"))
             {
                 if(line.contains("swf") || line.contains("SWF"))
                 {
                     internalSubset.append(line);
                 }
                 else
                 {
                     String[] notation = line.split("\"");
                     String[] notationValue = notation[1].split("/");
                      
                     internalSubset.append(notation[0] + "'" +notationValue[notationValue.length-1].replaceAll("%20", " ")+"'>");                     
                 }
                 internalSubset.append("\n");
             }
             if(line.contains("ENTITY"))
             {
                 if(line.contains("ICN")) {
                     if (line.contains("\"")) {
                         String[] entity = line.split("\"");

                         String orgFileLoc = dm.getParent().replaceAll("\\\\", "/");
                         String[] entityValue = entity[1].split(orgFileLoc + "/");

                         internalSubset.append(entity[0] + "'" + entityValue[entityValue.length - 1].replaceAll("%20", " ") +
                                 "'" + entity[entity.length - 1]);
                         internalSubset.append("\n");
                     } else {
                         internalSubset.append(line);
                         internalSubset.append("\n");
                     }
                 }
            	 
             }
             
         }
         
         DocType newDocType = new DocType("dmodule");
         newDocType.setInternalSubset(internalSubset.toString());
         
         return newDocType;
    }
}
