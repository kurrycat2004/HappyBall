class settings {
  float x;
  float y;
  float w;
  boolean time = false;
  boolean cl = false;
  float settsX, settsY, settsW, settsH;
  float options = 4;
  PShape setts;
  boolean set = true;
  int choice = -1;
  settings() {
    this.x = defaultSize*(70/50f);
    this.y = defaultSize*(70/50f);
    this.w = defaultSize*2;
    this.settsW = defaultSize*12;
    this.settsH = defaultSize*19;
    this.settsX = (displayWidth-settsW)/2;
    this.settsY = (displayHeight-settsH)/2;
  }
  void settsFill() {
    setts = createShape(GROUP);
    PShape Outer = createShape(GROUP);
    //ArrayList<PShape> rects = new ArrayList<PShape>();
    for (float i=0; i<6; i++) {
      PShape rects = createShape(RECT, -w/14, -w/2.8, w/7, w/7);
      rects.setStroke(false);
      rects.setFill(theme==0 ? 200 : 55);
      rects.translate(-w/5, -w/5);
      rects.rotate(TWO_PI/6*(i));
      Outer.addChild(rects);
    }
    PShape Inner = createShape(ELLIPSE, (w-w/2.5)/2, (w-w/2.5)/2, w/2.5, w/2.5);
    Inner.setFill(false);
    Inner.setStroke(theme==0 ? 200 : 55);
    Inner.setStrokeWeight(9);
    setts.addChild(Outer);
    setts.addChild(Inner);
  }
  void update() {
    if (!pause&&start) {
      if (mousePressed) {
        time = (sett||(mouseX>x&&mouseX<x+w&&
          mouseY>y&&mouseY<y+w&&!time))&&!pause&&start ? true : time;
      } else if (time && 
        (
        (
        !(mouseX > Settings.settsX && mouseX < Settings.settsX + Settings.settsW) ||
        !(mouseY > Settings.settsY && mouseY < Settings.settsY + Settings.settsH)
        ))
        ) {
        sett = true;
        time = false;
      }
      if (sett) {
        updateSettings();
      }
    }
  }
  void show() {
    if (!pause&&start) {
      stroke(theme==0 ? 255 : 60);
      fill(50, 150, 50);
      rect(x, y, w, w);
      if (sett) {
        pushMatrix();
        translate(x, y);
        settsFill();
        shape(setts);
        popMatrix();
        showSettings();
      } else {
        pushMatrix();
        translate(x, y);
        settsFill();
        shape(setts);
        popMatrix();
      }
    }
  }
  void showSettings() {
    fill(50, 150, 50);
    rect(settsX, settsY, settsW, settsH);
    String txt = "";
    for (int i=0; i<options; i++) {
      fill(50, 150, 50);
      rect(settsX+defaultSize, settsY+defaultSize+(settsH-defaultSize*5)/options*i, settsW-defaultSize*2, (settsH-defaultSize*5)/options);
      switch(i) {
      case 0: 
        txt = "Thema: " + (theme==0 ? "Dark" : "Bright"); 
        break;
      case 1: 
        txt = "Vibration: " + (vibration ? "An" : "Aus"); 
        break;
      case 2: 
        txt = "FreePlay: " + (freePlay ? "An" : "Aus"); 
        break;
      case 3:
        txt = "Daten resetten";
        break;
      }
      fill(theme==0 ? 200 : 60);
      textSize(defaultSize*(60/50f));
      text(txt, settsX+settsW/2, settsY+defaultSize+(settsH-defaultSize*5)/options*(i+0.5));
      txt = "";
    }
    fill(50, 150, 50);
    rect(settsX+defaultSize, settsY+settsH-defaultSize*3, settsW-defaultSize*2, defaultSize*2);
    fill(theme==0 ? 200 : 60);
    text("OK", settsX+settsW/2, settsY+settsH-defaultSize*2);
  }
  void updateSettings() {
    if (
      mousePressed&&(
      (
      (mouseX > Settings.settsX && mouseX < Settings.settsX + Settings.settsW) &&
      (mouseY > Settings.settsY && mouseY < Settings.settsY + Settings.settsH)
      ) && sett)
      )
    {
      if (mouseX>settsX+50&&mouseX<settsX+settsW-50&&mouseY>settsY+50&&mouseY<settsY+settsH-50) {
        choice = -1;
        for (int i=0; i<options; i++) {
          if (mouseY>settsY+50+(settsH-250)/options*i &&
            mouseY<settsY+50+(settsH-250)/options*(i+1)) {
            choice = i;
          }
        } 
        if (mousePressed&&
          mouseX>settsX+50&&mouseX<settsX+settsW-50&&mouseY>settsY+settsH-150&&mouseY<settsY+settsH-50)
        {
          set = false;
        }
      }
    } else if (!mousePressed&&choice>-1) {
      switch(choice) {
      case 0: 
        theme = theme==0 ? 1 : 0; 
        ((Vibrator) getContext().getSystemService(Context.VIBRATOR_SERVICE)).vibrate(vibration ? 100 : 0);
        break;
      case 1: 
        vibration = !vibration; 
        ((Vibrator) getContext().getSystemService(Context.VIBRATOR_SERVICE)).vibrate(vibration ? 100 : 0);
        break;
      case 2: 
        freePlay = !freePlay;
        ((Vibrator) getContext().getSystemService(Context.VIBRATOR_SERVICE)).vibrate(vibration ? 100 : 0);
        break;
      case 3:
        resetData();
        ((Vibrator) getContext().getSystemService(Context.VIBRATOR_SERVICE)).vibrate(vibration ? 100 : 0);
        break;
      }
      choice = -1;
    } else if(mousePressed){
      cl=true;
    }
    if(!mousePressed&&cl){
      sett=false;
      cl=false;
      time = false;
    }
    if (!mousePressed&&!set) {
      set=true;
      sett=false;
      time = false;
    } 
  }
}
