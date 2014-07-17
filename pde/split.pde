import java.util.Iterator;
int w = 600;
int mQty = 1;
int globId = -1;
MoverSystem ms;
	
void setup() {
	size(w, w);
	colorMode(HSB, 100, 100, 100);
	background(100, 0, 100);
	noStroke();
	smooth();
	globId = -1;

	ms = new MoverSystem();

	for (int i = 0; i < mQty; ++i) {
		ms.addMover();
	}
}

void draw() {
	ms.update();
}

void mouseClicked() {
	setup();
}

int getCleanId() {
	globId++;
	if (globId==19) globId = 0;
	return globId;
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

		float randHue = random(100);
		c = color(randHue, random(80, 100), random(90, 100)); // couleur par défaut
	}

	void update() {
		setDirection(); // (peut-être) changer de direction
		move(); // calculer le déplacement
		limit(); // limiter au cadre
		draw(); // dessiner le point
		showVector(); // afficher les info internes
		acceleration.mult(0);
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

	void setMagLimit(float maxAcc, float maxSpeed) {
		maxAccelerationMag = maxAcc;
		maxSpeedMag = maxSpeed;
	}

	void updateColor() {
		float newSaturation = map(speed.mag(), 0, maxSpeedMag, 20, 100);
		float newBrightness = map(acceleration.mag(), 0, maxAccelerationMag, 20, 100);
		float newHue = map(noise(position.x, position.y), 0, 1, -1, 1);

		newHue = hue(c) + newHue;
		if (newHue<0) newHue = 100 + newHue * 1;
		if (newHue>100) newHue = 0 + newHue * -1;
		newHue = constrain(newHue, 0, 100);
		c = lerpColor(c, color(newHue, newSaturation, newBrightness), .9);
	}

	void applyForce(PVector force) {
		acceleration.add(force);
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
		ellipse(0, 0, thumbSize, thumbSize);

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

////////////////////////////////////////////////////////////////////////////////
class Splitter extends Mover {

	int maxIteration, tick, childrenQty;
	boolean imAlive;
	Splitter[] children;

	Splitter(float startX, float startY) {
		super(startX, startY);
		maxIteration = 100;
		tick = 0;
		childrenQty = 2;
		imAlive = true;
		setChildren(childrenQty);
	}

	void update() {
		if (imAlive==true) {
			if (tick>=maxIteration) {
				split();
			} else {
				super.update();
				tick += 1;
			}
		} else if (childrenQty>1) {
			childrenUpdate();
		}
		showVector();
	}

	void split() {
		if (childrenQty>1 && maxIteration>=10) {
			float baseRad = PI/random(2, 9);

			for (int i = 0; i < childrenQty; ++i) {

				float rad = map(i+1, 0, childrenQty+1, -baseRad, baseRad); // répartition des enfants sur des angles divergeants

				children[i] = new Splitter(position.x, position.y); // position de départ aléatoire
				children[i].setId(getCleanId());
				children[i].setStartConditions(speed, acceleration, rad); // vitesse et acceleration de départ identique au parent
				children[i].setMagLimit(maxAccelerationMag-1, maxSpeedMag-1); // la magnitude des enfants ne peux pas dépasser celle du parent
				children[i].setMaxIteration(ceil(maxIteration + random(-maxIteration/2, maxIteration/2))); // décaler la fin de vie des enfants pour éviter un effet de ralentissement général
				children[i].setChildren(max(0, childrenQty-1)); // nombre d'enfants réduit 
			}
		}
		imAlive = false;
	}

	void setChildren(int newChildren) {
		childrenQty = newChildren;
		children = new Splitter[childrenQty];
	}

	void childrenUpdate() {
		for (Splitter s : children) {
			s.update();
		}
	}

	void setMaxIteration(int newMaxIteration) {
		maxIteration = newMaxIteration;
	}

	void setStartConditions(PVector nSpeed, PVector nAcceleration, float rad) {
		PVector cSpeed = new PVector(nSpeed.x, nSpeed.y);
		PVector cAcceleration = new PVector(nAcceleration.x, nAcceleration.y);

		//cSpeed.rotate(rad);
		cAcceleration.rotate(rad);

		speed = cSpeed;
		acceleration = cAcceleration;
	}

	boolean isDead() {
		return !imAlive;
	}
	
}

////////////////////////////////////////////////////////////////////////////////
class MoverSystem {
	ArrayList<Splitter> movers;
	int children;

	MoverSystem() {
		movers = new ArrayList<Splitter>();
		children = 3;
	}

	void addMover() {
		Splitter m = new Splitter(random(width), random(height));
		m.setId(getCleanId());
		m.setMagLimit(int(random(1, 6)), int(random(4, 40)));
		m.setChildren(children);
		movers.add(m);
	}

	void applyForce(PVector f) {
		for (Splitter m: movers) {
			m.applyForce(f);
		}
	}

	void update() {
		Iterator<Splitter> it = movers.iterator();
		while (it.hasNext()) {
			Splitter m = (Splitter) it.next();
			m.update();
			if (m.isDead()) {
				//it.remove();
			}
		}
	}

}