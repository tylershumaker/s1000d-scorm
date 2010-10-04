/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.util;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/**
 * Copies all the files from one directory to another.
 */
public class CopyDirectory
{

    /**
     * Moves all the files from the source directory to the destination 
     * directory.
     * 
     * @param srcFolder File that is the source directory of files to be copied.
     * @param dstFolder File that is the destination directory of where the files 
     * are to be copied to. 
     * @throws IOException
     */
    public void copyDirectory(File srcFolder, File destFolder) throws IOException
    {
        if (srcFolder.isDirectory()) 
        {
            if (!destFolder.exists()) 
            {
                destFolder.mkdir();
            }
 
            String[] oChildren = srcFolder.list();
            for (int i=0; i < oChildren.length; i++) 
            {
                copyDirectory(new File(srcFolder, oChildren[i]), new File(destFolder, oChildren[i]));
            }
        } 
        else 
        {
            if(destFolder.isDirectory())
            {
                copyFile(srcFolder, new File(destFolder, srcFolder.getName()));
            }
            else
            { 
                copyFile(srcFolder, destFolder);
            }
        }
        
    }
    
    /**
     * Moves each individual file to the destination folder or file.
     * 
     * @param srcFile File that is to be copied.
     * @param destFile File that is the destination directory or file that is 
     * being copied to.
     * @throws IOException
     */
    public static void copyFile(File srcFile, File destFile) throws IOException 
    {
            InputStream oInStream = new FileInputStream(srcFile);
            OutputStream oOutStream = new FileOutputStream(destFile);
     
            // Transfer bytes from in to out
            byte[] oBytes = new byte[1024];
            int nLength;
            BufferedInputStream oBuffInputStream = new BufferedInputStream( oInStream );
            while ((nLength = oBuffInputStream.read(oBytes)) > 0) 
            {
                oOutStream.write(oBytes, 0, nLength);
            }
            oInStream.close();
            oOutStream.close();
    }

}
