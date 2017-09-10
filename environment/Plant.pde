class Plant 
{
  PShape plant = createShape(GROUP); //create plant pshape group (contains leaves and stem)
  PShape stem = createShape(GROUP); //create stem pshape group (contains stem sides)
  PShape leaf;
  Leaf[] leaves;
  
  int numLeaves, stemS; //total number of leaves, sides of stem
  float stemH, stemR; //stem height, stem radius
  
  //Leaf f;
  
  Plant(int totalLeaves, float stemHeight, float stemRadius, int stemSides) 
  {
    stemH = stemHeight;
    stemR = stemRadius;
    stemS = stemSides;
    numLeaves = totalLeaves;
    plant.addChild(stem); //add stem to plant pshape group
    leaves = new Leaf[numLeaves];
    for(int i=0;i<numLeaves;i++) //adds numleaves number of leaf pshapes to leaves array 
    {
      //leaves[i]=new Leaf(((2*PI)/numLeaves)*i, 15, 100, 1.025, (stemH/numLeaves)*i, 5); //create a specific plant
      leaves[i]=new Leaf(); //makes a random leaf
    }
  }
  
  void display() //display pshapes
  {
    //f = new Leaf(5);
    for(int i=0;i<numLeaves;i++)
    {
      leaves[i].display();
    }
    shape(drawStem(stemS,stemR,stemH)); //generate stem
    //f.display();
  }
  
  void invis()
  {
    plant.setVisible(mousePressed);
  }
  
  PShape drawLeaves ()
  {
    return leaf;
  }
  
  PShape drawStem(int sides, float r, float h) //make stem
  {
    float angle = 360 / sides;
    
    PShape stem = createShape(GROUP);
    PShape stemSides = createShape();
    PShape stemBase = createShape();
    PShape stemTop = createShape();
    
    stem.addChild(stemSides); //adds base, sides, and top to stem pshape group
    stem.addChild(stemBase);
    stem.addChild(stemTop);
    
    // draw top shape
    stemTop.beginShape(); //creates a polygon with a given number of sides
    for (int i = 0; i < sides; i++) 
    {
      float x = cos(radians(i * angle))*r;
      float y = sin(radians(i * angle))*r;
      stemTop.vertex(x, y, 0);    
    }
    stemTop.endShape(CLOSE);
    
    // draw bottom shape
    stemBase.beginShape(); //creates a polygon with a given number of sides
    for (int i = 0; i < sides; i++) 
    {
      float x = cos(radians(i * angle))*r;
      float y = sin(radians(i * angle))*r;
      stemBase.vertex(x, y, h );    
    }
    stemBase.endShape(CLOSE);
      
    //draw body
    stemSides.beginShape(QUAD_STRIP); //creates a set of quadstrips to attach the base and top
    for (int i = 0; i < sides+1; i++) 
    {
      if(i==sides) angle=0;
      float x = cos(radians(i * angle))*r;
      float y = sin(radians(i * angle))*r;
      stemSides.vertex( x, y, h);
      stemSides.vertex( x, y, 0);    
    }
    stemSides.endShape(CLOSE); 
    
    return stem;
  }
}  