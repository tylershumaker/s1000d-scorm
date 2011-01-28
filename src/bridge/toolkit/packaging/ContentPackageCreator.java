/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.packaging;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import bridge.toolkit.util.CopyDirectory;

/**
 * Creates a directory to place all the files required to build the SCORM 
 * Content Package.
 *
 */
public class ContentPackageCreator
{

    /**
     * List of files that have been validated as referenced resources for the 
     * SCPM/imsmanifest file being converted/created.
     */
    List<File> mValidatedResources = null;
    
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
     * Operator that takes in a List object.
     * 
     * @param list List of File objects are validated resources.
     */
    public ContentPackageCreator(List<File> list)
    {
        mValidatedResources = list;
    }
    
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
        
        //copy over validated packages or resource package
        CopyDirectory cd = new CopyDirectory();
        File resource = new File(newCP.getAbsoluteFile()+ File.separator + 
                                "resources" + File.separator + "s1000d");
        resource.mkdirs();
        if(mValidatedResources != null)
        {
            
            Iterator<File> iterator = mValidatedResources.iterator();
            for(; iterator.hasNext();)
            {
                try
                {
                    cd.copyDirectory(iterator.next(), resource);
                } 
                catch (IOException e)
                {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
        }
        else
        {
            try
            {
                cd.copyDirectory(new File(mResourcePackage), resource);
            } 
            catch (IOException e)
            {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        
        return newCP;
    }
      
}
