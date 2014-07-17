int width = 440;
int height = 440;
int cSize = 10;
int cCount = height/cSize;
boolean[][] cells;
boolean[] rules = {false,true,false,true,true,false,true,false}; 
boolean STATE = false;
int gen = 1;
PFont f;

// Variables for timer
int interval = 500;
int lastRecordedTime = 0;

void setup() {
  f = createFont("Arial",16,true);
  size(width, height);
  cells = new boolean[cCount][cCount];
  for (int i = 0; i <= cCount-1; ++i) {
    for (int j = 0; j <= cCount-1; ++j) {
      cells[i][j] = false;
    }
  }
  cells[floor(cCount/2)][0] = true;
}

void keyPressed() {
  if (keyCode == ENTER) {
    if (STATE == false) {
      STATE = true;
      return;
    } else {
      STATE = false;
      return;
    }
  }
  if (key == 'n'){
    for (int i = 0; i < 8; i++) {
      rules[i] = boolean(int(random(2)));
      gen = 1;
    }
  }
}

void draw() {
  int c;
  noStroke();
  for (int i = 0; i <= cCount-1; ++i) {
    for (int j = 0; j <= cCount-1; ++j) {
      if (cells[i][j]) {c = 255;} else {c = 0;}
      fill(c);
      rect(i*cSize, j*cSize, cSize, cSize);
    }
  }
  
  // Iterate if timer ticks
  if (millis()-lastRecordedTime>interval) {
      if (STATE && gen < cCount) {evolve(gen); gen++;}
      lastRecordedTime = millis();
      print(gen);
  }
  
  if (!STATE) {fill(255,0,0); rect(0, 0, 2, 2);}
  
  textFont(f,10);                 
  fill(255,0,0);
  String r="";
  for (int i = 0; i < 8; ++i) {
    if(rules[i]) r+='1';
    else r+='0';
  }
  text(r,390,10);  

}

void evolve(int j) {
  boolean[][] newCells = cells;
  for (int i = 1; i <= cCount-2; ++i) {
    boolean left = cells[i-1][j-1];
    boolean me = cells[i][j-1];
    boolean right = cells[i+1][j-1];
    newCells[i][j] = execute(left, me, right);
  }
  cells = newCells;
}

boolean execute(boolean a, boolean b, boolean c) {
  if(a && b && c) {return rules[0];}
  if(a && b && !c) {return rules[1];}
  if(a && !b && c) {return rules[2];}
  if(a && !b && !c) {return rules[3];}
  if(!a && b && c) {return rules[4];}
  if(!a && b && !c) {return rules[5];}
  if(!a && !b && c) {return rules[6];}
  if(!a && !b && !c) {return rules[7];}
  return false;
}

void mousePressed() {
  int i = floor(mouseX/cSize);
  int j = floor(mouseY/cSize);
  switchTile(i, j);
  gen = j+1;
}

void switchTile (int i, int j) {
  boolean c;
  if (cells[i][j]) {c = false;} else {c = true;}
  cells[i][j] = c;
}
