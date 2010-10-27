/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import static org.junit.Assert.*;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;
import org.apache.commons.chain.impl.ContextBase;
import org.jdom.Document;
import org.jdom.JDOMException;
import org.jdom.output.XMLOutputter;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import bridge.toolkit.packaging.ContentPackageCreator;
import bridge.toolkit.util.Keys;
import bridge.toolkit.util.XMLParser;

/**
 * @author shumaket
 *
 */
public class ResourcesBuilderTest
{

    Context ctx;
    Command rb;
    File cpPackage;
    XMLParser parser;
    /**
     * @throws java.lang.Exception
     */
    @Before
    public void setUp() throws Exception
    {
        parser = new XMLParser();
        ctx = new ContextBase();
        ctx.put(Keys.XML_SOURCE, new File(System.getProperty("user.dir") + File.separator
                + "test_files\\imsmanifest_after_preprocess.xml"));
        ctx.put(Keys.RESOURCE_PACKAGE,System.getProperty("user.dir") + File.separator +
                "test_files\\resource_package");
        
        rb = new ResourcesBuilder();
        
        //creates cp_package directory for testing
        ContentPackageCreator cpc = new ContentPackageCreator((String) ctx.get(Keys.RESOURCE_PACKAGE));
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
     * Test method for {@link bridge.toolkit.commands.ResourcesBuilder#execute(org.apache.commons.chain.Context)}.
     */
    @Test
    public void testExecute()
    {
        //builds test media map 
        Map<String, List<String>> testMediaMap = new HashMap<String, List<String>>();
        List<String> media1 = new ArrayList<String>();
        List<String> media2 = new ArrayList<String>();
        media1.add("ICN-S1000DBIKE-AAA-DA20000-A-06RT9-00028-A-001-01");
        media2.add("ICN-S1000DBIKE-AAA-DA20000-A-06RT9-00029-A-001-01");
        testMediaMap.put("DMC-S1000DBIKE-AAA-DA2-00-00-00AA-028A-T-T28C_001-00_en-US.xml", media1);
        testMediaMap.put("DMC-S1000DBIKE-AAA-DA2-00-00-00AA-041A-T-T88E_001-00_en-US.xml", media2);


        ctx.put(Keys.MEDIA_MAP, testMediaMap);
        
        
        try
        {
            assertFalse(rb.execute(ctx));
            Document doc = parser.getDoc((File)ctx.get(Keys.XML_SOURCE));
            XMLOutputter outputter = new XMLOutputter();
            String returned = outputter.outputString(doc);
            System.out.println(returned);
        }
        catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
    
    
    @Test
    public void testFIMD()
    {
        //builds test media map 
        Map<String, List<String>> testMediaMap = new HashMap<String, List<String>>();
        List<String> media1 = new ArrayList<String>();
        List<String> media2 = new ArrayList<String>();
        media1.add("ICN-S1000DBIKE-AAA-DA20000-A-06RT9-00028-A-001-01");
        media2.add("ICN-S1000DBIKE-AAA-DA20000-A-06RT9-00029-A-001-01");
        media2.add("ICN-S1000DBIKE-AAA-DA20000-A-06RT9-00028-A-001-01");
        testMediaMap.put("DMC-S1000DBIKE-AAA-DA2-00-00-00AA-028A-T-T28C_001-00_en-US.xml", media1);
        testMediaMap.put("DMC-S1000DBIKE-AAA-DA2-00-00-00AA-041A-T-T88E_001-00_en-US.xml", media2);
        testMediaMap.put("DMC-S1000DBIKE-AAA-DA0-00-00-00AA-932A-T-H14B_001-00_EN-us.xml", media1);

        ctx.put(Keys.MEDIA_MAP, testMediaMap);
        
        try
        {
//            ctx.put(Keys.XML_SOURCE, new File(System.getProperty("user.dir") + File.separator
//                    + "test_files\\imsmanifest_media.xml"));
            Document doc = parser.getDoc((File)ctx.get(Keys.XML_SOURCE));
            XMLOutputter outputter = new XMLOutputter();
            String expected = outputter.outputString(doc);
            //System.out.println(expected);
            File test = ((ResourcesBuilder) rb).fillInMediaDependencies(doc, (Map<String, List<String>>)ctx.get(Keys.MEDIA_MAP),
                    new File((ctx.get(Keys.CP_PACKAGE).toString())));
            
            Document returnedDoc = parser.getDoc(test);
            

            String returned = outputter.outputString(returnedDoc);
    
            assertFalse(expected.equals(returned));
            System.out.println(returned);
        }
        catch (JDOMException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
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
