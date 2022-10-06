Drone drn;
ArrayList<Target> targets;
Population pop;

int nextConnectionNo = 1000;
boolean showNothing = false;
boolean lookup = false;

int geni = 0;

void setup(){
  fullScreen();
  targets = new ArrayList <Target>();
  targets.add(new Target(700,300));
  targets.add(new Target(900,200));
  targets.add(new Target(500,400));
  targets.add(new Target(550,550));
  pop = new Population(1000,width/2,height*3/4);
  setTargetActive(0);
}
void draw(){
  drawToScreen();
  if (!pop.done()) {
      pop.updateAlives();
      for(int i =0;i<targets.size();i++){
        targets.get(i).show();
      }
    } else {
      pop.naturalSelection();
      setTargetActive(0);
    }
}
void drawToScreen() {
  if (!showNothing) {
    background(250); 
    stroke(0);
    strokeWeight(2);
    drawBrain();
    writeInfo();
  }
}
void drawBrain() {
  int startX = 600;
  int startY = 10;
  int w = 600;
  int h = 400;
  if(pop.pop.size()<=geni){geni=0;}
  if (!pop.pop.get(geni).dead) {
    pop.pop.get(geni).brain.drawGenome(startX, startY, w, h);
  }
}
void writeInfo() {
  fill(200);
  textAlign(LEFT);
  textSize(40);
  //target x y
    //velocity x y
    // cos sin angle
    // angular velocity
    //output 3 r l
  text("Player " + geni, 30, height - 30);
  //text(, width/2-180, height-30);
  textAlign(RIGHT);

  text("Gen: " + (pop.gen +1), width -40, height-30);
  textSize(20);
  int x = 580;
  text("Target x", x, 18+44.44444);
  text("Target y", x, 18+2*44.44444);
  text("Velocity x", x, 18+3*44.44444);
  text("velocity y", x, 18+4*44.44444);
  text("cos", x, 18+5*44.44444);
  text("sin", x, 18+6*44.44444);
  text("angular velocity", x, 18+7*44.44444);
  text("Bias", x, 18+8*44.44444);

  textAlign(LEFT);
  text("R", 1220, 118);
  text("L", 1220, 218);
  text("S", 1220, 318);
}

void keyPressed(){//37 39
  if(keyCode == 37){
    if(geni>0)
      geni--;
    pop.highlight();
  }
  if(keyCode == 39){
    if(geni<pop.pop.size()-1)
      geni++;
      pop.highlight();
  }
  if(keyCode == 38){
    drn.setRgt(true);
    drn.setLft(true);
  }
  if(keyCode == 8){
    //drn.resetPos();
    showNothing = showNothing? false:true;
  }
  if(keyCode == 32){
    //drn.resetPos();
    lookup = lookup? false:true;
    pop.highlight();
  }
}
/*void keyReleased(){
  if(keyCode == 37){
    drn.setLft(false);
    
  }
  if(keyCode == 39){
    drn.setRgt(false);
    
  }
  if(keyCode == 38){
    drn.setRgt(false);
    drn.setLft(false);
  }
}*/
void setTargetActive(int m){
  for(int i = 0;i<targets.size();i++){
    targets.get(i).active = false;
  }
  targets.get(m).active = true;
}
