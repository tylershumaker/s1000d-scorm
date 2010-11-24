package bridge.toolkit.packaging;

import static org.junit.Assert.*;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class ZipCreatorTest
{
   ZipCreator contentPackage;

   @Before
   public void setUp() throws Exception
   {
      contentPackage = new ZipCreator();
   }

   @After
   public void tearDown() throws Exception
   {
   }

   @Test
   public void testZipFiles()
   {
      String packageLoc = System.getProperty("user.dir") + File.separator + "test_files\\bike_resource_package";
      contentPackage.setPackageLocation(packageLoc);
      contentPackage.zipFiles();
   }

}
