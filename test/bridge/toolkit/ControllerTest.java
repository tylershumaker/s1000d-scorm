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
public class ControllerTest {

    /**
     * @throws java.lang.Exception
     */
    @Before
    public void setUp() throws Exception {
        File output = new File(System.getProperty("user.dir") + "\\output");
        if (!(output.exists())) {
            output.mkdir();
        }
    }

    /**
     * @throws java.lang.Exception
     */
    @After
    public void tearDown() throws Exception {
        File output = new File(System.getProperty("user.dir") + "\\output");
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

    private String buildPath(final String... parts) {
        final StringBuilder b = new StringBuilder();
        b.append(System.getProperty("user.dir"));

        for (String p : parts) {
            b.append(File.separator);
            b.append(p);
        }

        return b.toString();
    }

    /**
     * Test method for {@link bridge.toolkit.Controller#main(java.lang.String[])}.
     */
    @Test
    public void testMain() {
        final String bikeScpm41 = buildPath("examples", "bike_SCPM_4.1", "SMC-S1000DBIKE-06RT9-00001-00.xml");
        final String bikeResourcePackage41 = buildPath("examples", "bike_resource_package_4.1");

        //4.1 - SCORM
        String[] SCORM41FLASH = {bikeScpm41, bikeResourcePackage41, "-scormflash"};
        String[] SCORM41HTML = {bikeScpm41, bikeResourcePackage41, "-scormhtml"};
        String[] MOBI41 = {bikeScpm41, bikeResourcePackage41, "-mobilePerformanceSupport"};
        String[] MOBI41COURSE = {bikeScpm41, bikeResourcePackage41, "-mobilecourse"};
        String[] PDF41STUDENT = {bikeScpm41, bikeResourcePackage41, "-pdfstudent"};
        String[] PDF41INSTRUCTOR = {bikeScpm41, bikeResourcePackage41, "-pdfinstructor"};

        final String bikeScpm = buildPath( "examples", "bike_SCPM", "SMC-S1000DBIKE-06RT9-00001-00.xml");
        final String bikeResourcePackage = buildPath("examples", "bike_resource_package");
        final String slim = buildPath( "examples", "scpm_slim", "SMC-S1000DBIKE-06RT9-00001-00.xml");
        final String slimResourcePackage = buildPath("examples", "resource_package_slim");

        //4.0 - SCORM
        String[] SCORM40FLASH = {bikeScpm, bikeResourcePackage, "-scormflash"};
        String[] SCORM40HTML = {bikeScpm, bikeResourcePackage, "-scormhtml"};
        String[] MOBI40 = {bikeScpm, bikeResourcePackage, "-mobilePerformanceSupport"};
        String[] MOBI40COURSE = {bikeScpm, bikeResourcePackage, "-mobileCourse"};
        String[] MOBI40COURSESLIM = {slim, slimResourcePackage, "-mobileCourse"};
        String[] PDF40STUDENT = {bikeScpm, bikeResourcePackage, "-pdfstudent"};
        String[] PDF40INSTRUCTOR = {bikeScpm, bikeResourcePackage, "-pdfinstructor"};
        String[] SCORM40HTMLSLIM = {slim, slimResourcePackage, "-SCORMHTML"};

        final String other = buildPath("other");

        //4.0 - SCORM with output
<<<<<<< HEAD
        String[] SCORM40FLASHWOUT = {bikeScpm, bikeResourcePackage, "-scormflash", other};
        String[] SCORM40HTMLWOUT = {bikeScpm, bikeResourcePackage, "-scormhtml", other};
        String[] MOBI40WOUT = {bikeScpm, bikeResourcePackage, "-mobilePerformanceSupport", other};
        String[] MOBI40WOUTCOURSE = {bikeScpm, bikeResourcePackage, "-mobilecourse", other};
        String[] PDF40WOUTSTUDENT = {bikeScpm, bikeResourcePackage, "-pdfstudent", other};
        String[] PDF40WOUTINSTRUCTOR = {bikeScpm, bikeResourcePackage, "-pdfinstructor", other};

        //4.1 - SCORM with output
        String[] SCORM41FLASHWOUT = {bikeScpm41, bikeResourcePackage41, "-scormflash", other};
        String[] SCORM41HTMLWOUT = {bikeScpm41, bikeResourcePackage41, "-scormhtml", other};
        String[] MOBI41WOUT = {bikeScpm41, bikeResourcePackage41, "-mobilePerformanceSupport", other};
        String[] MOBI41WOUTCOURSE = {bikeScpm41, bikeResourcePackage41, "-mobilecourse", other};
        String[] PDF41WOUTSTUDENT = {bikeScpm41, bikeResourcePackage41, "-pdfstudent", other};
        String[] PDF41WOUTINSTRUCTOR = {bikeScpm41, bikeResourcePackage41, "-pdfinstructor", other};
=======
		String[] SCORM40FLASHWOUT = {System.getProperty("user.dir") +"\\examples\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml",
									 System.getProperty("user.dir") +"\\examples\\bike_resource_package",
									 "-scormflash",
									 System.getProperty("user.dir") +"\\other"};
		String[] SCORM40HTMLWOUT = {System.getProperty("user.dir") +"\\examples\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml",
									System.getProperty("user.dir") +"\\examples\\bike_resource_package",
									"-scormhtml",
									System.getProperty("user.dir") +"\\other"};
		String[] MOBI40WOUT = {System.getProperty("user.dir") +"\\examples\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml",
					           System.getProperty("user.dir") +"\\examples\\bike_resource_package",
					           "-mobilePerformanceSupport",
					           System.getProperty("user.dir") +"\\other"};
		String[] MOBI40WOUTCOURSE = {System.getProperty("user.dir") +"\\examples\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml",
									 System.getProperty("user.dir") +"\\examples\\bike_resource_package",
									 "-mobilecourse",
									 System.getProperty("user.dir") +"\\other"};
		String[] PDF40WOUTSTUDENT = {System.getProperty("user.dir") +"\\examples\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml",
					          		 System.getProperty("user.dir") +"\\examples\\bike_resource_package",
					          		 "-pdfstudent",
					          		 System.getProperty("user.dir") +"\\other" };
		String[] PDF40WOUTINSTRUCTOR = {System.getProperty("user.dir") +"\\examples\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml",
										System.getProperty("user.dir") +"\\examples\\bike_resource_package",
										"-pdfinstructor",
										System.getProperty("user.dir") +"\\other"};

		//4.1 - SCORM with output
        String[] SCORM41FLASHWOUT = {System.getProperty("user.dir") +"\\examples\\bike_SCPM_4.1\\SMC-S1000DBIKE-06RT9-00001-00.xml",
        							 System.getProperty("user.dir") +"\\examples\\bike_resource_package_4.1",
        							 "-scormflash",
        							 System.getProperty("user.dir") +"\\other"};
        String[] SCORM41HTMLWOUT = {System.getProperty("user.dir") +"\\examples\\bike_SCPM_4.1\\SMC-S1000DBIKE-06RT9-00001-00.xml",
									System.getProperty("user.dir") +"\\examples\\bike_resource_package_4.1",
									"-scormhtml",
									System.getProperty("user.dir") +"\\other"};
		String[] MOBI41WOUT = {System.getProperty("user.dir") +"\\examples\\bike_SCPM_4.1\\SMC-S1000DBIKE-06RT9-00001-00.xml",
		               		   System.getProperty("user.dir") +"\\examples\\bike_resource_package_4.1",
		               		   "-mobilePerformanceSupport",
		               		   System.getProperty("user.dir") +"\\other"};		
		String[] MOBI41WOUTCOURSE = {System.getProperty("user.dir") +"\\examples\\bike_SCPM_4.1\\SMC-S1000DBIKE-06RT9-00001-00.xml",
					        		 System.getProperty("user.dir") +"\\examples\\bike_resource_package_4.1",
					        		 "-mobilecourse",
					        		 System.getProperty("user.dir") +"\\other"};	
		String[] PDF41WOUTSTUDENT = {System.getProperty("user.dir") +"\\examples\\bike_SCPM_4.1\\SMC-S1000DBIKE-06RT9-00001-00.xml",
		                      		 System.getProperty("user.dir") +"\\examples\\bike_resource_package_4.1",
		                      		 "-pdfstudent",
		                      		 System.getProperty("user.dir") +"\\other"};
		String[] PDF41WOUTINSTRUCTOR = {System.getProperty("user.dir") +"\\examples\\bike_SCPM_4.1\\SMC-S1000DBIKE-06RT9-00001-00.xml",
		                				System.getProperty("user.dir") +"\\examples\\bike_resource_package_4.1",
		                				"-pdfinstructor",
		                				System.getProperty("user.dir") +"\\other"};
		
		String[] SCORMMXTACHHTML = {System.getProperty("user.dir") + "\\test_files\\scpm_mx_tach\\SCP-SYS29-81205-00001-00_000-01_US-EN.xml",
				                    System.getProperty("user.dir") + "\\test_files\\resource_package_mx_tach",
				                    "-scormhtml"};
		
		String[] SCORMOPSEICASHTML = {System.getProperty("user.dir") + "\\test_files\\scpm_ops_eicas\\SCP-SYS01-81205-00001-00_000-01_US-EN.xml",
                                      System.getProperty("user.dir") + "\\test_files\\resource_package_ops_eicas",
                                      "-scormhtml"};
		
		String[] NEWSCORMOPSEICASHTML = {System.getProperty("user.dir") + "\\test_files\\scpm_ops_eicas\\SCP-SYS01-81205-00001-00_000-01_US-EN.xml",
                System.getProperty("user.dir") + "\\test_files\\resource_pkg_ops_eicas_Oct12014",
                "-scormhtml"};
		
		String[]  MX_NUMHTML = {System.getProperty("user.dir") + "\\test_files\\scpm_mx_tach\\SCP-SYS29-81205-00001-00_000-01_US-EN.xml",
                System.getProperty("user.dir") + "\\test_files\\resource_package_mx_tach",
                "-scormLevelledParaNum"};
		
>>>>>>> 1.0_BugFix

		
	
        Controller.main(NEWSCORMOPSEICASHTML);
    }
}
