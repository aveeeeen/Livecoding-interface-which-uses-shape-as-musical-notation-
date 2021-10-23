import controlP5.*;
import beads.*;
import java.util.*;
import java.io.File;
//import ddf.minim.*;
//import ddr.minim.ugens.*;

final float TARGET_FPS = 120.0f; // 目標フレームレート
final float FRAME_TIME = 1000.0f / TARGET_FPS; // 1フレームの許容処理時間
int lastUpdateTime = 0; // 前回の更新時刻
float elapsedTime = 0.0f;   // 前フレームからの経過時間

int msec,msec2;
float a = 0;
int i = 0;
ArrayList<SoundObject> s;
PVector pointA,pointB;
//Sound library class declaration
AudioContext ac;
SamplePlayer[] sound;
Gain[] g;
IOAudioFormat io;
/*
Glide[] gainV;
*/
int numSamples;
int soundLoad;
String[] sourceFile;
SoundPath[] soundPath;
//java.io.file for listing file array length in side a directory
String tempPath;
File dir;
File[] list;

//ui
UI ui;

void setup()
{
  size(1280, 720);
  pointA = new PVector(0,0);
  pointB = new PVector(0,height);
  // creating an empty arraylist for SoundShape class (creating a space to contain an object instance)
  s = new ArrayList<SoundObject>();
  //shape = new ArrayList<Shape>();
  //initial shape 
  setSamplePaths(sketchPath("") + "samples/");
  loadBeads();  
  ui = new UI(this);
  
  //UI
  
  
} 

public void setSamplePaths(String path){
   // getting a list of folder "samples"
    dir = new File(path);
    list = dir.listFiles();
    
    //getting sample that has a .wav extention then counting to numSamples
    for(int i = 0; i < list.length; i++){
      if(list[i].isFile() && list[i].getName().endsWith(".wav") && !list[i].getName().startsWith(".")) numSamples++;
    }
    
    //filtering path that only have .wav extentions then storing to sourceFile[]
    sourceFile = new String[numSamples];
    
    
    int count = 0;
    for(int i = 0; i < list.length; i++){
      if(list[i].isFile() && list[i].getName().endsWith(".wav") && !list[i].getName().startsWith(".")){
        sourceFile[count] = list[i].getAbsolutePath();
        count++;
      }
    }
    
    soundPath = new SoundPath[numSamples];
    for(int i = 0; i < numSamples; i++){
      soundPath[i] = new SoundPath(sourceFile[i],i);
      println(soundPath[i].getName(),soundPath[i].getID(),soundPath[i].getAbsolutePath());
    }
}

public void loadBeads(){
  if(dir != null){
    ac = new AudioContext(1024);
    io = new IOAudioFormat(44100.0,16,2,0) ;
    
      sound = new SamplePlayer[soundPath.length];
      if(sourceFile != null){
        for(int i = 0; i < soundPath.length; i++){
            try{
              sound[i] = new SamplePlayer(ac, SampleManager.sample(soundPath[i].getAbsolutePath()));
              sound[i].setKillOnEnd(false);
            }catch(Exception e){
              e.printStackTrace();
              println("sample loading error");
              exit();
            }
        }
      }else{
        println("There are no samples");
      }
      
    ac.start();
  }
}

void draw()
{
  background(255);
  
  fill(0);
  text(s.size(),800,20);
  
  beatGrid(16);
  //println(looper(240));
  int curTime = millis();
  elapsedTime += curTime - lastUpdateTime;
  lastUpdateTime = curTime;
  for( ; elapsedTime >= FRAME_TIME; elapsedTime -= FRAME_TIME) {
    update();
  }
  for (SoundObject s_ : s){
    s_.shapeManipulation();
  }
  
  
  
}

void folderSelected(File selection) {
  
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    tempPath = selection.getAbsolutePath();
    ac.reset();
    setSamplePaths(tempPath);
    loadBeads();  
  }
}

// another update function for optimizing performance
void update(){
  ui.clearCanvas();
  makeShape();
  lineLoop(132);
  mousePressed();
  //keyPressed();
  
  for (SoundObject s_ : s){
    s_.shape.hit(pointA);
    s_.shape.XYMinMax();
    s_.shape.distance(pointA,pointB);
    s_.gainV.setValue(s_.shape.getValue()*0.01);
    if (s_.shape.getIsHit()) {
      if(s_.shape.i > 1){
        s_.play();
        if(s_.isPlaying()) s_.runAudio();
      }
      //println(s_.shape.getValue());
    } else {
      s_.end();
    }

  }
  
  
}

void beatGrid(int coll)
{
  for (int j = 0; j < coll; j++) {
    int x = width/coll * j;

    if (j % 4 == 0) { 
      stroke(0, 255, 0);
    } else {
      stroke(0);
    }
    strokeWeight(2.5);
    line(x, 0, x, height);
  }
}

void lineLoop(int bpm) {
  stroke(80);
  beginShape(LINES);
  vertex(pointA.x, pointA.y);
  vertex(pointB.x, pointB.y);
  endShape();
  
  a += looper(bpm);
  //a = 210;
  
  pointA.set(a,0);
  pointB.set(a,height);

  if (a > width) a = 0;
}


float looper(float bpm) {
  
  float x = 0;
  float y = bpm;
  x = (float)(60/y);
  /*
  60 bpm = 60 beats per min = 1beat per sec = 4sec to interval for 4 beat
  240 sec to interval 4 beat
  x axis is 800 px. when 240bpm line intervals the canvas in a second
  800/60(f_rate) = 
  */
  return width/60/x/8;
}
