int numFrames = 30;
int m = 10;
int n = 10;
float delay_factor = 2;
float motion_radius = 0.5;
float offset_factor = 0.5;
float radius = 150;
OpenSimplexNoise noise;
int[][] result;
float t, c;
int samplesPerFrame = 3;
float shutterAngle = 2;
boolean recording = true;

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

float mn = .5*sqrt(3), ia = atan(sqrt(.5));

void push() {
  pushMatrix();
  pushStyle();
}

void pop() {
  popStyle();
  popMatrix();
}

void draw() {

  if (!recording) {
    t = mouseX*1.0/width;
    c = mouseY*1.0/height;
    if (mousePressed)
      println(c);
    draw_();
  } else {
    for (int i=0; i<width*height; i++)
      for (int a=0; a<3; a++)
        result[i][a] = 0;

    c = 0;
    for (int sa=0; sa<samplesPerFrame; sa++) {
      t = map(frameCount-1 + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
      draw_();
      loadPixels();
      for (int i=0; i<pixels.length; i++) {
        result[i][0] += pixels[i] >> 16 & 0xff;
        result[i][1] += pixels[i] >> 8 & 0xff;
        result[i][2] += pixels[i] & 0xff;
      }
    }

    loadPixels();
    for (int i=0; i<pixels.length; i++)
      pixels[i] = 0xff << 24 | 
        int(result[i][0]*1.0/samplesPerFrame) << 16 | 
        int(result[i][1]*1.0/samplesPerFrame) << 8 | 
        int(result[i][2]*1.0/samplesPerFrame);
    updatePixels();

    saveFrame("fr###.png");
    //println(frameCount,"/",numFrames);
    if (frameCount==numFrames)
      exit();
  }
}

class WiggleLine {
    float seedX = random(1, 5000);
    float seedY = random(1, 5000);
    float theta;

    float x;
    float y;


    WiggleLine(float theta_) {
        theta = theta_;
        x = 250 + radius * cos(theta);
        y = 250 + radius * sin(theta);
    }

    void show() {
        pushStyle();
                noStroke();
        ellipse(x(t), y(t), 8, 8);

        popStyle();
    }

    float x(float t) {
        return x + 50 * (float) noise.eval(seedX + motion_radius * cos(TWO_PI * t), motion_radius * sin(TWO_PI * t));
    }
    float y(float t) {
        return y + 50 * (float) noise.eval(seedY + motion_radius * cos(TWO_PI * t), motion_radius * sin(TWO_PI * t));
    }
}

WiggleLine[] array = new WiggleLine[n];

void setup() {
  result = new int[width*height][3];
  noise = new OpenSimplexNoise();
    size(500, 500, P3D);
    strokeWeight(1);
    stroke(241, 241, 241, 100);
    for (int i = 0; i < n; i++) {
        float theta = TWO_PI * i / n;
        array[i] = new WiggleLine(theta);
    }
}

void draw_() {
    //println("saving frame " + frameCount + "/" + numFrames);
    background(1);
    for (int i = 0; i < n; i++) {
        array[i].show();
    }

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < i; j++) {
            for (int k = 0; k <= m; k++) {
                float tt = 1.0 * k / m;

                float xx = lerp(array[i].x(t - offset_factor * tt), array[j].x(t - offset_factor * (1 - tt)), tt);
                float yy = lerp(array[i].y(t - offset_factor * tt), array[j].y(t - offset_factor * (1 - tt)), tt);

                point(xx, yy);
            }
        }
    }

    //if(frameCount<=numFrames) saveFrame("fr###.png");
    //if(frameCount == numFrames) stop();
}
