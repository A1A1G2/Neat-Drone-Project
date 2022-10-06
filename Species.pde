class Species {
  ArrayList<Player> players = new ArrayList<Player>();
  float bestFitness = 0;
  Player champ;
  float averageFitness = 0;
  int staleness = 0;//how many generations the species has gone without an improvement
  Genome rep;

  
  float excessCoeff = 1;
  float weightDiffCoeff = 0.5;
  float compatibilityThreshold = 3;

  Species() {
  }


  
  Species(Player p) {
    players.add(p); 
    
    bestFitness = p.fitness; 
    rep = p.brain.clone();
    champ = p.clone();
  }

  boolean sameSpecies(Genome g) {
    float compatibility;
    float excessAndDisjoint = getExcessDisjoint(g, rep);
    float averageWeightDiff = averageWeightDiff(g, rep);


    float largeGenomeNormaliser = g.gens.size() - 20;
    if (largeGenomeNormaliser<1) {
      largeGenomeNormaliser =1;
    }

    compatibility =  (excessCoeff* excessAndDisjoint/largeGenomeNormaliser) + (weightDiffCoeff* averageWeightDiff);
    return (compatibilityThreshold > compatibility);
  }

  void addToSpecies(Player p) {
    players.add(p);
  }

  float getExcessDisjoint(Genome brain1, Genome brain2) {
    float matching = 0.0;
    for (int i =0; i <brain1.gens.size(); i++) {
      for (int j = 0; j < brain2.gens.size(); j++) {
        if (brain1.gens.get(i).innovationNo == brain2.gens.get(j).innovationNo) {
          matching ++;
          break;
        }
      }
    }
    return (brain1.gens.size() + brain2.gens.size() - 2*(matching));
  }
  
  float averageWeightDiff(Genome brain1, Genome brain2) {
    if (brain1.gens.size() == 0 || brain2.gens.size() ==0) {
      return 0;
    }


    float matching = 0;
    float totalDiff= 0;
    for (int i =0; i <brain1.gens.size(); i++) {
      for (int j = 0; j < brain2.gens.size(); j++) {
        if (brain1.gens.get(i).innovationNo == brain2.gens.get(j).innovationNo) {
          matching ++;
          totalDiff += abs(brain1.gens.get(i).weight - brain2.gens.get(j).weight);
          break;
        }
      }
    }
    if (matching ==0) {
      return 100;
    }
    return totalDiff/matching;
  }
  
  void sortSpecies() {

    ArrayList<Player> temp = new ArrayList<Player>();

    
    for (int i = 0; i < players.size(); i ++) {
      float max = 0;
      int maxIndex = 0;
      for (int j = 0; j< players.size(); j++) {
        if (players.get(j).fitness > max) {
          max = players.get(j).fitness;
          maxIndex = j;
        }
      }
      temp.add(players.get(maxIndex));
      players.remove(maxIndex);
      i--;
    }

    players = (ArrayList)temp.clone();
    if (players.size() == 0) {
      print("BP_ONK!!"); 
      staleness = 200;
      return;
    }
    
    if (players.get(0).fitness > bestFitness) {
      staleness = 0;
      bestFitness = players.get(0).fitness;
      rep = players.get(0).brain.clone();
      champ = players.get(0).clone();
    } else {
      staleness ++;
    }
  }

  void setAverage() {

    float sum = 0;
    for (int i = 0; i < players.size(); i ++) {
      sum += players.get(i).fitness;
    }
    averageFitness = sum/players.size();
  }
  
  Player giveMeBaby(ArrayList<connectionHistory> innovationHistory) {
    Player baby;
    if (random(1) < 0.25) {
      baby =  selectPlayer().clone();
    } else {

      Player parent1 = selectPlayer();
      Player parent2 = selectPlayer();

      if (parent1.fitness < parent2.fitness) {
        baby =  parent2.crossover(parent1);
      } else {
        baby =  parent1.crossover(parent2);
      }
    } //<>//
    baby.brain.mutate(innovationHistory);
    return baby;
  }

  Player selectPlayer() {
    float fitnessSum = 0;
    for (int i =0; i<players.size(); i++) {
      fitnessSum += players.get(i).fitness;
    }

    float rand = random(fitnessSum);
    float runningSum = 0;

    for (int i = 0; i<players.size(); i++) {
      runningSum += players.get(i).fitness; 
      if (runningSum > rand) {
        return players.get(i);
      }
    }
    return players.get(0);
  }
  void cull() {
    if (players.size() > 2) {
      for (int i = players.size()/2; i<players.size(); i++) {
        players.remove(i); 
        i--;
      }
    }
  }
  void fitnessSharing() {
    for (int i = 0; i< players.size(); i++) {
      players.get(i).fitness/=players.size();
    }
  }
}
