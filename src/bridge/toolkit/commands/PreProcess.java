/**
 * This file is part of the S1000D-SCORM Bridge Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

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
import org.jdom.Namespace;
import org.jdom.xpath.XPath;

import bridge.toolkit.ResourceMapException;
import bridge.toolkit.util.DMParser;
import bridge.toolkit.util.Keys;

/**
 * The first module in the toolkit that transforms the SCPM into a imsmanifest.xml
 * file and generates a urn_resource_map.xml file from the resource package.
 */
public class PreProcess implements Command
{
    /**
     * Provides a way to parse S1000D files and to find data model codes.
     */
    private static DMParser dmParser;
    
    /**
     * JDOM Document that is used to create the imsmanifest.xml file.
     */
    private static Document manifest;
    
    /**
     * JDOM Document that is used to create the urn_resource_map.xml file.
     */
    private static Document urn_map;
    
    /**
     * Location of the XSLT transform file.
     */
    private static final String TRANSFORM_FILE = "preProcessTransform.xsl";

    /**
     * InputStream for the xsl file that is used to transform the SCPM file to 
     * an imsmanifest.xml file.
     */
    private static InputStream transform;
    
    /**
     * String that represents the location of the resource package.
     */
    private static String src_dir;
    
    /**
     * Message that is returned if the conversion from SCPM to imsmanifest.xml 
     * file is unsuccessful.
     */
    private static final String CONVERSION_FAILED = "CONVERSION OF SCPM TO IMSMANIFEST WAS UNSUCCESSFULL";

    /**
     * Constructor
     */
    public PreProcess()
    {
        dmParser = new DMParser();
    }

    /** 
     * The unit of processing work to be performed for the PreProcess module.
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

                addResources(urn_map);
                
                processDeps(mapDependencies());
            }
            catch (ResourceMapException e)
            {
                System.out.println(CONVERSION_FAILED);
                e.printTrace();
                return PROCESSING_COMPLETE;
            }
            catch (JDOMException jde)
            {
                System.out.println(CONVERSION_FAILED);
                jde.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            catch (TransformerException te)
            {
                System.out.println(CONVERSION_FAILED);
                te.printStackTrace();
                return PROCESSING_COMPLETE;
            }
            catch (IOException e1)
            {
                System.out.println(CONVERSION_FAILED);
                e1.printStackTrace();
                return PROCESSING_COMPLETE;
            }

            ctx.put(Keys.URN_MAP, urn_map);
            ctx.put(Keys.XML_SOURCE, manifest);

            System.out.println("CONVERSION OF SCPM TO IMSMANIFEST SUCCESSFULL");
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
     * Retrieves all of the files in a specified directory and returns them
     * in a list. 
     * 
     * @param src_dir String that represents the location of directory.
     * @return List<File> List of all of the files found in the source directory.
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
     * Walks through the List of files that represent all of the files in the
     * resource package and generates a urn_resource_map.xml files that is used
     * to map each file by file name to the S1000D URN. 
     * 
     * @param src_files List<Files> of all of the files found in the resources 
     * package.
     * @return Document JDOM Document that represents the urn_resource_map.xml 
     * file. 
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
     * Creates a 'urn' element for each file in the resource package to be added
     * to the urn_resource_map.xml file.  
     * 
     * @param name String that represents the URN of the given file.
     * @param file_name String that represents the actual file name for each file.
     * @return Element JDOM Element
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
            target.setText("media/" + file_name);
        }
        else
        {
            target.setText(file_name);
        }
        urn.addContent(target);
        return urn;
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
        TransformerFactory tFactory = TransformerFactory.newInstance();

        Transformer transformer = tFactory.newTransformer(new StreamSource(transform));

        File the_manifest = File.createTempFile("imsmanifest", ".xml");
        
        transformer.transform(new StreamSource(scpm_source), new StreamResult(new FileOutputStream(the_manifest)));

        manifest = dmParser.getDoc(the_manifest);

    }
    
    /**
     * Adds 'resource' elements to the imsmanifest.xml file for every file found
     * in the resource package that is provided.
     * 
     * @param urn_map JDOM Document that is used to create the urn_resource_map.xml file.
     * @throws ResourceMapException  Exception that is thrown when a URN is generated from in two different 
     * files in the Resource Package.
     * @throws IOException 
     * @throws JDOMException 
     */
    @SuppressWarnings("unchecked")
    private static void addResources(Document urn_map) throws ResourceMapException, JDOMException, IOException
    {
        Element resources = manifest.getRootElement().getChild("resources", null);
        Namespace ns = resources.getNamespace();
        Namespace adlcpNS = Namespace.getNamespace("adlcp", "http://www.adlnet.org/xsd/adlcp_v1p3");
        List<Element> urns = urn_map.getRootElement().getChildren();
        for (int i = 0; i < urns.toArray().length; i++)
        {
            String the_href = "resources/s1000d/" + urns.get(i).getChildText("target", null);
            String the_name = urns.get(i).getAttributeValue("name").replace("URN:S1000D:", "");

            Element resource = new Element("resource");
            Attribute id = new Attribute("identifier", the_name);
            Attribute type = new Attribute("type", "webcontent");
            Attribute scormtype = new Attribute("scormType", "asset", adlcpNS);
            Attribute href = new Attribute("href", the_href);
            resource.setAttribute(id);
            resource.setAttribute(type);
            resource.setAttribute(scormtype);
            resource.setAttribute(href);
            
            Element file = new Element("file", ns);
            Attribute fileHref = new Attribute("href", the_href);
            file.setAttribute(fileHref);
            resource.addContent(file);

            // get the parent element namespace (implicit - the default
            // namespace) and assign to resource element to prevent empty
            // default namespace in resource element

            resources.addContent(resource);
            resource.setNamespace(ns);

        }
        
    }

    /**
     * Walks through the 'resource' elements in the imsmanifest.xml file (that 
     * were generated from the 'scoEntry' elements in the SCPM) and creates a map
     * using the 'identifier' attribute of each 'resource' element as the key 
     * and a list of all of the 'identifierref' attributes of the 'dependency' 
     * child elements for that 'resource' element as the value.  This map is then
     * used by the processDeps method.
     * 
     * @return Map<String, List<String>> A Map that holds the 'identifierref' 
     * attributes of all of a SCO 'resource' elements and a List of all of 
     * 'dependency' children. 
     * @throws ResourceMapException  Exception that is thrown when a URN is generated from in two different 
     * files in the Resource Package.
     * @throws IOException 
     * @throws JDOMException 
     */
    @SuppressWarnings(
    { "unchecked", "rawtypes" })
    private static Map<String, List<String>> mapDependencies() throws ResourceMapException, JDOMException, IOException
    {
        Namespace ns = Namespace.getNamespace("ns", "http://www.imsglobal.org/xsd/imscp_v1p1");
        Map<String, List<String>> sco_map = new HashMap<String, List<String>>();

        // get the manifest sco resources
        XPath xp;
        xp = XPath.newInstance("//ns:resource[@adlcpNS:scormType='sco']");
        xp.addNamespace("ns", "http://www.imsglobal.org/xsd/imscp_v1p1");
        xp.addNamespace("adlcpNS", "http://www.adlnet.org/xsd/adlcp_v1p3");
        List<Element> scos = (ArrayList) xp.selectNodes(manifest);

        // iterate through the sco list
        Iterator<Element> iter = scos.iterator();
        while (iter.hasNext())
        {
            Element sco = iter.next();
            String sco_identifier = sco.getAttributeValue("identifier");
            // CHANGED STW 11/16 - get list of sco dependencies vice files - use
            // the identifierref to get the resource identifer/href
            List<Element> resFiles = sco.getChildren("dependency", ns);

            List<String> idrefs = new ArrayList<String>();
            for (int i = 0; i < resFiles.size(); i++)
            {
                Element resFile = resFiles.get(i);

                String identifierref = (resFile.getAttributeValue("identifierref"));
                if (identifierref != "")
                {
                    idrefs.add(identifierref);
                }
            }
            
            sco_map.put(sco_identifier, idrefs);
        }

        return sco_map;
      
    }

    /**
     * Walks through all of the 'dependency' elements for each SCO 'resource'
     * element in the imsmanifest.xml file and searches for referenced media
     * (ICN) files and referenced data modules (DMC) files. The found referenced
     * files are then added as 'dependency' elements to the specific SCO
     * 'resource' element. 
     * 
     * @param sco_map Map<String, List<String>> that holds the 'identifierref' 
     * attributes of all of a SCO 'resource' elements and a List of all of 
     * 'dependency' children.
     * @throws ResourceMapException Exception that is thrown when a URN is generated from in two different 
     * files in the Resource Package.
     * @throws JDOMException
     * @throws IOException 
     */
    private static void processDeps(@SuppressWarnings("rawtypes") Map sco_map) throws  ResourceMapException, JDOMException, IOException
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
                Document dmDoc = dmParser.getDoc(file);
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
            }
        }
    }

    /**
     * Searches through a data module file for referenced data modules.
     * 
     * @param dmDoc JDOM Document that represents the data module being searched
     * for dmRef instances.
     * @param sco_resource JDOM Element that represents the current SCO 
     * 'resource' element.
     * @return List<String> List of all of the referenced data modules found in
     * the specified data module.
     */
    @SuppressWarnings(
    { "unchecked" })
    private static List<String> searchForDmRefs(Document dmDoc, Element sco_resource)
    {
        Namespace ns = Namespace.getNamespace("http://www.imsglobal.org/xsd/imscp_v1p1");
        List<String> referencedDMs = new ArrayList<String>();

        Iterator<String> referencedDMsIterator = dmParser.searchForDmRefs(dmDoc).iterator();
        while(referencedDMsIterator.hasNext())
        {
            String dmc = referencedDMsIterator.next(); 
            boolean found = false;
    
            // CHANGED STW 11/16
            List<Element> sco_resources = sco_resource.getChildren("dependency", ns);
            Iterator<Element> iter = sco_resources.iterator();
            String identifierref = "";
            while (iter.hasNext())
            {
                Element current_el = iter.next();
    
                identifierref = current_el.getAttributeValue("identifierref");
                
                if (identifierref.contains(dmc))
                {
                    found = true;
                }
            }
            if (!referencedDMs.contains(dmc) && found == false && identifierref != "")
            {
                referencedDMs.add(dmc);
            }
        
        }

        return referencedDMs;
    }

    /**
     * Searches through a data module file for referenced media (ICN) files .
     * 
     * @param doc JDOM Document that represents the data module being searched
     * for dmRef instances.
     * @return List<String> List of all of the referenced media (ICN) files 
     * found in the specified data module.
     * @throws JDOMException 
     */
    @SuppressWarnings(
    { "unchecked", "rawtypes" })
    private static List<String> searchForICN(Document doc) throws JDOMException
    {
        List<String> icnRefs = new ArrayList<String>();
        List<Element> els = (ArrayList) XPath.selectNodes(doc, "//*[@infoEntityIdent]");

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

}
