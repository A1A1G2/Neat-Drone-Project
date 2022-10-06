class Player{
  float fitness;
  Genome brain;

  float unadjustedFitness;
  int lifespan = 0;
  int bestScore =0;
  boolean dead=false;
  boolean reached=false;
  int score=0;
  int rsc=0;
  int gen = 0;

  int start_time;
  float start_distance;

  int genomeInputs = 7;
  int genomeOutputs = 3;

  float[] vision = new float[genomeInputs];
  float[] decision = new float[genomeOutputs];
  
  int ti = 0;
  
  Drone drone;
  int sX,sY;
  
  int time=0;
  
  Player(int x,int y){
    brain = new Genome(genomeInputs, genomeOutputs);
    sX = x;
    sY = y;
    drone = new Drone(x,y);
    start_time = 0;
    start_distance = abs(targets.get(ti).pos.dist(drone.pos));
  }
  void show(){
    drone.show();
  }
  void move(){
    drone.move();
    if(currDistance()<20){
      reached = true;
      println("reached");
    }
  }
  void update(){
    time++;
    int t = (time-start_time)/100;
    move();
    if(reached){
      rsc++;
      if(rsc>10){//for get point you need to wait on it
        ti++;
        if(ti>targets.size()-1){// add new target if needed
          targets.add(new Target((int)random(width),(int)random(height))); //<>//
        }
        targets.get(ti).active = true;
        start_distance = abs(targets.get(ti).pos.dist(drone.pos));
        score += 500-t*t*t;
        start_time=time;
      }
      reached = false;
    }else if(t>5){
      score+=(int) (375*(sigmoid(currDistance()/start_distance)));
      dead=true;
      start_time=time;
    }
  }
  void look(){
    //target x y
    //velocity x y
    // cos sin angle
    // angular velocity
    //output 2 r l
    vision[0] = targets.get(ti).pos.x-drone.pos.x; 
    vision[1] = targets.get(ti).pos.y-drone.pos.y;
    vision[2] = drone.vel.x;
    vision[3] = drone.vel.y;
    vision[4] = drone.getSin();
    vision[5] = drone.getCos();
    vision[6] = drone.vel.z;
  }
  void think(){
    float max=0;
    int maxIndex=0;
    decision = brain.feedForward(vision);
    for(int i=0;i<decision.length;i++){
      if(max<decision[i]){
        max = decision[i];
        maxIndex = i;
      }
    }
    if(max>0.8){
      switch(maxIndex){
      case 0:
        drone.setLft(true);
        drone.setRgt(false);
        break;
      case 1:
        drone.setLft(false);
        drone.setRgt(true);
        break;
      case 2:
        drone.setLft(true);
        drone.setRgt(true);
        break;
      }
    }else{
      drone.setLft(false);
      drone.setRgt(false);
    }
  }
  Player clone() {
    Player clone = new Player(sX,sY);
    clone.brain = brain.clone();
    clone.fitness = fitness;
    clone.brain.generateNetwork(); 
    clone.gen = gen;
    clone.bestScore = score;
    return clone;
  }
  void calculateFitness() {
    fitness = score*score;
  }
  Player crossover(Player parent2) {
    Player child = new Player(sX,sY);
    child.brain = brain.crossover(parent2.brain);
    child.brain.generateNetwork();
    return child;
  }
  float currDistance(){
    return abs(targets.get(ti).pos.dist(drone.pos));
  }
  float sigmoid(float x) {
    float y = 1 / (1 + pow((float)Math.E, 5*x));
    return y;
  }
}
