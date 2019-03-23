class hole {
  float x;
  float y;
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  float d = defaultSize/2;
  float angle = 0;
  float offset = 0;
  float hor = 300;
  boolean up = true;
  float fa = 1;
  float dirX = 0;
  float dirY = 0;
  PVector Vdir;
  float VaccX = 0;
  float VaccY=0;
  float fade;
  float Grow = 0;
  float maxspeed = 0.2;
  boolean showHole = false;
  hole(float x1, float y1) {
    this.x = x1;
    this.y = y1;
    this.fade = 0;
    this.changeDir(0, 0);
  }
  void fadeIn() {
    this.showHole = true;
    this.fade += this.fade<255 ? 1 : 60;
  }
  void fadeOut() {
    this.fade-=this.fade>0 ? 1 : 60;
    if (this.fade==0) {
      this.showHole = false;
    }
  }

  void changeDir(float xdir, float ydir) {
    float dir = random(TWO_PI);
    this.dirX = cos(dir)*random(maxspeed);
    if (xdir<0) {
      this.dirX *= -1;
    } else if (xdir==0) {
    }
    this.dirY = sin(dir)*random(maxspeed);
    if (ydir<0) {
      this.dirY *= -1;
    } else if (ydir==0) {
    }
  }

  void show() {
    if (this.showHole) {
      colorMode(HSB);
      float b = 150;
      int count = floor(d/3);
      float yP, xP;
      stroke(200, 255, 200, this.fade);
      for (int i=0; i<count; i++) {
        xP = cos(angle)*(d/1.2+offset)+this.x;
        yP = sin(angle)*(d/1.2+offset)+this.y;
        strokeWeight(8);
        point(xP, yP);
        angle+=TWO_PI/count;
      }
      changeOff();
      angle+=(map(offset, -this.d/10, this.d/10, 0.08, 0.02));

      strokeWeight(1);
      for (float d1 = this.d; d1>0; d1--) {
        noFill();
        stroke(200, 255, b, this.fade);
        ellipse(this.x, this.y, d1, d1);
        b-=b/d1;
      }

      colorMode(RGB);
      }
    }

    void grow() {
      if (this.Grow>0) {
        this.d+=Grow/50;
        Grow-=Grow/50;
      }
      if (Grow<0.1) {
        Grow = 0;
      }
  }

  void update() {
    if (this.showHole) {
      grow();
      this.d = constrain(this.d, defaultSize/2, defaultSize*2);

      this.Vdir = new PVector(this.x, this.y);
      this.Vdir.sub(new PVector(Ball.x, Ball.y));
      float f = map(this.fade, 0, 255, 0, 0.5);
      this.Vdir.setMag((f*(this.d/10))/(dist(this.x, this.y, Ball.x, Ball.y)));
      this.Vdir.mult(G);

      this.Vdir.div(80);
      Ball.acc.add(this.Vdir);

      for (int i=Food.size()-1; i>=0; i--) {
        if (dist(Food.get(i).x, Food.get(i).y, this.x, this.y)<this.d/2+Food.get(i).d/2) {
          Food.remove(i);
        }
      }
      this.acc.mult(0);
      for (int i=Hole.size()-1; i>=0; i--) {
        if (Hole.get(i)==this) { 
          continue;
        }
        Vdir = new PVector(x, y);
        
        Vdir.sub(new PVector(Hole.get(i).x, Hole.get(i).y));
        Vdir.setMag((f*(Hole.get(i).d/50))/(2*dist(x, y, Hole.get(i).x, Hole.get(i).y)));
        Vdir.mult(G);
        //Vdir.mult(8);
        this.acc.sub(Vdir);
      }
      //text(nf(Vdir.x,1,2) + ":"+ nf(Vdir.y,1,2), 400, 400);
      this.vel.add(this.acc);
      this.vel.add(dirX*G, dirY*G);
      this.vel.mult(0.9);
      y += vel.y;
      x += vel.x;
      //y+=dirY;
      //x+=dirX;

      if (x-d*5/6<0) {
        x = d*5/6;
        changeDir(1, 0);
        vel.add(new PVector(-vel.x*0.8, 0));
        acc.add(new PVector(-acc.x*0.8, 0));
      } else if (x+d*5/6>width) {
        x = width-d*5/6;
        changeDir(-1, 0);
        vel.add(new PVector(-vel.x*0.8, 0));
        acc.add(new PVector(-acc.x*0.8, 0));
      }

      if (y-d*5/6 < 0) {
        y = d*5/6;
        changeDir(0, 1);
        vel.add(new PVector(0, -vel.y*0.8));
        acc.add(new PVector(0, -acc.y*0.8));
      } else if (y+d*5/6 > height) {
        y = height-d*5/6;
        changeDir(0, -1);
        vel.add(new PVector(0, -vel.y*0.8));
        acc.add(new PVector(0, -acc.y*0.8));
      }
      /*
    this.x = constrain(x,0,width);
       this.y = constrain(y,0,height);
       */
    }
    if (dist(Ball.x, Ball.y, this.x, this.y)<d/2+Ball.d/2) {
      if(!freePlay){
        start();
      }
    }
  }

  void changeOff() {
    if (up) {
      offset+=d/500;
    } else {
      offset-=d/500;
    }
    if (offset>d/8) {
      up = false;
    } else if (offset<-d/8) {
      up = true;
    }
  }
}
