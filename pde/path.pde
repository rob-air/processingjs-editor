PImage[] fragment;
int cell = 45;
int width = 900;
int height = 900;
int cCount;
int[][] cells;
boolean grid = false;
String tileSet = "B";

void setup() {
	smooth();
	size(width, height);
	background(255);
	fill(200);
	cCount = width/cell;
	fragment=new PImage[16];
	cells = new int[cCount+1][cCount+1];        

	for (int i=0;i<fragment.length;i++) {
		fragment[i] = loadImage("img/"+tileSet+"_"+str(i) + ".png");
	}

	for (int i = 0; i <= cCount; ++i) {
		for (int j = 0; j <= cCount; ++j) {
			cells[i][j] = rand();
		}
	}

	drawTiles();

}

void draw() {
	drawTiles();
}

void drawTiles() {
	background(255);
	drawGrid();
	for (int i = 1; i < cCount-1; ++i) {
		for (int j = 1; j < cCount-1; ++j) {

			if (cells[i][j]==0) continue;

			translate(i*cell, j*cell);

			int r = getTile(i, j);
			image(fragment[r], 0 , 0 , cell, cell);

			resetMatrix();
		}
	}
}

int rand() {
	int r = int(random(0, 1)*100);

	if (r>=60) return 1;
	return 0;
}

int getTile(int x, int y) {
	String[] directions = new String[4];

	directions[0] = str(cells[x-1][y]); // West
	directions[1] = str(cells[x][y+1]); // South
	directions[2] = str(cells[x+1][y]); // East
	directions[3] = str(cells[x][y-1]); // North

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
  if (keyCode == ENTER) setup();
}

void switchTile () {
	int x = ceil(mouseX / cell)-1;
	int y = ceil(mouseY / cell)-1;
	int c = cells[x][y];
	if (c==0) {
		c = 1;
	} else {
		c = 0;
	}

	cells[x][y] = c;
}

void drawGrid() {
	stroke(150);

	int mX = ceil(mouseX / cell)-1;
	int mY = ceil(mouseY / cell)-1;

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
