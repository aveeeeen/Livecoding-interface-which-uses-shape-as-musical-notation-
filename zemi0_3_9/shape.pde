public class Shape {
  public PVector[] edge = new PVector[16];
  public PVector[] hitPoint = new PVector[edge.length];
  public String shapeName;
  public color colour; 
  public int i = 0;
  public int state = 0;
  public float value = 0;
  public float xMin = 0;
  public float xMax = 0;
  public float yMin = 0;
  public float yMax = 0;
  public float r = 10;
  public Boolean isHit = false;

  public Shape(String shapeName) {
    this.shapeName = shapeName;
    i = 0;
    state = 0;  
    colour = color(255);
    isHit = false;
    for (int j = 0; j < edge.length; j++) {
      edge[j] = new PVector(0.0, 0.0);
    }
  } 
  public void render() {

    fill(colour);

    if (state == 1) {
      beginShape();
      for (int j = 0; j < i; j++) {
        vertex(edge[j].x, edge[j].y);
      }
      endShape(CLOSE);
    }
    if (0 < i) {
      for (int j = 0; j < i; j++) {
        ellipse(edge[j].x, edge[j].y, 5, 5);
      }
      ellipse(xMin, yMin, r*2, r*2);
    }
  }

  public void printText(String t, int x, int y) {
    fill(0);
    text(t, xMin + x, yMin + y);
  }

  public void setColour(color c) {
    this.colour = c;
  }

  public void setColour(int r, int g, int b) {
    color c = color(r, g, b);
    this.colour = c;
  }

  public void setEdge(float x, float y) {
    if (x == 0 || x < 0.1 ) x = 0.1;
    if (y == 0 || y < 0.1 ) y = 0.1;

    if (state == 0) {
      if (i < edge.length) {
        switch(shapeName) {
        case "vect":
          edge[i].set(x, y);
          i++;
          break;
        case "rect":
          if (i == 0) {
            edge[i].set(x, y);
            i++;
          }
          edge[1].set(x, y); 
          PVector tempVect = new PVector(edge[1].x, edge[1].y);
          edge[1].set(edge[0].x + (tempVect.x - edge[0].x), edge[0].y);
          edge[2].set(tempVect.x, tempVect.y);
          edge[3].set(edge[0].x, edge[0].y + (tempVect.y - edge[0].y));
          i = 4;
          break;
        case "tri":
          if (i == 0) {
            edge[i].set(x, y);
            i++;
          }
          edge[1].set(x, y);
          edge[2].set(edge[0].x, edge[0].y + (edge[1].y - edge[0].y)*2);
          i = 3;
          break;
        }
      } else {
        println("max edge count ecceeded ");
      }
    }
  }
  
  public PVector getEdges(int j){
    return this.edge[j];
  }

  public void translate(float x, float y) {
    if (x == 0 || x < 0.1 ) x = 0.1;
    if (y == 0 || y < 0.1 ) y = 0.1;

    for (int j = 0; j < edge.length; j++) {
      if (edge[j].x != 0.0 && edge[j].y != 0.0) {
        edge[j].add(x - xMin, y - yMin);
      } else {
        continue;
      }
    }
  }

  public Boolean getIsHit() {
    return this.isHit;
  }

  public float getValue() {
    float tempValue = 0.0;
    float[] distArray = new float[hitPoint.length];
    
    if(isHit){
      if(i > 2){
        float[] pointY = new float[hitPoint.length];
        int counter = 0;
        for(int j = 0; j < hitPoint.length; j++){
            if(hitPoint[j] != null){
              pointY[j] = hitPoint[j].y;
              counter ++;
            }else{
              pointY[j] = 0.0;
            }
        }
        
        /*
        for (int j = 0; j < pointY.length; j++){
          println("i is" + i); 
          if(j == 0) println( "[" );
          println(pointY[j] + ",");
          if(j == pointY.length - 1) println("]");
        }
        */
        pointY = sort(pointY);
        pointY = reverse(pointY);
        if(counter % 2 != 0){
          pointY[counter - 1] = 0.0;
        }
        
        
        for(int j = 0; j < pointY.length - 1; j++){
          if(j % 2 == 0){
            distArray[j] = pointY[j] - pointY[j+1]; 
          }
        }
        /*
        //turn this on only for debug purposes. Otherwise serious lag happens.
         for (int j = 0; j < pointY.length; j++){
          if(j == 0) println( "[" );
          println(pointY[j] + ",");
          if(j == pointY.length - 1) println("]");
        }
        for (int j = 0; j < distArray.length; j++){
          if(j == 0) println( "[" );
          println(distArray[j] + ",");
          if(j == distArray.length - 1) println("]");
        }
        /**/
        
          for(int j = 0; j < distArray.length; j++){
            tempValue += distArray[j];
          }
      }
    
      return tempValue;
    }else{
      tempValue = 0.0;
      return tempValue;
    }
  }

  private void XYMinMax () {
    float[] tempX = new float[edge.length];
    float[] tempY = new float[edge.length];

    for (int i = 0; i < edge.length; i++) {
      tempX[i] = edge[i].x;
      tempY[i] = edge[i].y;
    }
    tempX = sort(tempX);

    for (int j = 0; j < edge.length; j++) {
      if (j == 0) {
        xMax = isLarger(tempX[j], tempX[j+1]);
        yMax = isLarger(tempY[j], tempY[j+1]);
      } else {
        xMax = isLarger(xMax, tempX[j]);
        yMax = isLarger(yMax, tempY[j]);
      }
    }
    for (int j = 0; j < edge.length; j++) {
      if (j == 0) {
        xMin = isSmaller(tempX[j], tempX[j+1]);
        yMin = isSmaller(tempY[j], tempY[j+1]);
      } else {
        xMin = isSmaller(xMin, tempX[j]);
        yMin = isSmaller(yMin, tempY[j]);
      }
    }
  }


  private void hit (PVector a) {
    if (xMin < a.x && a.x < xMax) {
      isHit = true;
    } else {
      isHit = false;
    }
  }

  private float isLarger(float b, float c) {
    if (b > c) return b;
    return c;
  }

  private float isSmaller(float b, float c) {
    if (b == 0) return c;
    if (c == 0) return b;
    if (b < c) return b;
    return c;
  }

  public float getXmin() {
    return this.xMin;
  }

  public float getYmin() {
    return this.yMin;
  }


  public void distance (PVector a, PVector a2) {
    if(isHit){
      for (int j = 0; j < i ;j++) {
  
        float x0 = a.x;
        float y0 = a.y;
        float x1 = a2.x;
        float y1 = a2.y;
  
        float x2 = edge[j].x;
        float y2 = edge[j].y;
        float x3 = 0;
        float y3 = 0;
  
        if (i % 2 == 1 && j == i) {
          x3 = edge[0].x;
          y3 = edge[0].y;
        } else if (j+1 == i && i > 2) {
          x3 = edge[0].x;
          y3 = edge[0].y;
        } else {
          x3 = edge[j+1].x;
          y3 = edge[j+1].y;
        }
  
        if (abs(x1-x0) < 0.01) x1 = x0 + 0.01;
        if (abs(x3-x2) < 0.01) x3 = x2 + 0.01;
  
        float t0 = (y1-y0) / (x1-x0);
        float t1 = (y3-y2) / (x3-x2);
  
        float x = 0;
        float y = 0;
  
        if (t0 != t1) {
          x = (y2 - y0 + t0*x0 - t1*x2) / (t0 - t1);
          y = t0*(x-x0) + y0;
        }
  
        float r0 = (x-x0) / (x1-x0);
        float r1 = (x-x2) / (x3-x2);
        boolean hit = 0<r0 && r0<1 && 0<r1 && r1<1;
  
        if (t0 != t1 && hit && y2 != 0 && y3 != 0) {
          hitPoint[j] = new PVector(x, y);
          //*/
        }
      }
    }
  }
}
