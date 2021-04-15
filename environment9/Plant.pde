class Plant 
{
  PShape plant = createShape(GROUP); //create plant pshape group (contains leaves and stem)
  PShape stem = createShape(GROUP); //create stem pshape group (contains stem sides)
  PShape leaf;
  Leaf[] leaves;
  int hits;
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
    for (int i=0; i<numLeaves; i++) //adds numleaves number of leaf pshapes to leaves array 
    {
      //leaves[i]=new Leaf(((2*PI)/numLeaves)*i, 15, 100, 1.025, (stemH/numLeaves)*i, 5); //create a specific plant
      leaves[i]=new Leaf(i); //makes a random leaf
    }
  }

  void display() //display pshapes
  {
    shape(drawStem(stemS, stemR, stemH)); //generate stem
    //f = new Leaf(5);
    for (int i=0; i<numLeaves; i++)
    {
      leaves[i].display();
    }
    //f.display();
    
    fill(0);
    if(doFitnessStroke)
    {
      stroke(255, 0, 0, 50);
      for(int x=0;x<fdensity;x++)
        for(int y=0;y<fdensity;y++)
        {
          if(hitsArray[x][y]==true) line(field1[x][y].x, field1[x][y].y, field1[x][y].z, field2[x][y].x, field2[x][y].y, field2[x][y].z);
        }
    }
  }

  void evaluate()
  {
    int dummyHits=0;
    
    for(int i=0;i<fdensity;i++)
      for(int j=0;j<fdensity;j++)
        hitsArray[i][j]=false;
    
    if (keyPressed==true)
    {
      //if (keyCode == LEFT) field1_loc.x--;
      //if (keyCode == RIGHT) field1_loc.x++;
      //if (keyCode == UP) field1_loc.y--;
      //if (keyCode == DOWN) field1_loc.y++;
      if (key == 'd') fdensity++;
      if (key == 'f') fdensity--;
    }
    
    for (int x=0; x<fdensity; x++)
    {
      for (int y=0; y<fdensity; y++)
      {
        field1[x][y]= new PVector(x*(fwidth/fdensity)+field1_loc.x, 
                                  y*(fheight/fdensity)+field1_loc.y,
                                  field1_loc.z);
        field2[x][y]= new PVector(x*(fwidth/fdensity)+field2_loc.x,
                                  y*(fheight/fdensity)+field2_loc.y,
                                  field2_loc.z);        

        stroke(0, 0, 0, 10);
        if(doFieldLines) line(field1[x][y].x, field1[x][y].y, field1[x][y].z,
                              field2[x][y].x, field2[x][y].y, field2[x][y].z); //show field lines
              
        for (int l = 0; l<leafNum; l++)
        {
          for (int p=1; p<leaves[l].quads*2; p++)
          {
            //if(hitsArray[x][y]==false)
              if(leaves[l].intersect(p, field1[x][y], field2[x][y]))
              {
                dummyHits++;
                hitsArray[x][y]=true;
              }
          }
        }
      }
    }
    
    hits=dummyHits;
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
    fill(0, 80, 200, 200);
    //noFill();
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
      if (i==sides) angle=0;
      float x = cos(radians(i * angle))*r;
      float y = sin(radians(i * angle))*r;
      stemSides.vertex( x, y, h);
      stemSides.vertex( x, y, 0);
     }  
     stemSides.endShape(CLOSE);

    return stem;
  }
}  