class UI{
  ControlP5 cp5;
  Button b1,b2;
  DropdownList d1,d2;
  
  List l;
  
  int x = 200;
  
  public UI(PApplet thePApplet)
  {
    cp5 = new ControlP5(thePApplet);
   
    // dropdown ui element for choosing samples
    
    d1 = cp5.addDropdownList("Choose Sample")
     .setPosition(x*0, 0)
     .setSize(200, 100)
     .setBarHeight(20)
     .setItemHeight(20)
    ;
    
    if(dir == null){
      d1.addItem(null,1);
    }else{
      for(int i = 0; i < sourceFile.length; i++){
        d1.addItem(soundPath[i].getName() ,i);
      }
    }
    
    // dropdown ui element for choosing shape type
    l = Arrays.asList("vect","rect","tri");
    d2 = cp5.addDropdownList("Choose Shape Type")
     .setPosition(x*1, 0)
     .setSize(200, 100)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItem("vect", 0)
     .addItem("rect", 1)
     .addItem("tri", 2)
    ;
    
    b1 = cp5.addButton("clearCanvas")
     .setValue(1)
     .setPosition(width - (x),0)
     .setSize(200,20)
    ;
    
    /*
    b2 = b1 = cp5.addButton("loadFiles")
     .setValue(1)
     .setPosition(x*0,0)
     .setSize(200,20)
    ;
    */
    
  }
  
  public void loadFiles(){
    if(b2.isPressed()){
      selectFolder("Select a folder to process:", "folderSelected");
    }
  }
  
  public void clearCanvas() {
    if(b1.isPressed()){
      for(SoundObject s_ : s){
        s_.end();
      }
      s.removeAll(s);
    }
  }
  
  public void setSample(int i){
    d1.setValue(d1.getValue()+i);
    println(d1.getValue());
  }
  
  public void setShape(int i){
    d2.setValue(d2.getValue()+i);
    println(d2.getValue());
  }
  
  public int getSample(){
      return (int)d1.getValue();
  }
  
  public String getShapeType(){
      int id = (int)d2.getValue();
      if(id == 0){
        return "vect";
      }else if(id == 1){
        return "rect";
      }else if(id == 2){
        return "tri";
      }else{
        return "vect";
      }
  }
}
