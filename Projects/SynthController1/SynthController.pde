import themidibus.*;
import TUIO.*;

public class SynthController{

  private int channel, inDeviceNum, outDeviceNum;
  private boolean hasModeFiducial, hasNoteDownFiducial, hasNoteUpFiducial;
  private Fiducials fiducials;
  private MidiBus midiBus;
  private Note note;
  private HashMap<Integer, TuioBlob> onScreenFiducials;
  
  private String mode;
  
  public SynthController() {
    
    this.channel = 0;
    this.inDeviceNum = 0;
    this.outDeviceNum = 1;
    this.midiBus = new MidiBus(this, this.inDeviceNum, this.outDeviceNum);
    note = new Note(channel, 60, 127);
    this.fiducials = new Fiducials();
    this.onScreenFiducials = new HashMap<Integer, TuioBlob>();
    this.startHasParams();
    
    this.mode = null;
  }
  
  public void handleEnterOfFiducial( TuioObject tobj ) {
    FiducialFunction ff = this.fiducials.getFiducialFunctionFromId(tobj.getSymbolID());
  
    
    if ( ff.fiducialFunction.equals( FunctionsEnum.MODE.toString() ) ) {
      println("Se detecto modo");
      this.changeMode( ff.fiducialName );
    }
    
  }
  
  private void changeMode(String fiducialName){
    this.mode = fiducialName;
    if ( this.hasModeFiducial == false ) {
      this.hasModeFiducial = true;
    }
  }
  
  public void handleExitOfFiducial() {
  }
  
  public void noteDown() {
  }
  
  public void noteUp() {
  }
  
  public void play() {
    if ( this.canStartRunning() ) {
      println("Im running");
    } else {
      println(missingFiducials());
    }
  }
  
  private void startHasParams() {
    this.hasModeFiducial = false;
    this.hasNoteUpFiducial = false;
    this.hasNoteDownFiducial = false;
  }
  
  private boolean canStartRunning() {
    return this.hasModeFiducial; //&& this.hasNoteUpFiducial && this.hasNoteDownFiducial;
  }
  
  private String missingFiducials() {
    StringBuilder sb = new StringBuilder();
    if ( !this.hasModeFiducial ) {
      sb.append("You are missing a Mode fiducial, please choose one of the following: \n");
      sb.append(
        this.formatList(
          this.fiducials.listAllFiducialsWithFunction(FunctionsEnum.MODE.toString())
        )
      ); 
    }
    return sb.toString();
  }
  
  private String formatList(ArrayList<FiducialFunction> list) {
    StringBuilder sb = new StringBuilder();
    int index = 1;
    for ( FiducialFunction f : list ) {
      sb.append(index + ". " + f.id + " for " + f + "\n");
      index++;
    }
    return sb.toString();
  }
  

}