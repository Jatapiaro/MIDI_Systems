import themidibus.*;

PVector grv;
Ball ball;
MidiBus bus;

Ball[] balls;

void setup() {
  size(600, 400);
  background(127, 90, 30);
  MidiBus.list();
  bus = new MidiBus(this, 0, 1);
  //ball = new Ball(bus);
  balls = new Ball[100];
  grv = new PVector(0, 0.4);
  for ( int i = 0; i < 100; i++ ) {
    balls[i] = new Ball(bus);
    balls[i].AddAcc(grv);
  }
}

void draw() {
  background(127, 90, 30);
  for ( int i = 0; i < 100; i++ ) {
    balls[i].Update();
  }
}