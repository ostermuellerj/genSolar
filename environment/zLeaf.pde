class Leaf
{
  //int polys=10;
  //float w=200;
  //float l=50;
  //float c=-1.025;
  //float h;
  //float rotation;
  //double x;
  //double y;
  //double z;
  //float[] verts;
  //PShape stem;
  //PShape leaf;
  
  int polys=5;
  float w,l,c,h;
  float rotation;
  double x,y,z;
  float[] verts;
  PShape stem,leaf;
  boolean doRandom;
  float[] values;

  //float w=random(100,200);
  //float l=random(10,60);
  //float c=random(1.020,1.025);
  //float h=random(0,200);
  //float rotation=random(0,PI*2);

  
  //float w,l,c,h; //leaf's width, height, curl, and y location
  //double x,y,z; //xyz coordinates of a given vertice on the top row of a leaf
  //int polys; //number of quadrilateral polygons within a leaf
  //float rotation;
  //float [] verts;
  //boolean randomVerts;
  
  Leaf(float angle, float length, float width, float curl, float yLocation, int polyCount)
  {
    l = length;
    w = width;
    c = curl;
    h = yLocation;
    rotation = angle;
    polys=polyCount;
  }
  
  Leaf()
  {
    w=random(100,200);
    l=random(10,60);
    //c=random(1.020,1.025);
    h=random(0,200);
    rotation=random(0,PI*2);
  }
  
  float[] makeVerts()
  {
    float[] verts = new float [((polys+1)*3)];
     
    for(float i=0; i < polys+1; i++)
    {
      x = (w*i)/polys; //generate x values per number of polys
      y = l*Math.sin((PI*x)/(w)); //generate y
      z = -(float)Math.pow(c,x); //generate curl
        
      //top row of verts
      verts[(int)i] = (float)x; //assign x values to first i polys
      verts[(int)i+(polys+1)] = (float)y; //assign y values to first i+(polys+1) polys
      verts[(int)i+(2*(polys+1))] = (float)z; //assign z values to first i+(2*(polys+1)) polys      
    }
    return verts;
  }
  
  PShape makeLeaf() //generates leaf
  {
    verts = makeVerts();
    pushMatrix();
    translate(0,0,0); //center
      
    strokeWeight(1);
    rotateX(PI/2); //face up
    PShape l = createShape();
    PShape stem = createShape(GROUP); 
    stem.addChild(l);
    
    l.beginShape(QUAD_STRIP); //add leaves to stem PShape
      for(int i=0; i < polys+1; i++)
      {
        //print(i);
        l.vertex(verts[i], verts[i+(polys+1)], verts[i+(2*(polys+1))]); //top
        l.vertex(verts[i], -verts[i+(polys+1)], verts[i+(2*(polys+1))]); //bottom
      }
    l.endShape();
    
    popMatrix();
    return stem;
  }
  
  void display ()
  {
    //println("w: " + w + " l: " + l + " c: " + c + " h: " + h); //DEBUG
    //if (keyPressed == true && key == 'x')rotation+=.01;
    pushMatrix();
    rotateX(PI);
    translate(0,0,-h);
    rotateZ(rotation);  
    shape(makeLeaf());
    popMatrix();
  }
}