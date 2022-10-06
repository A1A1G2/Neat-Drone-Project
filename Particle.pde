class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  int r;
  int lifetime;
  
  PVector randomAngle(float rot){
    PVector d = PVector.random2D();
    d.add(PVector.mult(PVector.fromAngle(radians(rot)),4));
    d.limit(1);
    return d;
  }
  Particle(float x,float y,float rot) {
    this.pos = new PVector(x,y);
    this.vel = new PVector(0,0);
    vel = randomAngle(rot);
    vel.mult(random(1,5));
    this.acc = new PVector(0,0);
    this.r = 4;
    this.lifetime = 50;
  }
  
  boolean dead(){
    return lifetime<0;
  }
  
  void applyForce(PVector a) {
    acc.add(a);
  }
  void update(){
    vel.add(acc);
    pos.add(vel);
    acc.set(0,0);
    lifetime -=5;
  }
  void show(){
    stroke(0,lifetime);
    strokeWeight(2);
    fill(0,lifetime);
    ellipse(pos.x,pos.y,r*2,r*2);
  }
}
