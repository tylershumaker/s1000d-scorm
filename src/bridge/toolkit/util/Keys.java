/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.util;

/**
 * The static values of the keys to be used in the Context class.
 *
 */
public class Keys
{

    /**
     * String that represents the location of the S1000D SCPM file that is being
     * converted into a SCORM Content Package.
     */
    public static final String SCPM_FILE = "scpm_file";
    
    /**
     * String that represents the location of the resource package that contains
     * all the S1000D files referenced in the SCPM to be included in the SCORM 
     * Content Package.
     */
    public static final String RESOURCE_PACKAGE = "resource_package";

    /**
     * The imsmanifest.xml file that is generated from the SCPM.
     */
    public static final String XML_SOURCE = "xml_source";
    
    /**
     * The list of all the files that have been validated to 
     * be referenced in the SCPM and exist in the reource package.
     */
    public static final String VALIDATED_RESOURCES = "validated_resources";
    
    /**
     * Map that associates the all the DM files that have a referenced ICN to
     * a list of the ICNs found in that file.
     */
    public static final String MEDIA_MAP = "media_map";
    
    /**
     * File that represents the directory that is being used to build the 
     * SCORM Content Package.
     */
    public static final String CP_PACKAGE = "cp_package";
}
