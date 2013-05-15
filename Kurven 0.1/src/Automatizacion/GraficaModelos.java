/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Automatizacion;

import java.awt.Color;
import java.awt.Graphics;
import java.util.ArrayList;

/**
 *
 * @author rafael
 */
public class GraficaModelos extends javax.swing.JPanel {

    /**
     * Creates new form GraficaDatos
     */
    public GraficaModelos() {
        initComponents();
        graficarD=false;
        graficarMD=false;
        graficarFB=false;
        
        indiceX=0F;
        indiceY=0F;
        
    }
    @Override
    public void paintComponent(Graphics g)
    {
        super.paintComponent(g);
        
        int xOffSet = 50;
        int yOffSet = 20;
        
        g.setColor(Color.white);
        g.drawLine(xOffSet, yOffSet,xOffSet,this.getHeight()-yOffSet);
        g.drawString("Salida", xOffSet-g.getFontMetrics().stringWidth("Salida")/2, yOffSet-5);
        g.drawLine(xOffSet,this.getHeight()-yOffSet,this.getWidth()-xOffSet,this.getHeight()-yOffSet);
        g.drawString("Tiempo", this.getWidth()-xOffSet+3, this.getHeight()-yOffSet+2);
        
        //int pointSize = 2;
        ancho = this.getWidth()-2*xOffSet;
        alto = this.getHeight()-2*yOffSet;
        

        Color colorD = Color.CYAN;
        Color colorMD = Color.MAGENTA;
        Color colorFB = Color.ORANGE;
            

        escalaTiempo = (int) (ancho/indiceX);
        escalaSalida = (int) (alto/indiceY);
        
        
        g.setColor(Color.white);
        
        for(int i=0; i<(int)indiceY; i++)
        {
            g.drawString(Integer.toString(i),xOffSet-20 , this.getHeight()-yOffSet-i*escalaSalida+5);
            g.drawLine(xOffSet-2, this.getHeight()-yOffSet-i*escalaSalida, xOffSet+2, this.getHeight()-yOffSet-i*escalaSalida);
        }
        
        for(int i=0; i<(int)indiceX; i++)
        {
            String num = Integer.toString(i);
            g.drawLine(i*escalaTiempo+xOffSet, this.getHeight()-yOffSet+2, i*escalaTiempo+xOffSet, this.getHeight()-yOffSet-2);
            g.drawString(Integer.toString(i),i*escalaTiempo+xOffSet-g.getFontMetrics().stringWidth(num)/2, this.getHeight()-yOffSet+15);
            
        }
        
        if(graficarD)
            grafica(g,puntosD,xOffSet,yOffSet,colorD,false,4);
        if(graficarMD)
            grafica(g,puntosMD,xOffSet,yOffSet,colorMD,true,1);
        if(graficarFB)
            grafica(g,puntosFB,xOffSet,yOffSet,colorFB,true,1);
        
        
    }
    
    public void grafica(Graphics g, Punto[] puntos, int xOffSet, int yOffSet, Color color, boolean graficarLineas, int pointSize)
    {
        //int pointSize = 4;
        ancho = this.getWidth()-2*xOffSet;
        alto = this.getHeight()-2*yOffSet;
        
        g.setColor(color);
        
        
        
        for(int i=0; i<puntos.length; i++)
        {
            int x = (int) (puntos[i].getX()*escalaTiempo);
            int y = (int) (puntos[i].getY()*escalaSalida);
           
            g.fillOval(x+xOffSet-pointSize/2, this.getHeight()-yOffSet-y-pointSize/2, pointSize, pointSize);
            
            if(graficarLineas && i>0)
            {
                g.drawLine(((int) (puntos[i-1].getX()*escalaTiempo))+xOffSet, this.getHeight()-yOffSet-((int) (puntos[i-1].getY()*escalaSalida)), x+xOffSet, this.getHeight()-yOffSet-y);
            }
        }
    }
    

    public void setPuntosD(ArrayList<Punto> puntos)
    {
        this.puntosD = new Punto[puntos.size()];
        
        puntos.toArray(this.puntosD);
        
        float indiceXD = puntosD[puntosD.length-1].getX()+2;
            float indiceYD = puntosD[puntosD.length-1].getY()+1;

            if( indiceXD > indiceX )   
                indiceX = indiceXD;

            if( indiceYD > indiceY )   
                indiceY = indiceYD;
        
    }
    public void setPuntosMD(ArrayList<Punto> puntos)
    {
        this.puntosMD = new Punto[puntos.size()];
        puntos.toArray(this.puntosMD);
        
        float indiceXD = puntosMD[puntosMD.length-1].getX()+2;
            float indiceYD = puntosMD[puntosMD.length-1].getY()+1;

            if( indiceXD > indiceX )   
                indiceX = indiceXD;

            if( indiceYD > indiceY )   
                indiceY = indiceYD;
        
    }
    public void setPuntosFB(ArrayList<Punto> puntos)
    {
        this.puntosFB = new Punto[puntos.size()];
        puntos.toArray(this.puntosFB);
        
        float indiceXD = puntosFB[puntosFB.length-1].getX()+2;
            float indiceYD = puntosFB[puntosFB.length-1].getY()+1;

            if( indiceXD > indiceX )   
                indiceX = indiceXD;

            if( indiceYD > indiceY )   
                indiceY = indiceYD;
        
    }
    

    public void graficarD()
    {

        graficarD= true;
        repaint();
    }
    public void graficarMD()
    {

        graficarMD= true;
        repaint();
    }
    public void graficarFB()
    {

        graficarFB= true;
        repaint();
    }
    
    public void degraficarD()
    {

        graficarD= false;
        repaint();
    }
    public void degraficarMD()
    {

        graficarMD= false;
        repaint();
    }
    public void degraficarFB()
    {

        graficarFB= false;
        repaint();
    }


    

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */

    
    private boolean graficarD;
    private boolean graficarMD;
    private boolean graficarFB;

    private Punto[] puntosD;
    private Punto[] puntosMD;
    private Punto[] puntosFB;
    
    private int escalaTiempo;
    private int escalaSalida;
    private int ancho;
    private int alto;
    
    private float indiceX=0F;
    private float indiceY=0F;
    
 
    
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        setBackground(new java.awt.Color(0, 0, 0));
        setAutoscrolls(true);
        setEnabled(false);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 744, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 442, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents
    // Variables declaration - do not modify//GEN-BEGIN:variables
    // End of variables declaration//GEN-END:variables
}
