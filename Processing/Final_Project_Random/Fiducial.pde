import themidibus.*;

public class Fiducial {
  
  private int id, row;
  private float rotation;
  private int[] scale;
  private MidiBus midiBus;
  private Note midBusNote;
  private int note;

  public Fiducial(int id) {
    this.row = -1;
    this.id = id;
    this.scale = ScalesEnum.MAJOR.scale;
    this.rotation = 90.0f;
    this.mapNoteFromRotation();
  }
  
  public Fiducial(int id, MidiBus midiBus) {
    this.row = -1;
    this.id = id;
    this.scale = ScalesEnum.MAJOR.scale;
    this.rotation = 90.0f;
    this.midiBus = midiBus;
    this.mapNoteFromRotation();
  } 
  
  public void play() {
    this.midiBus.sendNoteOn(row, this.note, 127);
    this.midiBus.sendNoteOff(row, this.note, 127);
  } 
  
  public int getId() {
    return this.id;
  }
  
  public void setAngle(float angle) {
    this.rotation = angle;
    this.mapNoteFromRotation();
  }
  
  public void setRow( int row ) {
    //TODO hadle real row
    this.hardCodedRow();
  }
  
  private void hardCodedRow() {
    int rand = (int)random(0, 3);
    switch (rand) {
      case 0:
        this.row = InstrumentsEnum.NNXT.channel;
        break;
      case 1:
        this.row = InstrumentsEnum.EUROPA.channel;
        break;
      case 2:
        this.row = InstrumentsEnum.GRAIN.channel;
        break; 
      case 3:
        this.row = InstrumentsEnum.MALSTROM.channel;
        break;       
    }
  }
  
  private void mapNoteFromRotation() {
    int mapRotation = (int)map(this.rotation, 0, 180, 0, this.scale.length);
    this.note = 60 + scale[mapRotation];
    //println("Mapped to: "+this.note);
  }
  
  @Override
  public boolean equals( Object o ) {
    Fiducial other = (Fiducial)o;
    return other.getId() == this.id;
  }

  @Override
  public String toString() {
    return this.note+"";
  }
 
}