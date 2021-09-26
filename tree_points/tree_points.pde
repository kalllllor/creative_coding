int numFrames = 500;
float t;
int m = 500;
int n = 10;
float delay_factor = 1.0;
float motion_radius = 1;
OpenSimplexNoise noise;

class WiggleLine {
    float seedX = random(1, 5000);
    float seedY = random(1, 5000);
    float xx = random(0.1, 0.9);
    float yy = random(0.15, 0.30);

    void show() {
        ellipse(x1(t), y1(t), 6, 6);
        pushStyle();
        strokeWeight(1);
        stroke(255, 100);
        for (int i = 0; i <= m; i++) {
            float tt = 1.0 * i / m;
            float x = lerp(x1(t - delay_factor * tt), 0.5*width, tt);
            float y = lerp(y1(t - delay_factor * tt), 0.9*height, tt);
            point(x, y);
        }

        popStyle();
    }

    float x1(float t) {
        return xx * width + 50 * (float) noise.eval(seedX + motion_radius * cos(TWO_PI * t), motion_radius * sin(TWO_PI * t));
    }
    
    float y1(float t) {
        return yy * height + 50 * (float) noise.eval(seedY + motion_radius * cos(TWO_PI * t), motion_radius * sin(TWO_PI * t));
    }
}

WiggleLine[] array = new WiggleLine[n];

void setup() {
    noise = new OpenSimplexNoise();
    size(500, 500, P3D);

    stroke(255);
    fill(255);

    for (int i = 0; i < n; i++) {
        array[i] = new WiggleLine();
    }
}

void draw() {
    t = 1.0 * (frameCount - 1) / numFrames;
    //println("saving frame " + frameCount + "/" + numFrames);
    background(0);
    for(int i=0;i<n;i++){
      array[i].show();
    }

    //if(frameCount<=numFrames) saveFrame("fr###.png");
    //if(frameCount == numFrames) stop();
}
