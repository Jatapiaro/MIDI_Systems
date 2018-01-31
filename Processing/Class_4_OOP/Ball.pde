import themidibus.*;

class Ball {

   PVector vel, pos, acc, ppos, grv;
   color c;
   MidiBus bus;
   
   public Ball( MidiBus bus ) {
     vel = new PVector( random(-3, 3), -5 );
     pos = new PVector( random(0, width), random(0, height) );
     ppos = pos.copy();
     println("paos constructor");
     acc = new PVector( 0, 0 );
     c = color( random(0, 255), random(0, 255), random(0, 255) );
     this.bus = bus;
   }
   
   public void Update() {
     
     vel.add(acc);
     pos.add(vel);
     bounce();
     Draw();
     
     ppos = pos.copy();
     
     
   }
   
   public void AddAcc(PVector a) {
     acc.add(a);
   }
   
   public void Draw() {
     
     stroke(0);
     fill(c);
     ellipse(pos.x, pos.y, 20, 20);
     
   }
   
   private void bounce() {
     
     if ( pos.x >= width ) {
       pos.x = width;
       vel.x *= -1;
       sendNote(true);
     }
     
     if ( pos.x <= 0 ) {
       pos.x = 0;
       vel.x *= -1;
       sendNote(true);
     }
     
     if ( pos.y >= height ) {
       pos.y = height;
       vel.y *= -1;
       sendNote(true);
     }
     
     if ( pos.y <= 0 ) {
       pos.y = 0;
       vel.y *= -1;
       sendNote(true);
     }
     
   }
   
   private void sendNote( boolean isX ) {
     
     if( isX ) {
       if ( ppos.y != pos.y ) {
         sendNote( pos.x, true );
       }
     } else {
       sendNote( pos.y, false );
     }
     
   }
   
   
   private void sendNote( float val, boolean isX ) {
     
     float widthOrHeight = (isX)? height : width;
     
     int note = int(map(val, 0, widthOrHeight, 0, 127 ));
     bus.sendNoteOn(0, note, 90);
     println("Sending note");
     
   }

   
   
  
}