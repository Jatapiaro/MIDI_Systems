import themidibus.*; //Import the library

//Dynamic rendering

float x, y, incX, incY;
MidiBus myBus; // The MidiBus


void setup() {
  size(800, 400);
  background(#F1B3F2);
  x = y = 50;
  incX = 10;
  incY = 10;
  myBus = new MidiBus(this, 0, 1);
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
  
  if(x > width){
    incX = -1*incX;
    int note = int(map(y-9, 0, height, 0, 127));
    myBus.sendNoteOn(0, note, 60);
  }
  if(y > height){
    incY = -1*incY;
    int note = int(map(x+12, 0, width, 0, 127));
    myBus.sendNoteOn(0, 60, 60);
  }
  
  if(x < 0){
    incX = -1*incX;
    int note = int(map(y+3, 0, height, 0, 127));
    myBus.sendNoteOn(0, note, 60);
  }
  
  if(y < 0){
    incY = -1*incY;
    int note = int(map(x+1, 0, width, 0, 127));
    myBus.sendNoteOn(0, note, 60);
  }
  
  x += incX;
  y += incY;
  
 
  
}