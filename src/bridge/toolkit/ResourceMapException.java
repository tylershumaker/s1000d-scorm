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
     * 
     */
    private static final long serialVersionUID = 8601716686561938845L;

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
     * Constructor
     * 
     * @param urnFormat String the represents the URN.
     * @param firstFile String that represents the first file that has already 
     * been added to the urn_resource_map.xml.
     */
    public ResourceMapException(String urnFormat,String firstFile)
    {
        urn = urnFormat;
        file1 = firstFile;
    }

    /**
     * Writes the exception message out.
     */
    public void printTrace()
    {
        StringBuffer trace = new StringBuffer();
        trace.append("Resource " + file1 + " contains a dependency of Resource " + urn + ",\n");
        trace.append("however the Resource " + urn + "was not found in the imsmanifest.xml \n");
        trace.append("file produced during the transformation.  Please check the \n");
        trace.append("\"Resource Package\" provided to the Toolkit to determine if \n");
        trace.append("it contains all of the files referenced in the SCPM.");
        System.out.println(trace);
    }
    
}
