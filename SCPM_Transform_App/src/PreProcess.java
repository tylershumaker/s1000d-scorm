package SCPMTransformer;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
//import java.io.FilenameFilter;
//import java.io.StringWriter;

import java.io.IOException;
import java.util.ArrayList;
//import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
//import java.util.ListIterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

//import org.apache.commons.chain.Command;
//import org.jaxen.BaseXPath;
//import org.jaxen.JaxenException;
//import org.apache.commons.chain.Context;
import org.jdom.Attribute;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Namespace;
//import org.jdom.filter.ElementFilter;
//import org.jdom.filter.Filter;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.jdom.xpath.XPath;


public class PreProcess
{
	private static SAXBuilder sb;
	private static XMLOutputter outputter;
	private static Document manifest;
	private static Document urn_map;
	private static Namespace adlcp = Namespace.getNamespace("adlcp","http://www.adlnet.org/xsd/adlcp_v1p3");
	private static String src_dir = System.getProperty("user.dir") + File.separator + "S1000D_Bike_package\\TrainingContent";
	private static String urn_map_path = System.getProperty("user.dir") + File.separator + "xsl\\urn_resource_map.xml";
	private static String manifest_path = System.getProperty("user.dir") + File.separator + "xsl\\imsmanifest.xml";
	public static void main(String [] args)
	{
		sb = new SAXBuilder();
		try 
		{
			urn_map = sb.build(new File(urn_map_path));
		}
		catch (JDOMException e)
		{
			 e.printStackTrace();
		}
		catch(IOException e)
		{
			 e.printStackTrace();
		}

		File[] src_files = getSourceFiles(src_dir);
		doTransform();
		
		//WRITE THE URN MAP
		writeURNMap(src_files);
		
		manifest = buildManifest();
		
		//ADD RESOURCE TYPE ASSETS
		addResources(urn_map);
		//FINAL - write the finished manifest
		boolean success = writeManifest(manifest);
		if(success == true)
		{
			System.out.println("CONVERSION OF SCPM TO IMSMANIFEST SUCCESSSFULL!!!!");
		}
	        return;
	}
	
	private static Document buildManifest()
	{
		try {
			manifest = sb.build(new File(manifest_path));
		} catch (JDOMException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return manifest;
	}
	
	private static boolean writeManifest(Document manifest)
	{
		boolean success = true;
		XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
        File temp = new File(System.getProperty("user.dir") + File.separator + "xsl//imsmanifest.xml");
        try {
            FileWriter writer = new FileWriter(temp,false);
            outputter.output(manifest, writer);
            writer.flush();
            writer.close();
        } catch (java.io.IOException e) {
            e.printStackTrace();
            success = false;
        }
        
        return success;
	}
	
	@SuppressWarnings("unchecked")
	private static void addResources(Document urn_map)
	{
		 Element resources = manifest.getRootElement().getChild("resources",null);
		 Namespace ns = resources.getNamespace();
		 Namespace adlcpNS = Namespace.getNamespace("adlcp","http://www.adlnet.org/xsd/adlcp_v1p3");
		 List<Element> urns = urn_map.getRootElement().getChildren();
		 for(int i=0;i<urns.toArray().length;i++)
		 {
			 String the_href = urns.get(i).getChildText("target", null);
			 String the_name = urns.get(i).getAttributeValue("name").replace("URN:S1000D:","");
			 
			 Element resource = new Element("resource");
			 Attribute id = new Attribute("identifier",the_name);
			 Attribute type = new Attribute("type","webcontent");
			 Attribute scormtype = new Attribute("scormtype","resource",adlcpNS);
			 Attribute href = new Attribute("href",the_href);
			 href.setValue(the_href);
			 resource.setAttribute(id);
			 resource.setAttribute(type);
			 resource.setAttribute(scormtype);
			 resource.setAttribute(href);

			 // get the parent element namespace (implicit - the default namespace) and assign to resource element to prevent empty default namespace in resource element
			
			 resources.addContent(resource);
			 resource.setNamespace(ns);
			 
			 @SuppressWarnings("unused")
			boolean success = writeManifest(manifest);
			 
			 System.out.println("RESOURCE ADDED: " + the_name);
		 }
		 mapDependencies();
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private static void mapDependencies()
	{
		//build the manifest to get the added resource elements
		manifest = buildManifest();
		//***************************************************************
		Namespace ns = Namespace.getNamespace("ns","http://www.imsglobal.org/xsd/imscp_v1p1");
		@SuppressWarnings("unused")
		Namespace adlcpNS = Namespace.getNamespace("adlcp","http://www.adlnet.org/xsd/adlcp_v1p3");
		Map<String, List<String>> sco_map = new HashMap<String, List<String>>();
		
		// get the manifest sco resources
		XPath xp;
		List<Element> scos = null;
		try {
			xp = XPath.newInstance("//ns:resource[@adlcpNS:scormtype='sco']");
			xp.addNamespace("ns","http://www.imsglobal.org/xsd/imscp_v1p1");
			xp.addNamespace("adlcpNS","http://www.adlnet.org/xsd/adlcp_v1p3");
			scos = (ArrayList)xp.selectNodes(manifest);
		} catch (JDOMException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//iterate through the sco list 
		Iterator <Element> iter = scos.iterator();
		while(iter.hasNext())
		{
			Element sco = iter.next();
			String sco_identifier = sco.getAttributeValue("identifier");
			List<Element> resFiles = sco.getChildren("file", ns);
			
			List <String> hrefs = new ArrayList<String>();
			for(int i = 0;i<resFiles.size();i++)
			{
				//System.out.println("HREF :" + resFiles.get(i));
				Element resFile = resFiles.get(i);
				
				String file_href = (resFile.getAttributeValue("href"));
				if(file_href != "")
				{
				String [] split = file_href.split("/");
				String identifier = split[split.length-1];
				hrefs.add(identifier);
				}
			}
			sco_map.put(sco_identifier,hrefs);
		}
		@SuppressWarnings("unused")
		int key_len = sco_map.entrySet().size();
		System.out.println("Processing SCO Dependencies . . . .");
		processDeps(sco_map);
	   	
	}
	
	private static void processDeps(@SuppressWarnings("rawtypes") Map sco_map)
	{
		Namespace default_ns = manifest.getRootElement().getChild("resources",null).getNamespace();
		Element sco_resource = null;
		List<String> dependencies = null;
		XPath xp = null;
		String sco_key;
		
		// the updated map will track dependency addition to the sco to prevent duplicate entries before writing to the manifest
		//iterate the sco map entries
		@SuppressWarnings("unchecked")
		Iterator<Entry<String, List<String>>> iter = sco_map.entrySet().iterator();
		while (iter.hasNext())
		{
			Map.Entry<String, List<String>> pairs = (Map.Entry<String, List<String>>)iter.next();
			//store the sco identifier
			sco_key = pairs.getKey();
			
	            try {
					xp = XPath.newInstance("//ns:resource[@identifier='" + sco_key + "']");
				} catch (JDOMException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	            xp.addNamespace("ns","http://www.imsglobal.org/xsd/imscp_v1p1");
	            try {
						sco_resource = (Element) xp.selectSingleNode(manifest);
				} catch (JDOMException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
            Iterator<String> value = pairs.getValue().iterator();
            //store the icn references
            dependencies = new ArrayList<String>();
            while(value.hasNext())
            {
            	String str_current = value.next();
            	String resource_path = src_dir + "//" + str_current;
            	File file = new File(resource_path);
            	Document dmDoc = getDoc(file);
            	//reach into the dm docs and find ICN references
    			List<String> icnRefs = searchForICN(dmDoc);
    			Iterator<String> icn_iter = icnRefs.iterator();
    			while(icn_iter.hasNext())
    			{
    				String the_icn = icn_iter.next();
    				if(!dependencies.contains(the_icn))
					{
						dependencies.add(the_icn);
					}	
    			}
    			
    			// get the dm refs
    			List<String> dmrefs = searchForDmRefs(dmDoc, sco_resource);
    			Iterator<String> dmref_iter = dmrefs.iterator();
    			while(dmref_iter.hasNext())
    			{
    				String dmref = dmref_iter.next();
    				if(!dependencies.contains(dmref))
					{
						dependencies.add(dmref);
					}	
    			}
            }
		// add the dependencies
		//Iterate the icn list add dependency elements to manifest
		Iterator<String> dependency_iter = dependencies.iterator();
		while(dependency_iter.hasNext())
		{
			String identifierref = dependency_iter.next();
			Element dependency = new Element("dependency");
			
			dependency.setAttribute("identifierref", identifierref);
			sco_resource.addContent(dependency);
			dependency.setNamespace(default_ns);
			System.out.println("ICN RESOUREC: " + identifierref + " ADDED TO SCO: " + sco_key);
		}
		writeManifest(manifest);
		}		
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private static List<String> searchForDmRefs(Document dmDoc, Element sco_resource)
	{
		Namespace ns = Namespace.getNamespace("http://www.imsglobal.org/xsd/imscp_v1p1");
		List<String> referencedDMs = new ArrayList<String>();
		
    	XPath xp = null;
    	
		try {
			xp = XPath.newInstance("//dmCode");
		} catch (JDOMException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
    	List<Element> dmc_lst = null;
		try {
			dmc_lst = (ArrayList) xp.selectNodes(dmDoc);
		} catch (JDOMException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		int len = dmc_lst.size();
		if(len > 0)
		{
			System.out.println("SIZE: " + len);
		}
		
    	Iterator<Element> refdms = dmc_lst.iterator();
    	while(refdms.hasNext() == true)
    	{
    		Element e = refdms.next();
    		Element theAncestor = (Element) e.getParent().getParent();
    		String dmc;
    		if(theAncestor.getName() == "dmRef")
    		{
	    		dmc = "DMC-";
	    		@SuppressWarnings("unchecked")
				List<Attribute> atts = e.getAttributes();
	    		for(int i=0;i<atts.toArray().length;i++)
	    		{
	    			if(atts.get(i).getName() == "modelIdentCode")
	    			{
	    				dmc += atts.get(i).getValue() + "-";
	    			}
	    			else if(atts.get(i).getName() == "systemDiffCode")
	    			{
	    				dmc += atts.get(i).getValue() + "-";
	    			}
	    			else if(atts.get(i).getName() == "systemCode")
	    			{
	    				dmc += atts.get(i).getValue() + "-";
	    			}
	    			else if(atts.get(i).getName() == "subSystemCode")
	    			{
	    				dmc += atts.get(i).getValue();
	    			}
	    			else if(atts.get(i).getName() == "subSubSystemCode")
	    			{
	    				dmc += atts.get(i).getValue() + "-";
	    			}
	    			else if(atts.get(i).getName() == "assyCode")
	    			{
	    				dmc += atts.get(i).getValue() + "-";
	    			}
	    			else if(atts.get(i).getName() == "disassyCode")
	    			{
	    				dmc += atts.get(i).getValue();
	    			}
	    			else if(atts.get(i).getName() == "disassyCodeVariant")
	    			{
	    				dmc += atts.get(i).getValue() + "-";
	    			}
	    			else if(atts.get(i).getName() == "infoCode")
	    			{
	    				dmc += atts.get(i).getValue();
	    			}
	    			else if(atts.get(i).getName() == "infoCodeVariant")
	    			{
	    				dmc += atts.get(i).getValue() + "-";
	    			}
	    			else if(atts.get(i).getName() == "itemLocationCode")
	    			{
	    				if(atts.toArray().length > 11)
	    				{
	    					dmc += atts.get(i).getValue()+ "-";
	    				}
	    				else
	    				{
	    					dmc += atts.get(i).getValue();
	    				}
	    			}
	    			else if(atts.get(i).getName() == "learnCode")
	    			{
	    				dmc += atts.get(i).getValue();
	    			}
	    			else if(atts.get(i).getName() == "learnEventCode")
	    			{
	    				dmc += atts.get(i).getValue();
	    			}
	    			
	    		}// end for
	    		boolean found = false;
	    		
	    		@SuppressWarnings("unchecked")
				List<Element> sco_resources = sco_resource.getChildren("file",ns);
	    		Iterator<Element> iter = sco_resources.iterator();
	    		String href = "";
	    		while(iter.hasNext())
	    		{
	    			Element current_el = iter.next();
	    			
	    			try {
						href = current_el.getAttributeValue("href");
					} catch (Exception e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
	    			if(href.contains(dmc))
	    			{
	    				found = true;
	    			}
	    		}
	    		if(!referencedDMs.contains(dmc) & found == false & href != "")
	    		{
	    			System.out.println("DMC: " + dmc);
	    			referencedDMs.add(dmc);
	    		}
    		}//end if
    		
    	}// end while
    	return referencedDMs;
	}
	
    @SuppressWarnings({ "unchecked", "rawtypes" })
	private static List<String> searchForICN(Document doc)
	{
		List<Element> els = null;
		List <String> icnRefs = new ArrayList<String>();
		try {
			els = (ArrayList)XPath.selectNodes(doc, "//*[@infoEntityIdent]");
		} catch (JDOMException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		for(int i=0;i<els.size();i++)
		{
			Element e = (Element) els.get(i);
			String icn = null;
			if(e.getAttribute("infoEntityIdent") != null)
			{
				icn = e.getAttributeValue("infoEntityIdent");
				
				if(!icnRefs.contains(icn))
				{
					icnRefs.add(icn);
				}
			}
		}
		return icnRefs;	
		}
		
	private static void doTransform()
	{
		String xsl_source = System.getProperty("user.dir") + File.separator + "xsl\\preProcessTransform.xsl";
		String scpm_source = System.getProperty("user.dir") + File.separator + "SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml";
		TransformerFactory tFactory = TransformerFactory.newInstance();
		    
        Transformer transformer = null;
		try {
			transformer = tFactory.newTransformer(new StreamSource(xsl_source));
		} catch (TransformerConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
        File the_manifest = new File(System.getProperty("user.dir") + File.separator + "xsl\\imsmanifest.xml");
        try {
			transformer.transform(new StreamSource(scpm_source), new StreamResult(new FileOutputStream(the_manifest)));
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TransformerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private static File[] getSourceFiles(String src_dir)
	{
		src_dir = System.getProperty("user.dir") + File.separator + "S1000D_Bike_package\\TrainingContent";
		File csdb_files = new File(src_dir);
		File[] src_files = csdb_files.listFiles();
		return src_files;
	}
	
	private static void writeURNMap(File[] src_files)
	{
		Document urn_map = new Document();
		Element urnResource = new Element("urn-resource");
		Element urn = null;
		String file_name = null;
		@SuppressWarnings("unused")
		String theExt = null;
		String name = null;
		for(int i = 0; i<src_files.length;i++)
		{
			if(!src_files[i].isDirectory())
			{
				file_name = src_files[i].getName();
				String [] split = file_name.split("\\.");
				theExt = split[split.length - 1];
				file_name = split[0] + "." + theExt;
				split = file_name.split("_");
				name = split[0];
				
				
				urn = writeUrn(name, file_name);
				 urnResource.addContent(urn);
			}
			else
			{
				if(src_files[i].isDirectory() & src_files[i].getName().equals("media"))
				{
					//recurse the media folder
					File [] media_files = src_files[i].listFiles();
					for(int j = 0; j < media_files.length;j++)
					{
						file_name = media_files[j].getName();
						String [] split =  file_name.split("\\.");
						name = split[0];
						theExt = split[split.length - 1];
						urn = writeUrn(name, file_name);
						urnResource.addContent(urn);
					}
				}
			}
		}
		urn_map.addContent(urnResource);
		 XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat());
	        File temp = new File(System.getProperty("user.dir") + File.separator + "xsl//urn_resource_map.xml");
	        try {
	        	
	            FileWriter writer = new FileWriter(temp, false);
	            outputter.output(urn_map, writer);
	            writer.close();
	        } catch (java.io.IOException e) {
	            e.printStackTrace();
	        }
	        // cleanup
	        urn_map = null;
	}
	
	private static Element writeUrn(String name, String file_name)
	{
		Element urn = new Element("urn");
		urn.setAttribute(new Attribute("name", "URN:S1000D:" + name));
        Element target = new Element("target");
        Attribute type = new Attribute("type","file");
        target.setAttribute(type);
        // assume manifest is at level with resources folder
        if(name.startsWith("ICN"))
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
	
	private static Document getDoc(File anXmlDocFile)
    {
        Document doc = null;
        try
        {
            doc = sb.build(anXmlDocFile);
            
        }
        catch (JDOMException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        catch (IOException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return doc;
    }
}
