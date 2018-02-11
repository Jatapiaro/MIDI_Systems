import themidibus.*;
import TUIO.*;
import java.util.*;

public class SynthController {

  /*
  * Variables for all synths
  */
  private boolean hasModeFiducial, hasNoteDownFiducial, hasNoteUpFiducial,
    hasMartenotRing;
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
  
  /*
  * Variables to handle martenot mode
  */
  private boolean isPlayingNote = false;
  private float startX = 0.0f;
  
  
  
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
    return this.hasModeFiducial && this.hasNoteUpFiducial && this.hasNoteDownFiducial &&
      this.hasMartenotRing;
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
    if ( !this.mode.equals(FiducialsEnum.MARTENOT.toString()) ) {
      int currentNote = ( up )? (this.note.pitch + 1) : (this.note.pitch - 1);
      this.note.setPitch(currentNote);
      //If we detect a note change we tell the program to send it to the instrument
      this.sendNote = true;
    }
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
  
  public String getTextForDisplay( TuioObject tobj ) {
    
    
    StringBuilder sb = new StringBuilder();
    /*
    * We verify which function has the fiducial that just enters
    * se we check in our Fiducials object, what we assigned to that id
    */
    FiducialFunction ff = this.fiducials.getFiducialFunctionFromId(tobj.getSymbolID());
    
    if ( ff != null ) {
      
      String name = ff.fiducialName;
      
      if ( name.equals(FiducialsEnum.NOTEUP.toString()) ) {
        Note n = new Note( this.channel, (this.note.pitch+1), this.note.velocity );
        sb.append("Note Up -> " + n.name());
        return sb.toString();
      }
      
      if ( name.equals(FiducialsEnum.NOTEDOWN.toString()) ) {
        Note n = new Note( this.channel, (this.note.pitch-1), this.note.velocity );
        sb.append("Note Down -> " + n.name());
        return sb.toString();
      }
      
      if ( name.equals(FiducialsEnum.ARPEGGI.toString()) ) {
        sb.append(ff.visualText());
        return sb.toString();
      }      
      
      if ( name.equals(FiducialsEnum.MARTENOTRING.toString()) ) {
        sb.append("Ring: "+this.note.name());
        return sb.toString();
      }         
      
    }
     return sb.toString();
  }
  
  /**
  * Handles the enter of a fiducial on screen
  * @param TuioObject obj the object that enters on the screen
  */
  public void handleEnterOfFiducial( TuioObject tobj ) {
    
    /*
    * We verify which function has the fiducial that just enters
    * se we check in our Fiducials object, what we assigned to that id
    */
    FiducialFunction ff = this.fiducials.getFiducialFunctionFromId(tobj.getSymbolID());
  
    
    /*
    * If that id exists on our configuration
    */
    if ( ff != null ) {
      
      
      //We take the function that this fiducial does
      String function = ff.fiducialFunction;
      
      //If it acts as a MODE fiducial
      if ( function.equals( FunctionsEnum.MODE.toString() ) ) {
        //We change the current mode of control
        this.changeMode( ff.fiducialName );
        
        //Else if it has a Button Function
      } else if ( function.equals( FunctionsEnum.BUTTON.toString() ) ) {
        //We handle what this button does
        this.handleEnterOfButtonFiducial(ff);
      } else if ( function.equals( FunctionsEnum.MODE.toString() ) ) {
        this.changeMode( ff.fiducialName );
      } else if ( function.equals( FunctionsEnum.SLIDE.toString() ) ) {
        this.handleEnterOfSlideFiducial(ff, tobj.getPosition().getX());
      }
      
    } 
  }
  
  
  /**
  * Handles if a fiduccial enters and his function is to act as a button
  * @param FiducialFunction ff to check
  */
  private void handleEnterOfButtonFiducial(FiducialFunction ff) {
    
    //If this fiducial has to execute a note up
    if ( ff.fiducialName.equals( FiducialsEnum.NOTEUP.toString() ) ) {
      
      this.hasNoteUpFiducial = true;
      
    //If this fiducial has to execute a note down  
    } else if ( ff.fiducialName.equals( FiducialsEnum.NOTEDOWN.toString() ) ) {
      
      this.hasNoteDownFiducial = true;
      
    }
    
  }
  
  /**
  * Handles if a fiduccial enters and his function is to act as an Slide
  * @param FiducialFunction ff to check
  */
  private void handleEnterOfSlideFiducial(FiducialFunction ff, float startX) {
    if ( ff.fiducialName.equals( FiducialsEnum.MARTENOTRING.toString() ) ) {
      this.hasMartenotRing = true;
      this.startX = startX;
    }
  }
  
  /**
  * Handles the exit of a fiducial from the screen
  * @param TuioObject obj to evaluate
  */
  public void handleExitOfFiducial( TuioObject tobj ) {

    /*
    * We verify which function has the fiducial that just enters
    * se we check in our Fiducials object, what we assigned to that id
    */
    FiducialFunction ff = this.fiducials.getFiducialFunctionFromId(tobj.getSymbolID());
  
    //If that id is registered in ur fiducials
    if ( ff != null ) {
      //We check the function that this fiducial must execute
      String function = ff.fiducialFunction;
      //If the fiducial acts like a button
      if ( function.equals( FunctionsEnum.BUTTON.toString() ) ) {
        this.handleExitOfButtonFiduccial(ff);
      }
    }
    
  }
  
  /**
  * Handles the exit of a fiducial form the screen
  * @param FiducialFunction ff
  */
  private void handleExitOfButtonFiduccial( FiducialFunction ff ) {
    
    //If this fiducial has to execute a note up
    if ( ff.fiducialName.equals( FiducialsEnum.NOTEUP.toString() ) ) {
      //We change the note 1/2 step up
      this.changeNote(true);
    //If this fiducial has to execute a note down  
    } else if ( ff.fiducialName.equals( FiducialsEnum.NOTEDOWN.toString() ) ) {
      //We change the note 1/2 step down
      this.changeNote(false);
      
    }
    
  } 
  
  public void handleUpdateOfFiducial( TuioObject tobj ) {
    
    /*
    * We verify which function has the fiducial that just enters
    * se we check in our Fiducials object, what we assigned to that id
    */
    FiducialFunction ff = this.fiducials.getFiducialFunctionFromId(tobj.getSymbolID());
  
    /*
    * If that id exists on our configuration
    */
    if ( ff != null ) {
      
      if ( ff.fiducialName.equals(FiducialsEnum.MARTENOTRING.toString()) ) {
        println("Making an update");
        this.updateNoteWithMartenotRing(tobj);
      }
      
    }
  
  }
  
  /**
  * Returns a redable String of what fiducials are missing to start
  * playing with the synth
  * @return String with a readable missing fiducial
  */
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
    if ( !this.hasMartenotRing ) {
      sb.append("You are missing a MartenotRing fiducial, please put the next fiducial with ID: ");
      sb.append(this.fiducials.getFiducialIdFromFiducialName(FiducialsEnum.MARTENOTRING.toString()));
      sb.append("\n");
      return sb.toString();
    }    
    return sb.toString();
  }
  
  /**
  * Start playing with the synth, and must be called on the main draw function
  */
  public void play() {
    
    //  If the synth hast everything to start
    if ( this.canStartRunning() ) {
      //We called an overloaded function call play with a boolean value
      this.play(true);
    } else {
      /*
      * In case it doesnt have everything to run
      * we tell the user what we need
      */
      println(missingFiducials());
    }
    
  }
  
  /**
  * Overload play method, this
  * exceute the logic to send MIDI 
  * to reason
  */
  private void play( boolean play ) {
    
    //If we are playing with the arpeggi mode
    if ( this.mode.equals(FiducialsEnum.ARPEGGI.toString()) ) {
      /*
      * We call the function to execute all the logic to play
      * with the arpeggi mode
      */
      playAsArpeggi();
    //Else if we are playing with the synth mode
    } else if ( this.mode.equals(FiducialsEnum.SYNTH.toString()) ) {
      /*
      * We call the function to execute all the logic to play
      * with the synth mode
      */      
      playAsSynth();
    } else if ( this.mode.equals(FiducialsEnum.MARTENOT.toString()) ) {
      playAsMartenot();
    }
    
  }
  
  /**
  * Play the synth in an arpeggi mode
  */
  private void playAsArpeggi() {
    /*
    * We defined an arraylist up there
    * If their size is equal to 0, we add some
    * notes to be played
    */
    if ( this.scaleToRandomize.size() == 0 ) {
      this.scaleToRandomize = new ArrayList<Integer>();
      for ( int i : scale ) {
        this.scaleToRandomize.add(i);
      }
      //We shuffle the list to have random notes
      Collections.shuffle(this.scaleToRandomize);
    }
    
    //We check the current time
    int millis = millis();
    
    /*
    * If the current time is greather than
    * the last time we send a note + the difference between a note and another
    */
    if ( millis > (this.lastTimeOfNote + this.differenceBetweenNotes) ) {
      
      /*
      * If we sent a previous note
      * we turn it off so it dont keep ringing
      */
      if ( this.lastNote != null ) {
        this.midiBus.sendNoteOff(this.lastNote);
      }
      
      /*
      * We tacke out all the params of our global note
      */
      int currentPitch = this.note.pitch;
      int currentVelocity = this.note.velocity;
      int currentNoteChannel = this.note.channel;
      
      /*
      * We take a random value from our list of notes
      * and remove the used note
      */
      int nextPitch = int(random(scaleToRandomize.size()));
      currentPitch += this.scaleToRandomize.get(nextPitch);
      this.scaleToRandomize.remove(nextPitch);
      
      //We assign a last note played
      this.lastNote = new Note(currentNoteChannel, currentPitch, currentVelocity);
      
      //We send the note
      this.midiBus.sendNoteOn(lastNote);
      //We save the last moment a note was sent
      this.lastTimeOfNote = millis;
      
    }
    
  }
  
  /**
  * Play the synth in an martenot mode
  */
  private void playAsMartenot() {
    if ( !this.isPlayingNote ) {
      this.midiBus.sendNoteOn(note);
      this.isPlayingNote = true;
    }
  }
  
  /**
  * Play the synth in synth mode
  */
  private void playAsSynth() {
    /*
    * If the note was changed
    * we have to send it to the instrument
    */
    if ( this.sendNote ) {
      /*
      * We tell the program to send just one note
      * and wait for another one
      */
      this.sendNote = false;
      //Instant send and turn off the note
      this.midiBus.sendNoteOn(note);
      this.midiBus.sendNoteOff(note);
    }
  }
  
  /**
  * Reset the playing parameters
  * We told the program to not
  * send any noise and stop all running noise
  */
  private void resetParams() {
    this.sendNote = false;
    this.isPlayingNote = false;
    this.midiBus.sendNoteOff(note);
    this.midiBus.sendNoteOff(previousNote);
    this.midiBus.sendNoteOff(lastNote);
    this.note.setPitch(60);
  }
  
  /**
  * Auxiliar method to initialice all the boolean values
  * of what our controller needs to start playing
  * This is called on the class constructor
  */
  private void startHasParams() {
    this.hasModeFiducial = false;
    this.hasNoteUpFiducial = false;
    this.hasNoteDownFiducial = false;
    this.hasMartenotRing = false;
  }
  
  /**
  * This is executed when the program is closed
  * Basically we stop all the noise in case is something
  * running
  */
  public void stopPlaying() {
    if ( this.lastNote != null ) {
      this.midiBus.sendNoteOff(this.lastNote);
    }
    if ( this.previousNote != null ) {
      this.midiBus.sendNoteOff(this.previousNote);
    }
    this.midiBus.sendNoteOff(this.note);
  }
  
  public void updateNoteWithMartenotRing(TuioObject tobj) {
    if ( this.mode.equals(FiducialsEnum.MARTENOT.toString()) ) {     
      float newPos = tobj.getPosition().getX();
      println(newPos + " -- "+this.startX);
      int newPitch = this.note.pitch;
      if ( newPos > this.startX ) {
        newPitch++;
      } else if (newPos < this.startX) {
        newPitch--;
      }
      this.startX = newPos;
      this.midiBus.sendNoteOff(note);
      this.isPlayingNote = false;
      this.note.setPitch(newPitch);
    }
  }
  

}