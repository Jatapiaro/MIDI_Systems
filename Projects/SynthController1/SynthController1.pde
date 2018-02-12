/*
* @author Jacobo Tapia - A01336590
* @author Sofía Aguirre - A01332562
* @author Maximiliano Carmona Miranda - A01650052
*
*/

import TUIO.*;

SynthController synthController;
Fiducials fiducials;
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
  
  synthController = new SynthController();
  //GUI setup
  size(displayWidth,displayHeight); //Just here because is not allowed in a method
  this.tuioSetup();
  
}

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

void draw() {
  background(255);
  textFont(font,18*scale_factor);
  this.drawTuioObjects();
  if ( !synthController.canStartRunning() ) {
    pushMatrix();{
      fill(0, 0, 0);
      text(synthController.missingFiducials(), (width/2)-(width/4), height/2);
      textAlign(CENTER, CENTER);
    }
    popMatrix();
  }
  synthController.play();
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
    String info = this.synthController.getTextForDisplay(tobj);
    text(
      ""+info, 
      tobj.getScreenX(width), 
      tobj.getScreenY(height)
      ); 
    textAlign(CENTER, BOTTOM);
  }
}

@Override
void exit() {
  println("Stoped");
  this.synthController.stopPlaying();
  super.exit();
}

// --------------------------------------------------------------
// these callback methods are called whenever a TUIO event occurs
// there are three callbacks for add/set/del events for each object/cursor/blob type
// the final refresh callback marks the end of each TUIO frame

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  if (verbose) println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
  this.synthController.handleEnterOfFiducial(tobj);
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  if (verbose) println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
          +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
  
  this.synthController.handleUpdateOfFiducial(tobj);        
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
  this.synthController.handleExitOfFiducial(tobj);
}

// --------------------------------------------------------------
// called at the end of each TUIO frame
void refresh(TuioTime frameTime) {
  if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
  if (callback) redraw();
}