class money {
  float m;
  float offset = 0;
  boolean up = true;
  boolean blink = false;
  money() {
    m = 100;
  }

  void blink() {
    if (blink) {
      offset = up ? offset+1 : offset-1;
      if (offset>10) {
        up = false;
      }
      if(offset<0){
        offset = 0;
        up = true;
        blink = false;
      }
    }
  }

  void show() {
    blink();
    fill(theme==0 ? 200 : 150, theme==0 ? 200 : 150, theme==0 ? 50 : 0);
    textSize(defaultSize*0.8f+offset);
    text(nfall(m, 2) + "$", width-defaultSize*3f, defaultSize*1.5f);
  }

  void addOne() {
    m++;
  }

  void addMany(float count) {
    m+=abs(count);
  }
}
