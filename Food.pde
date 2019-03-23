class food {
  float x;
  float y;
  PVector acc = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  PVector Vdir;
  PVector pv;
  float d = defaultSize/2;
  int particles = 350;
  ArrayList<particle> touch = new ArrayList<particle>();
  //float lifespan = random(50, 300);
  boolean spec;

  food() {
    reset();
  }

  void touched() {
    for (int i=0; i<particles; i++) {
      touch.add(new particle(x, y));
    }
  }

  void update() {
    for (int i=touch.size()-1; i>=0; i--) {
      touch.get(i).update();
      touch.get(i).show();
      if (touch.get(i).lifespan < 0) {
        touch.remove(i);
      }
    }
      if (dist(x, y, Ball.x, Ball.y)<Ball.d/2+d/2) {
        touched();
        if (!freePlay&&!spec) {
          Money.blink = true;
          Money.addMany(foodPoints);
        } else if(spec){
          Pow.trigger();
        }
        reset();
      
    }
    this.acc.mult(0);
    for (int i=Hole.size()-1; i>=0; i--) {
      float f = map(Hole.get(i).fade, 0, 255, 0, 0.2);
      if (Hole.get(i).showHole) {
        Vdir = new PVector(Hole.get(i).x, Hole.get(i).y);
        pv = new PVector(x, y);
        Vdir.sub(pv);
        Vdir.setMag((f*(Hole.get(i).d/10))/(4*(dist(x, y, Hole.get(i).x, Hole.get(i).y))));
        Vdir.mult(G);
        Vdir.div(35);
        this.acc.add(Vdir);
      }
    }

    vel.add(this.acc);
    vel.mult(0.9);
    x+=vel.x;
    y+=vel.y;
    if (x<d/2||x>width-d/2) {
      vel.sub(vel.x, 0);
    } else if (y<d/2||y>height-d/2) {
      vel.sub(0, vel.y);
    }
    x = constrain(x, d/2, width-d/2);
    y = constrain(y, d/2, height-d/2);
  }

  void show() {
    noStroke();
    if (!spec) {
      fill(theme==0 ? 255 : 60, 150);
    } else {
      Pow = new powerup();
      fill(theme==0 ? 100 : 0, theme==0 ? 100 : 0, theme==0 ? 255 : 155, 150);
    }
    ellipse(x, y, d, d);
  }

  void reset() {
    spec = random(1)<=0.2;
    x = random(d, width-d);
    y = random(d, height-d);
  }
}
