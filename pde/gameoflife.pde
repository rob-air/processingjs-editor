int width = 400;
int height = 400;
int cSize = 40;
int cCount = height/cSize;
boolean[][] cells;
boolean STATE = false;
PFont f;
int deathcount;

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
}

void keyPressed() {
  if (keyCode == ENTER) {
    if (STATE == false) {
      STATE = true;
    } else {
      STATE = false;
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
      if (STATE) {evolve();}
      lastRecordedTime = millis();
  }
  
  if (!STATE) {fill(255,0,0); rect(0, 0, 2, 2);}
  
  textFont(f,10);                 
  fill(255,0,0);               
  String dc = nf(deathcount,6);  
  text("Deathcount: "+dc,305,10);  
  
}

void evolve() {
  int neighbors;
  boolean[][] newCells = cells;
  for (int i = 0; i <= cCount-1; ++i) {
    for (int j = 0; j <= cCount-1; ++j) {
      neighbors = getNeighbors(i,j);
      if (!cells[i][j] && neighbors==3) {
        newCells[i][j] = true;
      }
      if (cells[i][j] && !(neighbors==2 || neighbors==3)) {
        newCells[i][j] = false;
        deathcount++;
      } 
    }
  }
  cells = newCells;
}

int getNeighbors(int i, int j) {
  int n = 0;
  for (int x=i-1; x<=i+1; x++) {
    for (int y=j-1; y<=j+1; y++) {  
      if (((x>=0)&&(x<cCount))&&((y>=0)&&(y<cCount))) { // Make sure you are not out of bounds
        if (!((x==i)&&(y==j))) { // Make sure to to check against self
          if (cells[x][y]){
            n++;
          }
        } 
      } 
    }
  }
  return n;
}

void mousePressed() {
  switchTile();
}

void switchTile () {
  int i = floor(mouseX/cSize);
  int j = floor(mouseY/cSize);
  boolean c;
  if (cells[i][j]) {c = false;} else {c = true;}
  cells[i][j] = c;
  print(getNeighbors(i,j));
}
