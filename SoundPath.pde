public class SoundPath
{
  private String absolutePath;
  private String name;
  private int id;
  private color c;
  
  public SoundPath(String absolutePath,int id){
    this.absolutePath = absolutePath;
    this.id = id;
    if(absolutePath.contains("\\")){
      String[] list = split(absolutePath, '\\' ) ;
      this.name = list[list.length - 1] ;
    }else{
      String[] list = split(absolutePath, '/' ) ;
      this.name = list[list.length - 1] ;
    }
    this.c = color(random(0,255),random(0,255),random(0,255));
  }
  
  public color getColor(){
    return this.c;
  }
  
  public String getName(){
    return this.name;
  }
  
  public String getAbsolutePath(){
    return this.absolutePath;
  }
  
  public int getID(){
    return this.id;
  }
  
}
