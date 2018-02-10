public class FiducialFunction {
  
  String fiducialName, fiducialFunction;
  int id;
  
  public FiducialFunction(String fiducialName, String fiducialFunction) {
    this.fiducialName = fiducialName;
    this.fiducialFunction = fiducialFunction;
  }
  
  @Override
  public String toString() {
    return this.fiducialName + " --> acts like: " + this.fiducialFunction;
  }
  
  public String visualText() {
    return this.fiducialFunction + " : " + this.fiducialName;
  }
  
}