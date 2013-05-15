/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Automatizacion;

import javax.swing.SwingUtilities;

/**
 *
 * @author rafael
 */
public class ControlTiempoReal {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args)
    {
        // TODO code application logic here
        
        SwingUtilities.invokeLater(new Runnable() {
            @Override
      public void run() {
        VentanaPrincipal v = new VentanaPrincipal();
        v.setVisible(true);
      }
    });
        
    }
}
