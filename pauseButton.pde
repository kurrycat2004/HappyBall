class pauseButton {
  float x;
  float y;
  float w;
  float time = 0;
  float fade = 150;
  boolean againTime = false;
  PShape stopped,playing,again;
  pauseButton() {
    this.x = defaultSize*(70/50f);
    this.y = defaultSize*(70/50f);
    this.w = defaultSize*2;
  }
  void fillSet(){
    again = createShape(GROUP);
    for(float i =HALF_PI; i<TWO_PI;i+=0.1){
      PShape Inner = createShape(ELLIPSE, cos(i)*defaultSize*(3/5f)+defaultSize*(142/50f), sin(i)*defaultSize*(3/5f)-defaultSize/2f, defaultSize/5f, defaultSize/5f);
      Inner.setFill(theme==0 ? 200 : 60);
      Inner.setStroke(false);
      again.addChild(Inner);
    }
    again.setStroke(theme==0 ? 200 : 60);
    again.setFill(false);
    again.rotate(-HALF_PI);
    
    playing = createShape();
    playing.beginShape();
    playing.fill(theme==0 ? 200 : 55);
    playing.noStroke();
    playing.vertex(defaultSize*(2/5f), defaultSize*(15/50f));
    playing.vertex(defaultSize*(2/5f), w-defaultSize*(15/50f));
    playing.vertex(w/2-defaultSize/5f, w-defaultSize*(15/50f));
    playing.vertex(w/2-defaultSize/5f, defaultSize*(15/50f));
    playing.endShape(CLOSE);
    
    stopped = createShape();
    stopped.beginShape();
    stopped.fill(theme==0 ? 200 : 55);
    stopped.noStroke();
    stopped.vertex(defaultSize*(2/5f), defaultSize*(15/50f));
    stopped.vertex(defaultSize*(2/5f), w-defaultSize*(15/50f));
    stopped.vertex(w-defaultSize/5f, w/2);
    stopped.endShape(CLOSE);
    
  }
  void update() {
    fillSet();
    if (mousePressed) { 
      if (pause) {
        if(mouseX>x&&mouseX<x+w&&mouseY>y+w+30&&mouseY<y+2*w+30){
          againTime = true;
        } else{
          time = 1;
        }
      }
      if (mouseX>x&&mouseX<x+w&&
        mouseY>y&&mouseY<y+w&&time==0) {
        time = 1;
      }
    } else if (!mousePressed&&time==1) {
      pause = !pause;
      time = 0;
      Ball.vel.mult(0);
      Ball.velM.mult(0);
    } else if(!mousePressed&&againTime){
      againTime = false;
      start();
    }
  }
  void show() {
    stroke(theme==0 ? 255 : 60);
    fill(50, 150, 50);
    rect(x, y, w, w);
    if (pause) {
      rect(x,y+defaultSize*(130/50f),w,w);
      shape(stopped,x,y);
      shape(stopped, x+w/2-defaultSize*(15/50f), y+w+defaultSize*(30/50f), defaultSize*(4/5f), defaultSize*(4/5f));
      shape(again, x, y+w+defaultSize*(3/5f));
      textSize(defaultSize*(9/5f));
      fill(theme==0 ? 255 : 60, fade);
      text("Tippen um fortzusetzen", width/2, height/2);
      fade = f ? fade+3 : fade-3;
      if (fade>255||fade<150) {
        f = !f;
      }
    } else {
      shape(playing,x,y);
      shape(playing,x+w/2-defaultSize/5, y);
    }
  }
}
