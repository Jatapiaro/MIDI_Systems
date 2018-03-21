import TUIO.*;

InstrumentsMaster master;

/*
* Reactivision stuff 
*/
TuioProcessing tuioClient;

// these are some helper variables which are used
// to create scalable graphical feedback
float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;
PFont font;
boolean verbose = false; // print console debug messages
boolean callback = true; // updates only after callbacks


void setup() {
  this.master = new InstrumentsMaster();
  size(displayWidth,displayHeight);
  this.tuioSetup();
  loop();
}

void draw() {
  background(255);
  textFont(font,18*scale_factor);
  this.drawTheGrid();
  this.drawTuioObjects();
  this.master.play();
}

void drawTheGrid() {
  int cols = 16;
  int rows = 8;
  int boxsizeX = (displayWidth-20)/cols;
  int boxsizeY = (displayHeight)/rows;
  for (int i = 0; i < cols; i++) { 
    for (int j = 0; j < rows; j++) { 
      int x = i*boxsizeX; 
      int y = j*boxsizeY;
      pushMatrix();
      fill(255); 
      stroke(0); 
      rect(x+20, y-20, boxsizeX, boxsizeY); 
      textFont(font, 10); 
      fill(100, 150, 200); 
      popMatrix();
    } 
  } 
}  

@Override
/*
* Custom exit method
*/
void exit() {
  println("Stoped");
  super.exit();
}


/*
* TUIO methods
*/
void tuioSetup() {
  // GUI setup
  noCursor();
  noStroke();
  fill(0);
  
  // periodic updates
  if (!callback) {
    frameRate(60);
    loop();
  } else noLoop(); // or callback updates 
  
  font = createFont("Arial-Bold", 18);
  scale_factor = height/table_size;
  
  // finally we create an instance of the TuioProcessing client
  // since we add "this" class as an argument the TuioProcessing class expects
  // an implementation of the TUIO callback methods in this class (see below)
  tuioClient  = new TuioProcessing(this);
}

void drawTuioObjects() {
  
  float obj_size = object_size*scale_factor; 
  
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0; i < tuioObjectList.size(); i++) {
    
    TuioObject tobj = tuioObjectList.get(i);
    stroke(0);
    fill(0,0,0);
    pushMatrix();
    {
      translate(tobj.getScreenX(width),tobj.getScreenY(height));
      rotate(tobj.getAngle());
      rect(-obj_size/2,-obj_size/2,obj_size,obj_size);
    }
    popMatrix();
    fill(255, 0, 0);
    text(
      ""+tobj.getSymbolID(), 
      tobj.getScreenX(width), 
      tobj.getScreenY(height)
      ); 
    textAlign(CENTER, BOTTOM);
  }
}

// --------------------------------------------------------------
// these callback methods are called whenever a TUIO event occurs
// there are three callbacks for add/set/del events for each object/cursor/blob type
// the final refresh callback marks the end of each TUIO frame

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  if (verbose) println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
  this.master.addFiducial(tobj.getSymbolID());
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  if (verbose) println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
          +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());   
          
          this.master.updateFiducial(tobj.getSymbolID(), tobj.getAngleDegrees());
          
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
  this.master.removeFiducial(tobj.getSymbolID());
}

// --------------------------------------------------------------
// called at the end of each TUIO frame
void refresh(TuioTime frameTime) {
  if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
  if (callback) redraw();
}