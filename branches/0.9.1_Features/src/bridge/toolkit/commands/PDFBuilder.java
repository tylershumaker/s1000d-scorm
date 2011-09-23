/**
 * This file is part of the S1000D-SCORM Bridge Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.xml.transform.Transformer;
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
import org.xhtmlrenderer.pdf.ITextRenderer;

import com.itextpdf.text.DocumentException;

import bridge.toolkit.packaging.ContentPackageCreator;
import bridge.toolkit.util.CopyDirectory;
import bridge.toolkit.util.DMParser;
import bridge.toolkit.util.Keys;
import bridge.toolkit.util.StylesheetApplier;
import bridge.toolkit.util.URNMapper;

/**
 *
 */
public class PDFBuilder implements Command
{
    /**
     * JDOM Document that is used to create the urn_resource_map.xml file.
     */
    private static Document urn_map;

    /**
     * File that represents the location of the resource package.
     */
    private static File src_dir;
    
    /**
     * String that represents the location of the SCPM file;
     */
    private static String scpm_file;
    
    /**
     * CSS that is applied to the data modules to produce the PDF output
     */
    final String STUDENTPDFSTYLESHEET = "s1000d_student.css";
    
    /**
     * Location of the XSLT transform file.
     */
    private static final String TRANSFORM_FILE = "preProcessTransform.xsl";
    
    /**
     * JDOM Document that is used to create the imsmanifest.xml file.
     */
    private static Document manifest;
    
    /**
     * InputStream for the xsl file that is used to transform the SCPM file to 
     * an imsmanifest.xml file.
     */
    private static InputStream transform;
    
    /**
     * CSS that is applied to the data modules to produce the PDF output
     */
    final String INSTRUCTORPDFSTYLESHEET = "s1000d_instructor.css";
    
    /**
     * Message that is returned if the PDFBuilder is unsuccessful.
     */
    private static final String PDFBUILDER_FAILED = "PDFBuilder processing was unsuccessful";
    
    /** 
     * @see org.apache.commons.chain.Command#execute(org.apache.commons.chain.Context)
     */
    @Override
    public boolean execute(Context ctx) 
    {
    	System.out.println("Executing PDF Builder");
        String resource_dir = (String) ctx.get(Keys.RESOURCE_PACKAGE);
        ContentPackageCreator cpc = new ContentPackageCreator(resource_dir);
        try
        {
            src_dir = cpc.createPackage();
        }
        catch (IOException e1)
        {
            System.out.println(PDFBUILDER_FAILED);
            e1.printStackTrace();
            return PROCESSING_COMPLETE;
        }
        catch (JDOMException e1)
        {
            System.out.println(PDFBUILDER_FAILED);
            e1.printStackTrace();
            return PROCESSING_COMPLETE;
        }
        
        scpm_file = (String) ctx.get(Keys.SCPM_FILE);
        
        List<File> src_files = new ArrayList<File>();
        try
        {
            src_files = URNMapper.getSourceFiles(resource_dir);
        }
        catch (NullPointerException npe)
        {
            System.out.println(PDFBUILDER_FAILED);
            System.out.println("The 'Resource Package' is empty.");
            return PROCESSING_COMPLETE;
        }
        catch (JDOMException e)
        {
            System.out.println(PDFBUILDER_FAILED);
            e.printStackTrace();
            return PROCESSING_COMPLETE;
        }
        catch (IOException e)
        {
            System.out.println(PDFBUILDER_FAILED);
            e.printStackTrace();
            return PROCESSING_COMPLETE;
        }

        urn_map = URNMapper.writeURNMap(src_files, "");
        String Stylesheet = ""; 
        String filenameending = "";
        try
        {
	        //Apply css to the data modules
	        StylesheetApplier sa = new StylesheetApplier();
	        if (((String)ctx.get(Keys.PDF_OUTPUT_OPTION)) == "-instructor")
	        {
	        	sa.applyStylesheetToDMCs(src_dir, INSTRUCTORPDFSTYLESHEET, "css", " media='all'");
	        	Stylesheet = INSTRUCTORPDFSTYLESHEET;
	        	filenameending = "-instructor";
	        }
	        else
	        {
	        	sa.applyStylesheetToDMCs(src_dir, STUDENTPDFSTYLESHEET, "css", " media='all'");
	        	Stylesheet = STUDENTPDFSTYLESHEET;
	        	filenameending = "-student";
	        }
        }
        catch (JDOMException e)
        {
            System.out.println(PDFBUILDER_FAILED);
            e.printStackTrace();
            return PROCESSING_COMPLETE;
        }
        catch (IOException e)
        {
        	System.out.println(PDFBUILDER_FAILED);
            e.printStackTrace();
            return PROCESSING_COMPLETE;
        }
        
        //Copy the css file to the data modules location
        try
        {
	        CopyDirectory cd = new CopyDirectory();
	        //check if the directory exists if it does use it else copy it from the jar
	        File pdfCss = new File(System.getProperty("user.dir") + File.separator + "pdfCSS" + File.separator + Stylesheet);
	        if (pdfCss.exists())
	        {
	        	cd.copyDirectory(pdfCss, new File(src_dir +File.separator + "resources" +File.separator + "s1000d"));
	        }
	        else
	        {
	        	cd.CopyJarFiles(this.getClass(), "pdfCSS", src_dir +File.separator + "resources" +File.separator + "s1000d");
	        }
        }
        catch (FileNotFoundException e)
        {
        	System.out.println(PDFBUILDER_FAILED);
            e.printStackTrace();
            return PROCESSING_COMPLETE;
        }
        catch (IOException e)
        {
        	System.out.println(PDFBUILDER_FAILED);
            e.printStackTrace();
            return PROCESSING_COMPLETE;
        }
        
        try
        {
        	transform = this.getClass().getResourceAsStream(TRANSFORM_FILE);
        	doTransform(scpm_file);
        }
        catch (TransformerException e) 
        {
        	System.out.println(PDFBUILDER_FAILED);
            e.printStackTrace();
            return PROCESSING_COMPLETE;
		}
        catch (JDOMException e)
        {
            System.out.println("Content Package creation was unsuccessful");
            e.printStackTrace();
            return PROCESSING_COMPLETE;
        }
        catch (IOException e)
        {
        	System.out.println(PDFBUILDER_FAILED);
            e.printStackTrace();
            return PROCESSING_COMPLETE;
        }
        
        XMLOutputter imsoutputter = new XMLOutputter(Format.getPrettyFormat());
        File imsfile = new File(src_dir + File.separator +"imsmanifest.xml");
        try 
        {
            //writes the imsmanfest.xml file out to the content package
            FileWriter writer = new FileWriter(imsfile,false);
            imsoutputter.output(manifest, writer);
            writer.flush();
            writer.close();
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
        String FileName = title.getValue();
        
        try
        {
	        String outputPath = "";
	        if (ctx.get(Keys.OUTPUT_DIRECTORY) != null)
	        {
	        	outputPath = (String)ctx.get(Keys.OUTPUT_DIRECTORY);
	        	if (outputPath.length() > 0)
	        	{
	        		outputPath = outputPath + File.separator;
	        	}
	        }
	        
	        String outputFile = outputPath + FileName.trim() + filenameending + ".pdf";
	        OutputStream os = new FileOutputStream(outputFile);
	        ITextRenderer renderer = new ITextRenderer();
	        
	        DMParser dmp = new DMParser();
	        boolean created = false;
	        
	        xp = XPath.newInstance("//scoEntry[@scoEntryType='scot01']");
	        @SuppressWarnings("unchecked")
	        List<Element> scos = xp.selectNodes(dmp.getDoc(new File(scpm_file)));
	
	        Iterator<Element> iterator = scos.iterator();
	        while(iterator.hasNext())
	        {
	            Element sco = iterator.next();
	            sco.detach();
	            Document temp = new Document(sco);
	            List<String> dms = dmp.searchForDmRefs(temp);
	            Iterator<String> childIterator = dms.iterator();
	            
	            while(childIterator.hasNext())
	            {
	                String urnDM = childIterator.next();
	                xp = XPath.newInstance("//urn[@name='URN:S1000D:"+urnDM+"']");
	                Element urn = (Element)xp.selectSingleNode(urn_map);
	
	                File dataModule = new File(src_dir + File.separator + "resources" + File.separator +
	                        "s1000d" + File.separator + urn.getChild("target").getValue());
	                
	                xp = XPath.newInstance("//graphic");
	                Document dmDoc = dmp.getDoc(dataModule);
	                @SuppressWarnings("unchecked")
	                List<Element> graphics = xp.selectNodes(dmDoc);
	                
	                Iterator<Element> graphicIterator = graphics.iterator();
	                while(graphicIterator.hasNext())
	                {
	                    Element graphic = graphicIterator.next();
	                    Attribute infoEntityIdent = graphic.getAttribute("infoEntityIdent");
	                    
	                    Element graphicParent = graphic.getParentElement();
	                    Element img = new Element("img");
	                    Attribute src = new Attribute("src", "file:///" + src_dir + File.separator + "resources" + File.separator +
	                        "s1000d" + File.separator + infoEntityIdent.getValue() + ".jpg");
	                    img.setAttribute(src);
	                    graphicParent.addContent(img);
	
	                    XMLOutputter outputter = new XMLOutputter(Format.getRawFormat());
	
	                    File updatedDM = new File(src_dir + File.separator +"resources" + 
	                                       File.separator + "s1000d" + File.separator +
	                                       dataModule.getName());
	                    FileWriter writer = new FileWriter(updatedDM);
	                    outputter.output(dmDoc, writer);
	                    writer.close();
	                }
	                
	
	                renderer.setDocument(dataModule);
	                renderer.layout();
	                if(!created)
	                {
	                    renderer.createPDF(os, false);
	                    created = true;
	                }
	                else
	                {
	                    renderer.writeNextDocument();
	                }
	            }
	        }
	
	
	        // complete the PDF
	        renderer.finishPDF();
	        os.close(); 
	        System.out.println("Successfully created PDF");
        }
        catch (JDOMException e)
        {
            System.out.println(PDFBUILDER_FAILED);
            e.printStackTrace();
            return PROCESSING_COMPLETE;
        }
        catch (DocumentException e)
        {
        	System.out.println(PDFBUILDER_FAILED);
            e.printStackTrace();
            return PROCESSING_COMPLETE;
        }
        catch (FileNotFoundException e)
        {
        	System.out.println(PDFBUILDER_FAILED);
            e.printStackTrace();
            return PROCESSING_COMPLETE;
        }
        catch (IOException e)
        {
        	System.out.println(PDFBUILDER_FAILED);
            e.printStackTrace();
            return PROCESSING_COMPLETE;
        }
        catch (Exception e) 
        {
        	System.out.println(PDFBUILDER_FAILED);
            e.printStackTrace();
            return PROCESSING_COMPLETE;
        }
        return CONTINUE_PROCESSING;
    }
    
    
    /**
     * Performs the transformation of the S1000D file to the imsmanifest.xml.
     * 
     * @param scpm_source String that represents the location of the S1000D 
     * SCPM file.
     * @throws IOException
     * @throws JDOMException
     * @throws TransformerException
     */
    private static void doTransform(String scpm_source) throws IOException, JDOMException, TransformerException
    {
    	DMParser dmParser = new DMParser();
    	
        TransformerFactory tFactory = TransformerFactory.newInstance();

        Transformer transformer = tFactory.newTransformer(new StreamSource(transform));

        File the_manifest = File.createTempFile("imsmanifest", ".xml");

        transformer.transform(new StreamSource(scpm_source), new StreamResult(new FileOutputStream(the_manifest)));

        manifest = dmParser.getDoc(the_manifest);

    }

}
