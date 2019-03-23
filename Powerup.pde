class powerup{
  float cp = 3;
  
  void trigger(){
    int p = floor(random(cp));
    switch(p){
      case 0: money(); break;
      case 1: big(); break;
      case 2: doubleScore(); break;
    }
  }
  
  void money(){
    if(!freePlay){
      Money.addMany(random(foodPoints*50, foodPoints*150));
    }
  }
  
  void big(){
    if(Ball.d<defaultSize*2.5){
      Ball.d = Ball.d*1.2;
    }
  }
  void doubleScore(){
    Bereich.dS = true;
    Bereich.countdown = 250;
  }
}