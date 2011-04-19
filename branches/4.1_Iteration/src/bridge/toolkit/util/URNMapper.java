/**
 * This file is part of the S1000D-SCORM Bridge Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.util;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.jdom.Attribute;
import org.jdom.Document;
import org.jdom.Element;

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
     */
    public static List<File> getSourceFiles(String src_dir)
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

                urn = writeUrn(name, file_name, "");
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
                        urn = writeUrn(name, file_name, directoryDepth);
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
        // assume manifest is at level with resources folder
        if (name.startsWith("ICN"))
        {
            target.setText(directoryDepth + "media/" + file_name);
        }
        else
        {
            target.setText(directoryDepth + file_name);
        }
        urn.addContent(target);
        return urn;
    }
}
