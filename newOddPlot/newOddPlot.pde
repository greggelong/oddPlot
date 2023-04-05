// pixel array is so much faster
// I hope the comments help me remember the neet way to change colors
int iter;
float maxx, minx;
float maxy, miny;
float zoom = 0.1;
// color 100 will be set to black so the biggest iter value possible  is 99
float clrMod = 5;
// but it looks wild with smaller number like 20 or 8
// 50 is a nice comprimise
void setup() {
  size(1028, 1028);
  //fullScreen();
  colorMode(HSB, clrMod);
  maxx =5;
  minx=-5;
  maxy=5;
  miny=-5;
}


void draw() {
  loadPixels();
  showplot();
  updatePixels();
  //noLoop();
}

void mousePressed() {
  float x = map(mouseX, 0, width, minx, maxx);  // set the x on complex plane
  float y = map(mouseY, 0, height, miny, maxy); // s
  // center and zoom those coordinates
  maxx = x+zoom;
  minx = x-zoom;
  maxy = y+zoom;
  miny = y-zoom;

  zoom/=2;
  if (zoom<0.00001) {
    zoom=1;
    maxx =5;
    minx=-5;
    maxy=5;
    miny=-5;
  }
}

void mouseDragged() {
  // changes the colorMod which effects how many colors out of total are used

  clrMod+= 0.1;
  // if you want to change the absolute number of colors you chan then
  // set
  //colorMode(HSB,clrMod); //and then it will just use absolute number

  if (clrMod > 64) {
    clrMod = 1;
  }
}

void keyPressed() {
  if ( key == 'h') {
  }
}

/*
for this plot the functions are
sine and cos with a raduis of 20
functions:
  float nextx =sin(x)*20;
  float nexty = cos(y)*20;
x and y range:
-5 to 5

maximum iterations:
maxiter = 10:

breakout point:
breakOut = 20
if (abs(x+y)>breakOut) 
the absolute value of x and y added toogether

if the max iterations are reached without going over the breakout point
black pixels are plotted
if less than max iterations color of the pixel is placed by number of iterations before breakout

*/

void showplot() {
  //background(0);
  // get pixels from canvas using i and j
  for (int j = 0; j <height; j++) {
    for (int i =0; i <width; i++) {
      // map those to x and y coords in the range of min and max eg -5 to 5
      float x = map(i, 0, width, minx, maxx);  // set the x on complex plane
      float y = map(j, 0, height, miny, maxy); //  yset y on  the complex plane
      // get a copy of thoes ranges before iterating the values
      float cx=x;
      float cy =y;
      // set max iterater
      float maxiter = 10;
      float breakOut = 20;
        iter =0;
      while (iter < maxiter) {
        // iterate functions for x and y
        // put values in nextx and nexty
        float nextx =sin(x)*(20);
        float nexty = cos(y)*(20);
        // swap values so x and y become nextx and nexty and are fed into function
        x = nextx;
        y = nexty;

        // a break out check if the iterated number becomes large, note this is very different from the number of iterations
        // for sine and cosine functions changing the breakout can create more interesting  
        if (abs(x+y)>breakOut) {
          // I cound break out at 2 as it is proved for the mandelbrot any
          // orbit greater than 2 goes to infinity
          // but it lools better when the points have bigger iter numbers
          // which affects the color
          break;
        }
        iter++;
      }
      //println(iter);
      if (iter == maxiter) {
        // black pixels are part of the julia set for that function
        pixels[i+j*width] =color(0, 0, 0);
      } else {
        pixels[i+j*width] = color(iter%clrMod, 100, 100);
      }
    }
  }
}
