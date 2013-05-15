/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Automatizacion;

import java.awt.Color;
import java.awt.Graphics;
import java.io.*;
import java.text.DecimalFormat;
import java.util.ArrayList;
import javax.swing.JLabel;

/**
 *
 * @author rafael
 */
public class GraficaSimulacion extends javax.swing.JPanel implements Runnable {

    /**
     * Creates new form GraficaDatos
     */
    public GraficaSimulacion()
    {
        initComponents();
        
        graficar=false;
        
        u1_vivo = true;
        u2_vivo = true;
        
        //indiceX=0F;
        indiceY=0F;
        
        puntosSalida = new ArrayList<Float>();
        puntosSalida.add(0.0F);
        
        xOffSet = 50;
        yOffSet = 20;
        
        puntoMaximo = 0F;
        referencia = 0F;
        viejaReferencia = 0F;
        
        nuevaReferencia = false;
        
        subiendo = true;
        
        estable = false;
        
        puntoEstable = 0;
        
        aumentando = true;
        
        oscilacion = 9999999F;
        
        ultimoPico = 0F;
        
        delayer = 0;
        
    }
    @Override
    public void paintComponent(Graphics g)
    {
        super.paintComponent(g);
        
        
        
        g.setColor(Color.white);
        g.drawLine(xOffSet, yOffSet,xOffSet,this.getHeight()-yOffSet);
        g.drawString("Salida", xOffSet-g.getFontMetrics().stringWidth("Salida")/2, yOffSet-5);
        g.drawLine(xOffSet,this.getHeight()-yOffSet,this.getWidth()-xOffSet,this.getHeight()-yOffSet);
        
        //int pointSize = 2;
        //ancho = this.getWidth()-2*xOffSet;
        alto = this.getHeight()-2*yOffSet;
        

        Color colorSalida = Color.CYAN;
            

        escalaTiempo = 3; //(int) (ancho/300);
        escalaSalida = (int) (alto/indiceY);
        
        
        g.setColor(Color.white);
        
        for(int i=0; i<(int)indiceY; i++)
        {
            g.drawString(Integer.toString(i),xOffSet-20 , this.getHeight()-yOffSet-i*escalaSalida+5);
            g.drawLine(xOffSet-2, this.getHeight()-yOffSet-i*escalaSalida, xOffSet+2, this.getHeight()-yOffSet-i*escalaSalida);
        }
        

        if(graficar)
            grafica(g,puntosSalida,xOffSet,yOffSet,colorSalida,true,1);
        
        
    }
    
    public void grafica(Graphics g, ArrayList<Float> puntos, int xOffSet, int yOffSet, Color color, boolean graficarLineas, int pointSize)
    {
        //int pointSize = 4;
        //ancho = this.getWidth()-2*xOffSet;
        alto = this.getHeight()-2*yOffSet;
        
        
        //Hallando el Sobrepaso Maximo!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        if(referencia!=0.0)
        {
            if(nuevaReferencia)
            {
                nuevaReferencia = false;
                
                puntoMaximo = viejaReferencia;
            }
            
            g.setColor(Color.ORANGE);
            
            int yaux =0;
            DecimalFormat df = new DecimalFormat("0.00");
            
            if(subiendo)
            {
                if(puntos.get(puntos.size()-1)!=0.0 && puntos.get(puntos.size()-1) > puntoMaximo)
                    puntoMaximo = puntos.get(puntos.size()-1);
                
                yaux = (int)(this.getHeight()-yOffSet-puntoMaximo*escalaSalida);
                
                g.drawString("Sobrepaso Máximo: "+df.format((puntoMaximo-referencia)*100/referencia)+" %", this.getWidth()-xOffSet-180, yaux-5);
            }
            else
            {
                if(puntos.get(puntos.size()-1)!=0.0 && puntos.get(puntos.size()-1) < puntoMaximo)
                    puntoMaximo = puntos.get(puntos.size()-1);

                yaux = (int)(this.getHeight()-yOffSet-puntoMaximo*escalaSalida);
                
                g.drawString("Sobrepaso Máximo: "+df.format((referencia-puntoMaximo)*100/referencia)+" %", this.getWidth()-xOffSet-180, yaux-5);
            }
            
            g.drawLine(xOffSet, yaux, this.getWidth()-xOffSet, yaux);
        }
        /*
        int delay = 20;
        
        if(delayer <= delay && referencia!= 0.0)
            ++delayer;
        
        //Hallando el punto de estabilidad!!!!!!!!!!!!!!!!
        if(aumentando && puntos.size() > 2  && puntos.get(puntos.size()-1) < puntos.get(puntos.size()-2) && referencia!=0.0 && !estable && delayer > delay)
        {
            aumentando = false;
            
            oscilacion = puntos.get(puntos.size()-2) - ultimoPico;
            
            ultimoPico = puntos.get(puntos.size()-2);
            
            //System.out.println("Bajando: "+oscilacion);
        }
        
        if(!aumentando && puntos.size() > 2  && puntos.get(puntos.size()-1) > puntos.get(puntos.size()-2) && referencia!=0.0 && !estable && delayer > delay)
        {
            aumentando = true;
            
            oscilacion = ultimoPico - puntos.get(puntos.size()-2);
            
            ultimoPico = puntos.get(puntos.size()-2);
            
            //System.out.println("Subiendo: "+oscilacion);
        }
        
        System.out.println(ultimoPico);
        
        if(oscilacion <= referencia*0.05F && ultimoPico!=0.0 && !estable)
        {
            estable = true;
            puntoEstable = puntos.size()*escalaTiempo+xOffSet;
        }
        
        
        
        if(estable)
        {
            g.setColor(Color.GREEN);
            g.drawLine(puntoEstable, 50, puntoEstable, this.getHeight() - 20);
            //g.drawString("Tiempo de Asentamiento: "+puntoEstable+"s", puntoEstable*escalaTiempo + 10, (int)referencia*escalaSalida-20);
        }*/



        g.setColor(color);

        for(int i=0; i<puntos.size(); i++)
        {
            //int x = (int) (puntos.get(i).getX()*escalaTiempo);
            int x = (int) (i*escalaTiempo);
            //int y = (int) (puntos.get(i).getY()*escalaSalida);
            int y = (int) (puntos.get(i)*escalaSalida);
            
            //System.out.println("Hola!"+x+"  "+y);
            //System.out.println("Hola!"+puntos.get(i).getX()+"  "+puntos.get(i).getY());
           
            g.fillOval(x+xOffSet-pointSize/2, this.getHeight()-yOffSet-y-pointSize/2, pointSize, pointSize);
            
            if(graficarLineas && i>0)
            {
                g.drawLine(((int) ((i-1)*escalaTiempo))+xOffSet, this.getHeight()-yOffSet-((int) (puntos.get(i-1)*escalaSalida)), x+xOffSet, this.getHeight()-yOffSet-y);
            }
        }
    }
    


    public void graficarSalida(String mk,String mt,String ts,String kp,String ki,JLabel jLabel1,JLabel jLabel2, JLabel jLabel3, VentanaPrincipal vp)
    {

        this.mk = mk;
        this.mt = mt;
        this.ts = ts;
        this.kp = kp;
        this.ki = ki;
        this.jLabel1 = jLabel1;
        this.jLabel2 = jLabel2;
        this.jLabel3 = jLabel3;
        this.vp = vp;
        
        if(graficar)
            graficar = false;
        else
            graficar= true;
        repaint();
        
        vp.imprimirConsola("Esperando referencia, ingrese un valor...");
    }
    
    @Override
    public void run()
    {
        
        Runtime rt = Runtime.getRuntime();
        
        try
        {
            Process pr = rt.exec("./planta "+mk+" "+mt+" "+ts);
            Thread.sleep(1000);
            pr2 = rt.exec("./controlador_a "+ts+" "+kp+" "+ki);
            pr3 = rt.exec("./controlador_b "+ts+" "+kp+" "+ki);
            Thread.sleep(1000);
            Process pr4 = rt.exec("./operador");
            
            
            BufferedReader input = new BufferedReader(new InputStreamReader(pr.getInputStream()));
            BufferedReader input2 = new BufferedReader(new InputStreamReader(pr2.getInputStream()));
            BufferedReader input3 = new BufferedReader(new InputStreamReader(pr3.getInputStream()));
            output = new PrintWriter(new OutputStreamWriter(new BufferedOutputStream(pr4.getOutputStream())),true);
            
            while(graficar)
            {
                if(u1_vivo)
                    jLabel1.setText("U1: "+input2.readLine());
                if(u2_vivo)
                    jLabel2.setText("U2: "+input3.readLine());
                

                String line=input.readLine();
                
          
            
                float p = Float.parseFloat(line);


                if(puntosSalida.size()== this.getWidth()/escalaTiempo- xOffSet)
                {
                    puntosSalida.remove(0);
                    puntosSalida.add(p);
                    puntosSalida.trimToSize();
                    
                    if(estable)
                    puntoEstable-=escalaTiempo;
                }
                else
                    puntosSalida.add(p);

                jLabel3.setText("Y: "+p);


                float indiceYD = puntosSalida.get(puntosSalida.size()-1)+1;

                if( indiceYD > indiceY )   
                    indiceY = indiceYD;

                repaint();
                //System.out.println(puntosSalida.size()+":"+puntosSalida.get(puntosSalida.size()-1).getX()+" "+puntosSalida.get(puntosSalida.size()-1).getY());
                //Thread.sleep(100);
            }

        }
        catch(Exception e)    
        {
            System.err.println(e.toString());
        }
        
    }
    
    public void setRef(String ref)
    {
        nuevaReferencia = true;
        
        estable = false;
        
        delayer = 0;
        
        viejaReferencia = referencia;
        
        if(ref.contains("."))
            referencia = Float.parseFloat(ref);
        else
            referencia = (float) Integer.parseInt(ref);
        
        if(referencia > viejaReferencia)
        {
            subiendo = true;
            aumentando = true;
        }
        else
        {
            subiendo = false;
            aumentando = false;
        }
        
        ref = Float.toString(referencia);
       
       
        this.ref = ref;
        output.println(ref);
        
        vp.imprimirConsola("Buscando nueva referencia: "+referencia);
        
        
    }
    
    public void detener()
    {
        graficar = false;
        output.println("FIN");
        try
        {
            Thread.sleep(5000);
        }
        catch(Exception e)    
        {
            System.err.println(e.toString());
        }
    }
    
    public void matarU1()
    {
        jLabel1.setText("U1: Finalizado");
        if(!u2_vivo)
            detener();
        
        u1_vivo = false;
        try {Thread.sleep(1000);}catch(Exception e){System.err.println(e.toString());}
        pr2.destroy();
        
        
    }
    
    public void matarU2()
    {
        jLabel2.setText("U2: Finalizado");
        if(!u1_vivo)
            detener();
        u2_vivo = false;
        try {Thread.sleep(1000);}catch(Exception e){System.err.println(e.toString());}
        pr3.destroy();
        
    }



    private boolean graficar;
    private boolean u1_vivo;
    private boolean u2_vivo;
    

    private ArrayList<Float> puntosSalida;
    private int escalaTiempo;
    private int escalaSalida;
    //private int ancho;
    private int alto;
    
    //private float indiceX=0F;
    private float indiceY=0F;
    
    private int xOffSet;
    private int yOffSet;
    
    private String mk;
    private String mt;
    private String ts;
    private String kp;
    private String ki;
    private String ref;
    
    private PrintWriter output;
    
    private JLabel jLabel1;
    private JLabel jLabel2;
    private JLabel jLabel3;
    
    
    private Process pr2;
    private Process pr3;
    
    private float puntoMaximo;
    private float referencia;
    private float viejaReferencia;
    
    private boolean nuevaReferencia;
    
    private boolean subiendo;
    
    private boolean estable;
    private int puntoEstable;
    private boolean aumentando;
    
    private float oscilacion;
    
    private float ultimoPico;
    
    private int delayer;
    
    VentanaPrincipal vp;
    
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
