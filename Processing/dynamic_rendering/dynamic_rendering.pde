//Dynamic rendering

float x, y, incX, incY;


void setup() {
  size(800, 400);
  background(#F1B3F2);
  x = y = 50;
  incX = 1;
  incY = 1;
}

void draw() {
  
  background(#F1B3F2);
  //color of the draw
  stroke(90, 129, 255);
  fill(127, 30, 75);
  
  //position and then size
  //rectMode(CENTER);
  rect(x, y, 100, 100);
  
  fill(255, 255, 250);
  ellipseMode(CORNER);
  ellipse(x, y, 100, 100 );
  
  if ( x > width ) {
    incX = -1 * incX;
  }
  
  if ( y > height ) {
    incY = -1 * incY;
  }
  
  if ( x < 0 ) {
    incX = -1 * incX;
  }
  
  if ( y < 0 ) {
    incY = -1 * incY;
  }
  
  x += incX;
  y += incY;
  
 
  
}