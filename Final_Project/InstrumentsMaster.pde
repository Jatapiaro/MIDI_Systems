import java.util.*;
import themidibus.*;

public class InstrumentsMaster {
  
  /*
  * Hash map to have quick acces to all the columns
  * An Integer is used as a key or the 16 columns that maps
  * a List of fiducials for that column
  */
  private HashMap<Integer, List<Fiducial>> columns;
  /*
  * This will help us to track when a fiducial is taken off
  * Basically we store the column, alongside the fiducial id
  * Se when is removed, we just check the id, and then we look
  * for it on the columns to remove it.
  */
  private HashMap<Integer, Integer> fiducialInColumn;
  
  private int stepVelocity, lastStepSoundAt, step;
  
  private int inDeviceNum, outDeviceNum;

  private MidiBus midiBus;
  
  public InstrumentsMaster() {
    
    this.fiducialInColumn = new HashMap<Integer, Integer>();
    
    this.columns = new HashMap<Integer, List<Fiducial>>();
    /* Initialice all columns */
    for( int i = 0; i<16; i++ ) {
      this.columns.put(i, new ArrayList<Fiducial>());
    }
    
    /* Initialice velocity of steps */
    this.lastStepSoundAt = millis();
    this.stepVelocity = 250;
    this.step = 0;
    
    /* Initialice midibus */
    this.inDeviceNum = 0;
    this.outDeviceNum = 1;
    this.midiBus = new MidiBus(this, this.inDeviceNum, this.outDeviceNum);
    
    this.hardCodedTest(0);
    
  }
  
  private void hardCodedTest(int step) {
    List<Fiducial> list = this.columns.get(step);
    println("["+step+"]: "+list);
    for ( Fiducial f : list ) {
      f.play();
    }
  }
  
  private void hardCodedAddFiducial(int id) {
    if ( !this.fiducialInColumn.containsKey(id) ) {
      int randomColumn = (int)random(0, 15);
      this.fiducialInColumn.put(id, randomColumn);
      Fiducial f = new Fiducial(id, this.midiBus);
      f.setRow(-1);//TODO add real values
      this.columns.get(randomColumn).add(f);
    }
  }
  
  public void addFiducial(int id) {
    /*TODO implement correct method*/
    this.hardCodedAddFiducial(id);
  }
  
  public void updateFiducial( int id, float angle ) {
    /*TODO param for row*/
    if ( this.fiducialInColumn.containsKey(id) ) {
      int theColumn = this.fiducialInColumn.get(id);
      for(Fiducial f : this.columns.get(theColumn)) {
        if ( f.getId() == id ) {
          f.setAngle(angle);
        }
      }
    }
  }
  
  public void removeFiducial(int id) {
    if ( this.fiducialInColumn.containsKey(id) ) {
      int theColumn = this.fiducialInColumn.get(id);
      this.columns.get(theColumn).remove(new Fiducial(id));
    }
  }
  
  private void incrementStep() {
    int now = millis();
    if ( now >= (this.lastStepSoundAt + this.stepVelocity) ) { 
      this.step++;
      if ( this.step > 15 ) {
        this.step = 0;
      } else {
        this.hardCodedTest(this.step);
      }
      this.lastStepSoundAt = now;
    }
  }
  
  public void play() {
    this.incrementStep();
  }
  
  public void playCurrentStep() {
    
  }
  

  
}