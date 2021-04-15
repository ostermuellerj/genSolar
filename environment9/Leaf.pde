class Leaf
{
  int quads=6, id;
  float w, l, c, h;
  float rotation;
  double x, x1, y, y1, z, z1;
  PVector[][] verts, triVerts;
  PShape stem, leaf;
  boolean doRandom, drawVerts=false;
  float[] values;

  PVector M;

  Leaf(int leafID, float angle, float length, float width, float curl, float yLocation, int polyCount)
  {
    l = length;
    w = width;
    c = curl;
    h = yLocation;
    rotation = angle;
    quads=polyCount;
  }

  Leaf(int leafID)
  {
    id = leafID;
    w=random(100, 200);
    l=random(10, 60);
  
    c=random(1.020, 1.025);
    h=random(0, 200);
    rotation=random(0, 2*PI);
    //rotation=0;
  }

  //array[quads][points in each poly]
  //array[quads][3]


  PVector[][] makeVerts()
  {
    PVector[][] verts = new PVector[quads][4]; //holds verts (4 pvectors per quad)

    for (int i=0; i < quads; i++) //generates all points needed for leaf vertices
    {
      x=(float)((w*(i))/quads+.1);
      y=(l*Math.sin((PI*x)/(w)));
      z=Math.pow(c, x)+h;
      verts[i][0] = new PVector((float)x, //top left vertex
                                (float)y,
                                ((float)z));                                  
      verts[i][1] = new PVector((float)x, //bottom left vertex
                                -(float)y, 
                                (float)z); 

      x=(w*(i+1))/quads+.1;
      verts[i][2] = new PVector((float)x, //top right vertex
                                (float)(l*Math.sin((PI*x)/(w))),
                                ((float)Math.pow(c, x))+h);
      verts[i][3] = new PVector((float)x, //bottom right vertex
                                 -(float)(l*Math.sin((PI*x)/(w))),
                                 ((float)Math.pow(c, x))+h);
    }
    return verts;
  }

  //void rotate(float X, float Y, float theta)
  //{
  //  float mag = sqrt((pow(X, 2)+pow(Y, 2)));
  //  X = mag*cos(theta);
  //  Y = mag*sin(theta);
  //}

  PShape makeLeaf() //generates leaf
  {
    verts = makeVerts();
    //println("rotation: " + rotation);

    for (int i=0; i < quads; i++) //rotation of points
    {
      for (int j=0; j<4; j++)
      {
        float X=verts[i][j].x, Y=verts[i][j].y;  
        float theta = atan(Y/X);
        //println("theta: " + theta);
        float mag = sqrt((pow(X, 2)+pow(Y, 2)));
        X = mag*cos(rotation+theta);
        Y = mag*sin(rotation+theta);
        verts[i][j].x=X;
        verts[i][j].y=Y;
      }
    }

    genTris(); //generate triVerts[][] from verts[][] (triangles from convex quadrilaterals)

    pushMatrix();
    translate(0, 0, 0); //center

    strokeWeight(1);
    //rotateX(PI/2); //face up

    PShape stem = createShape(GROUP); 

    //add leaves to stem PShape
    for (int i=0; i < quads*2; i++)
    {      
      PShape l = createShape();

      l.beginShape(); //change shape gen type: "POINTS", "TRIANGLE", "QUAD_STRIP", "QUADS"

      drawVertex(l, triVerts[i][0]); //draws PShape vertices using verts[][] PVector array
      drawVertex(l, triVerts[i][1]);
      drawVertex(l, triVerts[i][2]);      

      if (drawVerts) drawSphere(triVerts[i][0]); //draws spheres on vertices of leaf
      if (drawVerts) drawSphere(triVerts[i][1]);
      if (drawVerts) drawSphere(triVerts[i][2]);

      //fill(0);
      fill(0, i*(100/quads)+30, i*(255/quads)+30); //color gradient
      l.endShape();
      stem.addChild(l);
    }

    popMatrix();
    return stem;
  }

  void genTris ()
  {
    triVerts = new PVector[quads*2][3];

    for (int i=0; i<quads; i++)
    {
      triVerts[2*i][0]=verts[i][0];
      triVerts[2*i][1]=verts[i][2];
      triVerts[2*i][2]=verts[i][1];

      triVerts[2*i+1][0]=verts[i][1];
      triVerts[2*i+1][1]=verts[i][2];
      triVerts[2*i+1][2]=verts[i][3];
    }
  }

  void display ()
  {
    shape(makeLeaf());
    line(0, 0, 0, 100*cos(rotation), 100*sin(rotation), 0);

    for (int i=0; i<quads; i++)
    {
      //print(id + "." + i + intersect(0, R_1, R_2) + "|");
    }

    if (keyPressed==true)
    {
      if (keyCode == LEFT) field1_loc.x--;
      if (keyCode == RIGHT) field1_loc.x++;
      if (keyCode == UP) field1_loc.y--;
      if (keyCode == DOWN) field1_loc.y++;
      if (key == 'd') fdensity++;
      if (key == 'f') fdensity--;
    }

    //field2_loc = new PVector(field1_loc.x, field1_loc.y, field1_loc.z+250); 
    field2_loc = new PVector(-fwidth/2, -fheight/2, 250);       
  }

  boolean intersect(int poly, PVector R1, PVector R2)  //float[] v
  { 
    PVector p0 = triVerts[poly][0];
    PVector p1 = triVerts[poly][1];
    PVector p2 = triVerts[poly][2];

    //drawSphere(p0);
    //drawSphere(p1);
    //drawSphere(p2);

    PVector edge1, edge2, h, s, q, dR;
    float a, f, u, v;

    edge1 = p1.copy().sub(p0);
    edge2 = p2.copy().sub(p0);

    dR = R2.copy().sub(R1);

    h = dR.copy().cross(edge2);

    a = edge1.copy().dot(h);

    if (a > -EPSILON && a < EPSILON)
      return false;

    f = 1/a;
    s = R1.copy().sub(p0);
    u = f * (s.copy().dot(h));
    if (u < 0.0 || u > 1.0)
      return false;

    q = s.copy().cross(edge1);
    v = f * dR.copy().dot(q);
    if (v < 0.0 || u + v > 1.0)
      return false;

    float t = f*edge2.copy().dot(q); //compute t to find intersection on line

    if (t > EPSILON) // ray intersection
    {
      R2 = R1.copy().add(dR.mult(t)); 
      //stroke(255, 0, 0, 50);
      //line(R1.x, R1.y, R1.z-10, R2.x, R2.y, R2.z+10); //show intersecting lines 
      return true;
    } else return false;
  }

  void drawSphere (PVector v)
  {
    pushMatrix();
    fill(0);
    translate(v.x, v.y, v.z);
    sphere(1);
    noFill();
    popMatrix();
  }  
  void drawVertex (PShape p, PVector v)
  {
    p.vertex(v.x, v.y, v.z);
  }

  float getArea () //HERON'S FORMULA
  {
    float area=0;
    for(int i=0;i<quads*2;i++)
    {
      //A = sqrt(s(s-a)(s-b)(s-c))
      //s = (a+b+c)/2
      float a = triVerts[i][0].dist(triVerts[i][1]);
      float b = triVerts[i][1].dist(triVerts[i][2]);
      float c = triVerts[i][2].dist(triVerts[i][0]);
      
      float s = (a+b+c)/2;
      
      if(i!=1 && i!=2*quads-1)
        area+=sqrt(s*(s-a)*(s-b)*(s-c));
    }
    return area;
  }
}