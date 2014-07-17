int tick;
int maxTick;
int circles;

void setup() {
    size(400, 400);
    noStroke();
    smooth();
    background(0);
    tick = 0;
    maxTick = 200;
    circles = 30;
    
    println("I'm alive!");
}

void draw() {
    if (tick<maxTick) {
        for (i=0; i<circles; ++i) {
            float size = random(3, 16);
            color c = color(random(255), random(255), random(255));
            
            fill(c);
            ellipse(
                random(width),
                random(height),
                size,
                size
            );
            
            
        }
        tick++;
    }
}