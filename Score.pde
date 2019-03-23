class bereich {
  float sizeY = height/9.6f;
  float sizeX = width-1;
  float y = height/2-sizeY/2;
  float x = 0;
  int score;
  int best = 0;
  int fPBest = 0;
  boolean up = true;
  boolean right = true;
  boolean dS=false;
  float countdown=0;
  float angle;
  float vorX;
  float vorY;
  float faktor = 1.01;
  float I = 2;
  color scoreCol= color(theme==0 ? 255 : 100);
 
  bereich() {
    setA();
    score = 0;
  }

  void update() {
    if (Ball.y+Ball.d/2 > y && Ball.y-Ball.d/2 < y+sizeY &&
      Ball.x+Ball.d/2 > x && Ball.x-Ball.d/2 < x+sizeX) {
      if(!start){
      score+=!dS ? floor(scorePerSek/60) : floor(scorePerSek/60)*2;
      countdown-=dS ? 1 : 0;
      if(countdown==0){
        dS = false;
      }
      }
      I = floor(2*scorePerSek/60);
      Ball.col = !dS ? color(50, 255, 50) : color(255, 255, 75);
    } else if (score>I*faktor) {
      I *= faktor;
      score -= I;
      Ball.col = color(255, 50, 50);
    } else {
      score = 0;
      Ball.col = color(255, 50, 50);
    }

    if (score > scorePerSek*2 && score < scorePerSek *10) {
      scrollY(floor((score/scorePerSek*50)/100));
      for(int i=0; i<Hole.size();i++){
        Hole.get(i).fadeOut();
      }
    } else if (score > scorePerSek *10 && score < scorePerSek *15) {
      if (sizeX>width/4) {
        changeSizeX(-1);
      }
      for(int i=0; i<Hole.size();i++){
        Hole.get(i).fadeOut();
      }
      scrollX(floor((score/scorePerSek*30)/100));
    } else if (score > scorePerSek * 15 && score < scorePerSek * 25) {
      scrollX(floor(cos(angle)*vorX*4));
      scrollY(floor(sin(angle)*vorY*4));
      for(int i=0; i<Hole.size();i++){
        Hole.get(i).fadeOut();
      }
    } else if (score > scorePerSek * 25 && score < scorePerSek*35) {
      //      if(Ball.grav>0){
      //        Ball.grav = -Ball.grav;
      //      }
      for(int i=0; i<Hole.size();i++){
        Hole.get(i).fadeOut();
      }
      scrollX(floor(cos(angle)*vorX*5));
      scrollY(floor(sin(angle)*vorY*5));
    } else if(score>scorePerSek*35){
      int j = constrain(floor((score-scorePerSek*35)/(scorePerSek * 5)), 0, 5);

      for(int i = j-holes; i>0; i--){
        addHole();
      }
      showHole = true;
      for(int i=0; i<Hole.size();i++){
        Hole.get(i).fadeIn();
      }
      scrollX(floor(cos(angle)*vorX*5));
      scrollY(floor(sin(angle)*vorY*5));
    }
    if (score == 0 && score < best-scorePerSek/3 && !freePlay) {
      start();
    }
    if (score > scorePerSek *10) {
      if (sizeX>width/4f) {
        changeSizeX(-1);
      }
    }
  }

  void show() {
    noStroke();
    fill(theme==0 ? 255 : 60, 20);
    rect(x, y, sizeX, sizeY);

    textSize(3*defaultSize);
    scoreCol=score>( freePlay ? fPBest : best )? color(theme==0 ? 200 : 60, theme==0 ? 255 : 115, theme==60 ? 200 : 60) : color(theme==0 ? 255 : 60);
    if(freePlay){
      fPBest = max(score, fPBest);
    } else{
      best = max(score, best);
    }
    fill(scoreCol);
    text(nfall(score, 0), width/2, defaultSize*4);
    textSize(defaultSize);
    fill(theme==0 ? 255 : 60, 150);
    //float w = textWidth("Highscore: " + str(best))/2;
    text("Highscore: " + (freePlay ? nfall(fPBest, 0) : nfall(best, 0)), width/2, defaultSize*1.5f);
  }

  void scrollY(int step) {
    y = (up) ? y-abs(step) : y+abs(step);
    if (y<defaultSize*4) {
      up = false;
      setA();
    } else if (y+sizeY>height) {
      up = true;
      setA();
    }
  }

  void scrollX(int step) {
    x = (right) ? x+abs(step) : x-abs(step);
    if (x<0) {
      right = true;
      setA();
    } else if (x+sizeX>width) {
      right = false;
      setA();
    }
  }

  void setSizeY(float s) {
    sizeY = s;
    y = height/2-s/2;
  }

  void changeSizeY(float s) {
    sizeY+=s;
    y = height/2-sizeY/2;
  }

  void setSizeX(float s) {
    sizeX = s;
    x = width/2-s/2;
  }

  void changeSizeX(float s) {
    sizeX+=s;
    x -= s/2;
  }

  void setA() {
    vorX = random(1)<0.5 ? 1 : -1;
    vorY = random(1)<0.5 ? 1 : -1;
    angle = random(TWO_PI);
  }
}
