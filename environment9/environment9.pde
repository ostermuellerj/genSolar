import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

PeasyCam cam;
Plant p;
Leaf k;
Leaf k1, k2;
float inc;
boolean doLeafStroke, doFitnessStroke, doFieldLines, doEvaluate=true;
//PVector R_1, R_2;
PVector R_1 = new PVector(-100, -100, 200); //test line for intersection point 1
PVector R_2 = new PVector(-100, -100, 0); //" point 2
//PVector R_2 = new PVector(100, 100, 0);

int fwidth=400, fheight=400;
PVector field1_loc = new PVector(-fwidth/2,-fheight/2,0),field2_loc = new PVector(0,0,0);
int fdensity=200;
float fitness;
PVector[][] field1 = new PVector[fwidth][fheight], field2 = new PVector[fdensity][fdensity]; //fitness field
Boolean[][] hitsArray = new Boolean[fdensity][fdensity];

int leafNum = 6;

void setup () 
{ 
  //noLoop();
  //fullScreen(P3D);
  size(600, 600, P3D);
  cam = new PeasyCam(this, 500);
  frameRate(60);
  
p = new Plant(leafNum, 200, 8, 10);  //generate new Plant: (int totalLeaves, float stemHeight, float stemRadius, int stemSides) ***
 
    for(int i=0;i<fdensity;i++)
      for(int j=0;j<fdensity;j++)
        hitsArray[i][j]=false;
}

void draw () 
{
  if (keyPressed==true) //move test intersection line with arrow keys
  {
    if (keyCode == LEFT) R_1.x--;
    if (keyCode == RIGHT) R_1.x++;
    if (keyCode == UP) R_1.y--;
    if (keyCode == DOWN) R_1.y++;
    
    if (keyCode == LEFT) R_2.x--;
    if (keyCode == RIGHT) R_2.x++;
    if (keyCode == UP) R_2.y--;
    if (keyCode == DOWN) R_2.y++;
    
  //  if(key == 'w') R_2.y++;
  //  if(key == 's') R_2.y--;
  //  if(key == 'd') R_2.x++;
  //  if(key == 'a') R_2.x--;
  }

  background(255);
  
  stroke(255);
  noFill();  
  drawBox(true); //make box
  drawAxis(true, 200); //make axis  
  fill(0, 100, 255, 200);

  pushMatrix();
    
  translate(0, 0, -100); //translate plant to bottom center of box
  
  stroke(0);
  strokeWeight(1);
  //line(R_1.x, R_1.y, R_1.z, R_2.x, R_2.y, R_2.z); //display test intersection line
   
  if (!doLeafStroke) noStroke();
  else stroke(255);
  
  p.display(); //display/update plant ***
  if(doEvaluate)
  {
    p.evaluate();
    println(p.leaves[0].getArea()); //***
    doEvaluate=false;
  }
  ////for(int i=0; i<101;i++) //***
  ////{
  ////  double start = millis();
  ////  Plant q = new Plant(leafNum, 100, 8, 10);
  ////  q.display();
  ////  q.evaluate();
  ////  double time = millis()-start;
  ////println(i + ", " + time); //performance stats
  ////  //println(i + ", " + q.hits + ", " + q.leaves[0].getArea()); //area stats
    
  //  if(i==100) exit();
  //}
  
  //fill(0);
  //rect(0,0,100,100);
  
  popMatrix();
  
  pushMatrix(); //draw hits ***
    rotateX(-PI/2);
    translate(100,0,50);
    text(""+p.hits,0,0,0);
  popMatrix();
}

void drawBox(boolean draw) //draws a box
{
  stroke(0);
  if (draw) box(200, 200, 200);
  noStroke();
}

void drawAxis(boolean draw, float length) //draws colored xyz axis
{
  if (draw)
  {
    noStroke();
    pushMatrix();
    translate(-100, -100, -100);

    fill(255, 0, 0); //x
    box(length, 2, 2);

    fill(0, 255, 0); //y
    box(2, length, 2);

    fill(0, 0, 255); //z
    box(2, 2, length);

    popMatrix();
    stroke(255);
  }
}

void keyReleased() //toggle polygon lines
{
  if (key == 'c') doLeafStroke = !doLeafStroke;
  if (key == 'e') doFitnessStroke = !doFitnessStroke;
  if (key == 'x') doFieldLines = !doFieldLines;
  
  if (key == 'r')
  {
    p = new Plant(leafNum, 200, 8, 10);  //generate new Plant: (int totalLeaves, float stemHeight, float stemRadius, int stemSides)
    doEvaluate=true;
    //p.evaluate();
  }
}