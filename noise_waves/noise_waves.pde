int samplesPerFrame = 5;
int numFrames = 80;        
float shutterAngle = .8;
boolean recording = false;
OpenSimplexNoise noise;
float space = 50;
float quant = 1;
float radius = 0.45;
float scale = 0.008;
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
void setup(){
  size(500,500);
  background(0);
  strokeWeight(1);
  stroke(255, 150);
  noise = new OpenSimplexNoise();
}

void draw_(){
  float t = 1.0*(frameCount-1)/numFrames;
  background(0);
  for(float y = space; y<=height-space; y+=space){
    beginShape();
    fill(0);
    vertex(-10, 510);
    vertex(-10, y);
    for(float x =0 ; x<=width; x+=quant){
       float ny = (float)noise.eval(scale * x + scale * y, radius*cos(TWO_PI*t + y*10), radius*sin(TWO_PI*t + y*10));
       float nval = map(ny, -1, 1, -height/4, height/4);
       vertex(x, y + nval);
    }
    vertex(510, y);
    vertex(510, 510);
    endShape();
  }
  
  
  println(frameCount);
  
  saveFrame("fr###.png");
  
  if(frameCount==numFrames){
    //saveFrame("a###.png");
    stop();
    println("finished");
  }
  
}
