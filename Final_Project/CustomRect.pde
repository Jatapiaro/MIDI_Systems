public class CustomRect {
  
  int row, col;
  float x, y, rwidth, rheight;
  
  float left, right, top, bottom;
  
  public CustomRect( float x, float y, float rw, float rh, int row, int col ) {
    
    this.row = row; this.col = col;
    this.x = x; this.y = y;
    this.rwidth = rw; this.rheight = rh;
    
    this.left = this.x;
    this.right = this.x + this.rwidth;
    this.top = this.y;
    this.bottom = this.y + this.rheight;
    
  }
  
  public int detectCollision( CustomRect other ) {
    boolean collide = this.onCollisionEnter( other );
    if ( collide ) {
      println("Collision in ["+this.row+", "+this.col+"]");
    }
    return row;
  }
  
  private boolean onCollisionEnter(CustomRect other) {
    return !(this.left > other.right || 
      this.right < other.left || 
      this.top > other.bottom || 
      this.bottom < other.top);
  }
  
  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("[ "); sb.append("x: "+this.x + ", ");
    sb.append("rw: "+this.rwidth + ", "); sb.append("y: "+this.y+", ");
    sb.append("rh: "+this.rheight+", "); sb.append("row: "+this.row+", ");
    sb.append("col: "+this.col+" ]");
    return sb.toString();
  }
   
}