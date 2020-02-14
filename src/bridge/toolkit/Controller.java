/**
 * This file is part of the S1000D Transformation Toolkit
 * project hosted on Sourceforge.net. See the accompanying
 * license.txt file for applicable licenses.
 */
package bridge.toolkit;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.apache.commons.chain.Catalog;
import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;
import org.apache.commons.chain.config.ConfigParser;
import org.apache.commons.chain.impl.CatalogFactoryBase;
import org.apache.commons.chain.impl.ContextBase;

import bridge.toolkit.util.Keys;

/**
 * The core of the toolkit that handles the execution of the modules.
 */
public class Controller {
    /**
     * Location of the XML configuration file that defines and configures
     * commands and command chains to be registered in a Catalog.
     */
    private static final String CONFIG_FILE = "chain-config.xml";

    /**
     * Class to parse the contents of an XML configuration file
     * (using Commons Digester) that defines and configures commands and
     * command chains to be registered in a Catalog.
     */
    private ConfigParser parser;

    /**
     * Collection of named Commands (or Chains) that can be used to retrieve
     * the set of commands that should be performed.
     */
    private Catalog catalog;

    /**
     * Constructor
     */
    public Controller() {
        parser = new ConfigParser();
    }

    /**
     * Creates the Catalog object based off of the configuration file.
     *
     * @return Catalog object that contains the set of commands to be performed.
     */
    public Catalog createCatalog() {
        if (catalog == null) {
            try {
                parser.parse(this.getClass().getResource(CONFIG_FILE));
            } catch (MalformedURLException e) {
                e.printStackTrace();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        catalog = CatalogFactoryBase.getInstance().getCatalog();
        return catalog;
    }

    private static void unzip(String zipFilePath, String destDir) {
        File dir = new File(destDir);
        // remove old files from directory if there are any
        if (dir.exists()) dir.delete();
        // create output directory
        if (!dir.exists()) dir.mkdirs();
        FileInputStream fis;
        //buffer for read and write data to file
        byte[] buffer = new byte[1024];
        try {
            fis = new FileInputStream(zipFilePath);
            ZipInputStream zis = new ZipInputStream(fis);
            ZipEntry ze = zis.getNextEntry();
            while (ze != null) {
                String fileName = ze.getName();
                File newFile = new File(destDir + File.separator + fileName);
                System.out.println("Unzipping to " + newFile.getAbsolutePath());
                //create directories for sub directories in zip
                new File(newFile.getParent()).mkdirs();
                FileOutputStream fos = new FileOutputStream(newFile);
                int len;
                while ((len = zis.read(buffer)) > 0) {
                    fos.write(buffer, 0, len);
                }
                fos.close();
                //close this ZipEntry
                zis.closeEntry();
                ze = zis.getNextEntry();
            }
            //close last ZipEntry
            zis.closeEntry();
            zis.close();
            fis.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * @param args
     */
    public static void main(String[] args) {
        Controller loader = new Controller();
        Catalog sampleCatalog = loader.createCatalog();
        Command toolkit = sampleCatalog.getCommand("SCORM");
        Context ctx = new ContextBase();

        String SCPM = args[0];
        String ResourcePack = args[1];
        String tempUnzipSCPM = new String(System.getProperty("java.io.tmpdir") + "SCPM");
        String tempUnzipResource = new String(System.getProperty("java.io.tmpdir") + "Resource");


        //Check if passed a zip file or directory
        if (SCPM.endsWith(".zip")) {

            unzip(SCPM, tempUnzipSCPM);

            //Get the SCPM file from the temp dir
            File dir = new File(tempUnzipSCPM);
            String[] files = dir.list();

            ctx.put(Keys.SCPM_FILE, tempUnzipSCPM + File.separator + files[0]);
        } else {

            ctx.put(Keys.SCPM_FILE, SCPM);
        }

        if (ResourcePack.endsWith(".zip")) {

            ctx.put(Keys.RESOURCE_PACKAGE, tempUnzipResource);
            unzip(ResourcePack, tempUnzipResource);
        } else {

            ctx.put(Keys.RESOURCE_PACKAGE, ResourcePack);
        }


        ctx.put(Keys.MIN_SCORE, "80");
        try {

            if (args.length > 2) {

                if (args[2] != null && args[2].equalsIgnoreCase("-scorm12")) {
                    toolkit = sampleCatalog.getCommand("SCORM");
                    //flash output is being depricated - always use html output
                    ctx.put(Keys.OUTPUT_TYPE, "SCORM12");
                } else if (args[2] != null && args[2].equalsIgnoreCase("-scormflash")) {
                    toolkit = sampleCatalog.getCommand("SCORM");
                    //flash output is being depricated - always use html output
                    ctx.put(Keys.OUTPUT_TYPE, "SCORMHTML");
                } else if (args[2] != null && args[2].equalsIgnoreCase("-scormhtml")) {
                    toolkit = sampleCatalog.getCommand("SCORM");
                    ctx.put(Keys.OUTPUT_TYPE, "SCORMHTML");
                } else if (args[2] != null && args[2].equalsIgnoreCase("-scorm2004_4")) {
                    toolkit = sampleCatalog.getCommand("SCORM");
                    ctx.put(Keys.OUTPUT_TYPE, "SCORM2004_4");
                } else if (args[2] != null && args[2].equalsIgnoreCase("-scormLevelledParaNum")) {
                    toolkit = sampleCatalog.getCommand("SCORM");
                    ctx.put(Keys.OUTPUT_TYPE, "SCORMLEVELLEDPARANUM");
                } else if (args.length > 2 && args[2] != null && (args[2].equalsIgnoreCase("-mobileCourse"))) {
                    toolkit = sampleCatalog.getCommand("Mobile");
                    ctx.put(Keys.OUTPUT_TYPE, "mobileCourse");
                } else if (args.length > 2 && args[2] != null && (args[2].equalsIgnoreCase("-mobilePerformanceSupport"))) {
                    toolkit = sampleCatalog.getCommand("Mobile");
                } else if (args[2] != null && args[2].equalsIgnoreCase("-pdfinstructor")) {
                    toolkit = sampleCatalog.getCommand("PDF");
                    ctx.put(Keys.PDF_OUTPUT_OPTION, "-instructor");
                } else if (args[2] != null && args[2].equalsIgnoreCase("-pdfstudent")) {
                    toolkit = sampleCatalog.getCommand("PDF");
                    ctx.put(Keys.PDF_OUTPUT_OPTION, "-student");
                }

                if (args.length > 3 && args[3] != null) {
                    ctx.put(Keys.OUTPUT_DIRECTORY, args[3]);
                }

                if (args.length > 5 && args[4] != null && args[5] != null) {
                    ctx.put(Keys.XAPI_ENDPOINT, args[4]);
                    ctx.put(Keys.XAPI_AUTH, args[5]);
                } else {
                    ctx.put(Keys.XAPI_ENDPOINT, "https://lrs.endpoint.com");
                    ctx.put(Keys.XAPI_AUTH, "userName:abc123");
                }
            }

            toolkit.execute(ctx);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(e.getCause().toString());
        }
    }

}
