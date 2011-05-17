/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
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

import bridge.toolkit.util.CopyDirectory;
import bridge.toolkit.util.DMParser;
import bridge.toolkit.util.Keys;
import bridge.toolkit.util.URNMapper;

/**
 * Builds a HTML, CSS, and JQueryMobile based mobile web app output from the S1000D SCPM and referenced
 * data modules. 
 */
public class MobileBuilder implements Command
{

    /**
     * Location of the XSLT transform file used to transform the SCPM to mobile app html file.
     */
    private static final String SCPM_TRANSFORM_FILE = "scpmStylesheet.mobile.xsl";
    
    /**
     * Location of the XSLT transform file used to transform the data modules to mobile app html file.
     */
    private static final String DM_TRANSFORM_FILE = "dmStylesheet.mobile.xsl";
    
    /**
     * InputStream for the xsl file that is used to transform the SCPM file and data modules
     * to mobile app html files.
     */
    private static InputStream transform;
    
    /**
     * JDOM Document that is used to create the urn_resource_map.xml file.
     */
    private static Document urn_map;

    /**
     * String that represents the location of the resource package.
     */
    private static String src_dir;
    
    /**
     * String that represents the location of the SCPM file;
     */
    private static String scpm_file;
    
    /**
     * List of Strings that represent the files generated to produce the mobile app output.
     */
    private List<String> mobileList = new ArrayList<String>();

    /**
     * Message that is returned if the MobileBuilder is unsuccessful.
     */
    private static final String MOBILEBUILDER_FAILED = "MobileBuilder processing was unsuccessful";

    /** 
     * The unit of processing work to be performed for the MobileBuilder module.
     * 
     * @see org.apache.commons.chain.Command#execute(org.apache.commons.chain.Context)
     */
    @Override
    public boolean execute(Context ctx)
    {
        if ((ctx.get(Keys.SCPM_FILE) != null) && (ctx.get(Keys.RESOURCE_PACKAGE) != null))
        {

            src_dir = (String) ctx.get(Keys.RESOURCE_PACKAGE);
            scpm_file = (String) ctx.get(Keys.SCPM_FILE);

            List<File> src_files = new ArrayList<File>();
            try
            {
                src_files = URNMapper.getSourceFiles(src_dir);
            }
            catch (NullPointerException npe)
            {
                System.out.println(MOBILEBUILDER_FAILED);
                System.out.println("The 'Resource Package' is empty.");
                return PROCESSING_COMPLETE;
            }

            urn_map = URNMapper.writeURNMap(src_files, "../media/");
            
            //write urn map file out to the ViewerApplication directory temporarily.  
            File js = new File(System.getProperty("user.dir") + File.separator + "ViewerApplication/app/urn_resource_map.xml");
            XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
            FileWriter writer;
            try
            {
                writer = new FileWriter(js);
                outputter.output(urn_map, writer);
                writer.flush();
                writer.close();
            }
            catch (IOException e)
            {
                System.out.println(MOBILEBUILDER_FAILED);
                e.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            
            //create new directory and folder for mobile_output
            File newMobApp = createOutputLocation();

            //transform SCPM to main index.htm file
            try
            {
                transformSCPM(newMobApp);
            }
            catch (FileNotFoundException e)
            {
                System.out.println(MOBILEBUILDER_FAILED);
                e.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            catch (TransformerConfigurationException e1)
            {
                System.out.println(MOBILEBUILDER_FAILED);
                e1.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            catch (TransformerException e)
            {
                System.out.println(MOBILEBUILDER_FAILED);
                e.printStackTrace();
                return PROCESSING_COMPLETE;
            }

            //parse SCPM for list of files in each scoEntry to create the individual mobile app pages
            try
            {
                generateMobilePages(newMobApp);
            }
            catch (TransformerConfigurationException e2)
            {
                System.out.println(MOBILEBUILDER_FAILED);
                e2.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            catch (FileNotFoundException e2)
            {
                System.out.println(MOBILEBUILDER_FAILED);
                e2.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            catch (JDOMException e2)
            {
                System.out.println(MOBILEBUILDER_FAILED);
                e2.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            catch (IOException e2)
            {
                System.out.println(MOBILEBUILDER_FAILED);
                e2.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            catch (TransformerFactoryConfigurationError e2)
            {
                System.out.println(MOBILEBUILDER_FAILED);
                e2.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            catch (TransformerException e2)
            {
                System.out.println(MOBILEBUILDER_FAILED);
                e2.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            
            //create list.js file
            try
            {
                generateListFile(newMobApp);
            }
            catch (IOException e1)
            {
                System.out.println(MOBILEBUILDER_FAILED);
                e1.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            catch (JDOMException e1)
            {
                System.out.println(MOBILEBUILDER_FAILED);
                e1.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            
            try
            {
                //copy over css and jquery mobile files
                CopyDirectory cd = new CopyDirectory();
                File mobiApp_loc = new File(System.getProperty("user.dir") + File.separator +
                "mobiApp");
                cd.copyDirectory(mobiApp_loc, newMobApp);
                
                //copy common.css from the ViewerApplication to the mobile output
                File common_css = new File(System.getProperty("user.dir") + File.separator + 
                        "ViewerApplication" + File.separator + "app" + File.separator + "common.css");
                cd.copyDirectory(common_css, newMobApp);
                
                //copy over media files
                File new_media_loc = new File(newMobApp.getAbsolutePath() + File.separator + "media");
                new_media_loc.mkdir();
                Iterator<File> srcIterator = src_files.iterator();
                while(srcIterator.hasNext())
                {
                    File src = srcIterator.next();
                    if(!src.getName().endsWith(".xml") && 
                       !src.getName().endsWith(".XML"))
                    {
                        cd.copyDirectory(src, new_media_loc);
                    }
                }

            }
            catch (IOException e)
            {
                System.out.println(MOBILEBUILDER_FAILED);
                e.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            
            //delete the urn map from the ViewerApplication location
            js.deleteOnExit();
            System.out.println("MobileBuilder processing was successful");
        }
        return CONTINUE_PROCESSING;

    }
    
    /**
     * Creates a new directory and folder for the mobile output
     * @return File object that represents the location of the mobile output.
     */
    private File createOutputLocation()
    {
        File mobileLocation = new File("mobile");
        if(!mobileLocation.exists())
        {
            mobileLocation.mkdirs();
        }
        
        String newOutput = "output";
        int numberOfPackages = 0;
        String[] outputs = mobileLocation.list();
        File mNewMobApp;
        if(outputs.length >= 1)
        {
            for(String name : outputs)
            {
                String temp = name.substring(newOutput.length());
                int currentNum = Integer.parseInt(temp);
                if(currentNum >= numberOfPackages)
                {
                    numberOfPackages = currentNum + 1;
                }
            }
            
            mNewMobApp = new File(mobileLocation +File.separator + newOutput + numberOfPackages);
            mNewMobApp.mkdirs();
        }
        else
        {
            mNewMobApp = new File(mobileLocation +File.separator + newOutput + "1");
            mNewMobApp.mkdirs();
        }
        
        return mNewMobApp;
    }
    
    /**
     * Transforms the SCPM to index.htm file that is the home page for the mobile output.
     * 
     * @param newMobApp File object that represents the location of the mobile output.
     * @throws FileNotFoundException
     * @throws TransformerException
     */
    private void transformSCPM(File newMobApp) throws FileNotFoundException, TransformerException
    {
        transform = this.getClass().getResourceAsStream(SCPM_TRANSFORM_FILE);
        File index = new File(newMobApp +File.separator +"index.htm");
        mobileList.add("index.htm");
        TransformerFactory tFactory = TransformerFactory.newInstance();
        Transformer transformer = tFactory.newTransformer(new StreamSource(transform));
        transformer.transform(new StreamSource(scpm_file), new StreamResult(new FileOutputStream(index)));
    }
    
    /**
     * Parse the SCPM file for the list of files in each scoEntry to create the 
     * individual mobile app pages.
     * 
     * @param newMobApp File object that represents the location of the mobile output.
     * @throws JDOMException
     * @throws TransformerException
     * @throws IOException
     */
    private void generateMobilePages(File newMobApp) throws JDOMException, TransformerException, IOException
    {
        DMParser dmp = new DMParser();
        
        XPath xp = XPath.newInstance("//scoEntry[@scoEntryType='scot01']");
        @SuppressWarnings("unchecked")
        List<Element> scos = xp.selectNodes(dmp.getDoc(new File(scpm_file)));
        
        int folderCount = 1;
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
                xp = XPath.newInstance("//urn[@name='URN:S1000D:"+urnDM+"']");
                Element urn = (Element)xp.selectSingleNode(urn_map);
                
                //System.out.println(urn.getChild("target").getValue());
                
                //The mobile output is meant to be performance support material so all assessments will not be included
                //checks to see if the data module is an overview assessment (post test or pre test) as indicated by the learnEventCode = E
                //or by the learnCode of T87 (Pre test), T88 (post test) or T28 (Terminal Objective).
                //T28 data modules were used in the S1000D bike example to indicate the post test assessments
                //If it an assessment the data module is not transformed and not included in the mobile output
                File dataModule = new File(src_dir + File.separator + urn.getChild("target").getValue());
                Document currDM = dmp.getDoc(dataModule);
                xp = XPath.newInstance("//dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@learnEventCode");
                Attribute learnEventCode = (Attribute)xp.selectSingleNode(currDM);

                xp = XPath.newInstance("//dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@learnCode");
                Attribute learnCode = (Attribute)xp.selectSingleNode(currDM);
                
                if(learnEventCode==null || !learnEventCode.getValue().equals("E"))
                {
                    if(learnCode==null ||!learnCode.getValue().equals("T28"))
                    {
                        File newChild = new File(newMobApp + File.separator + Integer.toString(folderCount));
                        newChild.mkdir();
                        transform = this.getClass().getResourceAsStream(DM_TRANSFORM_FILE);
                        TransformerFactory tFactory = TransformerFactory.newInstance();
                        Transformer transformer = tFactory.newTransformer(new StreamSource(transform));

                        String htmName = urn.getChild("target").getValue() + ".htm";
                        File htmlFile = new File(newChild +File.separator + htmName); 
                        mobileList.add(newChild.getName() + "/" + htmName);
                        transformer.transform(new StreamSource(dataModule), 
                                              new StreamResult(new FileOutputStream(htmlFile)));

                        handleSlideShows(currDM, learnCode, dataModule, newChild);
                    }
                }
             
            }
            
            folderCount++;
        }
    }
    
    /**
     * Gathers the required ICN files and data modules needed for Flash slide shows that exist 
     * in the example data. 
     * 
     * @param currDM JDom Document object that represents the current data module being processed. 
     * @param learnCode JDome Attribute object that is found in the current data module's dmCode.
     * @param dataModule File object that represents the location of the current data module file.
     * @param newChild File object that represents the mobile output child folder that the current mobile
     * output files are being output to. 
     * @throws JDOMException
     * @throws IOException
     */
    private void handleSlideShows(Document currDM, Attribute learnCode, File dataModule, File newChild) throws JDOMException, IOException
    {
        //check to see if the levelledPara element exists in the data module
        XPath xp = XPath.newInstance("//levelledPara");
        Element levelledPara = (Element)xp.selectSingleNode(currDM);
        if(levelledPara != null && learnCode != null)
        {
            //check to see if the learnCode is T4J - Interactive Content Procedure
            //Exploratory interactive simulation, animation or video used to
            //provide the learner with a procedure to be learned.
            if(learnCode.getValue().equals("T4J"))
            {
                CopyDirectory cd = new CopyDirectory();
                cd.copyDirectory(dataModule, newChild);
                
                String org = currDM.getDocType().getInternalSubset();
                
                BufferedReader in = new BufferedReader(new StringReader(org));
           
                List<String> lines = new ArrayList<String>();
                String str;
                while ((str = in.readLine()) != null) 
                {
                   lines.add(str);
                }
                in.close();
                
                Iterator<String> iterator2 = lines.iterator();
                while(iterator2.hasNext())
                {
                    String line = iterator2.next();
                    
                    if(line.contains("ENTITY"))
                    {
                        String[] entity = line.split("\"");
                        String orgFileLoc = dataModule.getParent().replaceAll("\\\\", "/");
                        String[] entityValue = entity[1].split(orgFileLoc + "/");
                        
                        File media = new File(src_dir + File.separator + entityValue[entityValue.length-1].replaceAll("%20", " ").replaceAll("/", "\\\\"));
                        //File mediaLoc = new File(newChild.getAbsolutePath() + File.separator + "media");
                        //mediaLoc.mkdir();
                        if(!media.getName().contains(".swf"))
                            cd.copyDirectory(media, newChild);
                    }
                    
                }
            }
        }
    }
    
    /**
     * Generates a JavaScript file that is used to navigate between the data
     * modules in the mobile output. 
     * 
     * @throws IOException
     * @throws JDOMException
     */
    private void generateListFile(File mobAppDir) throws IOException, JDOMException
    {
        File js = new File(mobAppDir.getAbsolutePath() + File.separator + "list.js");

        FileWriter writer = new FileWriter(js);
        int count = 0;
        writer.write("var scoPages = new Array(" +mobileList.size() + ");\n");
        Iterator<String> pages = mobileList.iterator();
        while(pages.hasNext())
        {
            String nextPg = pages.next();
            // = \""+file+"\";\n"
            writer.write("scoPages[" + count + "] = \"" + nextPg + "\";\n");
            count++;
        }
        writer.write("function getArray()\n");
        writer.write("{\n return scoPages;\n}");
        writer.close();
        
    }
    
}
