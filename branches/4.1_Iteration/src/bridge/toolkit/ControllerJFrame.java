/**
 * This file is part of the S1000D-SCORM Bridge Toolkit 
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
 * GUI created to execute the S1000D-SCORM Bridge Toolkit.
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
    Command toolkit;
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

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
   // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
   private void initComponents() {

      buttonGroup1 = new javax.swing.ButtonGroup();
      jPanel1 = new javax.swing.JPanel();
      jTextField1 = new javax.swing.JTextField();
      jButton1 = new javax.swing.JButton();
      jButton2 = new javax.swing.JButton();
      jTextField2 = new javax.swing.JTextField();
      jButton3 = new javax.swing.JButton();
      jLabel1 = new javax.swing.JLabel();
      jLabel2 = new javax.swing.JLabel();
      jScrollPane1 = new javax.swing.JScrollPane();
      jTextArea1 = new javax.swing.JTextArea();
      jLabel3 = new javax.swing.JLabel();
      jLabel4 = new javax.swing.JLabel();
      scormRadioButton = new javax.swing.JRadioButton();
      mobileRadioButton2 = new javax.swing.JRadioButton();
      jLabel5 = new javax.swing.JLabel();

      setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

      jButton1.setText("Browse..");
      jButton1.addActionListener(new java.awt.event.ActionListener() {
         public void actionPerformed(java.awt.event.ActionEvent evt) {
            jButton1ActionPerformed(evt);
         }
      });

      jButton2.setText("Browse..");
      jButton2.addActionListener(new java.awt.event.ActionListener() {
         public void actionPerformed(java.awt.event.ActionEvent evt) {
            jButton2ActionPerformed(evt);
         }
      });

      jButton3.setText("Run");
      jButton3.addActionListener(new java.awt.event.ActionListener() {
         public void actionPerformed(java.awt.event.ActionEvent evt) {
            jButton3ActionPerformed(evt);
         }
      });

      jLabel1.setText("SCPM");

      jLabel2.setText("Resource Package");

      jTextArea1.setColumns(20);
      jTextArea1.setRows(5);
      jScrollPane1.setViewportView(jTextArea1);

      jLabel3.setFont(new java.awt.Font("Tahoma", 1, 18));
      jLabel3.setForeground(new java.awt.Color(0, 102, 0));
      jLabel3.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
      jLabel3.setText("S1000D-SCORM Bridge Toolkit Beta ");

      jLabel4.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
      jLabel4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/bridge/toolkit/s1-scorm-bridge-logo-408x81.jpg"))); // NOI18N

      buttonGroup1.add(scormRadioButton);
      scormRadioButton.setText("SCORM Content Package");
      scormRadioButton.addActionListener(new java.awt.event.ActionListener() {
         public void actionPerformed(java.awt.event.ActionEvent evt) {
            scormRadioButtonActionPerformed(evt);
         }
      });

      buttonGroup1.add(mobileRadioButton2);
      mobileRadioButton2.setText("Mobile Web App");
      mobileRadioButton2.addActionListener(new java.awt.event.ActionListener() {
         public void actionPerformed(java.awt.event.ActionEvent evt) {
            mobileRadioButton2ActionPerformed(evt);
         }
      });

      jLabel5.setText("Output");

      javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
      jPanel1.setLayout(jPanel1Layout);
      jPanel1Layout.setHorizontalGroup(
         jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
         .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
               .addComponent(jScrollPane1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 566, Short.MAX_VALUE)
               .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel1Layout.createSequentialGroup()
                  .addContainerGap()
                  .addComponent(jLabel4, javax.swing.GroupLayout.DEFAULT_SIZE, 556, Short.MAX_VALUE))
               .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel1Layout.createSequentialGroup()
                  .addContainerGap()
                  .addComponent(jLabel3, javax.swing.GroupLayout.DEFAULT_SIZE, 556, Short.MAX_VALUE))
               .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel1Layout.createSequentialGroup()
                  .addContainerGap()
                  .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                     .addComponent(jLabel2)
                     .addComponent(jLabel1)
                     .addComponent(jLabel5))
                  .addGap(27, 27, 27)
                  .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                     .addComponent(jTextField1, javax.swing.GroupLayout.DEFAULT_SIZE, 244, Short.MAX_VALUE)
                     .addComponent(jTextField2, javax.swing.GroupLayout.DEFAULT_SIZE, 244, Short.MAX_VALUE)
                     .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(scormRadioButton)
                        .addGap(18, 18, 18)
                        .addComponent(mobileRadioButton2)))
                  .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                  .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                     .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jButton2, javax.swing.GroupLayout.DEFAULT_SIZE, 78, Short.MAX_VALUE)
                        .addGap(113, 113, 113))
                     .addComponent(jButton1)
                     .addComponent(jButton3, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 117, javax.swing.GroupLayout.PREFERRED_SIZE))))
            .addContainerGap())
      );
      jPanel1Layout.setVerticalGroup(
         jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
         .addGroup(jPanel1Layout.createSequentialGroup()
            .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 85, javax.swing.GroupLayout.PREFERRED_SIZE)
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
            .addComponent(jLabel3)
            .addGap(18, 18, 18)
            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
               .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                  .addComponent(jLabel1)
                  .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
               .addComponent(jButton1))
            .addGap(18, 18, 18)
            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
               .addComponent(jLabel2)
               .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jButton2))
            .addGap(38, 38, 38)
            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
               .addComponent(scormRadioButton, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(mobileRadioButton2)
               .addComponent(jButton3)
               .addComponent(jLabel5))
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 40, Short.MAX_VALUE)
            .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
      );

      javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
      getContentPane().setLayout(layout);
      layout.setHorizontalGroup(
         layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
         .addGroup(layout.createSequentialGroup()
            .addContainerGap()
            .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
            .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
      );
      layout.setVerticalGroup(
         layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
         .addGroup(layout.createSequentialGroup()
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addContainerGap())
      );

      pack();
   }// </editor-fold>//GEN-END:initComponents

    private void scormRadioButtonActionPerformed(java.awt.event.ActionEvent evt) 
    {//GEN-FIRST:event_scormRadioButtonActionPerformed
       outputType = "-scorm";
    }//GEN-LAST:event_scormRadioButtonActionPerformed

    private void mobileRadioButton2ActionPerformed(java.awt.event.ActionEvent evt) 
    {//GEN-FIRST:event_mobileRadioButton2ActionPerformed
       outputType = "-mobile";
    }//GEN-LAST:event_mobileRadioButton2ActionPerformed


    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt)
    {

        int returnVal = jFileChooser1.showOpenDialog(ControllerJFrame.this);

        if (returnVal == JFileChooser.APPROVE_OPTION)
        {
            File file = jFileChooser1.getSelectedFile();
            jTextField1.setText(file.getAbsolutePath());
        }

    }

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt)
    {

        jFileChooser2.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
        int returnVal = jFileChooser2.showOpenDialog(ControllerJFrame.this);

        if (returnVal == JFileChooser.APPROVE_OPTION)
        {
            File file = jFileChooser2.getSelectedFile();

            jTextField2.setText(file.getAbsolutePath());
        }

    }

    private void jButton3ActionPerformed(java.awt.event.ActionEvent evt)
    {

        ctx.put(Keys.SCPM_FILE, jTextField1.getText());
        ctx.put(Keys.RESOURCE_PACKAGE, jTextField2.getText());

        try
        {
            if(outputType.equals("-mobile"))
                toolkit = sampleCatalog.getCommand("MobileBuilder");
            else
                toolkit = sampleCatalog.getCommand("SCORM");
            
            toolkit.execute(ctx);
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
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            catch (Exception e)
            {
                // TODO Auto-generated catch block
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

   // Variables declaration - do not modify//GEN-BEGIN:variables
   private javax.swing.ButtonGroup buttonGroup1;
   private javax.swing.JButton jButton1;
   private javax.swing.JButton jButton2;
   private javax.swing.JButton jButton3;
   private javax.swing.JLabel jLabel1;
   private javax.swing.JLabel jLabel2;
   private javax.swing.JLabel jLabel3;
   private javax.swing.JLabel jLabel4;
   private javax.swing.JLabel jLabel5;
   private javax.swing.JPanel jPanel1;
   private javax.swing.JScrollPane jScrollPane1;
   private javax.swing.JTextArea jTextArea1;
   private javax.swing.JTextField jTextField1;
   private javax.swing.JTextField jTextField2;
   private javax.swing.JRadioButton mobileRadioButton2;
   private javax.swing.JRadioButton scormRadioButton;
   // End of variables declaration//GEN-END:variables

    private javax.swing.JFileChooser jFileChooser1 = new JFileChooser();
    private javax.swing.JFileChooser jFileChooser2 = new JFileChooser();
    PrintStream aPrintStream = new PrintStream(new FilteredStream(new ByteArrayOutputStream()));
    private String outputType = "-scorm";

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
