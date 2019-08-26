/**
 * This file is part of the S1000D Transformation Toolkit 
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
     * Output directory defaults to the directory of the toolkit 
     * if none is specified 
     */
    public static final String OUTPUT_DIRECTORY = "output_directory";

    /**
     * Output directory defaults to the directory of the toolkit 
     * if none is specified 
     */
    public static final String PDF_OUTPUT_OPTION = "pdf_output_option";
    
    /**
     * A list of temporary files generated by the mobile builder that are 
     * deleted in the Clean up command
     */
    public static final String MOBLIE_FILES_TO_DELETE = "moblie_files_to_delete";
    /**
     * File that represents the directory that is being used to build the 
     * SCORM Content Package.
     */
    public static final String CP_PACKAGE = "cp_package";
    
    /**
     * The urn_resource_map.xml file that provides a way to map all of the 
     * URN values for the resources to the file names.
     */
    public static final String URN_MAP = "urn_resource_map";
    
    
    /**
     * String that represents whether or not to render in html
     */
    public static final String OUTPUT_TYPE = "output_type";
    
    /**
     * String that represents Min passing score
     */
    public static final String MIN_SCORE = "80"; 
}
