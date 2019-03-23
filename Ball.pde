class ball {
  float x = width/2;
  float y = height/2;
  PVector grav = new PVector(0, 0.1*G);
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  PVector accM = new PVector(0,0);
  PVector velM = new PVector(0,0);
  float d = defaultSize;
  color col = color(theme==0 ? 255 : 60);

  void applyForce(float fX, float fY){
    PVector apply = new PVector(fX,fY);
    acc.add(apply);
  }

  void update() {
    //acc.add(grav);
    accM.add(grav);
    velM.add(new PVector(-ax,0));
    velM.add(new PVector(0,ay));
    accM.add(new PVector(0,ay));
    ay = 0;
    vel.add(acc);
    velM.add(accM);
    velM.mult(0.9);
    vel.mult(0.9);
    y += vel.y+velM.y;
    x += vel.x+velM.x;
    
    if(x-d/2<0){
      x = d/2;
      vel.add(new PVector(-vel.x*0.8, 0));
      acc.add(new PVector(-acc.x*0.8, 0));
      velM.add(new PVector(-velM.x*0.8, 0));
      accM.add(new PVector(-accM.x*0.8, 0));
    } else if(x+d/2>width){
      x = width-d/2;
      vel.add(new PVector(-vel.x*0.8, 0));
      acc.add(new PVector(-acc.x*0.8, 0));
      velM.add(new PVector(-velM.x*0.8, 0));
      accM.add(new PVector(-accM.x*0.8, 0));
    }

    if (y-d/2 < 0) {
      y = d/2;
      vel.add(new PVector(0, -vel.y*0.8));
      acc.add(new PVector(0, -acc.y*0.8));
      velM.add(new PVector(0, -velM.y*0.8));
      accM.add(new PVector(0, -accM.y*0.8));
    } else if (y+d/2 > height) {
      y = height-d/2;
      vel.add(new PVector(0, -vel.y*0.8));
      acc.add(new PVector(0, -acc.y*0.8));
      velM.add(new PVector(0, -velM.y*0.8));
      accM.add(new PVector(0, -accM.y*0.8));
    }
  }

  void show() {
    noStroke();
    fill(col);
    ellipse(x, y, d, d);
  }
}
