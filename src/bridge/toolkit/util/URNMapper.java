/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.util;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.jdom.Attribute;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;

/**
 * Generates a urn_resource_map.xml file that is used
 * to map each file in the resource package by file name to the S1000D URN. 
 */
public class URNMapper
{
   
    /**
     * Retrieves all of the files in a specified directory and returns them
     * in a list. 
     * 
     * @param src_dir String that represents the location of directory.
     * @return List<File> List of all of the files found in the source directory.
     * @throws IOException 
     * @throws JDOMException 
     */
    public static List<File> getSourceFiles(String src_dir) throws JDOMException, IOException
    {
        File csdb_files = new File(src_dir);

        List<File> src_files = new ArrayList<File>();
        File [] testVR = csdb_files.listFiles();
        
        for(File file : testVR)
        {
            // Add the file only if is not .svn (for test in working copy)
            // and check for s1000d 4.1 scoContent data modules
            if (!file.getName().equals(".svn"))
            {
                if(file.getName().endsWith(".xml"))
                {    
                    if(!SCOContentDMChecker.isSCOContentDM(file))
                    {
                        src_files.add(file);
                    }
                }
                else
                {
                    src_files.add(file);
                }
            }
                
            
            //check for s1000d 4.1 scoContent data modules
        }            
        return src_files;

    }
    

    /**
     * Walks through the List of files that represent all of the files in the
     * resource package and generates a urn_resource_map.xml file that is used
     * to map each file by file name to the S1000D URN. 
     * 
     * @param src_files List<Files> of all of the files found in the resources 
     * package.
     * @param directoryDepth String that add padding for the directory depth if needed.
     * @return Document JDOM Document that represents the urn_resource_map.xml 
     * file. 
     */
    public static Document writeURNMap(List<File> src_files, String directoryDepth)
    {
        Document urn_map = new Document();
        Element urnResource = new Element("urn-resource");
        Element urn = null;
        String file_name = null;
        String name = null;
        Iterator<File> filesIterator = src_files.iterator();
        while(filesIterator.hasNext())
        {
            File file = filesIterator.next();
            if (!file.isDirectory())
            {
                file_name = file.getName();
             
                // Split the string on the last occurrence of a period (the extension part of the file name)
                // This permits the use of periods in the filename itself
                name = file_name.substring(0, file_name.lastIndexOf('.'));
             
                if(name.contains("_"))
                {
                    String underscore_split[] = name.split("_");
                	
                    name = underscore_split[0];
                    urn = writeUrn(name, file_name, "");
                }
                else
                {
                    urn = writeUrn(name, file_name, directoryDepth);
                }
                
                urnResource.addContent(urn);
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
     * @param directoryDepth String that add padding for the directory depth if needed.
     * @return Element JDOM Element
     */
    private static Element writeUrn(String name, String file_name, String directoryDepth)
    {
        Element urn = new Element("urn");
        urn.setAttribute(new Attribute("name", "URN:S1000D:" + name));
        Element target = new Element("target");
        Attribute type = new Attribute("type", "file");
        target.setAttribute(type);
        target.setText(directoryDepth + file_name);

        urn.addContent(target);
        return urn;
    }
}
