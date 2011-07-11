/**
 * This file is part of the S1000D-SCORM Bridge Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;
import org.jdom.Attribute;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.jdom.xpath.XPath;
import org.xhtmlrenderer.pdf.ITextRenderer;

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
    final String PDFSTYLESHEET = "s1000d.css";
    
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

        String resource_dir = (String) ctx.get(Keys.RESOURCE_PACKAGE);
        ContentPackageCreator cpc = new ContentPackageCreator(resource_dir);
        src_dir = cpc.createPackage();
        scpm_file = (String) ctx.get(Keys.SCPM_FILE);
        System.out.println(src_dir.getAbsolutePath());
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

        urn_map = URNMapper.writeURNMap(src_files, "");
        
        try
        {
            
        
        //Apply css to the data modules
        StylesheetApplier sa = new StylesheetApplier();
        sa.applyStylesheetToDMCs(src_dir, PDFSTYLESHEET, "css", " media='all'");

        //Copy the css file to the data modules location
        CopyDirectory cd = new CopyDirectory();
        File pdfCss = new File(System.getProperty("user.dir") + File.separator + "pdfCSS" +
                File.separator + "s1000d.css");
        cd.copyDirectory(pdfCss, new File(src_dir +File.separator + "resources" +File.separator + "s1000d"));
        
        String outputFile = "out/doc.pdf";
        OutputStream os = new FileOutputStream(outputFile);
        ITextRenderer renderer = new ITextRenderer();
        
        DMParser dmp = new DMParser();
        boolean created = false;
        
        XPath xp = XPath.newInstance("//scoEntry[@scoEntryType='scot01']");
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
                //System.out.println(urnDM);
                //file:///C:/workspace2/0.9.1_Features/test_files/resource_package_slim/ICN-S1000DBIKE-AAA-DA20000-A-06RT9-00029-A-001-01.jpg 
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


//      String outputFile = "out/doc.pdf";
////      File out = new File(outputFile);
////      if(!out.exists())
////          out.mkdirs();
//      OutputStream os = new FileOutputStream(outputFile);
//      ITextRenderer renderer = new ITextRenderer();        
//        //\mobile\output17\1
//      File test = new File(System.getProperty("user.dir")+ "\\mobile\\output3\\8");
//      File[] list = test.listFiles();
//      boolean created = false;
//      for(File temp: list)
//      {
//          if(temp.getName().endsWith(".htm"))
//          {
//              FileInputStream is = new FileInputStream(temp);
//              Tidy tidy = new Tidy();
//              tidy.setXHTML(true);
//              ByteArrayOutputStream tidyOut = new ByteArrayOutputStream();
//              tidy.parse(is, tidyOut);
//
//              InputStream tidyIn = new ByteArrayInputStream(tidyOut.toByteArray());  
//              DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
//              
//              dbf.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", Boolean.FALSE);  
//              dbf.setFeature("http://xml.org/sax/features/validation", Boolean.FALSE);  
//              DocumentBuilder db = dbf.newDocumentBuilder();  
//              org.w3c.dom.Document doc = db.parse(tidyIn);  
//              
//              renderer.setDocument(doc, null);
//              renderer.layout();
//              
//              if(!created)
//              {
//                  renderer.createPDF(os, false);
//                  created = true;
//              }
//              else
//              {
//                  renderer.writeNextDocument();
//              }
//          }
//      }
        // complete the PDF
        renderer.finishPDF();
        os.close(); 
        }
        catch (Exception e) {
            // TODO: handle exception
            System.out.println(e.getMessage());
        }
        return false;
    }

}
