/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Automatizacion;

import java.awt.Graphics;
import java.awt.Image;
import java.awt.Toolkit;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author rafael
 */
public class Diagrama extends javax.swing.JPanel implements Runnable
{

    /**
     * Creates new form GraficaDatos
     */
    public Diagrama()
    {
        initComponents();
        try {
            img = Toolkit.getDefaultToolkit().createImage(getClass().getResource("/Automatizacion/Diagram1.png"));

        } catch (Exception ex) {
            Logger.getLogger(Diagrama.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        graficar = false;
        
    }
    @Override
    public void paintComponent(Graphics g)
    {
        super.paintComponent(g);
        int x = (this.getWidth() - img.getWidth(this)) / 2;
        int y = (this.getHeight() - img.getHeight(this))-10;
        g.drawImage(img, x, y, null);
    }
    
    @Override
    public void run()
    {
        while(graficar)
        {
            System.currentTimeMillis();
        }
    }
    Image img;
    private boolean graficar;
    
    public void accionGraficar()
    {
        if(graficar)
            graficar=false;
        else
            graficar = true;
    }
    
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        setBackground(new java.awt.Color(0, 0, 0));

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 173, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 94, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents
    // Variables declaration - do not modify//GEN-BEGIN:variables
    // End of variables declaration//GEN-END:variables
}
