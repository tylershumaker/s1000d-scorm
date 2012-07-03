/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;
import org.w3c.dom.Attr;
import org.w3c.dom.Comment;
import org.w3c.dom.DocumentType;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Element;

import bridge.toolkit.util.Keys;

import com.sun.org.apache.xpath.internal.NodeSet;
import com.sun.org.apache.xpath.internal.XPathAPI;

/**
 *  Converts S1000D 4.1 learning data into S1000D 4.0 learning data so that 
 *  it can be processed by the toolkit. 
 */
public class S1000DConverter implements Command
{

    /**
     * modelic SCPM
     */
    public static String modelic;
    /**
     * Package Issuer SCPM
     */
    public static String PackageIssuer;
    /**
     * package number
     */
    public static String PackageNumber;
    /**
     * Package volume
     */
    public static String PackageVolume;
    /**
     * Security classification
     */
    public static String securityClassification;
    /**
     * qualityAssurance
     */
    public static Node qualityAssurance;

    /**
     * 
     */
    public static String resourcepack;

    /** 
     * The unit of processing work to be performed for the S1000DConverter module.
     * @see org.apache.commons.chain.Command#execute(org.apache.commons.chain.Context)
     */
    public boolean execute(Context ctx)
    {
    	System.out.println("Executing S1000D Converter");
        if ((ctx.get(Keys.SCPM_FILE) != null) && (ctx.get(Keys.RESOURCE_PACKAGE) != null))
        {
        	/*
        	 * check the output directory in the context if it does not exist make it
        	 */
        	if (!(ctx.containsKey(Keys.OUTPUT_DIRECTORY)))
        	{
        		ctx.put(Keys.OUTPUT_DIRECTORY, "");
        	}
        	
            resourcepack = ctx.get(Keys.RESOURCE_PACKAGE).toString();
            /*
             * if SCPM is 4.1 then Move the original file to the temp directory
             * in this file it will perform the downgrade to 4.0 version If
             * /scormContentPackage/content/scoEntry/scoEntryItem exists is a
             * 4.1 SCPM
             */
            org.w3c.dom.Document new40 = null;
            File tempSCPM = null;
            try
            {
                new40 = getDoc(new File(ctx.get(Keys.SCPM_FILE).toString()));
                if (processXPathSingleNode("/scormContentPackage/content/scoEntry/scoEntryItem", new40) == null)
                {
                	System.out.println("S1000D Converter Complete");
                    return CONTINUE_PROCESSING;
                }
                tempSCPM = File.createTempFile(new File(ctx.get(Keys.SCPM_FILE).toString()).getName(), ".xml");
                copy(ctx.get(Keys.SCPM_FILE).toString(), tempSCPM.toString());
                ctx.put(Keys.SCPM_FILE, tempSCPM.getAbsolutePath());
            }
            catch (Exception e)
            {
                e.printStackTrace();
                return PROCESSING_COMPLETE;
            }

            List<File> src_files = new ArrayList<File>();
            try
            {
                src_files = getSourceFiles((String) ctx.get(Keys.RESOURCE_PACKAGE));
            }
            catch (Exception npe)
            {
                System.out.println("The 'Resource Package' is empty.");
                return PROCESSING_COMPLETE;
            }

            /*
             * For each scoEntry adding sconEntryAddress and scoEntryStatus
             */
            try
            {
                // getting the modelic and issuer from status SCPM
                modelic = processXPathSingleNode("/scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageIdent/scormContentPackageCode/@modelIdentCode", new40).getNodeValue();
                PackageIssuer = processXPathSingleNode("/scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageIdent/scormContentPackageCode/@scormContentPackageIssuer", new40).getNodeValue();
                PackageNumber = processXPathSingleNode("/scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageIdent/scormContentPackageCode/@scormContentPackageNumber", new40).getNodeValue();
                PackageVolume = processXPathSingleNode("/scormContentPackage/identAndStatusSection/scormContentPackageAddress/scormContentPackageIdent/scormContentPackageCode/@scormContentPackageVolume", new40).getNodeValue();

                securityClassification = processXPathSingleNode("/scormContentPackage/identAndStatusSection/scormContentPackageStatus/security/@securityClassification", new40).getNodeValue();
                ;
                qualityAssurance = processXPathSingleNode("/scormContentPackage/identAndStatusSection/scormContentPackageStatus/qualityAssurance", new40);

                // getting the content node
                Node content = processXPathSingleNode("//content", new40);

                if (content != null)
                {
                    // delete content..
                    Node contentclone = content.cloneNode(true);
                    removeNode(content);
                    // add the content Node..
                    org.w3c.dom.Element newcontent = new40.createElement("content");
                    // navigate through the tree seeking for scoEntry
                    for (int i = 0; i < contentclone.getChildNodes().getLength(); i++)
                    {
                        Node node = contentclone.getChildNodes().item(i);
                        if (node.getNodeName().equals("scoEntry"))
                        {
                            Node scoE = node.cloneNode(true);
                            walkingthrough(scoE, new40);
                            newcontent.appendChild(scoE);
                        }
                    }

                    // add the content modified
                    Node pm = processXPathSingleNode("//scormContentPackage", new40);
                    pm.appendChild(newcontent);

                    // re write on temp file the new XML..
                    writeOnDisk(tempSCPM, getXMLString(new40));
                }

            }
            catch (Exception npe)
            {
                Writer writer = new StringWriter();
                PrintWriter printWriter = new PrintWriter(writer);
                npe.printStackTrace(printWriter);
                writer.toString();
                System.out.println("Error " + npe + " " + writer.toString());
                return PROCESSING_COMPLETE;
            }

            System.out.println("Conversion of SCPM 4.1 to SCPM 4.0 was successful");
        }
        else
        {
            System.out.println("One of the required Context entries for the " + this.getClass().getSimpleName() + " command to be executed was null");
            return PROCESSING_COMPLETE;
        }
        return CONTINUE_PROCESSING;
    }

    /**
     * modify scoEntryItem in scoEntryContent, move lom from scoEntryItem
     * 
     * @param nodes
     * @throws Exception
     */
    private static void walkingthrough(Node nodes, org.w3c.dom.Document document) throws Exception
    {

        changeScoEntry(nodes, document);

        int length = nodes.getChildNodes().getLength();
        for (int i = 0; i < length; i++)
        {
            Node node = nodes.getChildNodes().item(i);

            changeScoEntry(node, document);

            if (node.getNodeName().equals("scoEntryItem"))
            {
                // the lom children must linked to the parent child (scoEntry)
                int lengthlom = node.getChildNodes().getLength();
                for (int lom = 0; lom < lengthlom; lom++)
                {
                    if (node.getChildNodes().item(lom) != null && node.getChildNodes().item(lom).getNodeName().equals("lom:lom"))
                    {
                        // clone the node..
                        Node cloneLom = node.getChildNodes().item(lom).cloneNode(true);
                        // first of all I remove it
                        Node lomnode = node.getChildNodes().item(lom);
                        Node father = lomnode.getParentNode();
                        Node grandf = father.getParentNode();
                        father.removeChild(lomnode);
                        // then I add it to the new parent..
                        grandf.insertBefore(cloneLom, father);
                    }

                    // for each dmRef open the DM and read the real data module
                    // content to be show in the lesson
                    if (node.getChildNodes().item(lom) != null && node.getChildNodes().item(lom).getNodeName().equals("dmRef"))
                    {
                        String filename = resourcepack + "\\" + gettingDmfilename(node.getChildNodes().item(lom)) + ".xml";
                        if (new File(filename).exists())
                        {
                            // if the data module is a scoContent will copy each
                            // dmref in the scoEntry
                            org.w3c.dom.Document dm41 = getDoc(new File(filename));

                            if (processXPathSingleNode("dmodule/content/scoContent", dm41) != null)
                                ;
                            {
                                NodeList dmre = processXPath("/dmodule/content/scoContent/trainingStep/dmRef", dm41);
                                Node father = node.getChildNodes().item(lom).getParentNode();
                                father.removeChild(node.getChildNodes().item(lom));
                                // remove the reference to Scocontent and
                                // replace it with the dm inside
                                for (int nodi = 0; nodi < dmre.getLength(); nodi++)
                                {
                                    Node cloneref = dmre.item(nodi).cloneNode(true);
                                    document.adoptNode(cloneref);
                                    father.appendChild(cloneref);
                                }

                            }
                        }

                    }

                }

                // rename scoEntryItem in scoEntry
                node = changeNodename(node, document, "scoEntryContent");
            }
            walkingthrough(node, document);
        }
    }

    /**
     * Receive scoEntrynode to modify it
     * 
     * @param node
     * @param document
     */
    public static void changeScoEntry(Node node, org.w3c.dom.Document document)
    {
        if (node.getNodeName().equals("scoEntry"))
        {
            /**
             * for each scoEntry must create scoEntryAddress node
             * 
             */
            // adding the title...scoEntry/scoEntryTitle
            if (node.getChildNodes().item(1) != null && node.getChildNodes().item(1).getNodeName().equals("scoEntryTitle"))
            {
                Node scoEntryAddress = document.createElement("scoEntryAddress");

                // create the scoEntryAddress node
                Node scoEntryCode = document.createElement("scoEntryCode");

                ((Element) scoEntryCode).setAttribute("modelIdentCode", modelic);
                ((Element) scoEntryCode).setAttribute("scormContentPackageNumber", PackageNumber);
                ((Element) scoEntryCode).setAttribute("scormContentPackageIssuer", PackageIssuer);
                ((Element) scoEntryCode).setAttribute("scormContentPackageVolume", PackageVolume);
                scoEntryAddress.appendChild(scoEntryCode);

                // create the scoEntryStatus node
                Node scoEntryStatus = document.createElement("scoEntryStatus");
                // status
                Node status = document.createElement("security");
                ((Element) status).setAttribute("securityClassification", securityClassification);
                // qualityAssurance

                Node qualityAssuranceNode = qualityAssurance.cloneNode(true);
                scoEntryStatus.appendChild(qualityAssuranceNode);

                // adding address and status
                node.insertBefore(scoEntryStatus, node.getChildNodes().item(1));
                node.insertBefore(scoEntryAddress, node.getChildNodes().item(1));

                // move the title under the scoEntryAddress section
                scoEntryAddress.appendChild(node.getChildNodes().item(3));
            }
        }
    }

    /**
     * Receive the node with the refdm, returns the dm file name
     * 
     * @param e
     * @return
     */
    public static String gettingDmfilename(Node theAncestor)
    {
        String dmc = "";
        String modelIdentCode = "";
        String systemDiffCode = "";
        String systemCode = "";
        String subSystemCode = "";
        String subSubSystemCode = "";
        String assyCode = "";
        String disassyCode = "";
        String disassyCodeVariant = "";
        String infoCode = "";
        String infoCodeVariant = "";
        String itemLocationCode = "";
        String learnCode = "";
        String learnEventCode = "";

        String countryIsoCode = "";
        String languageIsoCode = "";
        String issueinfo = "";
        String inwork = "";

        Node e = null;
        // looking for dmCode...
        for (int sons = 0; sons < theAncestor.getChildNodes().getLength(); sons++)
        {
            if (theAncestor.getChildNodes().item(sons) != null && theAncestor.getChildNodes().item(sons).getNodeName().equals("dmRefIdent"))
            {
                for (int sons2 = 0; sons2 < theAncestor.getChildNodes().item(sons).getChildNodes().getLength(); sons2++)
                {
                    if (theAncestor.getChildNodes().item(sons).getChildNodes().item(sons2) != null && theAncestor.getChildNodes().item(sons).getChildNodes().item(sons2).getNodeName().equals("dmCode"))
                    {
                        e = theAncestor.getChildNodes().item(sons).getChildNodes().item(sons2);
                        // building the file name structure
                        dmc = "DMC-";
                        NamedNodeMap atts = e.getAttributes();
                        for (int i = 0; i < atts.getLength(); i++)
                        {
                            if (atts.item(i).getNodeName() == "modelIdentCode")
                                modelIdentCode = atts.item(i).getNodeValue() + "-";

                            if (atts.item(i).getNodeName() == "systemDiffCode")
                                systemDiffCode = atts.item(i).getNodeValue() + "-";

                            if (atts.item(i).getNodeName() == "systemCode")
                                systemCode = atts.item(i).getNodeValue() + "-";

                            if (atts.item(i).getNodeName() == "subSystemCode")
                                subSystemCode = atts.item(i).getNodeValue();

                            if (atts.item(i).getNodeName() == "subSubSystemCode")
                                subSubSystemCode = atts.item(i).getNodeValue() + "-";

                            if (atts.item(i).getNodeName() == "assyCode")
                                assyCode = atts.item(i).getNodeValue() + "-";

                            if (atts.item(i).getNodeName() == "disassyCode")
                                disassyCode = atts.item(i).getNodeValue();

                            if (atts.item(i).getNodeName() == "disassyCodeVariant")
                                disassyCodeVariant = atts.item(i).getNodeValue() + "-";

                            if (atts.item(i).getNodeName() == "infoCode")
                                infoCode = atts.item(i).getNodeValue();

                            if (atts.item(i).getNodeName() == "infoCodeVariant")
                                infoCodeVariant = atts.item(i).getNodeValue() + "-";

                            if (atts.item(i).getNodeName() == "itemLocationCode")
                                if (atts.getLength() > 11)
                                    itemLocationCode = atts.item(i).getNodeValue() + "-";
                                else
                                    itemLocationCode = atts.item(i).getNodeValue();

                            if (atts.item(i).getNodeName() == "learnCode")
                                learnCode = atts.item(i).getNodeValue();

                            if (atts.item(i).getNodeName() == "learnEventCode")
                                learnEventCode = atts.item(i).getNodeValue();
                        }
                    }

                    if (theAncestor.getChildNodes().item(sons).getChildNodes().item(sons2) != null && theAncestor.getChildNodes().item(sons).getChildNodes().item(sons2).getNodeName().equals("language"))
                    {
                        e = theAncestor.getChildNodes().item(sons).getChildNodes().item(sons2);
                        NamedNodeMap atts = e.getAttributes();
                        for (int i = 0; i < atts.getLength(); i++)
                        {
                            if (atts.item(i).getNodeName() == "countryIsoCode")
                                countryIsoCode = "-" + atts.item(i).getNodeValue();

                            if (atts.item(i).getNodeName() == "languageIsoCode")
                                languageIsoCode = "_" + atts.item(i).getNodeValue();
                        }

                    }

                    if (theAncestor.getChildNodes().item(sons).getChildNodes().item(sons2) != null && theAncestor.getChildNodes().item(sons).getChildNodes().item(sons2).getNodeName().equals("issueInfo"))
                    {
                        e = theAncestor.getChildNodes().item(sons).getChildNodes().item(sons2);
                        NamedNodeMap atts = e.getAttributes();
                        for (int i = 0; i < atts.getLength(); i++)
                        {
                            if (atts.item(i).getNodeName() == "issueNumber")
                                issueinfo = "_" + atts.item(i).getNodeValue();

                            if (atts.item(i).getNodeName() == "inWork")
                                inwork = "-" + atts.item(i).getNodeValue();
                        }

                    }

                }
                if (e != null)
                    break;
            }
        }

        if (e == null)
            return "";
        return dmc + modelIdentCode + systemDiffCode + systemCode + subSystemCode + subSubSystemCode + assyCode + disassyCode + disassyCodeVariant + infoCode + infoCodeVariant + itemLocationCode + learnCode + learnEventCode + issueinfo + inwork + languageIsoCode + countryIsoCode;
    }

    /**
     * Receive the node, the DOM object and the new name of the node
     * 
     * @param nodo
     * @param doc
     * @param newname
     */
    public static Node changeNodename(Node nodo, org.w3c.dom.Document doc, String newname)
    {
        // Create an element with the new name
        Node element2 = doc.createElement(newname);

        // Copy the attributes to the new element
        NamedNodeMap attrs = nodo.getAttributes();
        for (int i = 0; i < attrs.getLength(); i++)
        {
            Attr attr2 = (Attr) doc.importNode(attrs.item(i), true);
            element2.getAttributes().setNamedItem(attr2);
        }

        // Move all the children
        while (nodo.hasChildNodes())
        {
            element2.appendChild(nodo.getFirstChild());
        }

        // Replace the old node with the new node
        nodo.getParentNode().replaceChild(element2, nodo);
        return element2;

    }

    /**
     * Process the xpath and return the single node that match
     * 
     * @param xpath
     * @param node
     * @return
     * @throws Exception
     */
    public static org.w3c.dom.Node processXPathSingleNode(String xpath, Node node) throws Exception
    {
        return XPathAPI.selectSingleNode(node, xpath);
    }

    /**
     * Write the string in the file on disk
     * 
     * @param file
     * @param contenuto
     * @throws Exception
     */
    public static void writeOnDisk(File file, String contenuto) throws Exception
    {
        try
        {
            BufferedWriter outWriter = null;

            outWriter = new BufferedWriter(new java.io.FileWriter(file));
            outWriter.write(contenuto);
            outWriter.flush();
            outWriter.close();
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    /**
     * Create the DOM from the file
     * 
     * @param filetempXML
     * @return
     * @throws Exception
     */
    public static org.w3c.dom.Document getDoc(File filetempXML) throws Exception
    {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(false);
        factory.setExpandEntityReferences(false);
        DocumentBuilder builder = factory.newDocumentBuilder();

        return builder.parse(filetempXML);
    }

    /**
     * Return the node's content in string
     * 
     * @param node
     * @return
     */
    public static String getXMLString(Node node)
    {

        StringWriter writer = new StringWriter();
        try
        {
            writeNode(node, writer, false, null, null);
        }
        catch (Exception e)
        {
        	e.printStackTrace();
        }

        return writer.toString();
    }

    /**
     * Iterate through the DOM tree
     * 
     * @param node
     * @param output
     * @param isDocument
     * @param encoding
     * @param internalSubset
     * @throws IOException
     */
    static void writeNode(Node node, Writer output, boolean isDocument, String encoding, String internalSubset) throws IOException
    {

        if (isDocument)
        {
            if (encoding == null)
                output.write("<?xml version=\"1.0\"?>\n\n");
            else
                output.write("<?xml version=\"1.0\" encoding=\"" + encoding + "\"?>\n\n");

            DocumentType doctype = node.getOwnerDocument().getDoctype();

            if (doctype != null)
            {
                String pubid = doctype.getPublicId();
                String sysid = doctype.getSystemId();
                output.write("<!DOCTYPE ");
                output.write(node.getNodeName());
                if (pubid != null)
                {
                    output.write(" PUBLIC \"");
                    output.write(pubid);
                    if (sysid != null)
                    {
                        output.write("\" \"");
                        output.write(sysid);
                    }
                    output.write('"');
                }
                else if (sysid != null)
                {
                    output.write(" SYSTEM \"");
                    output.write(sysid);
                    output.write('"');
                }
                String subset = internalSubset;
                if (subset == null)
                    subset = doctype.getInternalSubset();
                if (subset != null)
                {
                    output.write(" [");
                    output.write(subset);
                    output.write(']');
                }
                output.write(">\n\n");
            }
        }
        writeNode(node, output);

        if (isDocument)
            output.write("\n");
    }

    /**
     * Iterate through the DOM tree
     * 
     * @param node
     * @param output
     * @throws IOException
     */
    public static void writeNode(Node node, Writer output) throws IOException
    {

        int type = node.getNodeType();

        switch (type)
        {
        case Node.ATTRIBUTE_NODE:
            output.write(' ');
            output.write(node.getNodeName());
            output.write("=\"");
            writeXMLData(node.getNodeValue(), true, output);
            output.write('"');
            break;
        case Node.CDATA_SECTION_NODE:
        case Node.TEXT_NODE:
            writeXMLData(node.getNodeValue(), false, output);
            break;
        case Node.COMMENT_NODE:
            output.write("<!--");
            output.write(((Comment) node).getNodeValue());
            output.write("-->");
            break;
        case Node.DOCUMENT_FRAGMENT_NODE:
            writeNodes(node.getChildNodes(), output);
            break;
        case Node.DOCUMENT_NODE:
            writeNodes(node.getChildNodes(), output);
            break;
        case Node.DOCUMENT_TYPE_NODE:
            break;
        case Node.ELEMENT_NODE:
        {
            NamedNodeMap atts = node.getAttributes();

            output.write('<');
            output.write(node.getNodeName());
            if (atts != null)
            {
                int length = atts.getLength();
                for (int i = 0; i < length; i++)
                    writeNode(atts.item(i), output);
            }

            if (node.hasChildNodes())
            {
                output.write('>');
                writeNodes(node.getChildNodes(), output);
                output.write("</");
                output.write(node.getNodeName());
                output.write('>');
            }
            else
            {
                output.write("/>");
            }
            break;
        }
        case Node.ENTITY_NODE:
            break;
        case Node.ENTITY_REFERENCE_NODE:
            writeNodes(node.getChildNodes(), output);
            break;
        case Node.NOTATION_NODE:
            break;
        case Node.PROCESSING_INSTRUCTION_NODE:
            break;
        default:
            throw new Error("Unexpected DOM node type: " + type);
        }
    }

    /**
     * Write the XML in the writer
     * 
     * @param data
     * @param isLiteral
     * @param output
     * @throws IOException
     */
    private static void writeXMLData(String data, boolean isLiteral, Writer output) throws IOException
    {

        char ch[] = data.toCharArray();
        for (int i = 0; i < ch.length; i++)
        {
            switch (ch[i])
            {
            case '&':
                output.write("&amp;");
                break;
            case '<':
                output.write("&lt;");
                break;
            case '>':
                output.write("&gt;");
                break;
            case '"':
                if (isLiteral)
                {
                    output.write("&quot;");
                    break;
                }
            default:
                if (ch[i] >= 128)
                {
                    output.write("&#");
                    output.write(new Integer(ch[i]).toString());
                    output.write(';');
                }
                else if (ch[i] < 32 && ch[i] != '\n' && ch[i] != '\r' && ch[i] != '\t')
                {
                    throw new IOException("Illegal XML data character " + new Integer(ch[i]).toString());
                }
                else
                {
                    output.write(ch[i]);
                }
                break;
            }
        }
    }

    /**
     * Iterate trough the tree
     * 
     * @param nodes
     * @param output
     * @throws IOException
     */
    private static void writeNodes(NodeList nodes, Writer output) throws IOException
    {

        int length = nodes.getLength();
        for (int i = 0; i < length; i++)
            writeNode(nodes.item(i), output);
    }

    /**
     * Remove the node from the DOM
     * 
     * @param node
     * @throws Exception
     */
    public static void removeNode(Node node) throws Exception
    {

        if (node != null)
            node.getParentNode().removeChild(node);
    }

    /**
     * Process xpath and return the list of node that match the xpath in
     * document.
     * 
     * @param xpath
     * @param document
     * @return
     * @throws Exception
     */
    public static NodeList processXPath(String xpath, org.w3c.dom.Document document) throws Exception
    {

        NodeSet set = new NodeSet(XPathAPI.selectNodeIterator(document, xpath));
        return (NodeList) set;
    }

    /**
     * Retrieves all of the files in a specified directory and returns them in a
     * list.
     * 
     * @param src_dir
     *            String that represents the location of directory.
     * @return List<File> List of all of the files found in the source
     *         directory.
     */
    private static List<File> getSourceFiles(String src_dir)
    {
        File csdb_files = new File(src_dir);

        List<File> src_files = new ArrayList<File>();
        File[] testVR = csdb_files.listFiles();
        for (File file : testVR)
        {
            src_files.add(file);
        }
        return src_files;

    }

    /**
     * copy file content
     * 
     * @param from_
     *            String
     * @param to_
     *            String
     * @throws Exception
     */
    public static void copy(String from_, String to_) throws Exception
    {

        try
        {

            FileChannel sourceChannel = new FileInputStream(from_).getChannel();
            FileChannel destinationChannel = new FileOutputStream(to_).getChannel();
            sourceChannel.transferTo(0, sourceChannel.size(), destinationChannel);
            sourceChannel.close();
            destinationChannel.close();

        }
        catch (Exception ex)
        {

            throw (ex);
        }
    }

}
