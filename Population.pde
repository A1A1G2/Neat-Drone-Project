class Population {
  ArrayList<Player> pop = new ArrayList<Player>();
  Player bestPlayer;//the best ever player 
  int bestScore =0;//the score of the best ever player
  int gen;
  ArrayList<connectionHistory> innovationHistory = new ArrayList<connectionHistory>();
  ArrayList<Player> genPlayers = new ArrayList<Player>();
  ArrayList<Species> species = new ArrayList<Species>();

  boolean massExtinctionEvent = false;
  boolean newStage = false;
  int populationLife = 0;
  int exhglght=0;



  Population(int size,int x,int y) {

    for (int i =0; i<size; i++) {
      pop.add(new Player(x,y));
      pop.get(i).brain.generateNetwork();
      pop.get(i).brain.mutate(innovationHistory);
    }
  }

  void updateAlives() {
    populationLife ++;
    for (int i = pop.size()-1; i>=0; i--) {
      if (!pop.get(i).dead) {
        pop.get(i).update();
        pop.get(i).look();
        pop.get(i).think();
        if (!showNothing && !lookup) {
          pop.get(i).show();
        }
      }
    }
    if(lookup){
      pop.get(geni).show();
    }
  }
  
  boolean done() {
    for (int i = 0; i< pop.size(); i++) {
      if (!pop.get(i).dead) {
        return false;
      }
    }
    return true;
  }

  void setBestPlayer() {
    Player tempBest =  species.get(0).players.get(0);
    tempBest.gen = gen;


    if (tempBest.score > bestScore) {
      println("old best:", bestScore);
      println("new best:", tempBest.score);
      bestScore = tempBest.score;
      bestPlayer = tempBest;
    }
  }

  void naturalSelection() {
    speciate();
    calculateFitness();
    sortSpecies();
    if (massExtinctionEvent) { 
      massExtinction();
      massExtinctionEvent = false;
    }
    cullSpecies();
    setBestPlayer();
    killStaleSpecies();
    killBadSpecies();


    println("generation", gen, "Number of mutations", innovationHistory.size(), "species: " + species.size(), "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");


    float averageSum = getAvgFitnessSum();
    ArrayList<Player> children = new ArrayList<Player>();
    println("Species:");               
    for (int j = 0; j < species.size(); j++) {

      println("best unadjusted fitness:", species.get(j).bestFitness);
      for (int i = 0; i < species.get(j).players.size(); i++) {
        print("player " + i, "fitness: " +  species.get(j).players.get(i).fitness, "score " + species.get(j).players.get(i).score, ' ');
      }
      children.add(species.get(j).champ.clone());
      if(species.get(j).champ==bestPlayer){
        children.get(children.size()-1).drone.supe = true;
      }
      else{
        children.get(children.size()-1).drone.best = true;
      }

      int NoOfChildren = floor(species.get(j).averageFitness/averageSum * pop.size()) -1;
      for (int i = 0; i< NoOfChildren; i++) {
        children.add(species.get(j).giveMeBaby(innovationHistory));
      }
    }

    while (children.size() < pop.size()) {
      children.add(species.get(0).giveMeBaby(innovationHistory));
    }
    pop.clear();
    pop = (ArrayList)children.clone();
    gen+=1;
    for (int i = 0; i< pop.size(); i++) {
      pop.get(i).brain.generateNetwork();
    }
    
    populationLife = 0;
  }

  void speciate() {
    for (Species s : species) {
      s.players.clear();
    }
    for (int i = 0; i< pop.size(); i++) {
      boolean speciesFound = false;
      int j=0;
      while(j<species.size()&&!speciesFound){
        if (species.get(j).sameSpecies(pop.get(i).brain)) {
          species.get(j).addToSpecies(pop.get(i));
          speciesFound = true;
        }
        j++;
      }
      if (!speciesFound) {
        species.add(new Species(pop.get(i)));
      }
    }
  }

  void calculateFitness() {
    for (int i =1; i<pop.size(); i++) {
      pop.get(i).calculateFitness();
    }
  }
 
  void sortSpecies() {
    for (Species s : species) {
      s.sortSpecies();
    }
    ArrayList<Species> temp = new ArrayList<Species>();
    for (int i = 0; i < species.size(); i ++) {
      float max = 0;
      int maxIndex = 0;
      for (int j = 0; j< species.size(); j++) {
        if (species.get(j).bestFitness > max) {
          max = species.get(j).bestFitness;
          maxIndex = j;
        }
      }
      temp.add(species.get(maxIndex));
      species.remove(maxIndex);
      i--;
    }
    species = (ArrayList)temp.clone();
  }
  
  void killStaleSpecies() {
    for (int i = 2; i< species.size(); i++) {
      if (species.get(i).staleness >= 15) {
        species.remove(i);
        i--;
      }
    }
  }
  
  void killBadSpecies() {
    float averageSum = getAvgFitnessSum();

    for (int i = 1; i< species.size(); i++) {
      if (species.get(i).averageFitness/averageSum * pop.size() < 1) {
        species.remove(i);//sad
        i--;
      }
    }
  }
  
  float getAvgFitnessSum() {
    float averageSum = 0;
    for (Species s : species) {
      averageSum += s.averageFitness;
    }
    return averageSum;
  }

  
  void cullSpecies() {
    for (Species s : species) {
      s.cull(); 
      s.fitnessSharing();
      s.setAverage();
    }
  }


  void massExtinction() {
    for (int i =5; i< species.size(); i++) {
      species.remove(i);//sad
      i--;
    }
  }
  void highlight(){
    pop.get(exhglght).drone.supe = false;
    pop.get(geni).drone.supe = true;
    exhglght = geni;
  }
}
