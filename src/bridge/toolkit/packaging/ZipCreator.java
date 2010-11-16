/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.packaging;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * Creates a ZIP file containing all the files in a directory.
 */
public class ZipCreator
{
    /**
     * Location of the root directory of the files to include in the ZIP file.
     */
    private String packageLocation;

    /**
     * List of all the files in the directory to be zipped. 
     */
    private List<String> files = new ArrayList<String>();

    /**
     * Adds all the files from the list into the zip file.
     */
    public void zipFiles()
    {
        // Create a buffer for reading the files
        byte[] buf = new byte[24];

        try
        {
            // Create the ZIP file
            String target = "target.zip";
            ZipOutputStream out = new ZipOutputStream(new FileOutputStream(target));

            File packageDir = new File(packageLocation);

            File[] packageFiles = packageDir.listFiles();

            addFiles(packageFiles);
            
            if (!files.isEmpty())
            {
                // Compress the files
                for (int i = 0; i < files.size(); i++)
                {
                    FileInputStream in = new FileInputStream(files.get(i));

                    // Add ZIP entry to output stream.
                    int baseLength = packageLocation.length();
                    String fileOut = files.get(i).substring(baseLength);
                    out.putNextEntry(new ZipEntry(fileOut));

                    // Transfer bytes from the file to the ZIP file
                    int len;
                    while ((len = in.read(buf)) > 0)
                    {
                        out.write(buf, 0, len);
                    }

                    // Complete the entry
                    out.closeEntry();
                    in.close();
                }

                // Complete the ZIP file
                out.close();
            }
            else
            {
                System.out.println("There are no files to package");
            }
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }

    /**
     * Sets the packageLocation String.
     * @param pLocation String the is the absolute path of the directory of the 
     * files to be placed into the ZIP file.
     */
    public void setPackageLocation(String pLocation)
    {
        packageLocation = pLocation;
    }

    /**
     * Adds all the files in the packageLocation to a list.
     * 
     * @param pFiles Array of Files from the packageLocation to be added to a 
     * list.
     */
    private void addFiles(File[] pFiles)
    {
        for (File file : pFiles)
        {
            if (file.isDirectory())
            {
                File[] subDir = file.listFiles();
                addFiles(subDir);
            }
            else
            {
                files.add(file.getAbsolutePath());
            }
        }
    }

}
