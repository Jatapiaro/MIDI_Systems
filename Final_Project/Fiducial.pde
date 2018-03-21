import themidibus.*;

public class Fiducial {
  
  private int id, row;
  private float rotation;
  private int[] scale;
  private MidiBus midiBus;

  public Fiducial(int id) {
    this.id = id;
    this.scale = ScalesEnum.MAJOR.scale;
    this.rotation = 90.0f;
  }
  
  public Fiducial(int id, MidiBus midiBus) {
    this.id = id;
    this.scale = ScalesEnum.MAJOR.scale;
    this.rotation = 90.0f;
    this.midiBus = midiBus;
  }  
 
}