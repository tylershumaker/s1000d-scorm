/**
 * This file is part of the S1000D-SCORM Bridge Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.packaging;

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
import java.util.zip.ZipOutputStream;

/**
 * Creates a ZIP file containing all the files in a directory.
 */
public class ZipCreator
{

    /**
     * Adds all the files from the content package into the zip file.
     * 
     * @param directory File that represents the location of the all the file 
     * to be used to create the content package.
     * @param zipfile File that will be the zip file name of the content package.
     * @throws IOException
     */
    public void zipFiles(File directory, File zipfile) throws IOException
    {
        URI base = directory.toURI();     
        Deque<File> queue = new LinkedList<File>();     
        queue.push(directory);     
        OutputStream out = new FileOutputStream(zipfile);     
        Closeable res = out;     
        try 
        {       
            ZipOutputStream zout = new ZipOutputStream(out);       
            res = zout;       
            while (!queue.isEmpty()) 
            {         
                directory = queue.pop();         
                for (File kid : directory.listFiles()) 
                {           
                    String name = base.relativize(kid.toURI()).getPath();           
                    if (kid.isDirectory()) 
                    {             
                        queue.push(kid);             
                        name = name.endsWith("/") ? name : name + "/";             
                        zout.putNextEntry(new ZipEntry(name));           
                    } 
                    else 
                    {             
                        zout.putNextEntry(new ZipEntry(name));             
                        copy(kid, zout);             
                        zout.closeEntry();           
                    }         
                }       
            }     
         } 
         finally 
         {       
             res.close();     
         }   

    }

    /**
     * Copies an InputStream to an OutputSteam.
     * 
     * @param in InputStream
     * @param out OutputStream
     * @throws IOException
     */
    private static void copy(InputStream in, OutputStream out) throws IOException
    {
        byte[] buffer = new byte[1024];
        while (true)
        {
            int readCount = in.read(buffer);
            if (readCount < 0)
            {
                break;
            }
            out.write(buffer, 0, readCount);
        }
    }

    /**
     * Copies a File object to an OutputStream.
     * 
     * @param file File
     * @param out OutputStream
     * @throws IOException
     */
    private static void copy(File file, OutputStream out) throws IOException
    {
        InputStream in = new FileInputStream(file);
        try
        {
            copy(in, out);
        }
        finally
        {
            in.close();
        }
    }

}
