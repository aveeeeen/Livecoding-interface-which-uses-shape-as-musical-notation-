//key interactions
int timeState = 0;
int state = 0;
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
  if (timeState > 1 && timeState < 6) {
    switch(key) {
    case'n':
      if (state == 0) {
        s.add(new SoundObject(ui.getShapeType(), ui.getSample()));
        state = 1;
        println(s, ui.getShapeType(), soundPath[ui.getSample()].getName());
      }

      if (state == 1) {
        for (SoundObject s_ : s) {
          s_.shape.setEdge(mouseX, mouseY);
        }
      }
      break;
    }
  }
  println(timeState);
}

void mouseReleased() {
  timeState = 0;
}

void keyReleased() {
  switch(key) {
  case 'n':
    if (state == 1) {
      for (SoundObject s_ : s) {
        s_.shape.state = 1;
        for (int i = 0; i < 15; i++) {
          println(s_.shape.getEdges(i));
        }
      }
      state = 0;
      timeState = 0;
    }
    break;
  }
}

//mouse interactions
void mousePressed() {
  if (keyPressed && key == 'n') timeState ++;
  //moving the shape (vector translate)
  for (int i = s.size() - 1; i>= 0; i-- ) {
    SoundObject s_ = s.get(i);
    if (s_.select == true) {
      s_.shape.translate(mouseX, mouseY);
    }
  }
}
