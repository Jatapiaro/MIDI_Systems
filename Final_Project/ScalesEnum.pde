/**
* ScalesEnum
*
* @author Jacobo Tapia - A01336590
* @author Sofía Aguirre - A01332562
* @author Maximiliano Carmona Miranda - A01650052
*
*/
import java.util.Arrays;
public enum ScalesEnum {
  
    MAJOR(new int[] {0, 2, 4, 5, 7, 9, 11}), 
    PURVI(new int[] {0, 1, 4, 6, 7, 8, 11});
 
    private int[] scale;
 
    private ScalesEnum(final int[] scale) {
        this.scale = scale;
    }
 
    @Override
    public String toString() {
        return Arrays.toString(this.scale);
    }
}