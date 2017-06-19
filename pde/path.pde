PImage[] fragment;
int cell = 45;
int width = 1080;
int height = 1080;
int cCount;
int fillPercent = 40;
boolean[][] cells;
boolean grid = false;
boolean preFill = true;
String[] tileSets;
int tileSet = 2;
ArrayList<boolean[][]> cellStore;
int cellStoreIndex = 0;

void setup() {
  size(1080, 1080);
  background(255);
  fill(200);
  cCount = width/cell;
  cells = new boolean[cCount+1][cCount+1];
  tileSets = new String[4];
  tileSets[0] = "A";
  tileSets[1] = "B";
  tileSets[2] = "C";
  tileSets[3] = "D";
  
  ArrayList<boolean[][]> cellStore = new ArrayList<boolean[][]>();
  
  loadTileSet();
  
  if (preFill) {
    for (int i = 0; i <= cCount; ++i) {
      for (int j = 0; j <= cCount; ++j) {
        cells[i][j] = rand();
      }
    }
    cellStore.add(cells);
  }
  drawTiles();
}

void loadTileSet() {
  fragment=new PImage[16];
  for (int i=0;i<fragment.length;i++) {
    fragment[i] = loadImage("img/"+tileSets[tileSet]+"_"+str(i) + ".png");
  }
  println("Loaded tileset " + tileSets[tileSet]);
}

void draw() {
  drawTiles();
}

void drawTiles() {
    background(255);
    drawGrid();
    for (int i = 1; i < cCount-1; ++i) {
    for (int j = 1; j < cCount-1; ++j) {

      if (cells[i][j]==false) continue;

      translate(i*cell, j*cell);

      int r = getTile(i, j);
      image(fragment[r], 0 , 0 , cell, cell);

      resetMatrix();
    }
  }
}

boolean rand() {
  int r = int(random(0, 1)*100);

  if (r<=fillPercent) return true;
  return false;
}

int getTile(int x, int y) {
  String[] directions = new String[4];

  directions[0] = (cells[x-1][y])? "1": "0"; // West
  directions[1] = (cells[x][y+1])? "1": "0"; // South
  directions[2] = (cells[x+1][y])? "1": "0"; // East
  directions[3] = (cells[x][y-1])? "1": "0"; // North

  if (x-1==0) directions[0] = "0";
  if (x+2==cCount) directions[2] = "0";
  if (y-1==0) directions[3] = "0";
  if (y+2==cCount) directions[1] = "0";

  String dir = join(directions, "");
  
  if (dir.equals("0000")) { return 0; }
  if (dir.equals("0001")) { return 1; }
  if (dir.equals("0010")) { return 2; }
  if (dir.equals("0100")) { return 3; }
  if (dir.equals("1000")) { return 4; }
  if (dir.equals("0101")) { return 5; }
  if (dir.equals("1010")) { return 6; }
  if (dir.equals("0011")) { return 7; }
  if (dir.equals("1100")) { return 8; }
  if (dir.equals("0110")) { return 9; }
  if (dir.equals("1001")) { return 10; }
  if (dir.equals("1101")) { return 11; }
  if (dir.equals("1011")) { return 12; }
  if (dir.equals("0111")) { return 13; }
  if (dir.equals("1110")) { return 14; }
  if (dir.equals("1111")) { return 15; }

  return 0;
}

void mouseClicked() {
  switchTile();
}

void keyPressed() {
  if (keyCode == ENTER || keyCode == RETURN) {
    setup();
  }
  /*
  if (keyCode == UP) {
    if (cellStore.contains(cellStoreIndex+1)) {
      cellStore.add(cells);
      cells = cellStore.get(cellStoreIndex+1);
      drawTiles();
    }
  }
  
  if (keyCode == DOWN) {
    cellStore.add(cells);
    cells = cellStore.get(cellStoreIndex-1);
    drawTiles();
  }
  */
  // loop through available tilesets
  if (keyCode == RIGHT) {
    if (tileSet+1 >= tileSets.length) {
      tileSet = 0;
    } else {
      tileSet += 1;
    }
    loadTileSet();
    drawTiles();
  }
  if (keyCode == LEFT) {
    if (tileSet == 0) {
      tileSet = tileSets.length-1;
    } else {
      tileSet -= 1;
    }
    loadTileSet();
    drawTiles();
  }
}

void switchTile () {
  int x = ceil(mouseX / cell);
  int y = ceil(mouseY / cell);
  cells[x][y] = !cells[x][y];
}

void drawGrid() {
  stroke(150);

  int mX = ceil(mouseX / cell);
  int mY = ceil(mouseY / cell);

  for (int i = 0; i <= cCount; ++i) {
    if (grid) line(0, i*cell, width, i*cell);

    for (int j = 0; j <= cCount; ++j) {
      if (grid) line(j*cell, 0, j*cell, height);
      if (mX==i && mY==j) {
        noStroke();
        rect(i*cell, j*cell, cell, cell);
        stroke(150);
      }
    }
  }

  stroke(0);
}