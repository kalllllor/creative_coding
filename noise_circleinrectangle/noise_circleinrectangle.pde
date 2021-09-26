OpenSimplexNoise noise;


int samplesPerFrame = 1;
int numFrames = 100;
float shutterAngle = .8;
float totalWidth = 0;
float r = 0.5;
float scale = 0;
float recWidth = 5;
float[] columnWidthArray = new float[0];

void setup() {
  size(500, 500);
  noise = new OpenSimplexNoise();
  while (totalWidth < width) {
    float columnWidth = round(random(10, 100));
    if (totalWidth + columnWidth > width) {
      columnWidth = width - totalWidth;
    }
    columnWidthArray = expand(columnWidthArray, columnWidthArray.length + 1);
    columnWidthArray[columnWidthArray.length-1] = columnWidth;
    totalWidth += columnWidth;
  }
  totalWidth = 0;
}

void draw() {
  float columnWidth = 0;
  float t = 1.0*frameCount/numFrames;
  background(0);
  for (int i = 0; i < columnWidthArray.length; i++) {
    totalWidth += columnWidthArray[i];
    columnWidth = columnWidthArray[i];
    scale = 1/(columnWidth/width);
    for (int j = 0; j < height; j++) {
      boolean ns = noise.eval((totalWidth-columnWidth/2)*scale, j*scale + 1000, r*sin(TWO_PI*t), r*cos(TWO_PI*t)) > 0 ? true : false;
      stroke(ns ? 255 : 0);
      line(totalWidth - columnWidth, j, totalWidth, j);
    }
  }
  totalWidth = 0;
  saveFrame("fr###.png");
  println(t);
  println(frameCount);
  if (frameCount==numFrames) {
    //saveFrame("a###.png");
    stop();
    println("finished");
  }
}
