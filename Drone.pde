class Drone{
  PVector pos;
  PVector vel;
  PVector acc;
  PVector xPos;//for reset
  PVector gravity;
  int span;
  boolean rgt,lft;
  boolean best=false,supe = false;
  Confetti cn[];
  
  Drone(int x, int y){
    pos = new PVector(x,y,0);
    xPos = new PVector(x,y);
    vel = new PVector(0,0,0);
    acc = new PVector(0,0,0);
    gravity = new PVector(0,0.1);
    cn = new Confetti[2];
    for(int i =0;i<2;i++){
      cn[i] = new Confetti();
    }
    span = 50;
  }
  void show(){
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(radians(pos.z));
    if(supe){
      fill(#0CF7F1);
    }
    else if(best){
      fill(#CBC72F);
    }else{
      fill(0);
    }
    rect(-span,-5,span*2,10);
    circle(-span,-5,20);
    circle(span,-5,20);
    circle(0,0,20);
    fill(0,255,0);
    circle(0,0,10);
    popMatrix();
    float xf = span*getCos();
    float yf = span*getSin();
    cn[0].show(pos.x-xf,pos.y-5-yf,pos.z+90,lft);
    cn[1].show(pos.x+xf,pos.y-5+yf,pos.z+90,rgt);
    
  }
  void move(){
    
    acc.z = getTork();
    acc.y = getForce()*cos(radians(pos.z));
    acc.x = -getForce()*sin(radians(pos.z));
    acc.mult(0.1);
    acc.add(gravity);
    acc.limit(10);
    vel.add(acc);
    vel.limit(20);
    vel.mult(0.99);
    pos.add(vel);
  }
  void setLft(boolean b){
    lft = b;
  }
  void setRgt(boolean b){
    rgt = b;
  }
  int getTork(){
    return ((lft)?1:0)-((rgt)?1:0);
  }
  int getForce(){
    return -((lft)?1:0)-((rgt)?1:0);
  }
  void resetPos(){
    pos.set(xPos.x,xPos.y,0); 
    vel.set(0,0,0);
    acc.set(0,0,0);
  }
  float getCos(){
    return cos(radians(pos.z));
  }
  float getSin(){
    return sin(radians(pos.z));
  }
  
}
