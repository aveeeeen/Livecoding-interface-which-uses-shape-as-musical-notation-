import controlP5.*;
import beads.*;
import java.util.*;
import java.io.File;
//import ddf.minim.*;
//import ddr.minim.ugens.*;

final float TARGET_FPS = 120.0f; // 目標フレームレート
final float FRAME_TIME = 1000.0f / TARGET_FPS; // 1フレームの許容処理時間
final float TARGET_FPS2 = 30.0f; // 目標フレームレート
final float FRAME_TIME2 = 1000.0f / TARGET_FPS; // 1フレームの許容処理時間
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

//java.io.file for listing file array length in side a directory
String[] sourceFile;
SoundPath[] soundPath;
String tempPath;
int fileSelected = 0;
File dir;
File[] list;

//ui
UI ui;

int setupState = 0;
int folderSelectState = 0;

void setup()
{
  size(1280, 720);
  pointA = new PVector(0,0);
  pointB = new PVector(0,height);
  // creating an empty arraylist for SoundShape class (creating a space to contain an object instance)
  s = new ArrayList<SoundObject>();
  //shape = new ArrayList<Shape>();
  //initial shape 
  //setSamplePaths(sketchPath("") + "samples/");
  selectFolder("Select a folder to process:", "folderSelected");
  //UI
  ui = new UI(this);
} 

void draw()
{
  background(255);
  fill(0);
  ui.loadFiles();
  println(ui.pressState);
  
  switch(setupState){
    // state where the sample path isn't fetched yet
    case 0:{
        
        fill(0);
        text("please load sample first",width/2-400,height/2);
        textSize(50); 
        if(fileSelected == 1) setupState = 1;
      }
      break;
    // initializing sound library and linking sample path to all elements
    case 1:{
        setSamplePaths(tempPath);
        loadBeads();  
        ui.updateSampleItems();
        setupState = 2;
      }
      break;
    // draw loop
    case 2:{
        text(s.size(),800,20);
        textSize(18);
        beatGrid(16);
        //println(looper(240));
        int curTime = millis();
        elapsedTime += curTime - lastUpdateTime;
        lastUpdateTime = curTime;
        //lineloop
        {
        stroke(80);
        beginShape(LINES);
          vertex(pointA.x, pointA.y);
          vertex(pointB.x, pointB.y);
        endShape();
        }
        for (SoundObject s_ : s){
          s_.render();
        }
        
        for( ; elapsedTime >= FRAME_TIME; elapsedTime -= FRAME_TIME) {
          fastUpdate();
        }
        
        for( ; elapsedTime >= FRAME_TIME2; elapsedTime -= FRAME_TIME2) {
          slowUpdate();
        }
      }
      break;
  } 
}

public void setSamplePaths(String path){
  
    int numSamples = 0;
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
    ac = new AudioContext(512*8);
    //io = new IOAudioFormat(44100.0,16,2,0) ;
    
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

void folderSelected(File selection) {
  
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    fileSelected = 2;
  } else {
    tempPath = selection.getAbsolutePath();
    fileSelected = 1;
  }
}

// another update function for optimizing performance
void fastUpdate(){
  lineLoop(120);
  for (SoundObject s_ : s){
    s_.update();
  }
}

void slowUpdate(){
  makeShape();
  ui.clearCanvas();
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
  return width/TARGET_FPS/x/4;
}
