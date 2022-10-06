import java.util.Iterator;
class Confetti {
  ArrayList<Particle> particles;
  Confetti() {
    particles = new ArrayList<Particle>();
  }
    
  void show(float x,float y,float rot,boolean active){
    PVector gravity = new PVector(0,0.2);
    if(active){
      if(0.5<random(1)){
        particles.add(new Particle(x,y,rot));
      }
    }
    Iterator<Particle> particle = particles.iterator();
    
    while(particle.hasNext()){
      Particle partic = particle.next();
      if (partic.dead()){
        particle.remove();
      }
       partic.applyForce(gravity);
    
       partic.update();
       partic.show();
    }
  }
}
