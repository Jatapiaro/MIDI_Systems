/**
* Fiducials
*
* Class like a configuration file
* in this class you define the ID's
* of the fiducials that will control
* some part of the synth
*
* @author Jacobo Tapia - A01336590
* @author
* @author
*
*/


import java.util.Map;

public class Fiducials {
    
  private HashMap<Integer, String> fiducials;
  
  public Fiducials() {
    
    this.fiducials = new HashMap<Integer, String>();
    
    this.fiducials.put(1, FiducialsEnum.ARPEGGIMODE.toString());
   
    this.fiducials.put(2, FiducialsEnum.MARTENOTMODE.toString());
    
    this.fiducials.put(3, FiducialsEnum.NOTEDOWN.toString());
    
    this.fiducials.put(4, FiducialsEnum.NOTEUP.toString());
    
    this.fiducials.put(5, FiducialsEnum.SYNTHMODE.toString());
    
  }
  
  /**
  * @param function that we need to know which fiducial has control over it
  * @return int the id of the fiducial that controls that function
  */
  public int getFiducialIdFromFunction( String function ) {
    for (Map.Entry fid : this.fiducials.entrySet()) {
      if ( fid.getValue().equals(function) ) {
        return (int)fid.getKey();
      }
    }
    return -1;
  }
  
  /**
  * @param id of the fiducial 
  * @return String with the function that this id has
  */
  public String getFiducialFunctionFromId( int id ) {
    return this.fiducials.get(id);
  }
  
  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder("Fiducials configuration: \n");
    for (Map.Entry fid : this.fiducials.entrySet()) {
      sb.append("FiduccialID: "+ fid.getKey() + " --> " + fid.getValue()+"\n");
    }
    return sb.toString();
  }
  
}