class shop {
  float x, y;
  int clicked = -1;
  float mon_cost;
  float scor_cost;
  int goFurther = -1;
  
  int monUps = 0;
  int scorUps = 0;
  
  shop(float x1, float y1) {
    x = x1;
    y = y1;
  }

  void mon() {
    if (Money.m - mon_cost > 0) {
      monUps++;
      Money.m -= mon_cost;
      mon_cost *= 1.5;
      foodPoints *= 1.3;
    }
  }
  void scor(){
    if(Money.m - scor_cost>0){
      scorUps++;
      Money.m-=scor_cost;
      scor_cost *=1.5;
      scorePerSek *= 1.3;
    }
  }
  void show() {
    mon_cost = 10*pow(1.5, monUps);
    scor_cost = 120*pow(1.5, scorUps);
    stroke(theme==0 ? 255 : 60);
    fill(50,150,50);
    for (int i =0; i<upgrades; i++) {
      rect(x+(width/upgrades*i), y, width/upgrades-1, height-x);
    }
    
    String p = nfall(mon_cost,2) + "$";
    String t = "$/Ball";
    String c = "x" + str(monUps);
    for(int i = 0; i<2;i++){
      fill(theme==0 ? 255 : 60);
      textSize(defaultSize);
      textAlign(CENTER, CENTER);
      float xpos = width/upgrades*i;
      float x2pos = width/upgrades*(i+1);
      text(t, (xpos+x2pos)/2, y+defaultSize*3);
      textSize(defaultSize*(4/5f));
      text(p, (xpos+x2pos)/2, y+defaultSize*(23/5f));
      textSize(defaultSize*(30/50f));
      text(c, (xpos+x2pos)/2, y+defaultSize);
      switch(i){
        case 0: t = "Score/Sek";
                p = nfall(scor_cost,2) + "$";
                c = "x" + str(scorUps);
      }
    }
  }

  void update() {
    for (int i =0; i<upgrades; i++) {
      if (goFurther>0) {
        goFurther--;
        break;
      }
      if (mousePressed) {
        if (mouseX>width/upgrades*i&&mouseX<width/upgrades*(i+1)
          && mouseY>y) {
          clicked = i;
          break;
        }
      }
    }
    switch(clicked){
      case 0: mon(); res();
      case 1: scor(); res();
    }
  }
  void res(){
    clicked = -1;
    if (goFurther == -1) {
      goFurther = 25;
    }
  }
}
