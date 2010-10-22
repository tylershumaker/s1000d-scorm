/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit;

/**
 * Exception class that is thrown when a URN is generated from in two different 
 * files in the Resource Package.  This causes a collision in the 
 * urn_resource_map.xml file that prevents the correct file href to be added 
 * to the imsmanifest.xml file during the transform. 
 */
public class ResourceMapException extends Exception
{
    /**
     * The URN that has been identified as existing in two separate files.
     */
    private String urn;

    /**
     * The first file that was identified and already exists in the 
     * urn_resource_map.xml file.
     */
    private String file1;
    
    /**
     * The second file that was identified and now can not be added to the 
     * urn_resource_map.xml file.
     */
    private String file2;
    
    /**
     * Constructor
     * 
     * @param urnFormat String the represents the URN.
     * @param secondFile String that is the second file to be identified with that
     * URN.
     * @param firstFile String that represents the first file that has already 
     * been added to the urn_resource_map.xml.
     */
    public ResourceMapException(String urnFormat, String secondFile,
            String firstFile)
    {
        urn = urnFormat;
        file1 = firstFile;
        file2 = secondFile;
    }

    /**
     * Writes the exception message out.
     */
    public void printTrace()
    {
        StringBuffer trace = new StringBuffer();
        trace.append("The following " + urn +"\n");
        trace.append("was found in both the file :" +file1+ "\n");
        trace.append("and the file : " +file2+ ".\n");
        System.out.println(trace);
    }
    
}
