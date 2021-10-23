//key interactions
int state,keystate = 0;
boolean mouseReleased;
SoundObject temp;



void keyPressed() {  


  for (int i = s.size() - 1; i>= 0; i--) {
    SoundObject s_ = s.get(i);
    PVector guiPoint = new PVector(s_.shape.xMin, s_.shape.yMin);
    PVector mousePoint = new PVector(mouseX, mouseY);
    if (s_.shape.r > mousePoint.dist(guiPoint)) {
      switch(key) {
      case 's':
        if (s_.select == false) {
          s_.select = true;
        } else if (s_.select == true) {
          s_.select = false;
        }
        break;
      case 'd':
        s_.end();
        s.remove(i);
        break;
      case 'h':
        println(s_, s_.select, s_.soundPlay, s_.path);
        break;
      case 'c':
        temp = s_;
        break;
    }
    }
  }
  
  /*
  switch(key){
      case'a':
        ui.setShape(-1);
        break;
      case'w':
        ui.setSample(1);
        break;
      case's':
        ui.setSample(-1);
        break;
      case'd':
        ui.setShape(1);
        break;   
    }
  */
  switch(key){
    case 'n':
    keystate = 1;
    break;
  }
}

void mouseReleased() {
  mouseReleased = true;
}

void keyReleased() {
  switch(key) {
  case 'n':
    keystate = 0;
    break;
  }
}

//mouse interactions
void mousePressed() {
  //moving the shape (vector translate)
  for (int i = s.size() - 1; i>= 0; i-- ) {
    SoundObject s_ = s.get(i);
    if (s_.select == true) {
      s_.shape.translate(mouseX, mouseY);
    }
  }
}

void makeShape(){
  switch(state){
      
      //create new instatnce state
      case 0:
        if(keystate == 1 && mouseReleased){
          s.add(new SoundObject(ui.getShapeType(), ui.getSample()));
          for (SoundObject s_ : s) {
            s_.shape.setEdge(mouseX, mouseY);
          }
          state = 1;
          println(s, ui.getShapeType(), soundPath[ui.getSample()].getName());
        }
        break;
      //drawing state
      case 1:
        if(keystate == 1 && mouseReleased){
          for (SoundObject s_ : s) {
            s_.shape.setEdge(mouseX, mouseY);
          }
        }
        if(keystate == 0) state = 2;
        break;
      // finish drawing state
      case 2:
        for (SoundObject s_ : s) {
          s_.shape.state = 1;
          for (int i = 0; i < 15; i++) {
            println(s_.shape.getEdges(i));
          }
          state = 0;
        }
        break;
    }
 mouseReleased = false;   
}
