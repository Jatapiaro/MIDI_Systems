public class Fiducials {
  
  private int arpeggiMode, synthMode, noteUp, noteDown;
  
  public Fiducials() {
    this.arpeggiMode = 204;
    this.synthMode = 205;
    this.noteUp = 11;
    this.noteDown = 10;
  }
  
  public void setArpeggiMode( int id ) {
    this.arpeggiMode = id;
  }
  
  public void synthMode( int id ) {
      this.synthMode = id;
  }
  
}