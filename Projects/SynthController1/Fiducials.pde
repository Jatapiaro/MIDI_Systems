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
    
  private HashMap<Integer, FiducialFunction> fiducials;
  
  public Fiducials() {
    
    this.fiducials = new HashMap<Integer, FiducialFunction>();
    
    this.fiducials.put(1, 
      new FiducialFunction(
        FiducialsEnum.ARPEGGI.toString(),
        FunctionsEnum.MODE.toString()
      )
    );
    
    this.fiducials.put(2, 
      new FiducialFunction(
        FiducialsEnum.MARTENOT.toString(),
        FunctionsEnum.MODE.toString()
      )
    );
    
    this.fiducials.put(3, 
      new FiducialFunction(
        FiducialsEnum.NOTEDOWN.toString(),
        FunctionsEnum.BUTTON.toString()
      )
    );
    
    this.fiducials.put(4, 
      new FiducialFunction(
        FiducialsEnum.NOTEUP.toString(),
        FunctionsEnum.BUTTON.toString()
      )
    );

    this.fiducials.put(5, 
      new FiducialFunction(
        FiducialsEnum.SYNTH.toString(),
        FunctionsEnum.MODE.toString()
      )
    );
    
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
  public FiducialFunction getFiducialFunctionFromId( int id ) {
    return this.fiducials.get(id);
  }
  
  /**
  * @param function that has certain fiducial 
  * @return List with all the fiducials that has that function
  */
  public ArrayList<FiducialFunction> listAllFiducialsWithFunction(String function) {
    ArrayList<FiducialFunction> fids = new ArrayList<FiducialFunction>();
    for (Map.Entry fid : this.fiducials.entrySet()) {
      FiducialFunction f = (FiducialFunction)fid.getValue();
      if ( f.fiducialFunction.equals(function) ) {
        f.id = (int)fid.getKey();
        fids.add(f);
      }
    }
    return fids;
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