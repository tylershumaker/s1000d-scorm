/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileWriter;
import java.io.FilterOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;
import java.net.MalformedURLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.swing.JFileChooser;

import org.apache.commons.chain.Catalog;
import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;
import org.apache.commons.chain.config.ConfigParser;
import org.apache.commons.chain.impl.CatalogFactoryBase;
import org.apache.commons.chain.impl.ContextBase;

import bridge.toolkit.util.Keys;

/**
 * GUI created to execute the S1000D Transformation Toolkit.
 */
public class ControllerJFrame extends javax.swing.JFrame
{
    /**
     * Location of the XML configuration file that defines and configures
     * commands and command chains to be registered in a Catalog.
     */
    private static final String CONFIG_FILE = "chain-config.xml";

    /**
     * Class to parse the contents of an XML configuration file (using Commons
     * Digester) that defines and configures commands and command chains to be
     * registered in a Catalog.
     */
    private ConfigParser parser;

    /**
     * Collection of named Commands (or Chains) that can be used to retrieve the
     * set of commands that should be performed.
     */
    private Catalog catalog;
    Command toolkit = null;
    Context ctx;
    String currentTime;
    Catalog sampleCatalog;

    /** Creates new form NewJFrame */
    public ControllerJFrame()
    {
        DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd-HHmmss");
        Date date = new Date();

        currentTime = dateFormat.format(date);
        
        parser = new ConfigParser();
        Controller loader = new Controller();
        sampleCatalog = loader.createCatalog();

        ctx = new ContextBase();
        initComponents();
        System.setOut(aPrintStream); // catches System.out messages
        System.setErr(aPrintStream); // catches error messages

    }

    private void initComponents() {

        OutputButtonGroup = new javax.swing.ButtonGroup();
        ImageLabel = new javax.swing.JLabel();
        TitleLabel = new javax.swing.JLabel();
        SCPMLabel = new javax.swing.JLabel();
        ResourceLabel = new javax.swing.JLabel();
        OutputDirectoryLabel = new javax.swing.JLabel();
        SCPMField = new javax.swing.JTextField();
        ResourceField = new javax.swing.JTextField();
        OutputDirectoryField = new javax.swing.JTextField();
        MinScoreField = new javax.swing.JTextField();
        MinScoreLabel = new javax.swing.JLabel();
        SCPMBrowseButton = new javax.swing.JButton();
        ResourceBrowseButton = new javax.swing.JButton();
        OutputDirectoryBrowseButton = new javax.swing.JButton();
        OutputLabel = new javax.swing.JLabel();
        RunButton = new javax.swing.JButton();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTextArea1 = new javax.swing.JTextArea();
        SelectionDropDown = new javax.swing.JComboBox();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        ImageLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        ImageLabel.setIcon(new javax.swing.ImageIcon(getClass().getResource("/bridge/toolkit/s1-scorm-bridge-logo-408x81.jpg"))); // NOI18N

        TitleLabel.setFont(new java.awt.Font("Tahoma", 1, 18));
        TitleLabel.setForeground(new java.awt.Color(0, 102, 0));
        TitleLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        TitleLabel.setText("S1000D Transformation Toolkit");


        SCPMLabel.setFont(new java.awt.Font("Arial", 1, 12));
        SCPMLabel.setText("SCPM");

        ResourceLabel.setFont(new java.awt.Font("Arial", 1, 12));
        ResourceLabel.setText("Resource Package");

        OutputDirectoryLabel.setFont(new java.awt.Font("Arial", 1, 12));
        OutputDirectoryLabel.setText("Output Directory");

        MinScoreLabel.setFont(new java.awt.Font("Arial",1,12));
        MinScoreLabel.setText("Min Score (defaults to 80)  ");
        
        SCPMBrowseButton.setFont(new java.awt.Font("Arial", 1, 12));
        SCPMBrowseButton.setText("Browse..");
        SCPMBrowseButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                SCPMBrowseButtonActionPerformed(evt);
            }
        });

        ResourceBrowseButton.setFont(new java.awt.Font("Arial", 1, 12));
        ResourceBrowseButton.setText("Browse..");
        ResourceBrowseButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ResourceBrowseButtonActionPerformed(evt);
            }
        });

        OutputDirectoryBrowseButton.setFont(new java.awt.Font("Arial", 1, 12));
        OutputDirectoryBrowseButton.setText("Browse..");
        OutputDirectoryBrowseButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                OutputDirectoryBrowseButtonActionPerformed(evt);
            }
        });

        OutputLabel.setFont(new java.awt.Font("Arial", 1, 12));
        OutputLabel.setText("Output");

        RunButton.setFont(new java.awt.Font("Arial", 1, 12));
        RunButton.setText("Run");
        RunButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                RunButtonActionPerformed(evt);
            }
        });

        jTextArea1.setColumns(20);
        jTextArea1.setRows(5);
        jScrollPane1.setViewportView(jTextArea1);

        SelectionDropDown.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "SCORM 2004 3rd Edition", "SCORM 1.2", "SCORM With levelledPara Numbering", "Mobile Web App", "Mobile Web App With Assessments", "PDF Instructor Version", "PDF Student Version" }));
        SelectionDropDown.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                SelectionDropDownActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGap(16, 16, 16)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(SCPMLabel)
                            .addComponent(ResourceLabel)
                            .addComponent(OutputDirectoryLabel)
                            .addComponent(MinScoreLabel)
                            .addComponent(OutputLabel))
                        .addGap(4, 4, 4)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                .addComponent(SCPMField)
                                .addComponent(ResourceField)
                                .addComponent(OutputDirectoryField, javax.swing.GroupLayout.DEFAULT_SIZE, 405, Short.MAX_VALUE)
                                .addComponent(MinScoreField))
                            .addComponent(SelectionDropDown, javax.swing.GroupLayout.PREFERRED_SIZE, 240, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(RunButton)
                            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                .addComponent(SCPMBrowseButton, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(ResourceBrowseButton, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(OutputDirectoryBrowseButton, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
                    .addGroup(layout.createSequentialGroup()
                        .addGap(139, 139, 139)
                        .addComponent(ImageLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 408, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(layout.createSequentialGroup()
                        .addGap(189, 189, 189)
                        .addComponent(TitleLabel))
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 616, Short.MAX_VALUE)))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(ImageLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 81, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(3, 3, 3)
                .addComponent(TitleLabel)
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(SCPMField, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(SCPMLabel)
                    .addComponent(SCPMBrowseButton))
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(ResourceLabel)
                    .addComponent(ResourceField, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(ResourceBrowseButton))
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(OutputDirectoryField, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(OutputDirectoryLabel)
                    .addComponent(OutputDirectoryBrowseButton))
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(MinScoreField, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(MinScoreLabel))
                .addGap(18, 18, 18)                
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(OutputLabel)
                    .addComponent(SelectionDropDown, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(RunButton))
                .addGap(29, 29, 29)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 121, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        pack();
    }

    
    private void SCPMBrowseButtonActionPerformed(java.awt.event.ActionEvent evt) {                                                 
    	int returnVal = SCPMFileChooser.showOpenDialog(ControllerJFrame.this);

        if (returnVal == JFileChooser.APPROVE_OPTION)
        {
            File file = SCPMFileChooser.getSelectedFile();
            SCPMField.setText(file.getAbsolutePath());
        }
    }                                                

    private void ResourceBrowseButtonActionPerformed(java.awt.event.ActionEvent evt) {                                                     
    	ResourceFileChooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
        int returnVal = ResourceFileChooser.showOpenDialog(ControllerJFrame.this);

        if (returnVal == JFileChooser.APPROVE_OPTION)
        {
            File file = ResourceFileChooser.getSelectedFile();
            ResourceField.setText(file.getAbsolutePath());
        }
    }                                                    

    private void OutputDirectoryBrowseButtonActionPerformed(java.awt.event.ActionEvent evt) {                                                            
       
    	OutputFileChooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
        int returnVal = OutputFileChooser.showOpenDialog(ControllerJFrame.this);

        if (returnVal == JFileChooser.APPROVE_OPTION)
        {
            File file = OutputFileChooser.getSelectedFile();
            OutputDirectoryField.setText(file.getAbsolutePath());
        }
    }                                                                                              

//    private void PDFStudentRadioButtonActionPerformed(java.awt.event.ActionEvent evt) {                                                      
//        outputType = "-pdfstudent";
//    }                                                     
//
//    private void MobileRadioButtonActionPerformed(java.awt.event.ActionEvent evt) {                                                  
//        outputType = "-mobile";
//    }                                                 
//
//    private void ScormFlashRadioButtonActionPerformed(java.awt.event.ActionEvent evt) {                                                 
//        outputType = "-scormflash";
//    }                                                
//
//    private void PDFInstructorRadioButtonActionPerformed(java.awt.event.ActionEvent evt) {                                                         
//        outputType = "-pdfinstructor";
//    }                                                        
//
//    private void ScormHTMLRadioButtonActionPerformed(java.awt.event.ActionEvent evt) {
//        outputType = "-scormhtml";
//    }

    private void SelectionDropDownActionPerformed(java.awt.event.ActionEvent evt) 
    {                                                  
        javax.swing.JComboBox cb = (javax.swing.JComboBox)(evt.getSource());
        int val = cb.getSelectedIndex();
        switch (val)
        {
//            case 0:
//                outputType = "-scormflash";
//                break;
            case 0:
                outputType = "-scormhtml";
                break;
            case 1:
            	outputType = "-scormLevelledParaNum";
            	break;
            case 2:
                outputType = "-mobile";
                break;
            case 3:
                outputType = "-mobilecourse";
                break;
            case 4:
                outputType = "-pdfinstructor";
                break;
            case 5:
                outputType = "-pdfstudent";
                break;
        }
    }
    
    private void RunButtonActionPerformed(java.awt.event.ActionEvent evt)
    {

        ctx.put(Keys.SCPM_FILE, SCPMField.getText());
        ctx.put(Keys.RESOURCE_PACKAGE, ResourceField.getText());
        ctx.put(Keys.OUTPUT_DIRECTORY, OutputDirectoryField.getText());

        if(!MinScoreField.getText().isEmpty()){
            ctx.put(Keys.MIN_SCORE,  MinScoreField.getText());
        }
        else{
            ctx.put(Keys.MIN_SCORE, "80");
        }

        try
        {
            
            if (outputType.equals("-scormflash"))
            {
            	toolkit = sampleCatalog.getCommand("SCORM");
            	ctx.put(Keys.OUTPUT_TYPE, null);
            }
            else if (outputType.equals("-scormhtml"))
            {
            	toolkit = sampleCatalog.getCommand("SCORM");
            	ctx.put(Keys.OUTPUT_TYPE, "SCORMHTML");
            }
            else if (outputType.equals("-scormLevelledParaNum"))
            {
            	toolkit = sampleCatalog.getCommand("SCORM");
            	ctx.put(Keys.OUTPUT_TYPE, "SCORMLEVELLEDPARANUM");
            }            
            else if(outputType.equals("-mobile"))
            {
            	toolkit = sampleCatalog.getCommand("Mobile"); 
            }
            else if(outputType.equals("-mobilecourse"))
            {
            	toolkit = sampleCatalog.getCommand("Mobile");
            	ctx.put(Keys.OUTPUT_TYPE, "mobileCourse");
            }
            else if(outputType.equals("-pdfinstructor"))
            {
            	toolkit = sampleCatalog.getCommand("PDF");
            	ctx.put(Keys.PDF_OUTPUT_OPTION,"-instructor");
            }
            else if(outputType.equals("-pdfstudent"))
            {
                toolkit = sampleCatalog.getCommand("PDF");
                ctx.put(Keys.PDF_OUTPUT_OPTION,"-student");
            }
            if (toolkit != null)
            {
            	toolkit.execute(ctx);
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
            System.out.println(e.getCause().toString());
        }

    }

    /**
     * Creates the Catalog object based off of the configuration file.
     * 
     * @return Catalog object that contains the set of commands to be performed.
     */
    public Catalog createCatalog()
    {
        if (catalog == null)
        {
            try
            {
                parser.parse(this.getClass().getResource(CONFIG_FILE));
            }
            catch (MalformedURLException e)
            {
                e.printStackTrace();
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }
        }
        catalog = CatalogFactoryBase.getInstance().getCatalog();
        return catalog;
    }

    /**
     * @param args
     *            the command line arguments
     */
    public static void main(String args[])
    {
        java.awt.EventQueue.invokeLater(new Runnable()
        {
            public void run()
            {
                new ControllerJFrame().setVisible(true);
            }
        });
    }

    private javax.swing.JLabel ImageLabel;
    private javax.swing.ButtonGroup OutputButtonGroup;
    private javax.swing.JButton OutputDirectoryBrowseButton;
    private javax.swing.JTextField OutputDirectoryField;
    private javax.swing.JTextField MinScoreField;
    private javax.swing.JLabel MinScoreLabel;
    private javax.swing.JLabel OutputDirectoryLabel;
    private javax.swing.JLabel OutputLabel;
    private javax.swing.JButton ResourceBrowseButton;
    private javax.swing.JTextField ResourceField;
    private javax.swing.JLabel ResourceLabel;
    private javax.swing.JButton RunButton;
    private javax.swing.JButton SCPMBrowseButton;
    private javax.swing.JTextField SCPMField;
    private javax.swing.JLabel SCPMLabel;
    private javax.swing.JComboBox SelectionDropDown;
    private javax.swing.JLabel TitleLabel;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTextArea jTextArea1;

    private javax.swing.JFileChooser SCPMFileChooser = new JFileChooser();
    private javax.swing.JFileChooser ResourceFileChooser = new JFileChooser();
    private javax.swing.JFileChooser OutputFileChooser = new JFileChooser();
    PrintStream aPrintStream = new PrintStream(new FilteredStream(new ByteArrayOutputStream()));
    private String outputType = "-scormflash";

    class FilteredStream extends FilterOutputStream
    {
        public FilteredStream(OutputStream aStream)
        {
            super(aStream);
        }

        public void write(byte b[]) throws IOException
        {
            String aString = new String(b);
            jTextArea1.append(aString);
        }

        public void write(byte b[], int off, int len) throws IOException
        {
            String aString = new String(b, off, len);
            jTextArea1.append(aString);
            
            File logLocation = new File("logs");
            if(!logLocation.exists())
            {
                logLocation.mkdirs();
            }
            
            FileWriter aWriter = new FileWriter("logs/toolkit-"+currentTime+".log", true);
            aWriter.write(aString);
            aWriter.close();
        }
    }

}
