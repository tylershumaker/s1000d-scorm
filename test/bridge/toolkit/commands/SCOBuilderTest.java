/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import static org.junit.Assert.*;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.script.ScriptContext;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;

import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;
import org.apache.commons.chain.impl.ContextBase;
import org.jdom.Attribute;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.ProcessingInstruction;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import bridge.toolkit.packaging.ContentPackageCreator;
import bridge.toolkit.util.CopyDirectory;
import bridge.toolkit.util.Keys;
import bridge.toolkit.util.XMLParser;

/**
 *
 */
public class SCOBuilderTest
{

    Context ctx;
    Command rb;
    File cpPackage;
    List<String> commonFiles = new ArrayList<String>();
    
    /**
     * @throws java.lang.Exception
     */
    @Before
    public void setUp() throws Exception
    {
        ctx = new ContextBase();
        ctx.put(Keys.XML_SOURCE, new File(System.getProperty("user.dir") + File.separator
                + "test_files\\imsmanifest_res_built.xml"));
        ctx.put(Keys.RESOURCE_PACKAGE,System.getProperty("user.dir") + File.separator +
                "test_files\\resource_package");
        
        ContentPackageCreator cpc = new ContentPackageCreator((String)ctx.get(Keys.RESOURCE_PACKAGE));
        cpc.setPackagesLocation(System.getProperty("user.dir") + File.separator +
                "test_files\\packages");
        cpPackage = cpc.createPackage();
        ctx.put(Keys.CP_PACKAGE, cpPackage);
    }
    
    @After
    public void tearDown() throws Exception
    {
        deleteDirectory(cpPackage.getParentFile());
    }

    /**
     * Test method for {@link bridge.toolkit.commands.SCOBuilder#execute(org.apache.commons.chain.Context)}.
     */
    @Test
    public void testExecute()
    {
        fail("Not yet implemented");
    }
    
    @Test 
    public void copyOverTC()
    {
        File trainingContent = new File(System.getProperty("user.dir") + File.separator + "TrainingContent");
        File cpTrainingContent = new File(cpPackage + File.separator + "TrainingContent");
        CopyDirectory cd = new CopyDirectory();
        try
        {
            cd.copyDirectory(trainingContent, cpTrainingContent);
        }
        catch (IOException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
        //add list.js and urn_rsource_map.xml to trainingcontent in package

        listFiles(cpTrainingContent);
        
        Element commonResource = new Element("resource");
        commonResource.setAttribute(new Attribute("identifier", "RES-common-files"));
        commonResource.setAttribute(new Attribute("type", "webcontent"));
        commonResource.setAttribute(new Attribute("scormType", "asset"));

        Iterator<String> iterator = commonFiles.iterator();
        while(iterator.hasNext())
        {
            String file = iterator.next();
            file = file.replace("\\", "/");
            String[] split = file.split(cpPackage.getName()+"/");
            Element fileElement = new Element("file");
            fileElement.setAttribute(new Attribute("href", split[1]));
            commonResource.addContent(fileElement);
        }
        
        XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
        String returned = outputter.outputString(commonResource);
        System.out.println(returned);
        

    }
    
    public void listFiles(File srcFolder)
    {
        
        if (srcFolder.isDirectory()) 
        {
 
            String[] oChildren = srcFolder.list();
            for (int i=0; i < oChildren.length; i++) 
            {
                listFiles(new File(srcFolder, oChildren[i]));
            }
        } 
        else 
        {

            if(!srcFolder.getAbsolutePath().contains(".svn"))
            commonFiles.add(srcFolder.getAbsolutePath());

        }
    }
    
    @Test
    public void testnavScript()
    {
        File js = new File(System.getProperty("user.dir") + File.separator + "test_files\\list.js");
        //String test = "here is some new stuff";
       
        //parse resource element to find file names...
        List<List> scoPages = new ArrayList<List>();
        List<String> page = new ArrayList<String>();
        page.add("../../resources/DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-A_001-00_en-us.xml");
        page.add("../DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H10A_001-00_en-us.xml");
        page.add("../DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H11A_001-00_en-us.xml");
        page.add("../DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H18A_001-00_en-us.xml");
        page.add("../DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H19A_001-00_en-us.xml");
        page.add("../DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H20A_001-00_en-us.xml");
        page.add("../DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H30A_001-00_en-us.xml");
        page.add("../DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H40A_001-00_en-us.xml");
        
        scoPages.add(page);

        page = new ArrayList<String>();
        page.add("../DMC-S1000DBIKE-AAA-DA0-00-00-00AA-932A-T-H14B_001-00_EN-us.xml");
        
        scoPages.add(page);
        try 
        {
            FileWriter writer = new FileWriter(js);
            int count = 0;
            writer.write("var scoPages = new Array(" +scoPages.size() + ")\n");

            Iterator<List> pages = scoPages.iterator();
            while(pages.hasNext())
            {
                List<String> nextPg = pages.next();
                writer.write("scoPages[" + count + "] = new Array(" + nextPg.size() + ")\n");
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
            writer.write("funtion getArray()\n");
            writer.write("{return scoPages;}");
            writer.close();
        } 
        catch (java.io.IOException e) 
        {
            e.printStackTrace();
        }
    }
    
    @Test
    public void testResourceMap()
    {
        //
        String icn1 = "ICN-S1000DBIKE-AAA-DA20000-A-06RT9-00028-A-001-01.jpg";
        String icn2 = "ICN-S1000DBIKE-AAA-DA20000-A-06RT9-00029-A-001-01.jpg";
        Document iDoc = new Document();
        Element urnResource = new Element("urn-resource");
        Element urn = new Element("urn");
        String[] split = icn1.split(".jpg");
        urn.setAttribute(new Attribute("name","URN:S1000D:" + split[0]));
        Element target = new Element("target");
        Attribute type = new Attribute("type","figure");
        target.setAttribute(type);
        target.setText("../../resource/" +icn1);
        urn.addContent(target);
        urnResource.addContent(urn);
        
        iDoc.addContent(urnResource);
        
        
        
        XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
        File temp = new File(System.getProperty("user.dir") + File.separator + "test_files\\urn_resource_map.xml");
        try {
            FileWriter writer = new FileWriter(temp);
            outputter.output(iDoc, writer);
            writer.close();
        } catch (java.io.IOException e) {
            e.printStackTrace();
        }
    }
    
    @Test
    public void testApplyStylesheet()
    {
        File dm = new File(System.getProperty("user.dir") + File.separator + "test_files\\resource_package\\DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-A_001-00_en-us.xml");
        
        XMLParser parser = new XMLParser();
        Document doc = parser.getDoc(dm);
        
        String STYLESHEET = "xml-stylesheet";
        String STYLEPROCESSINGINSTRUCTION = "type=\"text/xsl\" href=\"";
        
        String xslt = "Test_Bike_Package/BikeViewerApplication/TrainingContent/app/LearnPlan.xslt";
        
        ProcessingInstruction stylesheet = new ProcessingInstruction(STYLESHEET, STYLEPROCESSINGINSTRUCTION+xslt+"\"");
        Element root = doc.getRootElement();
        doc.removeContent();
        doc.addContent(stylesheet);
        doc.addContent(root);
        
        XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
        File temp = new File(System.getProperty("user.dir") + File.separator + "test_files\\dmStyleTest.xml");
        try {
            FileWriter writer = new FileWriter(temp);
            outputter.output(doc, writer);
            writer.close();
        } catch (java.io.IOException e) {
            e.printStackTrace();
        }
        
        
    }
    
    @Test
    public void testBuildHTMLFile()
    {
        Document doc = new Document();
        
        Element html = new Element("html");
            Element head = new Element("head");
                Element script = new Element("script");
                List<Attribute> scriptAtts = new ArrayList<Attribute>();
                scriptAtts.add(new Attribute("language","javascript"));
                scriptAtts.add(new Attribute("src","TrainingContent/app/navScript.js"));
                script.setAttributes(scriptAtts);
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
                topframeAtts.add(new Attribute("src","TrainingContent/app/topz.htm"));
                topframeAtts.add(new Attribute("scrolling","no"));
                topframeAtts.add(new Attribute("frameborder","0"));
                topframeAtts.add(new Attribute("marginheight","1"));
                topframe.setAttributes(topframeAtts);
                
                Element content = new Element("frame");
                List<Attribute> contentAtts = new ArrayList<Attribute>();
                contentAtts.add(new Attribute("id","content"));
                contentAtts.add(new Attribute("name","content"));
                contentAtts.add(new Attribute("src","TrainingContent/app/content.htm"));
                contentAtts.add(new Attribute("scrolling","auto"));
                contentAtts.add(new Attribute("frameborder","0"));
                content.setAttributes(contentAtts);
                
                Element navframe = new Element("nav_frame");
                List<Attribute> navframeAtts = new ArrayList<Attribute>();
                navframeAtts.add(new Attribute("id","nav_frame"));
                navframeAtts.add(new Attribute("name","nav_frame"));
                navframeAtts.add(new Attribute("src","TrainingContent/app/navPage.htm?loc=0"));
                navframeAtts.add(new Attribute("frameborder","0"));
                navframe.setAttributes(navframeAtts);
                
            frameset.addContent(topframe);
            frameset.addContent(content);
            frameset.addContent(navframe);
        html.addContent(frameset);
        
        doc.addContent(html);
        
        
        XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
        String returned = outputter.outputString(doc);
        System.out.println(returned);
        
    
    }

    static public boolean deleteDirectory(File path) {
        if( path.exists() ) {
          File[] files = path.listFiles();
          for(int i=0; i<files.length; i++) {
             if(files[i].isDirectory()) {
               deleteDirectory(files[i]);
             }
             else {
               files[i].delete();
             }
          }
        }
        return( path.delete() );
      }
}
