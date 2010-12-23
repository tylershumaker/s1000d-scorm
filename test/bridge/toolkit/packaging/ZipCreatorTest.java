package bridge.toolkit.packaging;

import static org.junit.Assert.*;

import java.io.File;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class ZipCreatorTest
{
   ZipCreator contentPackage;
   File testZip;

   @Before
   public void setUp() throws Exception
   {
      contentPackage = new ZipCreator();
      testZip = new File(System.getProperty("user.dir") + File.separator + "test.zip");
   }

   @After
   public void tearDown() throws Exception
   {
       testZip.delete();
   }

   @Test
   public void testZipFiles()
   {
      String packageLoc = System.getProperty("user.dir") + File.separator + "test_files\\bike_resource_package";
      contentPackage.setPackageLocation(packageLoc);
      contentPackage.zipFiles("test");
      assertTrue(testZip.exists());
   }

}
