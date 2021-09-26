int numFrames = 1;
float space = 25;
float radius = 0.45;
PVector field(float x,float y){
  float amount = 26;
  float scale = 0.03;

  double value1 = noise.eval(x,y,radius*cos(TWO_PI*1.0*(frameCount-1)/numFrames),radius*sin(TWO_PI*1.0*(frameCount-1)/numFrames));
  double value2 = noise.eval(1000+scale*x,scale*y,radius*cos(TWO_PI*1.0*(frameCount-1)/numFrames),radius*sin(TWO_PI*1.0*(frameCount-1)/numFrames));
  
  if(value1 > 0) return new PVector(space, space);
  else return new PVector(-space, space);
}

OpenSimplexNoise noise;

void setup(){
  size(500,500);
  background(0);
  stroke(255, 255);
  noise = new OpenSimplexNoise();
}

void draw(){
  float t = 1.0*(frameCount-1)/numFrames;
  background(0);
  for(float x = 0;x<=width;x+=space){
    for(float y=0;y<=height;y+=space){
       float ns = (float)noise.eval(space*x,space*y,radius*cos(TWO_PI*t),radius*sin(TWO_PI*t));
      noFill();
        if(ns > 0) line(x, y, x + space, y + space);
        else line(x + space, y, x, y+space);
    }
  }
  
  
  println(frameCount);
  
  saveFrame("fr###.png");
  
  if(frameCount==numFrames){
    //saveFrame("a###.png");
    stop();
    println("finished");
  }
  
}
