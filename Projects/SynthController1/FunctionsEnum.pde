/**
* FunctionsEnum
*
* Class to have an enumerator, so 
* you define just once all the 
* components of your synth.
*
* @author Jacobo Tapia - A01336590
* @author
* @author
*
*/
public enum FunctionsEnum
{
    MODE("Mode"),
    BUTTON("Button"),
    SLIDE("Slides");
 
    private String function;
 
    private FunctionsEnum(final String function) {
        this.function = function;
    }
 
    public String toString() {
        return this.function;
    }
}