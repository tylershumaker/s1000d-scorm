/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
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

import java.util.ArrayList;
import java.util.HashMap;
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
import org.jdom.Namespace;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.jdom.xpath.XPath;

import bridge.toolkit.ResourceMapException;
import bridge.toolkit.util.Keys;
import bridge.toolkit.util.XMLParser;

public class PreProcess implements Command
{
    /**
     * 
     */
    private static XMLParser xmlParser;
    
    /**
     * 
     */
    private static Document manifest;
    
    /**
     * 
     */
    private static Document urn_map;
    
    /**
     * Location of the XSLT transform file.
     */
    private static final String TRANSFORM_FILE = "preProcessTransform.xsl";

    /**
     * 
     */
    private static InputStream transform;
    
    /**
     * 
     */
    private static String src_dir;
    
    /**
     * 
     */
    private static final String CONVERSION_FAILED = "CONVERSION OF SCPM TO IMSMANIFEST WAS UNSUCCESSFULL";

    /**
     * 
     */
    public PreProcess()
    {
        xmlParser = new XMLParser();
    }

    /** 
     * @see org.apache.commons.chain.Command#execute(org.apache.commons.chain.Context)
     */
    @SuppressWarnings("unchecked")
    public boolean execute(Context ctx)
    {
        if ((ctx.get(Keys.SCPM_FILE) != null) && (ctx.get(Keys.RESOURCE_PACKAGE) != null))
        {

            src_dir = (String) ctx.get(Keys.RESOURCE_PACKAGE);
            List<File> src_files = new ArrayList<File>(); 
            try
            {
                src_files = getSourceFiles(src_dir);
            }
            catch(NullPointerException npe)
            {
                System.out.println(CONVERSION_FAILED);
                System.out.println("The 'Resource Package' is empty.");
                return PROCESSING_COMPLETE;
            }

            urn_map = writeURNMap(src_files);
            
            transform = this.getClass().getResourceAsStream(TRANSFORM_FILE);

            try
            {
                doTransform((String) ctx.get(Keys.SCPM_FILE));
            }
            catch (IOException e1)
            {
                // TODO Auto-generated catch block
                System.out.println(CONVERSION_FAILED);
                e1.printStackTrace();
                return PROCESSING_COMPLETE;
            }

            // ADD RESOURCE TYPE ASSETS
            try
            {
                addResources(urn_map);
            }
            catch (ResourceMapException e)
            {
                System.out.println(CONVERSION_FAILED);
                e.printTrace();
                return PROCESSING_COMPLETE;
            }

            ctx.put(Keys.XML_SOURCE, manifest);

            System.out.println("CONVERSION OF SCPM TO IMSMANIFEST SUCCESSSFULL");
        }
        else
        {
            System.out.println(CONVERSION_FAILED);
            System.out.println("One of the required Context entries for the " + this.getClass().getSimpleName()
                    + " command to be executed was null");
            return PROCESSING_COMPLETE;
        }
        return CONTINUE_PROCESSING;
    }

    /**
     * @param urn_map
     * @throws ResourceMapException
     */
    @SuppressWarnings("unchecked")
    private static void addResources(Document urn_map) throws ResourceMapException
    {
        Element resources = manifest.getRootElement().getChild("resources", null);
        Namespace ns = resources.getNamespace();
        Namespace adlcpNS = Namespace.getNamespace("adlcp", "http://www.adlnet.org/xsd/adlcp_v1p3");
        List<Element> urns = urn_map.getRootElement().getChildren();
        for (int i = 0; i < urns.toArray().length; i++)
        {
            String the_href = urns.get(i).getChildText("target", null);
            String the_name = urns.get(i).getAttributeValue("name").replace("URN:S1000D:", "");

            Element resource = new Element("resource");
            Attribute id = new Attribute("identifier", the_name);
            Attribute type = new Attribute("type", "webcontent");
            Attribute scormtype = new Attribute("scormtype", "asset", adlcpNS);
            Attribute href = new Attribute("href", the_href);
            href.setValue(the_href);
            resource.setAttribute(id);
            resource.setAttribute(type);
            resource.setAttribute(scormtype);
            resource.setAttribute(href);

            // get the parent element namespace (implicit - the default
            // namespace) and assign to resource element to prevent empty
            // default namespace in resource element

            resources.addContent(resource);
            resource.setNamespace(ns);

//            System.out.println("RESOURCE ADDED: " + the_name);
        }
        mapDependencies();
    }

    /**
     * @throws ResourceMapException
     */
    @SuppressWarnings(
    { "unchecked", "rawtypes" })
    private static void mapDependencies() throws ResourceMapException
    {
        Namespace ns = Namespace.getNamespace("ns", "http://www.imsglobal.org/xsd/imscp_v1p1");
        @SuppressWarnings("unused")
        Namespace adlcpNS = Namespace.getNamespace("adlcp", "http://www.adlnet.org/xsd/adlcp_v1p3");
        Map<String, List<String>> sco_map = new HashMap<String, List<String>>();

        // get the manifest sco resources
        XPath xp;
        List<Element> scos = null;
        try
        {
            xp = XPath.newInstance("//ns:resource[@adlcpNS:scormtype='sco']");
            xp.addNamespace("ns", "http://www.imsglobal.org/xsd/imscp_v1p1");
            xp.addNamespace("adlcpNS", "http://www.adlnet.org/xsd/adlcp_v1p3");
            scos = (ArrayList) xp.selectNodes(manifest);
        }
        catch (JDOMException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        // iterate through the sco list
        Iterator<Element> iter = scos.iterator();
        while (iter.hasNext())
        {
            Element sco = iter.next();
            String sco_identifier = sco.getAttributeValue("identifier");
            // CHANGED STW 11/16 - get list of sco dependencies vice files - use
            // the identifierref to get the resource identifer/href
            // List<Element> resFiles = sco.getChildren("file", ns);
            List<Element> resFiles = sco.getChildren("dependency", ns);

            List<String> idrefs = new ArrayList<String>();
            for (int i = 0; i < resFiles.size(); i++)
            {
                // System.out.println("HREF :" + resFiles.get(i));
                Element resFile = resFiles.get(i);

                String identifierref = (resFile.getAttributeValue("identifierref"));
                if (identifierref != "")
                {
                    // String [] split = file_href.split("/");
                    // String identifier = split[split.length-1];
                    idrefs.add(identifierref);
                }
            }
            sco_map.put(sco_identifier, idrefs);
        }
        @SuppressWarnings("unused")
        int key_len = sco_map.entrySet().size();
//        System.out.println("Processing SCO Dependencies . . . .");
        try
        {
            processDeps(sco_map);
        }
        catch (JDOMException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
      

    }

    /**
     * @param sco_map
     * @throws JDOMException
     * @throws ResourceMapException
     */
    private static void processDeps(@SuppressWarnings("rawtypes") Map sco_map) throws JDOMException, ResourceMapException
    {
        Namespace default_ns = manifest.getRootElement().getChild("resources", null).getNamespace();
        Element sco_resource = null;
        List<String> dependencies = null;
        XPath xp = null;
        String sco_key;

        // the updated map will track dependency addition to the sco to prevent
        // duplicate entries before writing to the manifest
        // iterate the sco map entries
        @SuppressWarnings("unchecked")
        Iterator<Entry<String, List<String>>> iter = sco_map.entrySet().iterator();
        while (iter.hasNext())
        {
            Map.Entry<String, List<String>> pairs = (Map.Entry<String, List<String>>) iter.next();
            // store the sco identifier
            sco_key = pairs.getKey();
            xp = XPath.newInstance("//ns:resource[@identifier='" + sco_key + "']");
            xp.addNamespace("ns", "http://www.imsglobal.org/xsd/imscp_v1p1");
            sco_resource = (Element) xp.selectSingleNode(manifest);

            Iterator<String> value = pairs.getValue().iterator();
            // store the icn references
            dependencies = new ArrayList<String>();
            while (value.hasNext())
            {
                Element resource = null;
                String str_current = value.next();
                xp = XPath.newInstance("//ns:resource[@identifier='" + str_current + "']");
                xp.addNamespace("ns", "http://www.imsglobal.org/xsd/imscp_v1p1");
                resource = (Element) xp.selectSingleNode(manifest);

                String[] split;
                String src_href = "";
                try
                {
                    split = resource.getAttributeValue("href").split("/");
                    src_href = split[split.length - 1];
                }
                catch (NullPointerException npe)
                {
                    throw new ResourceMapException(str_current, sco_key);
                }
                
                String resource_path = src_dir + "//" + src_href;
                File file = new File(resource_path);
                Document dmDoc = xmlParser.getDoc(file);
                // reach into the dm docs and find ICN references
                List<String> icnRefs = searchForICN(dmDoc);
                Iterator<String> icn_iter = icnRefs.iterator();
                while (icn_iter.hasNext())
                {
                    String the_icn = icn_iter.next();
                    if (!dependencies.contains(the_icn))
                    {
                        dependencies.add(the_icn);
                    }
                }

                // get the dm refs
                List<String> dmrefs = searchForDmRefs(dmDoc, sco_resource);
                Iterator<String> dmref_iter = dmrefs.iterator();
                while (dmref_iter.hasNext())
                {
                    String dmref = dmref_iter.next();
                    if (!dependencies.contains(dmref))
                    {
                        dependencies.add(dmref);
                    }
                }
            }
            // add the dependencies
            // Iterate the icn list add dependency elements to manifest
            Iterator<String> dependency_iter = dependencies.iterator();
            while (dependency_iter.hasNext())
            {
                String identifierref = dependency_iter.next();
                Element dependency = new Element("dependency");

                dependency.setAttribute("identifierref", identifierref);
                sco_resource.addContent(dependency);
                dependency.setNamespace(default_ns);
//                System.out.println("ICN RESOURCE: " + identifierref + " ADDED TO SCO: " + sco_key);
            }
        }
    }

    /**
     * @param dmDoc
     * @param sco_resource
     * @return
     */
    @SuppressWarnings(
    { "unchecked", "rawtypes" })
    private static List<String> searchForDmRefs(Document dmDoc, Element sco_resource)
    {
        Namespace ns = Namespace.getNamespace("http://www.imsglobal.org/xsd/imscp_v1p1");
        List<String> referencedDMs = new ArrayList<String>();

        XPath xp = null;

        try
        {
            xp = XPath.newInstance("//dmCode");
        }
        catch (JDOMException e1)
        {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
        List<Element> dmc_lst = null;
        try
        {
            dmc_lst = (ArrayList) xp.selectNodes(dmDoc);
        }
        catch (JDOMException e1)
        {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }

        int len = dmc_lst.size();
//        if (len > 0)
//        {
//            System.out.println("SIZE: " + len);
//        }

        Iterator<Element> refdms = dmc_lst.iterator();
        while (refdms.hasNext() == true)
        {
            Element e = refdms.next();
            Element theAncestor = (Element) e.getParent().getParent();
            String dmc;
            if (theAncestor.getName() == "dmRef")
            {
                dmc = "DMC-";
                List<Attribute> atts = e.getAttributes();
                for (int i = 0; i < atts.toArray().length; i++)
                {
                    if (atts.get(i).getName() == "modelIdentCode")
                    {
                        dmc += atts.get(i).getValue() + "-";
                    }
                    else if (atts.get(i).getName() == "systemDiffCode")
                    {
                        dmc += atts.get(i).getValue() + "-";
                    }
                    else if (atts.get(i).getName() == "systemCode")
                    {
                        dmc += atts.get(i).getValue() + "-";
                    }
                    else if (atts.get(i).getName() == "subSystemCode")
                    {
                        dmc += atts.get(i).getValue();
                    }
                    else if (atts.get(i).getName() == "subSubSystemCode")
                    {
                        dmc += atts.get(i).getValue() + "-";
                    }
                    else if (atts.get(i).getName() == "assyCode")
                    {
                        dmc += atts.get(i).getValue() + "-";
                    }
                    else if (atts.get(i).getName() == "disassyCode")
                    {
                        dmc += atts.get(i).getValue();
                    }
                    else if (atts.get(i).getName() == "disassyCodeVariant")
                    {
                        dmc += atts.get(i).getValue() + "-";
                    }
                    else if (atts.get(i).getName() == "infoCode")
                    {
                        dmc += atts.get(i).getValue();
                    }
                    else if (atts.get(i).getName() == "infoCodeVariant")
                    {
                        dmc += atts.get(i).getValue() + "-";
                    }
                    else if (atts.get(i).getName() == "itemLocationCode")
                    {
                        if (atts.toArray().length > 11)
                        {
                            dmc += atts.get(i).getValue() + "-";
                        }
                        else
                        {
                            dmc += atts.get(i).getValue();
                        }
                    }
                    else if (atts.get(i).getName() == "learnCode")
                    {
                        dmc += atts.get(i).getValue();
                    }
                    else if (atts.get(i).getName() == "learnEventCode")
                    {
                        dmc += atts.get(i).getValue();
                    }

                }// end for
                boolean found = false;

                // CHANGED STW 11/16
                List<Element> sco_resources = sco_resource.getChildren("dependency", ns);
                Iterator<Element> iter = sco_resources.iterator();
                String identifierref = "";
                while (iter.hasNext())
                {
                    Element current_el = iter.next();

                    try
                    {
                        identifierref = current_el.getAttributeValue("identifierref");
                    }
                    catch (Exception e1)
                    {
                        // TODO Auto-generated catch block
                        e1.printStackTrace();
                    }
                    if (identifierref.contains(dmc))
                    {
                        found = true;
                    }
                }
                if (!referencedDMs.contains(dmc) & found == false & identifierref != "")
                {
//                    System.out.println("DMC: " + dmc);
                    referencedDMs.add(dmc);
                }
            }// end if

        }// end while
        return referencedDMs;
    }

    /**
     * @param doc
     * @return
     */
    @SuppressWarnings(
    { "unchecked", "rawtypes" })
    private static List<String> searchForICN(Document doc)
    {
        List<Element> els = null;
        List<String> icnRefs = new ArrayList<String>();
        try
        {
            els = (ArrayList) XPath.selectNodes(doc, "//*[@infoEntityIdent]");
        }
        catch (JDOMException e1)
        {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
        for (int i = 0; i < els.size(); i++)
        {
            Element e = (Element) els.get(i);
            String icn = null;
            if (e.getAttribute("infoEntityIdent") != null)
            {
                icn = e.getAttributeValue("infoEntityIdent");

                if (!icnRefs.contains(icn))
                {
                    icnRefs.add(icn);
                }
            }
        }
        return icnRefs;
    }

    private static void doTransform(String scpm_source) throws IOException
    {
        TransformerFactory tFactory = TransformerFactory.newInstance();

        Transformer transformer = null;
        try
        {
            transformer = tFactory.newTransformer(new StreamSource(transform));
        }
        catch (TransformerConfigurationException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        File the_manifest = File.createTempFile("imsmanifest", ".xml");//new File("imsmanifest.xml");
        try
        {
            transformer.transform(new StreamSource(scpm_source), new StreamResult(new FileOutputStream(the_manifest)));
        }
        catch (FileNotFoundException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        catch (TransformerException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        manifest = xmlParser.getDoc(the_manifest);

    }

    /**
     * @param src_dir
     * @return
     */
    private static List<File> getSourceFiles(String src_dir)
    {
        File csdb_files = new File(src_dir);

        List<File> src_files = new ArrayList<File>();
        File [] testVR = csdb_files.listFiles();
        for(File file : testVR)
        {
            src_files.add(file);
        }            
        return src_files;

    }

    /**
     * @param src_files
     * @return
     */
    private static Document writeURNMap(List<File> src_files)
    {
        Document urn_map = new Document();
        Element urnResource = new Element("urn-resource");
        Element urn = null;
        String file_name = null;
        String theExt = null;
        String name = null;
        Iterator<File> filesIterator = src_files.iterator();
        while(filesIterator.hasNext())
        {
            File file = filesIterator.next();
            if (!file.isDirectory())
            {
                file_name = file.getName();
                String[] split = file_name.split("\\.");
                theExt = split[split.length - 1];
                file_name = split[0] + "." + theExt;
                split = file_name.split("_");
                name = split[0];

                urn = writeUrn(name, file_name);
                urnResource.addContent(urn);
            }
            else
            {
                if (file.isDirectory() & file.getName().equals("media"))
                {
                    // recurse the media folder
                    File[] media_files = file.listFiles();
                    for (int j = 0; j < media_files.length; j++)
                    {
                        file_name = media_files[j].getName();
                        String[] split = file_name.split("\\.");
                        name = split[0];
                        theExt = split[split.length - 1];
                        urn = writeUrn(name, file_name);
                        urnResource.addContent(urn);
                    }
                }
            }
        }
        urn_map.addContent(urnResource);

        return urn_map;
    }

    /**
     * @param name
     * @param file_name
     * @return
     */
    private static Element writeUrn(String name, String file_name)
    {
        Element urn = new Element("urn");
        urn.setAttribute(new Attribute("name", "URN:S1000D:" + name));
        Element target = new Element("target");
        Attribute type = new Attribute("type", "file");
        target.setAttribute(type);
        // assume manifest is at level with resources folder
        if (name.startsWith("ICN"))
        {
            target.setText("resources/media/" + file_name);
        }
        else
        {
            target.setText("resources/" + file_name);
        }
        urn.addContent(target);
        return urn;
    }

}
