import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

PeasyCam cam;
Plant p;
Leaf k;
Leaf k1,k2;
float inc;
boolean doStroke;

void setup () 
{
  //fullScreen(P3D);
  size(600, 600, P3D);
  cam = new PeasyCam(this,500);
  frameRate(30);
  //k = new Leaf();
  //k.display();
  //noLoop();
  
  p = new Plant(20,200,8,10);  //generate new Plant: (int totalLeaves, float stemHeight, float stemRadius, int stemSides)
  //k = new Leaf();
}

void draw () 
{ 
  pushMatrix();
  fill(0);
  text("" + frameRate,20,20);
  println(frameRate);
  popMatrix();

//inc+=0.015;
  rotateZ(inc); //rotate entire model slowly
  //lights();
  background(255);
  stroke(255);
  noFill();  
  drawBox(true); //make box
  drawAxis(true, 200); //make axis
  fill(0,100,255,200);
  
  pushMatrix();
  translate(0,0,-100); //translate plant to bottom center of box
  //k1 = new Leaf(PI/2, 15, 100, 1.01, 50, 5);
  //k2 = new Leaf(PI/4, 15, 100, 1.05, 0, 5);
  if(doStroke) stroke(255);
  else noStroke();
  p.display(); //display/update plant
  p.invis();
  //k.display();
  //k1.display();
  //k2.display();
  popMatrix();  
  
}

void drawBox(boolean draw) //draws a box
{
  stroke(0);
  if(draw) box(200,200,200);
  noStroke();
}

void drawAxis(boolean draw, float length) //draws colored xyz axis
{
  if(draw)
  {
    noStroke();
    pushMatrix();
    translate(-100,-100,-100);

    fill(255,0,0); //x
    box(length,2,2);
    
    fill(0,255,0); //y
    box(2,length,2);
    
    fill(0,0,255); //z
    box(2,2,length);
    
    popMatrix();
    stroke(255);
  }
}

void keyReleased() //toggle polygon lines
{
  if (key == 'c')
    doStroke = !doStroke;
}