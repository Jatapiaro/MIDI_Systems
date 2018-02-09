/**
* FiducialsEnum
*
* Class to have an enumerator, so 
* you define just once all the 
* components of your synth.
* For example, if you need to know
* in other class which of your fiducials
* has the arpeggi mode, you just ask for 
* FiducialsEnum.ARPEGGIMODE, so you don't need
* to remember what is the exact string value of the mode
* and if you need to change a value, you need to do it just once
*
* @author Jacobo Tapia - A01336590
* @author
* @author
*
*/
public enum FiducialsEnum
{
    ARPEGGIMODE("Arpeggi-Mode"),
    MARTENOTMODE("Martenot-Mode"),
    NOTEDOWN("Note-Down"),
    NOTEUP("Note-Up"),
    SYNTHMODE("Synth-Mode");
 
    private String fiducial;
 
    private FiducialsEnum(final String fiducial) {
        this.fiducial = fiducial;
    }
 
    public String toString() {
        return this.fiducial;
    }
}