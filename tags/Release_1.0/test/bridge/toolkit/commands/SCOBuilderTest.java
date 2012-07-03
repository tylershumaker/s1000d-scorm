/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import static org.junit.Assert.*;

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
import org.apache.commons.chain.impl.ContextBase;
import org.jdom.DocType;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.ProcessingInstruction;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

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
    File tempRes;
    List<String> commonFiles = new ArrayList<String>();
    XMLParser parser;
    
    /**
     * @throws java.lang.Exception
     */
    @Before
    public void setUp() throws Exception
    {
        ctx = new ContextBase();
        parser = new XMLParser();
        ctx.put(Keys.SCPM_FILE, System.getProperty("user.dir") + File.separator
                + "examples\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml");
        ctx.put(Keys.XML_SOURCE, parser.getDoc(new File(System.getProperty("user.dir") + File.separator
                + "test_files\\bike_imsmanifest_after_preprocess.xml")));
        ctx.put(Keys.URN_MAP, parser.getDoc(new File(System.getProperty("user.dir") + File.separator +
                                            "test_files\\bike_urn_resource_map.xml")));
        String resources = System.getProperty("user.dir") + File.separator +
        "examples\\bike_resource_package";
        
        File srcPath = new File(resources);
        tempRes = new File(System.getProperty("user.dir") + File.separator +
                "test_files\\tempRes");
        CopyDirectory cd = new CopyDirectory();
        
        try
        {
            cd.copyDirectory(srcPath, tempRes);
            File svn = new File(tempRes.getAbsolutePath()+ File.separator + ".svn");
            if (svn.exists())
            {
                deleteDirectory(svn);
            }

        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
        
        ctx.put(Keys.RESOURCE_PACKAGE, tempRes.getAbsolutePath());
        rb = new SCOBuilder();
        
        
    }
    
    @After
    public void tearDown() throws Exception
    {
        deleteDirectory(tempRes);
    }

    /**
     * Test method for {@link bridge.toolkit.commands.SCOBuilder#execute(org.apache.commons.chain.Context)}.
     */
    @Test
    public void testExecute()
    {
        try
        {
            assertFalse(rb.execute(ctx));
            
//          Document returned = (Document)ctx.get(Keys.XML_SOURCE);
//          XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
//          String output = outputter.outputString(returned);
//          System.out.println(output);               
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
//    @Test
//    public void testapplystyle()
//    {
//        SCOBuilder sb = new SCOBuilder();
//        try
//        {
//            sb.applyStylesheetToDMCs();
//        }
//        catch (JDOMException e)
//        {
//            e.printStackTrace();
//        }
//        catch (IOException e)
//        {
//            e.printStackTrace();
//        }
//
//        
//    }
    
//    @Test
//    public void changeFile() throws JDOMException, IOException
//    {
//        File dm = new File(System.getProperty("user.dir") + File.separator +
//        "examples\\bike_resource_package\\DMC-S1000DBIKE-AAA-D00-00-00-00AA-041A-A_007-00_EN-US.xml");
//        
//        SAXBuilder builder = new SAXBuilder();
//        builder.setExpandEntities(false);
//        
//        Document doc = builder.build(dm);
//        
//        DocType dt = doc.getDocType();
//        String org = dt.getInternalSubset();
//System.out.println(org);
//        BufferedReader in = new BufferedReader(new StringReader(org));
//
//        List<String> lines = new ArrayList<String>();
//        String str;
//        while ((str = in.readLine()) != null) {
//           lines.add(str);
//        }
//        in.close();
//        
//        //<!NOTATION JPEG SYSTEM "file:/C:/workspace2/sourceforge_toolkit/test_files/resource_package_slim/Joint%20Photographic%20Experts%20Group">
//        //<!ENTITY ICN-S1000DBIKE-AAA-DA20000-A-06RT9-00029-A-001-01 SYSTEM "file:/C:/workspace2/sourceforge_toolkit/test_files/resource_package_slim/media/ICN-S1000DBIKE-AAA-DA20000-A-06RT9-00029-A-001-01%20NDATA%20JPEG">
//
//        StringBuffer internalSubset = new StringBuffer();
//        Iterator<String> iterator = lines.iterator();
//        while(iterator.hasNext())
//        {
//            String line = iterator.next();
//            
//            if(line.contains("NOTATION"))
//            {
//            
//                String[] notation = line.split("\"");
//                String[] notationValue = notation[1].split("/");
//                
//                internalSubset.append(notation[0] + "'" +notationValue[notationValue.length-1].replaceAll("%20", " ")+"'>");
//            }
//            if(line.contains("ENTITY"))
//            {
//                String[] entity = line.split("\"");
//                String orgFileLoc = dm.getParent().replaceAll("\\\\", "/");
//                String[] entityValue = entity[1].split(orgFileLoc + "/");
//                
//                internalSubset.append(entity[0] + "'" +entityValue[entityValue.length-1].replaceAll("%20", " ")+
//                                      "'" + entity[entity.length-1] );
//                
//            }
//            
//            internalSubset.append("\n");
//        }
//        
//        DocType newDocType = new DocType("dmodule");
//        newDocType.setInternalSubset(internalSubset.toString());
//
//        System.out.println(newDocType.toString());
//    }
   

//    @Test
//    public void removeStylesheet() throws IOException, JDOMException
//    {
//        File dm = new File(System.getProperty("user.dir") + File.separator +
//                           "examples\\bike_resource_package");
//
//        File[] resources = dm.listFiles();
//        for(File resource: resources)
//        {
//        
//            System.out.println(resource.getAbsolutePath());
//         if(!resource.isDirectory())
//         {
//             SAXBuilder parser = new SAXBuilder();
//             parser.setExpandEntities(false);
//             Document doc = parser.build(resource);
//             doc.removeContent(0);
//             DocType docType = doc.getDocType();
//             if(docType!=null)
//             {
//                 //The JDOM parser converts the DocType and EntityRef from
//                 //relative paths to absolute paths.  So the docType is remove
//                 //then reformated back to a relative path.
//                 doc.removeContent(docType);
//                 doc.setDocType(formatDocType(docType, resource));
//             }
//             
//             XMLOutputter outputter = new XMLOutputter(Format.getRawFormat());
//        
//             File temp = new File(System.getProperty("user.dir") + File.separator +
//                     "examples\\bike_resource_package" + File.separator +
//                                  resource.getName());
//
//             FileWriter writer = new FileWriter(temp);
//             outputter.output(doc, writer);
//             writer.close();
//         }
//        }
//    }
//    
//    public DocType formatDocType(DocType docT, File dm) throws IOException
//    {
//         String org = docT.getInternalSubset();
//    
//         BufferedReader in = new BufferedReader(new StringReader(org));
//    
//         List<String> lines = new ArrayList<String>();
//         String str;
//         while ((str = in.readLine()) != null) 
//         {
//            lines.add(str);
//         }
//         in.close();
//         
//         StringBuffer internalSubset = new StringBuffer();
//         Iterator<String> iterator = lines.iterator();
//         while(iterator.hasNext())
//         {
//             String line = iterator.next();
//             
//             if(line.contains("NOTATION") )
//             {
//             
//                if(line.contains("swf") || line.contains("SWF"))
//                {
//                    internalSubset.append(line);
//                }
//                else
//                {
//                    String[] notation = line.split("\"");
//                    String[] notationValue = notation[1].split("/");
//                     
//                    internalSubset.append(notation[0] + "'" +notationValue[notationValue.length-1].replaceAll("%20", " ")+"'>");                     
//                }
//                internalSubset.append("\n");
//             }
//             if(line.contains("ENTITY"))
//             {
//                 String[] entity = line.split("\"");
//                 String orgFileLoc = dm.getParent().replaceAll("\\\\", "/");
//                 String[] entityValue = entity[1].split(orgFileLoc + "/");
//                 
//                 internalSubset.append(entity[0] + "'" +entityValue[entityValue.length-1].replaceAll("%20", " ")+
//                                       "'" + entity[entity.length-1] );
//                 internalSubset.append("\n");
//                 
//             }
//             
//         }
//         
//         DocType newDocType = new DocType("dmodule");
//         newDocType.setInternalSubset(internalSubset.toString());
//         
//         return newDocType;
//    }    
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
