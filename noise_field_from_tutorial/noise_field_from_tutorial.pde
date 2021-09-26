OpenSimplexNoise noise;
int[][] result;
float t, c;

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
    println(frameCount,"/",numFrames);
    if (frameCount==numFrames)
      exit();
  }
}

//////////////////////////////////////////////////////////////////////////////

int samplesPerFrame = 1;
int numFrames = 80;        
float shutterAngle = .8;
int N = 40; 
float r = 0.5;
float border = 100;
float val = 1;
boolean recording = false;
float scale = 0.04;
float numOfTentacles = 200;

PVector tentacle(float x, float y){
    float nx = (float) (val * noise.eval(scale*x, scale*y, r*sin(TWO_PI*t), r*cos(TWO_PI*t)));
    float ny = (float) (val * noise.eval(scale*x+500, scale*y, r*sin(TWO_PI*t), r*cos(TWO_PI*t)));  
    return new PVector(nx, ny);
}

void setup(){
  size(500,500);
  noise = new OpenSimplexNoise();
  result = new int[width*height][3];
}

void draw_ () {
  background(0);
  stroke(255, 25);
  strokeWeight(1);
  for(int i = 0; i < N; i++) {
    for(int j = 0; j < N; j++) {
      float x = map(i, 0, N-1, border, width-border);
      float y = map(j, 0, N-1, border, width-border);
      for(int k = 0; k<numOfTentacles; k++) {
        PVector res = tentacle(x, y);
        x+=res.x;
        y+=res.y;
        point(x, y);
      }
      point(x, y);
    }
  }
}
