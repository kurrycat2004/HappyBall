import android.os.Environment;
import android.content.SharedPreferences;
import android.content.Context;
import android.app.Activity;
import android.os.Bundle;
import java.io.FileOutputStream;
import android.preference.PreferenceManager;

ball Ball;
bereich Bereich;
AccelerometerManager accel;
money Money;
powerup Pow;
shop Shop;
ArrayList<hole> Hole;
ArrayList<food> Food;
pauseButton Pause;
settings Settings;

import android.os.Vibrator;
import android.content.Context;

boolean freePlay = false;

float defaultSize;

float theme = 0f;
boolean vibration = true;

boolean Start = false;

int foods = 8;
int holes;
boolean pressed = false;
boolean showHole = false;
float G = 0.8;
float ax;
float ay;
boolean start = true;
float fade = 150;
boolean f = true;
int highscore = 0;
int fPHighscore = 0;

boolean pause = false;
boolean sett = false;

//Upgrades
float upgrades = 4;
float foodPoints = 1;
float scorePerSek = 60;
void addHole() {
  Hole.add(new hole(random(Ball.d*5/3, width-Ball.d*5/3), random(Ball.d*5/3, height-Ball.d*5/3)));
  holes++;
}

String nfall(float num, int right){
  int type = 0;
  if(num<10000){
    return nf(num, 1,right);
  } 
  while(num>=1000){
    num /= 1000;
    type++;
  }
  String end = "";
  switch(type){
    case 1:
      end = "T";
      break;
    case 2:
      end = "mio";
      break;
    case 3:
      end = "mrd";
      break;
    case 4:
      end = "bio";
      break;
  }
  return nf(num,1, 2) + " " + end;
 
}

void writeFile(String filename, String string) {
  Activity act;
  Context context;
  FileOutputStream outputStream;
  act = this.getActivity();
  context = act.getApplicationContext();
     
  try {
    outputStream = context.openFileOutput(filename, Context.MODE_PRIVATE);
    outputStream.write(string.getBytes());
    outputStream.close();
      
  } catch (Exception e) {
    println(e);
  }
      
}

void resetData() {
  String Data = "0" + "\t" +
    "0" + "\t" +
    "0.0" + "\t" +
    "1" + "\t" +
    "0" + "\t" +
    "1.0" + "\t" + 
    "60.0" + "\t" +
    "0" + "\t" + 
    "0" + "\t" +
    "0.0";
  writeFile("data.txt", Data);
  String[] data = splitTokens(loadStrings("data.txt")[0]);
  highscore = Integer.parseInt(data[0]);
  fPHighscore = Integer.parseInt(data[1]);
  Bereich.best = highscore;
  Bereich.fPBest = fPHighscore;
  theme = Float.parseFloat(data[2]);
  vibration = Integer.parseInt(data[3])==0 ? false : true;
  freePlay = Integer.parseInt(data[4])==0 ? false : true;
  foodPoints = Float.parseFloat(data[5]);
  scorePerSek = Float.parseFloat(data[6]);
  Shop.monUps = Integer.parseInt(data[7]);
  Shop.scorUps = Integer.parseInt(data[8]);
  Money.m = Float.parseFloat(data[9]);
}

void loadData() { 
  try {
    String[] data = splitTokens(loadStrings("data.txt")[0]);
    highscore = Integer.parseInt(data[0]);
    fPHighscore = Integer.parseInt(data[1]);
    theme = Float.parseFloat(data[2]);
    vibration = Integer.parseInt(data[3])==0 ? false : true;
    freePlay = Integer.parseInt(data[4])==0 ? false : true;
    foodPoints = Float.parseFloat(data[5]);
    scorePerSek = Float.parseFloat(data[6]);
    Shop.monUps = Integer.parseInt(data[7]);
    Shop.scorUps = Integer.parseInt(data[8]);
    Money.m = Float.parseFloat(data[9]);
  } 
  catch(Exception e) {
    println(e);
  }
} 
void saveData() {
  String data = Bereich.best + "\t" +
    Bereich.fPBest + "\t" +
    theme + "\t" +
    (vibration ? 1 : 0) + "\t" +
    (freePlay ? 1 : 0) + "\t" +
    foodPoints + "\t" + 
    scorePerSek + "\t" +
    Shop.monUps + "\t" + 
    Shop.scorUps + "\t" +
    Money.m;
  writeFile("data.txt", data);
  loadData();
}

void start() {
  showHole = false;
  //accel = new AccelerometerManager(this);
  Ball = new ball();
  Hole = new ArrayList<hole>();
  holes = 0;

  Ball.applyForce(0, -1*G);
  try {
    fPHighscore = Bereich.fPBest;
    highscore = Bereich.best;
  } catch (Exception e) {
  }
  Bereich = new bereich();
  Bereich.best = highscore;
  Bereich.fPBest = fPHighscore;
  Food = new ArrayList<food>();
  for (int i=0; i<foods; i++) {
    Food.add(new food());
  }

  start = true;
  pause = false;
  sett = false;
}
void setup() {

  frameRate(60);
  orientation(PORTRAIT);
  textAlign(CENTER, CENTER);
  defaultSize = displayWidth/(1080/50);
  start();
  Money = new money();
  Shop = new shop(0, height-defaultSize*6);
  Pause = new pauseButton();
  Settings = new settings();
  accel = new AccelerometerManager(this);
  loadData();
}

@Override
void onDestroy(){
  saveData();
  super.onDestroy();
}

@Override
  void onStart() {
  //super.onStart();
}

@Override
  public void onStop() {
    if(!start){
      pause = true;
      Ball.accM.mult(0);
    }
  saveData();
}

@Override
  public void onPause() {
  //super.onPause();
  if (!start) {
    pause = true;
    Ball.accM.mult(0);
  }
  saveData();
}

@Override
  public void onResume() {
  super.onResume();
  loadData();
}


void draw() {
  background(theme==0 ? 60 : 200);
  if (frameCount%100==0&&!pause&&!start) {
    saveData();
  }

  Money.show();
  if (!start) {
    if (!pause) {
      Pause.update();

      Ball.update();
      Ball.show();
      for (int i=0; i<Food.size(); i++) {
        Food.get(i).update();
        Food.get(i).show();
      }
      if (showHole) {
        for (int i=Hole.size()-1; i>=0; i--) {
          i = constrain(i, 0, Hole.size()-1);
          Hole.get(i).update();
          if (Hole.size() == 0) {
            break;
          }
          Hole.get(i).show();
        }
        for (int i=Hole.size()-1; i>=0; i--) {
          if (dist(Ball.x, Ball.y, Hole.get(i).x, Hole.get(i).y)<200&&Hole.get(i).showHole) {
            ((Vibrator) getContext().getSystemService(Context.VIBRATOR_SERVICE)).vibrate(0);
          }
          for (int j = Hole.size()-1; j>=0; j--) {
            i = constrain(i, 0, Hole.size()-1);
            j = constrain(j, 0, Hole.size()-1);
            if (Hole.get(i)==Hole.get(j)) {
              continue;
            }
            if (dist(Hole.get(i).x, Hole.get(i).y, Hole.get(j).x, Hole.get(j).y)<Hole.get(j).d+Hole.get(i).d) {
              if (Hole.get(i).d>Hole.get(j).d) {
                Hole.get(i).Grow += Hole.get(j).d;
                Hole.remove(j);
                continue;
              } else {
                Hole.get(j).Grow += Hole.get(i).d;
                Hole.remove(i);
                continue;
              }
            }
          }
        }
      }
      Bereich.update();
      Bereich.show();

      Pause.show();
    } else {
      Pause.update();

      Ball.show();
      for (int i=0; i<Food.size(); i++) {
        Food.get(i).show();
      }
      if (showHole) {
        for (int i=0; i<Hole.size(); i++) {
          Hole.get(i).show();
        }
      }
      Bereich.show();
      Pause.show();
    }
  } else {

    Ball.show();
    for (int i=0; i<Food.size(); i++) {
      Food.get(i).show();
    }

    Bereich.show();

    Shop.update();
    Shop.show();

    textSize(defaultSize*2);
    fill(theme==0 ? 255 : 60, fade);
    text("Tippen um zu starten", width/2, height/4*2.5);
    fade = f ? fade+3 : fade-3;
    f = fade>255||fade<150 ? !f : f;

    Settings.update();
    Settings.show();
    if (mousePressed && mouseY < Shop.y && !((mouseY > Settings.y && mouseY < Settings.y + Settings.w)&&
      (mouseX > Settings.x && mouseX < Settings.x + Settings.w)) && 
      (
      (
      !(mouseX > Settings.settsX && mouseX < Settings.settsX + Settings.settsW) ||
      !(mouseY > Settings.settsY && mouseY < Settings.settsY + Settings.settsH)
      ) || !sett)) {
      Start = true;
    }
    if (!mousePressed&&Start) {
      Start=false;
      start = false;
    }
  }
}
void mousePressed() {
  if (!pressed&&!start&&!pause) {
    ay = (Ball.grav.y>0 ? -3*G : 3*G);
    pressed = true;
  }
}

void mouseReleased() {
  Shop.goFurther = -1;
  pressed = false;
}

public void accelerationEvent(float x, float y, float z) {
  //  println("acceleration: " + x + ", " + y + ", " + z);
  ax = x;
  //ay = y;
  //az = z;
}
