int numFrames = 30;
float t;
int m = 1000;
int n = 10;
float delay_factor = 1.0;
float motion_radius = 1;
int [] [] seedMatrix = new int [m] [m];
OpenSimplexNoise noise;

class WiggleLine {
    float seedX;
    float seedY;
    float theta;
    float radius = 150;
    float x;
    float y;

   
    WiggleLine(float theta_){
      theta = theta_;
      x = 250 + radius*cos(theta);
      y = 250 + radius*sin(theta);  
  }

    void show() {
      stroke(255,200);
      strokeWeight(6);
      point(x, y);
    }

    float x(float t, int seed) {
        return x + 50 * (float) noise.eval(seed + motion_radius * cos(TWO_PI * t), motion_radius * sin(TWO_PI * t));
    }
    float y(float t, int seed) {
        return y + 50 * (float) noise.eval(seed + motion_radius * cos(TWO_PI * t), motion_radius * sin(TWO_PI * t));
    }
}

WiggleLine[] array = new WiggleLine[n];

void setup() {
    for (int i=0; i<seedMatrix.length; i++) {
      for (int j=0; j<seedMatrix[i].length; j++) {
        seedMatrix[i][j] = (int) (random(1, 5000));
      }           
    }
    noise = new OpenSimplexNoise();
    size(500, 500, P3D);
    stroke(255);
    fill(255);
    
    for (int i = 0; i < n; i++) {
        float theta = TWO_PI*i/n;
        array[i] = new WiggleLine(theta);
    }
}

void draw() {
    t = 1.0 * (frameCount - 1) / numFrames;
    //println("saving frame " + frameCount + "/" + numFrames);
    background(0);
    for(int i=0;i<n;i++){
      array[i].show();
    }
    
      for(int i=0;i<n;i++){
    float theta = TWO_PI*i/n;
    array[i] = new WiggleLine(theta);
  }
  
  for(int i = 0; i<n; i++) {
    for(int j = 0; j<n; j++) {
      for(int k = 0; k<m; k++) {
        float tt = 1.0*k/m;
          float x = lerp(array[i].x(t - delay_factor*tt, seedMatrix[1][1]),  array[j].x(t - delay_factor*(tt - 1), seedMatrix[1][2]),  tt);
          float y = lerp(array[i].y(t - delay_factor*tt, seedMatrix[1][4]),  array[j].y(t - delay_factor*(tt - 1), seedMatrix[1][3]),  tt);
          strokeWeight(1);
          point(x,y);
      }
    }
  }

    //if(frameCount<=numFrames) saveFrame("fr###.png");
    //if(frameCount == numFrames) stop();
}
