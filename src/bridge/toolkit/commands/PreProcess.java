/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import static org.junit.Assert.assertFalse;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;
import org.jdom.Attribute;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.jdom.xpath.XPath;

import bridge.toolkit.ResourceMapException;
import bridge.toolkit.util.DMParser;
import bridge.toolkit.util.Keys;
import bridge.toolkit.util.XMLParser;

/**
 * The first module in the toolkit that transforms the SCPM into a XML structure
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
     * List of all the files in the resource package.
     */
    private List<File> resources = new ArrayList<File>();
    
    /**
     * Class that parses an S1000D DM file for any referenced ICN.
     */
    private DMParser dmParser;
    
    /**
     * Class that parses a XML document using JDOM.
     */
    private XMLParser xp;
    
    /**
     * Constructor
     */
    public PreProcess()
    {
        dmParser = new DMParser();
        xp = new XMLParser();
    }
    /**
     * The unit of processing work to be performed for the PreProcess module.
     * 
     * @see org.apache.commons.chain.Command#execute(org.apache.commons.chain.Context)
     */
    @Override
    public boolean execute(Context ctx) throws TransformerException,
            TransformerConfigurationException, FileNotFoundException, IOException
    {

        if ((ctx.get(Keys.SCPM_FILE)!= null) &&
        (ctx.get(Keys.RESOURCE_PACKAGE) != null))
        {
            try
            {
                createResourceMap((String)ctx.get(Keys.RESOURCE_PACKAGE));
            }
            catch (JDOMException e)
            {
                e.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            catch (ResourceMapException rme)
            {
                rme.printTrace();
                return PROCESSING_COMPLETE;
            }
            
            TransformerFactory tFactory = TransformerFactory.newInstance();
    
            Transformer transformer = tFactory.newTransformer(new StreamSource(TRANFORM_FILE));
    
            File manifest = new File("imsmanifest.xml");
            
            transformer.transform(new StreamSource((String) ctx.get(Keys.SCPM_FILE)), 
                    new StreamResult(new FileOutputStream(manifest)));
    
            ctx.put(Keys.XML_SOURCE, manifest);
            ctx.put(Keys.MEDIA_MAP, dmParser.getMedia());
            //ctx.put(Keys.REF_DM, dmParser.getReferencedDMs());
        }
        else
        {
            System.out.println("One of the required Context entries for the " +
                    this.getClass().getSimpleName()+" command to be executed was null");
            return PROCESSING_COMPLETE;
        }
        return CONTINUE_PROCESSING;
    }

    /**
     * Creates a urn_resource_map.xml file that is used in the XSLT transform 
     * to populate the file element href attribute in the imsmanifest.xml file
     * with the correct file name.
     * 
     * @param resourcePackage String that represents the location of the 
     * resource package provided to the toolkit.
     * @throws JDOMException
     * @throws ResourceMapException
     */
    public void createResourceMap(String resourcePackage) throws JDOMException, ResourceMapException
    {

        File resPackage = new File(resourcePackage);
        int resourcePath = resPackage.getPath().length();
        List<String> existingURNs = new ArrayList<String>();
        Document iDoc = new Document();
        Element urnResource = new Element("urn-resource");

        getDMCFiles(resPackage);
        Iterator<File> resIterator = resources.iterator();

        while(resIterator.hasNext())
        {
            File fileName = resIterator.next();
            String urnFormat = generateURN(fileName);
            
            if(!existingURNs.contains(urnFormat))
            {
                Element urn = new Element("urn");
                urn.setAttribute(new Attribute("name", urnFormat));
                Element target = new Element("target");
                Attribute type = new Attribute("type","figure");
                target.setAttribute(type);
                target.setText("resources" + File.separator + fileName.getAbsolutePath().substring(resourcePath +1));
                urn.addContent(target);
                urnResource.addContent(urn);
                existingURNs.add(urnFormat);
            }
            else
            {
                iDoc.addContent(urnResource);
                String existingFile = ((Element) XPath.selectSingleNode(iDoc, "/urn-resource//urn[@name='"+urnFormat+"']")).getValue();
                // removes "resource/" from the file name
                existingFile = existingFile.substring(10);
                throw new ResourceMapException(urnFormat, fileName.getAbsolutePath().substring(resourcePath +1), existingFile);
            }
            
        }
        
        iDoc.addContent(urnResource);
        dmParser.parseDMs(resources);
        
        XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
        File temp = new File(System.getProperty("user.dir") + File.separator + "xsl//urn_resource_map.xml");
        try {
            FileWriter writer = new FileWriter(temp);
            outputter.output(iDoc, writer);
            writer.close();
        } catch (java.io.IOException e) {
            e.printStackTrace();
        }
        
    }
    
    /**
     * Walks through a data model and generates a URN based off of the dmCode.
     * 
     * @param iResource A S1000D data model file.
     * @return String that is the URN created.
     * @throws JDOMException
     */
    public String generateURN(File iResource) throws JDOMException
    {
        
        Document resource = xp.getDoc(iResource);
    	//Document resource = DMParser.getDoc(iResource);
        StringBuffer urn = new StringBuffer();
        urn.append("URN:S1000D:DMC-");
        
        urn.append(((Attribute)XPath.selectSingleNode(resource, 
            "/dmodule//identAndStatusSection//dmAddress//dmIdent//dmCode//@modelIdentCode")).getValue()+"-");
        urn.append(((Attribute)XPath.selectSingleNode(resource, 
            "/dmodule//identAndStatusSection//dmAddress//dmIdent//dmCode//@systemDiffCode")).getValue()+"-");
        urn.append(((Attribute)XPath.selectSingleNode(resource, 
            "/dmodule//identAndStatusSection//dmAddress//dmIdent//dmCode//@systemCode")).getValue()+"-");
        urn.append(((Attribute)XPath.selectSingleNode(resource, 
            "/dmodule//identAndStatusSection//dmAddress//dmIdent//dmCode//@subSystemCode")).getValue());
        urn.append(((Attribute)XPath.selectSingleNode(resource, 
            "/dmodule//identAndStatusSection//dmAddress//dmIdent//dmCode//@subSubSystemCode")).getValue()+"-");
        urn.append(((Attribute)XPath.selectSingleNode(resource, 
            "/dmodule//identAndStatusSection//dmAddress//dmIdent//dmCode//@assyCode")).getValue()+"-");
        urn.append(((Attribute)XPath.selectSingleNode(resource, 
            "/dmodule//identAndStatusSection//dmAddress//dmIdent//dmCode//@disassyCode")).getValue());
        urn.append(((Attribute)XPath.selectSingleNode(resource, 
            "/dmodule//identAndStatusSection//dmAddress//dmIdent//dmCode//@disassyCodeVariant")).getValue()+"-");
        urn.append(((Attribute)XPath.selectSingleNode(resource, 
            "/dmodule//identAndStatusSection//dmAddress//dmIdent//dmCode//@infoCode")).getValue());      
        urn.append(((Attribute)XPath.selectSingleNode(resource, 
            "/dmodule//identAndStatusSection//dmAddress//dmIdent//dmCode//@infoCodeVariant")).getValue()+"-");     
        urn.append(((Attribute)XPath.selectSingleNode(resource, 
            "/dmodule//identAndStatusSection//dmAddress//dmIdent//dmCode//@itemLocationCode")).getValue());   
        
        try
        {
            String learnCode = ((Attribute)XPath.selectSingleNode(resource, 
                "/dmodule//identAndStatusSection//dmAddress//dmIdent//dmCode//@learnCode")).getValue();
            String learnEventCode = ((Attribute)XPath.selectSingleNode(resource, 
            "/dmodule//identAndStatusSection//dmAddress//dmIdent//dmCode//@learnEventCode")).getValue();

            urn.append("-" + learnCode + learnEventCode);

        }
        catch (JDOMException e){}
        
        try
        {
            String issueNumber = ((Attribute)XPath.selectSingleNode(resource, 
                "/dmodule//identAndStatusSection//dmAddress//dmIdent//issueInfo//@issueNumber")).getValue();

            //urn.append("_I-" + issueNumber );
            urn.append("_" + issueNumber );

        }
        catch (JDOMException e){}
        
        try
        {
            String inWork = ((Attribute)XPath.selectSingleNode(resource, 
                "/dmodule//identAndStatusSection//dmAddress//dmIdent//issueInfo//@inWork")).getValue();

            //urn.append("_W-" + inWork );
            urn.append("-" + inWork );

        }
        catch (JDOMException e){}
        
        try
        {
            String languageIsoCode = ((Attribute)XPath.selectSingleNode(resource, 
                "/dmodule//identAndStatusSection//dmAddress//dmIdent//language//@languageIsoCode")).getValue();

            //urn.append("_L-" + languageIsoCode );
            urn.append("_" + languageIsoCode );

        }
        catch (JDOMException e){}
        
        try
        {
            String countryIsoCode = ((Attribute)XPath.selectSingleNode(resource, 
                "/dmodule//identAndStatusSection//dmAddress//dmIdent//language//@countryIsoCode")).getValue();

            //urn.append("_C-" + countryIsoCode );
            urn.append("-" + countryIsoCode );

        }
        catch (JDOMException e){}

        return urn.toString();
    }

    /**
     * Provides the file name for DMC file in the Resource Package
     * @param srcFile File that is the root of the Resource Package.
     */
    private void getDMCFiles(File srcFile)
    {
        if (srcFile.isDirectory()) 
        {
 
            String[] oChildren = srcFile.list();
            for (int i=0; i < oChildren.length; i++) 
            {
                getDMCFiles(new File(srcFile, oChildren[i]));
            }
        } 
        else 
        {
             if(srcFile.getName().endsWith(".xml"))
             resources.add(srcFile);
            
        }
        
    }
}
