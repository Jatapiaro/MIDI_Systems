import themidibus.*;


float x,y, incX, incY, velX, velY, accX, accY, grv;

MidiBus bus;

/*
* Executed only once
*  at the beggining of the program
*/
void setup() {
  
  drawCanvas();
  
  size(600, 400);
  
  MidiBus.list();
  
  bus = new MidiBus(this, 0, 1);
  
  println(bus);
  
  incX = incY = 1;
  
  x = random(0, width);
  y = random(0, height);
  
  velX = velY = 0;
  
  grv = 0.1;
  
  
}


/*
* Inifnite loop
* here we draw
*/
void draw() {
  
  velY = grv+velY;
  mouseInteraction();
  
  drawCanvas();
  
  ellipse(x, y, 20, 20);
  x += velX; y+= velY;
  
  if ( x >= width || x <= 0 ) {
    velX *= -1;
    int note = int( map(y, 0, height, 0, 127) );
    bus.sendNoteOn(0, int(note), 127);
  }
  
  if ( y >= height || y <= 0 ) {
    velY *= -1;
    int note = int( map(x, 0, width, 0, 127) );
    bus.sendNoteOn(0, int(note), 127);
  }
  
}

void mouseInteraction() {

  
    accX = (abs(mouseX-x) < 200 )? abs(mouseX-x) * 0.001 : 0; 
    accY = (abs(mouseY-y) < 200 )? abs(mouseX-x) * 0.001 : 0;
    
    velY += accY;
    velX += accX;
  
}

void drawCanvas() {
  background(127, 90, 30);
}