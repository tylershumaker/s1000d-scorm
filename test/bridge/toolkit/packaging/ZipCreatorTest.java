package bridge.toolkit.packaging;

import static org.junit.Assert.*;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.Closeable;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URI;
import java.util.Deque;
import java.util.LinkedList;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

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
      // testZip.delete();
   }

   @Test
   public void testZipFiles() throws IOException
   {
      File directory = new File(System.getProperty("user.dir") + File.separator + "examples\\bike_resource_package");

      contentPackage.zipFiles(directory, testZip);
      
      assertTrue(testZip.exists());
   }

}
