public class SoundObject implements Cloneable
{
  public int soundPlay = 0;
  public int path;
  //shape types
  //PShape shape;
  public String shapeName;
  public boolean select = false;
  public boolean copied = false;
  public boolean isHit;
  //Beads object instances

  Gain g;
  Glide gainV;
  /*  
  SamplePlayer sound;
  */
  //Shape object instances
  Shape shape;

  public SoundObject(String shapeName, int path) 
  {
    this.path = path;
    this.shapeName = shapeName;
    shape = new Shape(shapeName);
    loadAudio();
    runAudio();
  }
  
  public void update(){
    shape.hit(pointA);
    shape.XYMinMax();
    shape.distance(pointA,pointB);
    
    if (shape.getIsHit()) {
      if(shape.i > 1){
        play();
        if(isTriggered()) runAudio();
      }
      //println(s_.shape.getValue());
    } else {
      end();
    }
    
    shape.setColour(soundPath[path].getColor());
    if(select) shape.setColour(255,0,0);
    if(copied) shape.setColour(0,0,255);
  }
  
  public void render(){
    
    shape.render();
    shape.printText(soundPath[path].getName(),20,-20);
    debugInfo();
  }

  public void runAudio()
  {
      sound[path].pause(false);
      sound[path].setToLoopStart();  
      sound[path].start(); 
  }
  
  public boolean isTriggered(){
    if(this.soundPlay == 1) return true;
    return false;
  }
  
  private void debugInfo() {
    shape.printText("duration " + str(shape.xMax - shape.xMin) + ",",20, 0);
    shape.printText("Max Amplitude " + str((shape.yMax - shape.yMin)*0.01) + ",",20, 20);
    shape.printText("Current Amplitude " + str(shape.getValue()*0.01) + ",",20, 40);
  }
  
  private void loadAudio() 
  {
      try {
        gainV = new Glide(ac, 0);
        g = new Gain(ac, 2, gainV);
        g.addInput(sound[path]);
        ac.out.addInput(g);      
      }
      catch(Exception e) {
        e.printStackTrace();
        exit();
      }

  }
  
  public void play() {
    soundPlay += 1;
    gainV.setValue(shape.getValue()*0.01);
    //sound[path].pause(false);
  }
  public void end() {
    soundPlay = 0;
    gainV.setValue(0);
    //sound[path].pause(true);
  }
  
  public void getStatus(){
    println();
  }
  
  @Override
  public Object clone()throws CloneNotSupportedException{  
    return super.clone();  
  } 
}
