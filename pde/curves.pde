int w = 600;
int mQty = 3;
Mover[] movers;

void setup() {
	size(w, w);
	colorMode(HSB, 100, 100, 100);
	background(100, 0, 100);
	noStroke();
	smooth();

	movers = new Mover[mQty];

	for (int i = 0; i < mQty; ++i) {
		movers[i] = new Mover(random(0, width), random(0, height)); // position de départ aléatoire
		movers[i].setId(i);
		movers[i].setMagLimit(int(random(1, 4)), int(random(4, 30)));
	}
}

void draw() {
	for (Mover m : movers) {
		m.update();
	}
}

void mouseClicked() {
	setup();
}

////////////////////////////////////////////////////////////////////////////////
class Mover {

	PVector position, speed, acceleration;
	float maxAccelerationMag, maxSpeedMag;
	color c;
	boolean freeFly, slowDown;
	int id;

	Mover(float startX, float startY) {
		colorMode(HSB, 100, 100, 100);
		position = new PVector(startX, startY);
		speed = new PVector(0, 0);
		acceleration = new PVector(0, 0);
		maxAccelerationMag = 4; // limite de magnitude pour l'acceleration
		maxSpeedMag = 20; // limite de magnitude pour la vitesse
		freeFly = true; // mode de collision avec les bords
		slowDown = false; // ralentissement en cours

		int randHue = int(noise(startX, startY)*100);
		c = color(randHue, 100, 80); // couleur par défaut
	}

	void update() {
		setDirection(); // (peut-être) changer de direction
		move(); // calculer le déplacement
		limit(); // limiter au cadre
		draw(); // dessiner le point
		showVector(); // afficher les info internes
	}

	void move() {
		//slowDown = false;
		if (slowDown==true) {
			acceleration.limit(maxAccelerationMag); 
			acceleration.div(2); // réduire l'acceleration
			speed.add(acceleration);
			speed.limit(maxSpeedMag*0.8); // réduire la vitesse
			position.add(speed);
		} else {
			acceleration.limit(maxAccelerationMag); // limiter l'acceleration
			speed.add(acceleration); // ajouter l'acceleration à la vitesse
			speed.limit(maxSpeedMag); // limiter la vitesse
			position.add(speed); // ajouter la vitesse à la position
		}
	}

	void limit() {
		if (freeFly==true) {

			// ressortir du côté opposé
			if (position.x<0) position.x = width;
			if (position.x>width) position.x = 0;
			if (position.y<0) position.y = height;
			if (position.y>height) position.y = 0;

		} else {

			// rebondir
			if (position.x<=0 || position.x>=width) {
				speed.x = speed.x * -1;
			} 

			if (position.y<=0 || position.y>=height) {
				speed.y = speed.y * -1;
			}
		}

		// rester dans le cadre
		position.x = constrain(position.x, 0, width);
		position.y = constrain(position.y, 0, height);
	}

	void draw() {
		updateColor();

		float dot = speed.mag();//-acceleration.mag();

		//fill(color(hue(c), saturation(c)-10, brightness(c)-10));
		//ellipse(position.x-acceleration.x, position.y-acceleration.y, dot*1.3, dot*1.3);

		fill(c);
		ellipse(position.x, position.y, dot, dot);
	}

	void setDirection() {
		int r = int(random(1)*100);
		if (r>=70) {
			acceleration.x = random(-3, 3);
			acceleration.y = random(-3, 3);
		} else if (r<=10) {
			slowDown = !slowDown;
		}
	}

	void setColor(color newColor) {
		c = newColor;
	}

	void setId(int newId) {
		id = newId;
	}

	void setMagLimit(int maxAcc, int maxSpeed) {
		maxAccelerationMag = maxAcc;
		maxSpeedMag = maxSpeed;
	}

	void updateColor() {
		float newSaturation = map(speed.mag(), 0, maxSpeedMag, 30, 100);
		float newBrightness = map(acceleration.mag(), 0, maxAccelerationMag, 30, 100);
		float newHue = map(noise(position.x, position.y), 0, 1, -1, 1);

		newHue = hue(c) + newHue;
		if (newHue<0) newHue = 100 + newHue * 1;
		if (newHue>100) newHue = 0 + newHue * -1;
		newHue = constrain(newHue, 0, 100);
		c = color(newHue, newSaturation, newBrightness);
	}

	void showVector() {
		int thumbSize = 31;

		PVector target = speed.get();
		PVector targetDistance = acceleration.get();
		target.normalize();
		targetDistance.normalize();

		target.add(targetDistance);
		target.mult(thumbSize/4);

		translate(width - thumbSize*(id+1) + thumbSize/2, height - thumbSize/2);

		fill(color(hue(c), saturation(c), brightness(c), 15));
		ellipse(0, 0, thumbSize+1, thumbSize+1);

		stroke(0);
		strokeWeight(2);
		
		if (target.x>0) {
			float tX = target.x - 1;
		} else {
			float tX = target.x + 1;
		}
		if (target.y>0) {
			float tY = target.y - 1;
		} else {
			float tY = target.y + 1;
		}

		line(0, 0, target.x, target.y);

		noStroke();
		resetMatrix();
	}

}
