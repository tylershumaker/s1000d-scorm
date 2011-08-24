/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.util;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
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
     * @param destFolder File that is the destination directory of where the files 
     * are to be copied to. 
     * @throws IOException
     */
    public void copyDirectory(File srcFolder, File destFolder) throws IOException
    {
        if (srcFolder.isDirectory()) 
        {
            //ensures that hidden folders are not included
            if(!srcFolder.getName().startsWith("."))
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
     * Copies the files from a directory in a jar file using the FileList in the base directory to copy the files
     * @param jarDirectory String indicating the directory to look in
     * @param OutputDirectory The file location to copy the files to
     * @throws FileNotFoundException
     * @throws IOException
     */
    public void CopyJarFiles(Class currclass, String jarDirectory, String OutputDirectory) throws IOException, FileNotFoundException
    {
    	//get the file list
        InputStream FileListinput = currclass.getResourceAsStream(jarDirectory+"/FileList.txt");
        
        BufferedReader reader = new BufferedReader( new InputStreamReader(FileListinput));
        String CurrentFile = "";
        while(( CurrentFile = reader.readLine()) != null)
        {
        	String path = "";
        	if (CurrentFile.indexOf('/') != -1)
        	{
        		path = "\\" + CurrentFile.substring(0,CurrentFile.lastIndexOf('/'));
        		path = path.replace('/', '\\');
        	}
        	
        	CopyJarFile(currclass,CurrentFile,OutputDirectory + path,jarDirectory);
        }
    }
    
    /**
     * Copies a file from a directory in a jar file the the path specified by the outputFile
     * @param currclass the class that the jar file is relative to
     * @param jarFile The file to copy from the jar
     * @param OutputDirectory The file location to copy the files to
     * @throws FileNotFoundException
     * @throws IOException
     */
    public void CopyJarFile(Class currclass, String jarFile, String OutputDirectory) throws IOException, FileNotFoundException
    {
    	CopyJarFile(currclass,jarFile,OutputDirectory, "");
    }
    
    /**
     * Copies a file from a directory in a jar file the the path specified by the outputFile
     * @param currclass the class that the jar file and directory is relative to
     * @param jarFile The file to copy from the jar in the jar Directory
     * @param OutputDirectory The file location to copy the files to
     * @param jarDirectory String indicating the directory to look in reletive to the class
     * @throws FileNotFoundException
     * @throws IOException
     */
    public void CopyJarFile(Class currclass, String jarFile, String OutputDirectory, String jarDirectory) throws IOException, FileNotFoundException
    {
    	//Check if the path exists
    	if (jarFile.indexOf('/') != -1)
    	{
    		//this file has a path
    		File testFileObject = new File( OutputDirectory );
        	if (!(testFileObject.exists()))
        	{
        		testFileObject.mkdirs();
        	}
    	}
    	InputStream input = currclass.getResourceAsStream(jarDirectory +"/" + jarFile);
    	String Filename = jarFile;
    	if (Filename.indexOf('/') != -1)
    	{
    		Filename = Filename.substring(Filename.lastIndexOf('/'));
    	}
        FileOutputStream output = new FileOutputStream(OutputDirectory + File.separator + Filename);
        byte buffer[] = new byte[1024];
        int length = 0;
        while((length=input.read(buffer)) > 0)
        {
        	output.write(buffer,0,length);
        }
        input.close();
        output.close();
        
    }
    
    /**
     * Moves each individual file to the destination folder or file.
     * 
     * @param srcFile File that is to be copied.
     * @param destFile File that is the destination directory or file that is 
     * being copied to.
     * @throws IOException
     */
    private static void copyFile(File srcFile, File destFile) throws IOException 
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
