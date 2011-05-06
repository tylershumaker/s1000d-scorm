/**
 * This file is part of the S1000D-SCORM Bridge Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;
import org.jdom.Attribute;
import org.jdom.DocType;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Namespace;
import org.jdom.ProcessingInstruction;

import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.jdom.xpath.XPath;

import bridge.toolkit.packaging.ContentPackageCreator;
import bridge.toolkit.util.CopyDirectory;
import bridge.toolkit.util.DMParser;
import bridge.toolkit.util.Keys;
import bridge.toolkit.util.StylesheetApplier;

/**
 * Builds the launchable learning resources (SCOs) from the DMs found in the 
 * SCPM.
 */
public class SCOBuilder implements Command
{

    /**
     * File that represents the location of the content package directory.
     */
    File cpPackage; 
    
    /**
     * List of Strings that represent the file found in the Viewer Application
     * directory. 
     */
    List<String> commonFiles = new ArrayList<String>();
    
    /**
     * JDOM Document that is used for the imsmanifest.xml file.
     */
    Document manifest;
    
    /**
     * JDOM Document that is used for the S1000D SCPM file.
     */
    Document scpm;
    
    /**
     * Provides a way to parse S1000D files and to find data model codes.
     */
    DMParser dmp; 
    
    /**
     * Message that is returned if the building of the SCOs is unsuccessful.
     */
    final String SCOBUILDER_FAILED = "SCOBuilder processing was unsuccessful";
    
    /**
     * SCORM CP XSLT StyleSheet to be applied to the data modules
     */
    final String CPSTYLESHEET = "app/s1000d_4.xslt";
    
    /**
     * The unit of processing work to be performed for the SCOBuilder module.
     * 
     * @see org.apache.commons.chain.Command#execute(org.apache.commons.chain.Context)
     */
    @Override
    public boolean execute(Context ctx)
    {

        if ((ctx.get(Keys.XML_SOURCE) != null) &&
            (ctx.get(Keys.RESOURCE_PACKAGE) != null) &&
            (ctx.get(Keys.SCPM_FILE) != null))
        {
            //check to see if a cp_package directory exist yet
            if(ctx.get(Keys.CP_PACKAGE)== null)
            {
                
                ContentPackageCreator cpc = new ContentPackageCreator((String) ctx.get(Keys.RESOURCE_PACKAGE));
                cpPackage = cpc.createPackage();
                ctx.put(Keys.CP_PACKAGE, cpPackage);
            }
            else
            {
                cpPackage = (File) ctx.get(Keys.CP_PACKAGE);
            }
            
            try
            {
                //copy necessary files over to CP folder
                copyViewerAppFiles();
                
                //apply the SCORM CP XSLT StyleSheet to the data modules
                StylesheetApplier sa = new StylesheetApplier();
                sa.applyStylesheetToDMCs(cpPackage, CPSTYLESHEET);
            
                //create list.js, add to CP
                dmp = new DMParser();
                manifest = (Document)ctx.get(Keys.XML_SOURCE);
                File scpmFile = new File((String)ctx.get(Keys.SCPM_FILE));
                scpm = dmp.getDoc(scpmFile);
            
                generateListFile();
            
                //write urn map to cp app location
                Document urn_map = (Document)ctx.get(Keys.URN_MAP);
                File js = new File(cpPackage + File.separator + "resources/s1000d/app/urn_resource_map.xml");
            
                XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
                FileWriter writer = new FileWriter(js);
                outputter.output(urn_map, writer);
                writer.flush();
                writer.close();
                commonFiles.add(js.getAbsolutePath());
                
                //add as a common resource element
                generateCommonResource();
            
                //build launchable htm files and add to manifest
                generateLaunchableFile();
            }
            catch (JDOMException e)
            {
                System.out.println(SCOBUILDER_FAILED);
                e.printStackTrace();
                return PROCESSING_COMPLETE;  
            }
            catch (IOException ioe)
            {
                System.out.println(SCOBUILDER_FAILED);
                ioe.printStackTrace();
                return PROCESSING_COMPLETE;  
            }


            
            ctx.put(Keys.XML_SOURCE, manifest);
            System.out.println("SCOBuilder processing was successful");
        }
        else
        {
            System.out.println(SCOBUILDER_FAILED);
            System.out.println("One of the required Context entries for the " + this.getClass().getSimpleName()
                    + " command to be executed was null");
            return PROCESSING_COMPLETE;
        }

        return CONTINUE_PROCESSING;
    }

    /**
     * Copies the Viewer Application files to the content package directory 
     * location.
     * 
     * @throws IOException
     */
    private void copyViewerAppFiles() throws IOException
    {
        File trainingContent = new File(System.getProperty("user.dir") + File.separator + "ViewerApplication");
        File cpTrainingContent = new File(cpPackage + File.separator + 
                                         "resources" + File.separator + 
                                         "s1000d");
        CopyDirectory cd = new CopyDirectory();
        cd.copyDirectory(trainingContent, cpTrainingContent);
        
        listViewerAppFiles(cpTrainingContent);

    }

   /**
     * Adds all of the Viewer Application files to a List that will be used to 
     * generate a common 'resource' element to be added to the imsmanifest.xml
     * file. 
     * 
     * @param srcFolder File object that represents the location of the 
     * Viewer Application files in the content package.  
     */
    private void listViewerAppFiles(File srcFolder)
    {
        
        if (srcFolder.isDirectory()) 
        {
            //ensures that hidden folders are not included
            if(!srcFolder.getName().contains("."))
            {
                String[] oChildren = srcFolder.list();
                for (int i=0; i < oChildren.length; i++) 
                {
                    listViewerAppFiles(new File(srcFolder, oChildren[i]));
                }
            }
        } 
        else 
        {
            if(srcFolder.getParent().contains("app") || 
               srcFolder.getParent().contains("Assessment_templates"))
            commonFiles.add(srcFolder.getAbsolutePath());
        }
    }
    
    /**
     * Generates a JavaScript file that is used to navigate between the data
     * modules inside of each SCO. 
     * 
     * @throws IOException
     * @throws JDOMException
     */
    private void generateListFile() throws IOException, JDOMException
    {
        File js = new File(cpPackage + File.separator + "resources/s1000d/app/list.js");
         
        //parse resource element to find file names...
        List<List<String>> sco_map = new ArrayList<List<String>>();

        XPath xp = XPath.newInstance("//scoEntry[@scoEntryType='scot01']");
        @SuppressWarnings("unchecked")
        List<Element> scos = xp.selectNodes(scpm);
        
        Iterator<Element> iterator = scos.iterator();
        while(iterator.hasNext())
        {
            Element sco = iterator.next();
            sco.detach();
            Document temp = new Document(sco);
            List<String> dms = dmp.searchForDmRefs(temp);
            sco_map.add(dms);
        }

        
        List<List<String>> scoPages = new ArrayList<List<String>>();
        List<String> page;
        xp = null;
        Iterator<List<String>> iter = sco_map.iterator();
        while (iter.hasNext())
        {
            List<String> scoList = iter.next();
            page = new ArrayList<String>();
            Iterator<String> value = scoList.iterator();
            while (value.hasNext())
            {
                Element resource = null;
                String str_current = value.next();
                xp = XPath.newInstance("//ns:resource[@identifier='" + str_current + "']");
                xp.addNamespace("ns", "http://www.imsglobal.org/xsd/imscp_v1p1");
                resource = (Element) xp.selectSingleNode(manifest);

                String[] resource_path = resource.getAttributeValue("href").split("/");
                
                page.add("../" + resource_path[resource_path.length-1]);
                
            }
            scoPages.add(page);
        }

        FileWriter writer = new FileWriter(js);
        int count = 0;
        writer.write("var scoPages = new Array(" +scoPages.size() + ");\n");
        Iterator<List<String>> pages = scoPages.iterator();
        while(pages.hasNext())
        {
            List<String> nextPg = pages.next();
            writer.write("scoPages[" + count + "] = new Array(" + nextPg.size() + ");\n");
            Iterator<String> nextPgIterator = nextPg.iterator();
            int numfile = 0;
            while(nextPgIterator.hasNext())
            {
                String file = nextPgIterator.next();
                writer.write("scoPages[" + count + "]["+numfile+"] = \""+file+"\";\n");
                numfile++;
            }
            count++;
        }
        writer.write("function getArray()\n");
        writer.write("{\n return scoPages;\n}");
        writer.close();

        
        commonFiles.add(js.getAbsolutePath());
    }
    
    /**
     * Generates a common 'resource' element that contains all of the files
     * in the View Application and adds a dependency element for the 
     * RES-common-files to all resource elements that have scormType = 'sco'.
     * 
     * @throws JDOMException
     */
    private void generateCommonResource() throws JDOMException
    {
        Element resources = manifest.getRootElement().getChild("resources", null);
        Namespace ns = manifest.getRootElement().getNamespace();
        Namespace adlcpNS = Namespace.getNamespace("adlcp", "http://www.adlnet.org/xsd/adlcp_v1p3");
        String commonFilesID = "RES-common-files";
        
        Element commonResource = new Element("resource");
        commonResource.setAttribute(new Attribute("identifier", commonFilesID));
        commonResource.setAttribute(new Attribute("type", "webcontent"));
        commonResource.setAttribute(new Attribute("scormType", "asset", adlcpNS));

        Iterator<String> iterator = commonFiles.iterator();
        while(iterator.hasNext())
        {
            String file = iterator.next();
            file = file.replace("\\", "/");
            String[] split = file.split(cpPackage.getName()+"/");
            Element fileElement = new Element("file", ns);
            fileElement.setAttribute(new Attribute("href", split[1]));
            commonResource.addContent(fileElement);
        }
        commonResource.setNamespace(ns);
        resources.addContent(commonResource);
        
        //add a dependency element for the RES-common-files to all resource 
        //elements that have scormType = 'sco'
        Iterator<Element> scoResIterator = findSCOResources();
        while(scoResIterator.hasNext())
        {
            Element resource = scoResIterator.next();
            Element dependency = new Element("dependency");
            dependency.setAttribute("identifierref", commonFilesID);
            dependency.setNamespace(ns);
            resource.addContent(dependency);
        }
        
    }    
    
    /**
     * Searches through the imsmanifest.xml file for all of the 'resource' 
     * elements that have scormType = 'sco'.
     * 
     * @return Iterator<Element> Iterator of JDOM Elements that are 'resource'
     * elements with scormType = 'sco'.
     * @throws JDOMException
     */
    private Iterator<Element> findSCOResources() throws JDOMException
    {
        XPath xp = XPath.newInstance("//ns:resource[@adlcpNS:scormType='sco']");
        xp.addNamespace("ns", "http://www.imsglobal.org/xsd/imscp_v1p1");
        xp.addNamespace("adlcpNS", "http://www.adlnet.org/xsd/adlcp_v1p3");
        
        return xp.selectNodes(manifest).iterator();
    }
    
    /**
     * Generates a unique htm file for each 'resource' element that has 
     * scormType = 'sco' found in the imsmanifest.xml file and applies the 
     * unique htm file name to the 'href' values for each of the SCO 'resource'
     * elements.  
     * 
     * @throws JDOMException
     * @throws IOException
     */
    private void generateLaunchableFile() throws JDOMException, IOException
    {
        int scoCounter = 0;
        Iterator<Element> scoResIterator = findSCOResources();
        while(scoResIterator.hasNext())
        {
            Element resource = scoResIterator.next();
            //replace href and file href
            Namespace ns = manifest.getRootElement().getNamespace();
            resource.setAttribute("href", 
                    "resources/scos/index" + scoCounter +".htm");
            XPath xp = XPath.newInstance("//ns:file[@href='TODO:ref_to_SCO_goes_here']");
            xp.addNamespace("ns", "http://www.imsglobal.org/xsd/imscp_v1p1");
            Element file = (Element)xp.selectSingleNode(resource);
            file.setAttribute("href",
                    "resources/scos/index" + scoCounter +".htm");
            
            buildHTMLFile(scoCounter);
            scoCounter++;
        }
    }
    
    /**
     * Builds an unique htm file for each 'resource' element that has 
     * scormType = 'sco' found in the imsmanifest.xml file.  
     * 
     * @param scoNum
     * @throws IOException 
     */
    public void buildHTMLFile(int scoNum) throws IOException
    {
        String num = Integer.toString(scoNum);
        Element html = new Element("html");
            Element head = new Element("head");
                Element script = new Element("script");
                List<Attribute> scriptAtts = new ArrayList<Attribute>();
                scriptAtts.add(new Attribute("language","javascript"));
                scriptAtts.add(new Attribute("src","../s1000d/app/navScript.js"));
                script.setAttributes(scriptAtts);
                script.addContent("/*        */");
           head.addContent(script);
           html.addContent(head);
            Element frameset = new Element("frameset");
            List<Attribute> framesetAtts = new ArrayList<Attribute>();
            framesetAtts.add(new Attribute("id","toolkit"));
            framesetAtts.add(new Attribute("rows","43,*,35"));
            frameset.setAttributes(framesetAtts);
                Element topframe = new Element("frame");
                List<Attribute> topframeAtts = new ArrayList<Attribute>();
                topframeAtts.add(new Attribute("id","topframe"));
                topframeAtts.add(new Attribute("name","topframe"));
                topframeAtts.add(new Attribute("src","../s1000d/app/topz.htm"));
                topframeAtts.add(new Attribute("scrolling","no"));
                topframeAtts.add(new Attribute("frameborder","0"));
                topframeAtts.add(new Attribute("marginheight","1"));
                topframe.setAttributes(topframeAtts);
                
                Element content = new Element("frame");
                List<Attribute> contentAtts = new ArrayList<Attribute>();
                contentAtts.add(new Attribute("id","content"));
                contentAtts.add(new Attribute("name","content"));
                contentAtts.add(new Attribute("src","../s1000d/app/content.htm"));
                contentAtts.add(new Attribute("scrolling","auto"));
                contentAtts.add(new Attribute("frameborder","0"));
                content.setAttributes(contentAtts);
                
                Element navframe = new Element("frame");
                List<Attribute> navframeAtts = new ArrayList<Attribute>();
                navframeAtts.add(new Attribute("id","nav_frame"));
                navframeAtts.add(new Attribute("name","nav_frame"));
                navframeAtts.add(new Attribute("src","../s1000d/app/navPage.htm?loc=" + num));
                navframeAtts.add(new Attribute("frameborder","0"));
                navframe.setAttributes(navframeAtts);
                
            frameset.addContent(topframe);
            frameset.addContent(content);
            frameset.addContent(navframe);
        html.addContent(frameset);
        
        File scoFolder = new File(cpPackage + File.separator + 
                             "resources/scos/");
        scoFolder.mkdir();
        
        XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
        FileWriter writer = new FileWriter(cpPackage + File.separator + 
                            "resources/scos/index" + num +".htm");
        outputter.output(html, writer);
        writer.flush();
        writer.close();

        
    
    }
}
