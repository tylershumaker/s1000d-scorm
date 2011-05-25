/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.packaging;

import java.io.File;
import java.io.IOException;

import bridge.toolkit.util.CopyDirectory;
import bridge.toolkit.util.SCOContentDMChecker;

/**
 * Creates a directory to place all the files required to build the SCORM 
 * Content Package.
 *
 */
public class ContentPackageCreator
{

    /**
     * The location of the resource package that contains
     * all the S1000D files referenced in the SCPM to be included in the SCORM 
     * Content Package.
     */
    String mResourcePackage = null;
    
    /**
     * The directory where the Content Packages will be stored in the system.
     */
    String packagesLocation = System.getProperty("java.io.tmpdir") + File.separator + "packages";
    

    /**
     * Operator that takes in a String object.
     * 
     * @param iResourcePackage String that represents the location of the provided
     * resource package of S1000D files.
     */
    public ContentPackageCreator(String iResourcePackage)
    {
        mResourcePackage = iResourcePackage;
    }

    /**
     * Sets the directory where the Content Packages will be stored in the system.
     * 
     * @param packagesLocation the packagesLocation to set
     */
    public void setPackagesLocation(String packagesLocation)
    {
        this.packagesLocation = packagesLocation;
    }
    
    /**
     * Creates a new folder to act as the root of the Content Package being 
     * created by the toolkit.
     * 
     * @return File that is the location of the new directory created.
     */
    public File createPackage()
    {
        
        File cp = new File(packagesLocation); 
        
        if(!cp.exists())
        {
            cp.mkdir();
        }

        String newPackage = "package";
        int numberOfPackages = 0;
        String[] cpPackages = cp.list();
        File newCP;
        if(cpPackages.length >= 1)
        {
            for(String name : cpPackages)
            {
                String temp = name.substring(newPackage.length());
                int currentNum = Integer.parseInt(temp);
                if(currentNum >= numberOfPackages)
                {
                    numberOfPackages = currentNum + 1;
                }
            }
            
            newCP = new File(packagesLocation +File.separator + newPackage + numberOfPackages);
            newCP.mkdirs();
        }
        else
        {
            newCP = new File(packagesLocation +File.separator + newPackage + "1");
            newCP.mkdirs();
        }
        
        //copy over resource package
        File resource = new File(newCP.getAbsoluteFile()+ File.separator + 
                                "resources" + File.separator + "s1000d");
        resource.mkdirs();

        try
        {
            copyResources(new File(mResourcePackage), resource);
        }
        catch (IOException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
        return newCP;
    }
    
    /**
     * Copies the data modules and ICN files provided in the resource package 
     * to the directory where the Content Package is being built. 
     * 
     * Note: S1000D 4.1 SCO content data modules are not copied over. 
     * 
     * @param srcDir File that represents the location of the resource package.
     * @param destDir File that represents the location of the in the Content Package 
     * where the data modules and ICN files will be copied.  
     * @throws IOException
     */
    private void copyResources(File srcDir, File destDir) throws IOException
    {
        CopyDirectory cd = new CopyDirectory();
        File[] srcArray = srcDir.listFiles();
        for(File file: srcArray)
        {
            if(file.getName().endsWith(".xml"))
            {    
                if(!SCOContentDMChecker.isSCOContentDM(file))
                {
                    cd.copyDirectory(file, destDir);
                }
            }
            else
            {
                cd.copyDirectory(file, destDir);
            }
        }
        
    }
      
}
