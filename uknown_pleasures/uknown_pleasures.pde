int samplesPerFrame = 5;
int numFrames = 80;        
float shutterAngle = .8;
boolean recording = true;
OpenSimplexNoise noise;
float space = 5;
float radius = 0.45;
float scale = 0.008;
int[][] result;
float t, c;
int recWidth=150;
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
  size(500, 500);
  result = new int[width*height][3];
  noise = new OpenSimplexNoise();
}

void draw_(){
  strokeWeight(1);
  background(0);
  for(float y = recWidth-50; y<=height-recWidth+50; y+=space){
    beginShape();
    fill(0);
    vertex(recWidth, width);
    vertex(recWidth, y);
    stroke(255,255);
    for(float x = recWidth ; x<=width-recWidth; x++){
       float intensity = ease(pow(constrain(map(dist(x,0,width/2,0),0,0.5*width-recWidth,1,0),0,1),3),2.0);
       float ny = (float)noise.eval(0.09 * x + y * 500 , radius*cos(TWO_PI*t + y*15), radius*sin(TWO_PI*t + y*15));
       float nval = y + intensity * map(ny, -1, 1, -height/24, height/24);
       vertex(x, nval);
    }
    vertex(width-recWidth, y);
    vertex(width-recWidth, width);
    endShape();
    noStroke();
    rect(0, 0, recWidth+2, width); 
    rect(width-recWidth-2, 0, width, width);  
}
}
