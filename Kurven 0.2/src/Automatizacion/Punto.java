/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Automatizacion;

/**
 *
 * @author rafael
 */
public class Punto
{
    public Punto(float x, float y)
    {
        this.x=x;
        this.y=y;
    }
    
    public void setX(float x)
    {
        this.x=x;
    }
    
    public void setY(float y)
    {
        this.y=y;
    }
    
    public float getX()
    {
        return x;
    }
    
    public float getY()
    {
        return y;
    }
    
    private float x,y;
}
