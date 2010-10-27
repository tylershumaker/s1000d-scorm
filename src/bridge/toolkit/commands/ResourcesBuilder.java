/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

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

import bridge.toolkit.packaging.ContentPackageCreator;
import bridge.toolkit.util.Keys;
import bridge.toolkit.util.XMLParser;

/**
 * Takes the list of DMs and LDMs from ResourcesValidator and updates the File 
 * hrefs in the manifest to be the actual XML file name in the manifest then 
 * takes the Map of media and creates the a Resource for the media file (ICN) 
 * and a Dependency element under the Resource with the DMC in that reference 
 * that ICN that points the media files resource. 
 * 
 */
public class ResourcesBuilder implements Command
{

    private List<File> mediaFiles = new ArrayList<File>();
    /**
     * The unit of processing work to be performed for the ResourcesBuilder 
     * module.
     * 
     * @see org.apache.commons.chain.Command#execute(org.apache.commons.chain.Context)
     */
    @Override
    public boolean execute(Context ctx) throws Exception
    {

        if ((ctx.get(Keys.XML_SOURCE) != null) &&
            (ctx.get(Keys.RESOURCE_PACKAGE) != null) &&
            (ctx.get(Keys.MEDIA_MAP) != null))
        {
            //check to see if a cp_package directory exist yet
            if(ctx.get(Keys.CP_PACKAGE)== null)
            {
                
                ContentPackageCreator cpc = new ContentPackageCreator((String) ctx.get(Keys.RESOURCE_PACKAGE));
                File cpPackage = cpc.createPackage();
                ctx.put(Keys.CP_PACKAGE, cpPackage);
            }
            
            try
            {
                //apply real locations of files in resources hrefs
                XMLParser parser = new XMLParser();
                Document doc = parser.getDoc((File)ctx.get(Keys.XML_SOURCE));
                /*File updatedManifest = fillInResources(doc, new File((ctx.get(Keys.CP_PACKAGE).toString())));
                ctx.put(Keys.XML_SOURCE, updatedManifest);*/
                
                //add the referenced media resources
                Map<String, List<String>> media = (HashMap<String, List<String>>)ctx.get(Keys.MEDIA_MAP);
                if(!media.isEmpty())
                {
                    doc = parser.getDoc((File)ctx.get(Keys.XML_SOURCE));
                    File updatedManifest = fillInMediaDependencies(doc, media, new File((ctx.get(Keys.CP_PACKAGE).toString())));
                    ctx.put(Keys.XML_SOURCE, updatedManifest);
                }
            }
            catch (JDOMException e)
            {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            
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
     * Creates Resource elements for all the media files referenced in the data
     * models reference in the manifest file. Then adds Dependency elements to 
     * the appropriate Resource elements that point the the new elements that were
     * created.
     * 
     * @param iDoc Document representing the manifest.
     * @param media Map that contains the data models that contain references to
     * media files as the key and a list of all the media files that each data 
     * model (key) references.
     * @param iCP File that is the root of the content package being created for
     * this iteration of the toolkit.
     * @return File that is the updated manifest file with the new Resource elements and
     * the Dependency elements added to the appropriate elements. 
     * @throws JDOMException 
     */
    public File fillInMediaDependencies(Document iDoc, Map<String, List<String>> media, File iCP) throws JDOMException
    {
        File cpResources = new File(iCP.getAbsolutePath()+ File.separator + "resources");
        //File[] packageFiles = cpResources.listFiles();

        List<String> newResource = new ArrayList<String>();
        getMediaFiles(cpResources);
        Namespace NS = Namespace.getNamespace("ns", "http://www.imsglobal.org/xsd/imscp_v1p1"); 
        List<Element> allResources = iDoc.getRootElement().getChild("resources", NS).getChildren();
        //find media in the content package
        Map<String, List<String>> mMedia = media;
        Iterator<Entry<String, List<String>>> iterator = media.entrySet().iterator();
        while(iterator.hasNext())
        {
            Map.Entry<String, List<String>> pairs = (Map.Entry<String, List<String>>)iterator.next();
            List<String> idRefs = new ArrayList<String>();
            Iterator<String> value = pairs.getValue().iterator();
            while(value.hasNext())
            {
                String mediaFile = value.next();
                Iterator<File> mediaIterator = mediaFiles.iterator();
                while(mediaIterator.hasNext())
                {
                    File file = mediaIterator.next();
                    String filePath = file.getParentFile().getName() + File.separator + file.getName();
                    System.out.println(filePath);
                    if(filePath.contains(mediaFile))
                    {
                        idRefs.add("RES-"+mediaFile);
                        //generate new resources for each list (one resource per file)
                        if(!newResource.contains(mediaFile))
                        {
                            newResource.add(mediaFile);
                            Element mediaResource = new Element("resource");
                            mediaResource.setNamespace(iDoc.getRootElement().getNamespace());
                            mediaResource.setAttribute(new Attribute("identifier", "RES-"+mediaFile));
                            mediaResource.setAttribute(new Attribute("type", "webcontent"));
                            mediaResource.setAttribute(new Attribute("scormType", "asset"));
                            mediaResource.setAttribute(new Attribute("href", filePath));
                            Element fileElement = new Element("file");
                            fileElement.setNamespace(iDoc.getRootElement().getNamespace());
                            fileElement.setAttribute(new Attribute("href", filePath));
                            mediaResource.setContent(fileElement);
                            //add the new resources element
                            allResources.add(mediaResource);
                        }
                    }
                }
            }
            
            //updates the new media map with the file names (identifier) of the
            //resource elements that were added for the media
            if(!idRefs.isEmpty())
            {
                mMedia.put(pairs.getKey(), idRefs);
            }
        }

        //get resource names from map keys (updated Media map)
        Iterator<Entry<String, List<String>>> updatedIterator = mMedia.entrySet().iterator();
        while(updatedIterator.hasNext())
        {
            Map.Entry<String, List<String>> pairs = (Map.Entry<String, List<String>>)updatedIterator.next();
            
            String key = pairs.getKey();
            List<String> dependNames = pairs.getValue();
            //search existing for resource that contains that name
            XPath xpath = XPath.newInstance("/ns:manifest//ns:resources//ns:resource//ns:file//@href");
            xpath.addNamespace(NS);
            
            List<Attribute> hrefList = xpath.selectNodes(iDoc);
            Iterator<Attribute> hrefIterator = hrefList.iterator();
            while(hrefIterator.hasNext())
            {
                Attribute href = hrefIterator.next();
                String hrefValue = href.getValue();
                boolean addDepend = true;
                if (hrefValue.equals("resources" + File.separator + key))
                {
                    Element resource = href.getParent().getParentElement();
                    System.out.println("in if");
                    Iterator<String> newDepend = dependNames.iterator();
                    while(newDepend.hasNext())
                    {
                        String ref = newDepend.next();
                        Element dependency = new Element("dependency");
                        dependency.setNamespace(iDoc.getRootElement().getNamespace());
                        dependency.setAttribute(new Attribute("identifierref", ref));
                        

                        List<Element> children = resource.getChildren();
                        Iterator<Element> childrenIterator = children.iterator();
                        while(childrenIterator.hasNext())
                        {
                            Element node = childrenIterator.next();
                            if(node.getName().equals("dependency"))
                            {
                                if(node.getAttribute("identifierref").getValue().equals(ref))
                                {
                                    addDepend = false;
                                }
                            }
                        }
                        if(addDepend)
                        resource.addContent(dependency);
                    }
                   
                }
            }
        }

        return updateXMLSource(iDoc);   
    }
    
    /**
     * Takes the manifest file in Document form that has been updated and creates
     * a new File object to be added to the Context map.
     * 
     * @param iDoc Document representing the manifest.
     * @return File that is the updated manifest file.
     */
    private File updateXMLSource(Document iDoc)
    {
        XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
        File temp = new File("imsmanifest.xml");
        try {
            FileWriter writer = new FileWriter(temp);
            outputter.output(iDoc, writer);
            writer.close();
        } catch (java.io.IOException e) {
            e.printStackTrace();
        }

        return temp;
    }    
    
    /**
     * Provides the file name for each file in the Resource Package
     * @param srcFile File that is the root of the Resource Package.
     */
    public void getMediaFiles(File srcFile)
    {
        if (srcFile.isDirectory()) 
        {
 
            String[] oChildren = srcFile.list();
            for (int i=0; i < oChildren.length; i++) 
            {
                getMediaFiles(new File(srcFile, oChildren[i]));
            }
        } 
        else 
        {
             if(!srcFile.getName().endsWith(".svn-base"))
             mediaFiles.add(srcFile);
            
        }
        
    }
    

    
}
