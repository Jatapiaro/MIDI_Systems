import themidibus.*;
import TUIO.*;
import java.util.*;

public class SynthController {

  /*
  * Variables for all synths
  */
  private boolean hasModeFiducial, hasNoteDownFiducial, hasNoteUpFiducial;
  private Fiducials fiducials;
  private int channel, inDeviceNum, outDeviceNum;
  private MidiBus midiBus;
  private Note note;
  private String mode;
  private HashMap<Integer, TuioBlob> onScreenFiducials;
  
  
  /*
  * Variables to handle the arpeggi mode
  */
  private ArrayList<Integer> scaleToRandomize;
  private float differenceBetweenNotes, lastTimeOfNote;
  private int[] scale = { 0, 1, 3, 5, 7, 8, 10 };
  private Note lastNote;
  
  /*
  * Variables to handle synth mode
  */
  private boolean sendNote = false;
  private Note previousNote;
  
  
  /**
  * Constructor 
  * Initialice the Synth
  */
  public SynthController() {
    
    /*
    * Start the midi bus
    */
    this.channel = 0;
    this.inDeviceNum = 0;
    this.outDeviceNum = 1;
    this.midiBus = new MidiBus(this, this.inDeviceNum, this.outDeviceNum);
    this.note = new Note(channel, 60, 127);
    this.previousNote = new Note(channel, 60, 70);
    
    
    /*
    * Initialice custom fiducials obects
    */
    this.fiducials = new Fiducials();
    this.onScreenFiducials = new HashMap<Integer, TuioBlob>();
    this.startHasParams();
    this.mode = "";
    
    /*
    * Initialize variables for
    * arpeggi mode
    */
    this.lastTimeOfNote = millis();
    this.differenceBetweenNotes = 750; //Milliseconds
    this.scaleToRandomize = new ArrayList<Integer>();
    
    /*
    * Initialize variables for synth mode
    */
    this.lastNote = new Note(this.channel, 60, 127);
    
  }
  
  
  /**
  * @return boolean
  * Tell us if all the needed fiducials are on screen
  */
  private boolean canStartRunning() {
    return this.hasModeFiducial && this.hasNoteUpFiducial && this.hasNoteDownFiducial;
  }
  
  
  /**
  * Change the current controller mode
  * @param String fiducialName
  * which is the name defined in fiducials enum 
  * for a fiducial which has a function of mode
  */
  private void changeMode(String fiducialName){
    
    /*
    * If we don't have a fiducialMode, the
    * synth will not play, so, when a fiducial mode
    * enters, we say that now we have a modeFiducial
    */
    if ( this.hasModeFiducial == false ) {
      this.hasModeFiducial = true;
    }
    
    /*
    * If accidentally we hide a fiducial of mode
    * and enters again to the screen, we validate if
    * that fiducial is the same that we already have.
    * If its different, we reset the params and 
    * start playing the new mode
    */
    if ( !this.mode.equals(fiducialName) ) {
      this.mode = fiducialName;
      this.resetParams();
    }
    
  }

  /**
  * Change the current note
  * @param boolean up 
  * If up is true it means that we have to go a half step up
  * else if it's false we have to go down half step.
  * Se the noew will increase or decrease its value
  */
  private void changeNote( boolean up ) {
    int currentNote = ( up )? (this.note.pitch + 1) : (this.note.pitch - 1);
    this.note.setPitch(currentNote);
    this.sendNote = true;
  }  
  
  /**
  * Returns a list of FiducialFunction into a readable string
  * @param ArrayList<FiducialFunction> list -> to be converted to readable string
  * @return String with the list in a readable way
  */
  private String formatList(ArrayList<FiducialFunction> list) {
    StringBuilder sb = new StringBuilder();
    int index = 1;
    for ( FiducialFunction f : list ) {
      sb.append(index + ". " + f.id + " for " + f + "\n");
      index++;
    }
    return sb.toString();
  }  
  
  
  public void handleEnterOfFiducial( TuioObject tobj ) {
    
    FiducialFunction ff = this.fiducials.getFiducialFunctionFromId(tobj.getSymbolID());
  
    if ( ff != null ) {
      String function = ff.fiducialFunction;
      if ( function.equals( FunctionsEnum.MODE.toString() ) ) {
        
        this.changeMode( ff.fiducialName );
        
      } else if ( function.equals( FunctionsEnum.BUTTON.toString() ) ) {
        this.handleEnterOfButtonFiduccial(ff);
      }
    }
    
  }
  
  private void handleEnterOfButtonFiduccial(FiducialFunction ff) {
    
    if ( ff.fiducialName.equals( FiducialsEnum.NOTEUP.toString() ) ) {
      
      this.hasNoteUpFiducial = true;
      
    } else if ( ff.fiducialName.equals( FiducialsEnum.NOTEDOWN.toString() ) ) {
      
      this.hasNoteDownFiducial = true;
      
    }
    
  }
  
  
  private void resetParams() {
    this.sendNote = false;
    this.midiBus.sendNoteOff(note);
    this.midiBus.sendNoteOff(previousNote);
    this.midiBus.sendNoteOff(lastNote);
  }
  

  
  public void handleExitOfFiducial( TuioObject tobj ) {
    
  
    FiducialFunction ff = this.fiducials.getFiducialFunctionFromId(tobj.getSymbolID());
  
    if ( ff != null ) {
      String function = ff.fiducialFunction;
      if ( function.equals( FunctionsEnum.BUTTON.toString() ) ) {
        this.handleExitOfButtonFiduccial(ff);
      }
    }
    
  }
  
  private void handleExitOfButtonFiduccial( FiducialFunction ff ) {
    
    if ( ff.fiducialName.equals( FiducialsEnum.NOTEUP.toString() ) ) {
      
      this.changeNote(true);
      
    } else if ( ff.fiducialName.equals( FiducialsEnum.NOTEDOWN.toString() ) ) {
      
      this.changeNote(false);
      
    }
    
  }
  
  
  public void play() {
    if ( this.canStartRunning() ) {
      this.play(true);
    } else {
      println(missingFiducials());
    }
  }
  
  private void play( boolean play ) {
    
    if ( this.mode.equals(FiducialsEnum.ARPEGGI.toString()) ) {
      playAsArpeggi();
    } else if ( this.mode.equals(FiducialsEnum.SYNTH.toString()) ) {
      playAsSynth();
    }
    
  }
  
  private void playAsArpeggi() {
    
    if ( this.scaleToRandomize.size() == 0 ) {
      this.scaleToRandomize = new ArrayList<Integer>();
      for ( int i : scale ) {
        this.scaleToRandomize.add(i);
      }
      Collections.shuffle(this.scaleToRandomize);
    }
    
    int millis = millis();
    if ( millis > (this.lastTimeOfNote + this.differenceBetweenNotes) ) {
      
      if ( this.lastNote != null ) {
        this.midiBus.sendNoteOff(this.lastNote);
      }
      
      
      int currentPitch = this.note.pitch;
      int currentVelocity = this.note.velocity;
      int currentNoteChannel = this.note.channel;
      
      int nextPitch = int(random(scaleToRandomize.size()));
      currentPitch += this.scaleToRandomize.get(nextPitch);
      this.scaleToRandomize.remove(nextPitch);
      
      this.lastNote = new Note(currentNoteChannel, currentPitch, currentVelocity);
      
      this.midiBus.sendNoteOn(lastNote);
      this.lastTimeOfNote = millis;
      
    }
    
  }
  
  private void playAsSynth() {
    if ( this.sendNote ) {
      this.sendNote = false;
      this.midiBus.sendNoteOn(note);
      this.midiBus.sendNoteOff(note);
    }
  }
  
  private void startHasParams() {
    this.hasModeFiducial = false;
    this.hasNoteUpFiducial = false;
    this.hasNoteDownFiducial = false;
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
      return sb.toString();
    } 
    if ( !this.hasNoteDownFiducial ) {
      sb.append("You are missing a Note-Down fiducial, please put the next fiducial with ID: ");
      sb.append(this.fiducials.getFiducialIdFromFiducialName(FiducialsEnum.NOTEDOWN.toString()));
      sb.append("\n");
      return sb.toString();
    }
     if ( !this.hasNoteUpFiducial ) {
      sb.append("You are missing a Note-Up fiducial, please put the next fiducial with ID: ");
      sb.append(this.fiducials.getFiducialIdFromFiducialName(FiducialsEnum.NOTEUP.toString()));
      sb.append("\n");
      return sb.toString();
    }
    return sb.toString();
  }
  

  
  public void stopPlaying() {
    if ( this.lastNote != null ) {
      this.midiBus.sendNoteOff(this.lastNote);
    }
    this.midiBus.sendNoteOff(this.note);
  }
  

}