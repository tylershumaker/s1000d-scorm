/**
 * This file is part of the S1000D Transformation Toolkit
 * project hosted on Sourceforge.net. See the accompanying
 * license.txt file for applicable licenses.
 */
package bridge.toolkit;


import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import java.io.File;
import java.util.ArrayList;

/**
 *
 */
public class ControllerTest
{

    /**
     * @throws java.lang.Exception
     */
    @Before
    public void setUp() throws Exception
    {
        File output = new File(System.getProperty("user.dir") + File.separator + "output");
        if (!(output.exists()))
        {
            output.mkdir();
        }
    }

    /**
     * @throws java.lang.Exception
     */
    @After
    public void tearDown() throws Exception {
        File output = new File(System.getProperty("user.dir") + File.separator + "output");
        if (output.exists()) {
            System.out.println("Attempting to delete");
            DeleteDirectoryOnExit(output);
        }
    }

    private void DeleteDirectoryOnExit(File dir) {
        if (dir.isDirectory()) {
            String files[] = dir.list();
            for (int f = 0; f < files.length; f++) {
                File innerFile = new File(dir, files[f]);
                if (innerFile.isDirectory()) {
                    DeleteDirectoryOnExit(innerFile);
                } else {
                    innerFile.delete();
                }
            }
        }
        dir.delete();
    }

    /**
     * Test method for {@link bridge.toolkit.Controller#main(java.lang.String[])}.
     */
    @Test
    public void testMain()
    {
        //4.1 - SCORM
        String[] SCORM41FLASH = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM_4.1" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package_4.1",
                "-scormflash"};
        String[] SCORM41HTML = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM_4.1" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package_4.1",
                "-scormhtml"};
        String[] MOBI41 = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM_4.1" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package_4.1",
                "-mobilePerformanceSupport"};
        String[] MOBI41COURSE = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM_4.1" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package_4.1",
                "-mobilecourse"};
        String[] PDF41STUDENT = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM_4.1" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package_4.1",
                "-pdfstudent"};
        String[] PDF41INSTRUCTOR = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM_4.1" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package_4.1",
                "-pdfinstructor"};

        //4.0 - SCORM
        String[] SCORM40FLASH = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package",
                "-scormflash"};
        String[] SCORM40HTML = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package",
                "-scormhtml"};
        String[] MOBI40 = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package",
                "-mobilePerformanceSupport"};
        String[] MOBI40COURSE = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package",
                "-mobileCourse"};
        String[] MOBI40COURSESLIM = {System.getProperty("user.dir") + File.separator + "test_files" + File.separator + "scpm_slim" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "test_files" + File.separator + "resource_package_slim",
                "-mobileCourse"};
        String[] PDF40STUDENT = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package",
                "-pdfstudent"};
        String[] PDF40INSTRUCTOR = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package",
                "-pdfinstructor"};
        String[] SCORM40HTMLSLIM = {System.getProperty("user.dir") + File.separator + "test_files" + File.separator + "scpm_slim" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "test_files" + File.separator + "resource_package_slim",
                "-SCORMHTML"};

        //4.0 - SCORM with output
        String[] SCORM40FLASHWOUT = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package",
                "-scormflash",
                System.getProperty("user.dir") + File.separator + "other"};
        String[] SCORM40HTMLWOUT = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package",
                "-scormhtml",
                System.getProperty("user.dir") + File.separator + "other"};
        String[] MOBI40WOUT = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package",
                "-mobilePerformanceSupport",
                System.getProperty("user.dir") + File.separator + "other"};
        String[] MOBI40WOUTCOURSE = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package",
                "-mobilecourse",
                System.getProperty("user.dir") + File.separator + "other"};
        String[] PDF40WOUTSTUDENT = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package",
                "-pdfstudent",
                System.getProperty("user.dir") + File.separator + "other" };
        String[] PDF40WOUTINSTRUCTOR = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package",
                "-pdfinstructor",
                System.getProperty("user.dir") + File.separator + "other"};

        //4.1 - SCORM with output
        String[] SCORM41FLASHWOUT = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM_4.1" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package_4.1",
                "-scormflash",
                System.getProperty("user.dir") + File.separator + "other"};
        String[] SCORM41HTMLWOUT = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM_4.1" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package_4.1",
                "-scormhtml",
                System.getProperty("user.dir") + File.separator + "other"};
        String[] MOBI41WOUT = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM_4.1" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package_4.1",
                "-mobilePerformanceSupport",
                System.getProperty("user.dir") + File.separator + "other"};
        String[] MOBI41WOUTCOURSE = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM_4.1" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package_4.1",
                "-mobilecourse",
                System.getProperty("user.dir") + File.separator + "other"};
        String[] PDF41WOUTSTUDENT = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM_4.1" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package_4.1",
                "-pdfstudent",
                System.getProperty("user.dir") + File.separator + "other"};
        String[] PDF41WOUTINSTRUCTOR = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM_4.1" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package_4.1",
                "-pdfinstructor",
                System.getProperty("user.dir") + File.separator + "other"};

        String[] SCORMMXTACHHTML = {System.getProperty("user.dir") + "" + File.separator + "test_files" + File.separator + "scpm_mx_tach" + File.separator + "SCP-SYS29-81205-00001-00_000-01_US-EN.xml",
                System.getProperty("user.dir") + "" + File.separator + "test_files" + File.separator + "resource_package_mx_tach",
                "-scormhtml"};

        String[] SCORMOPSEICASHTML = {System.getProperty("user.dir") + "" + File.separator + "test_files" + File.separator + "scpm_ops_eicas" + File.separator + "SCP-SYS01-81205-00001-00_000-01_US-EN.xml",
                System.getProperty("user.dir") + "" + File.separator + "test_files" + File.separator + "resource_package_ops_eicas",
                "-scormhtml"};

        String[] NEWSCORMOPSEICASHTML = {System.getProperty("user.dir") + "" + File.separator + "test_files" + File.separator + "scpm_ops_eicas" + File.separator + "SCP-SYS01-81205-00001-00_000-01_US-EN.xml",
                System.getProperty("user.dir") + "" + File.separator + "test_files" + File.separator + "resource_pkg_ops_eicas_Oct12014",
                "-scormhtml"};

        String[]  MX_NUMHTML = {System.getProperty("user.dir") + "" + File.separator + "test_files" + File.separator + "scpm_mx_tach" + File.separator + "SCP-SYS29-81205-00001-00_000-01_US-EN.xml",
                System.getProperty("user.dir") + "" + File.separator + "test_files" + File.separator + "resource_package_mx_tach",
                "-scormLevelledParaNum"};

        //1.2

        String[]  SCORM_12 = {System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_SCPM" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                    System.getProperty("user.dir") + File.separator + "examples" + File.separator + "bike_resource_package",
                    "-SCORM12"};

        String[]  SCORM12_slim = {System.getProperty("user.dir")  + File.separator + "test_files" + File.separator + "scpm_slim" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "test_files" + File.separator + "resource_package_slim",
                "-SCORM12"};

        String[]  SCORM12_slim_Zip_Resource = {System.getProperty("user.dir")  + File.separator + "test_files" + File.separator + "scpm_slim" + File.separator + "SMC-S1000DBIKE-06RT9-00001-00.xml",
                System.getProperty("user.dir") + File.separator + "test_files" + File.separator + "resource_package_slim.zip",
                "-SCORM12"};

        String[]  SCORM12_slim_ZIP_SCPM = {System.getProperty("user.dir")  + File.separator + "test_files" + File.separator + "scpm_slim.zip",
                System.getProperty("user.dir") + File.separator + "test_files" + File.separator + "resource_package_slim",
                "-SCORM12"};

        Controller.main(SCORM40HTMLWOUT);
    }
}
