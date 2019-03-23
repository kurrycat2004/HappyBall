class particle{
  float x;
  float y;
  PVector dir;
  PVector acc;
  float speed;
  float lifespan;
  
  particle(float x, float y){
    this.x = x;
    this.y = y;
    this.acc = new PVector(0,0);
    this.speed = random(1, 10);
    this.dir = new PVector(random(-5, 5), random(-5, 5));
    this.lifespan = random(10, 30);
  }
  
  void show(){
    stroke(random(100,200), random(50,150), 50, map(lifespan, 0, 30, 0, 255));
    strokeWeight(random(2, 6));
    point(x,y);
    strokeWeight(1);
    noStroke();
  }
  void update(){
    acc.add(new PVector(0, 0.1));
    dir.add(acc);
    dir.setMag(speed);
    speed*=0.9;
    lifespan--;
    x+=dir.x;
    y+=dir.y;
  }
}