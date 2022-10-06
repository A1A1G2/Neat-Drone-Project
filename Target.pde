class Target{
  PVector pos;
  PVector vel;
  boolean active= false;
  Target(int x,int y){
    pos = new PVector(x,y);
  }
  void show(){
    if(active){
      noStroke();
      fill(0,125,125);
      circle(pos.x,pos.y,20);
    }
  }
  void setPos(int x,int y){
    pos.set(x,y);
  }
}
