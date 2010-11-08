package SCPMTransformer;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.StringWriter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

//import org.apache.commons.chain.Command;
import org.jaxen.BaseXPath;
import org.jaxen.JaxenException;
//import org.apache.commons.chain.Context;
import org.jdom.Attribute;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Namespace;
import org.jdom.filter.ElementFilter;
import org.jdom.filter.Filter;
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
			 
			 boolean success = writeManifest(manifest);
			 
			 System.out.println("RESOURCE ADDED: " + the_name);
		 }
		 mapDependencies();
	}
	
	private static void mapDependencies()
	{
		//build the manifest to get the added resource elements
		manifest = buildManifest();
		//***************************************************************
		Namespace ns = Namespace.getNamespace("ns","http://www.imsglobal.org/xsd/imscp_v1p1");
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
		int len = scos.size();
		
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
		int key_len = sco_map.entrySet().size();
		System.out.println("Processing SCO Dependencies . . . .");
		processDeps(sco_map);
	   	
	}
	
	private static void processDeps(Map sco_map)
	{
		Namespace default_ns = manifest.getRootElement().getChild("resources",null).getNamespace();
		Element sco_resource = null;
		List<String> dependencies = null;
		XPath xp = null;
		String sco_key;
		
		// the updated map will track dependency addition to the sco to prevent duplicate entries before writing to the manifest
		//iterate the sco map entries
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
	
	private static List<String> searchForDmRefs(Document dmDoc, Element sco_resource)
	{
		Namespace ns = Namespace.getNamespace("http://www.imsglobal.org/xsd/imscp_v1p1");
		//Element resources = manifest.getRootElement().getChild("resources", ns);
//		Element root = dmDoc.getRootElement();
//		Namespace x = root.getNamespace();
		
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
		String theExt = null;
		String name = null;
		for(int i = 0; i<src_files.length;i++)
		{
			if(!src_files[i].isDirectory())
			{
				file_name = src_files[i].getName();
				String [] split = Splitter(file_name);
				name = splitName(file_name);
				theExt = split[split.length - 1];
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
						String [] split = Splitter(file_name);
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
	
	private static String splitName(String toSplit)
	{
		String split[] = toSplit.split("_");
		
		return split[0];
	}
	private static String [] Splitter(String toSplit)
	{
		String [] split = toSplit.split("\\."); 
		
		return split;
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

//class FileListFilter implements FilenameFilter {
//	  private String name; 
//
//	  private String extension; 
//
//	  public FileListFilter(String name, String extension) {
//	    this.name = name;
//	    this.extension = extension;
//	  }
//
//	  public boolean accept(File directory, String filename) {
//	    boolean fileOK = true;
//
//	    if (name != null) {
//	      fileOK &= filename.startsWith(name);
//	    }
//
//	    if (extension != null) {
//	      fileOK &= filename.endsWith('.' + extension);
//	    }
//	    return fileOK;
//	  }
//	}


//List<String> lst_resources = null;
//try 
//{
	//the following code can be used to verify the resource
	//xp = XPath.newInstance("//ns:resource[contains(@identifier,'" + the_icn + "')]");
//	xp = XPath.newInstance("//ns:resource[@identifier='" + the_icn + "']");
//	xp.addNamespace("ns","http://www.imsglobal.org/xsd/imscp_v1p1");
//	Element resource = (Element)xp.selectSingleNode(manifest);
//	if(!icn_dependencies.contains(the_icn))
//	{
//		icn_dependencies.add(the_icn);
//	}	
//} 
//catch (JDOMException e1) 
//{
//	// TODO Auto-generated catch block
//	e1.printStackTrace();
//}
//private static void addDependencies(ArrayList dependencies)
//{
//	for(int i=0;i<dependencies.size();i++)
//	{
//		//extract the map from the array parameter
//		Map<String, List<String>> map = (Map<String, List<String>>) dependencies.get(i);
//		int len = map.values().toArray().length;
//		Iterator iter = map.keySet().iterator(); 
//		//recurse the dependencies array
//		while (iter.hasNext())
//		{
//			//VAR key provides the parent DM for refdm and media files (ICN)
//			//use the key value to read the scotype resource(s) where the key dm is located in the manifest
//			String key = (String) iter.next(); 
//			XPath xp;
//			Element sco_resource = null;
//			List<Element> key_resources = null;
//			try {
//				xp = XPath.newInstance("//ns:file[contains(@href,'" + key + "')]");
//				xp.addNamespace("ns","http://www.imsglobal.org/xsd/imscp_v1p1");
//				key_resources = (ArrayList)xp.selectNodes(manifest);
//			} catch (JDOMException e1) {
//				// TODO Auto-generated catch block
//				e1.printStackTrace();
//			}
//			
//			ListIterator<Element> li = key_resources.listIterator();
//			//recurse the return(s) from the key DM id match
//			while(li.hasNext())
//			{
//				//sets parser to sco resource level
//				Element key_resource = li.next();
//				sco_resource = key_resource.getParentElement();
//				
//				Namespace ns = Namespace.getNamespace("ns","http://www.imsglobal.org/xsd/imscp_v1p1");
//				List<Element> sco_entries = sco_resource.getChildren("file",ns);
//				
//				//***************************************************************
//				Map<String, List<String>> dep_map = new HashMap<String, List<String>>();
//				
//				ListIterator<Element> sco_iter = sco_entries.listIterator();
//				
//				List dependency_strings = new ArrayList();
//				while(sco_iter.hasNext())
//				{
//					//Map scoMap = 
//					String dependency = null;
//					Element sco_entry = sco_iter.next();
//					ns = sco_entry.getNamespace();
//					String val = sco_entry.getAttribute("href").getValue();
////					
//					//Initialize dependency list from the resource map list dimension
//					
//					List dep_list = (List)map.get(key);
//					ListIterator dep_iter = dep_list.listIterator();
//					boolean found = false;
//					
//					while(dep_iter.hasNext())
//					{
//						dependency = (String)dep_iter.next();
//						if(val.contains(dependency))
//						{
//							found = true;
//							// do nothing
//						}
//					}
//					if(found == false)
//					{
//						
//						if(!dependency_strings.contains(dependency))
//						{
//							dependency_strings.add(dependency);
//						}
//						
//					}
//				}
//				
//				// build map
//				dep_map.put("dependencies", dependency_strings);
				
				// add dependency to sco resource
//				ListIterator dep_list_iter = dependency_string;s.listIterator();
//				
//				while(dep_list_iter.hasNext())
//				{
//					
//					String val = (String)dep_list_iter.next();
//					System.out.println("DEP_VAL: " + val);
//					
//					if(val != null)
//					{
//						System.out.println("DEPENDENCY: " + val + " ADDED");
//						Element dependency_element = new Element("dependency");
//						dependency_element.setNamespace(ns);
//						Attribute identifier = new Attribute("identifierref",val);
//						dependency_element.setAttribute(identifier);
//						List<Element> updated_sco_resource = sco_resource.getChildren("dependency",ns);
//						len = updated_sco_resource.size();
//						
//						if(!updated_sco_resource.contains(dependency_element))
//						{
//							try {
//								sco_resource.addContent(dependency_element);
//							} catch (Exception e) {
//								// TODO Auto-generated catch block
//								e.printStackTrace();
//							}
//						}
//					}
//				}
//				
				
//			}
//			System.out.println("****************************");
//			
//			// end recurse sco
//		}

//	}
//}
