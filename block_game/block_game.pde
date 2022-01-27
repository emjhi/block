boolean wkey, akey, skey, dkey, spacekey;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ;
float leftRightHeadAngle, upDownHeadAngle;

boolean skipFrame;

PImage snow;
PImage snowSide;
PImage dirt;

import java.awt.Robot;

Robot rbt;

color black = #000000;
color white = #FFFFFF;
color blue = #7092BE;
color green = #20ff00;

int gridSize;
PImage bottom, mid, top;

void setup() {
  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);

  wkey = akey = skey = dkey = spacekey = false;

  eyeX = width/2;
  eyeY = height/2; //9*height/11;
  eyeZ = 0;
  focusX = width/2;
  focusY = height/2;
  focusZ = 10;
  tiltX = 0;
  tiltY = 1;
  tiltZ = 0;

  leftRightHeadAngle = radians(270);
  noCursor();

  //map = loadImage("New Piskel (1).png");
  //map = loadImage("map.png");
  bottom = loadImage("bottom.png");
  mid = loadImage("middle.png");
  top = loadImage("top.png");

  gridSize = 100;

  snow = loadImage("snow.png");
  snowSide = loadImage("snowy dirt.png");
  dirt = loadImage("dirt.png");


  textureMode(NORMAL);

  try { 
    rbt = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }

  skipFrame = false;
}


void draw() {
  background(blue);
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ);
  //drawFloor();
  drawFocalPoint();
  controlCamera();
  drawMap();
  pointLight(255, 255, 255, eyeX, eyeY, eyeZ);
}


void drawFloor() {
  stroke(255);

  int z = -2000;
  int x = -2000;
  while (z < 2000) {
    texturedCube(x, height, z, snow, snowSide, dirt, gridSize);
    //texturedCube(x, height-gridSize*4, z, snow, gridSize);
    x += gridSize;
    if (x >= 2000) {
      x = -2000;
      z += gridSize;
    }
  }
}

void controlCamera() {
  if (wkey) {
    eyeX += cos(leftRightHeadAngle)*10;
    eyeZ += sin(leftRightHeadAngle)*10;
  }

  if (skey) {
    eyeX -= cos(leftRightHeadAngle)*10;
    eyeZ -= sin(leftRightHeadAngle)*10;
  }

  if (dkey) {
    eyeX -= cos(leftRightHeadAngle - PI/2)*10;
    eyeZ -= sin(leftRightHeadAngle - PI/2)*10;
  }

  if (akey) {
    eyeX -= cos(leftRightHeadAngle + PI/2)*10;
    eyeZ -= sin(leftRightHeadAngle + PI/2)*10;
  }

  if (skipFrame == false) {
    leftRightHeadAngle += (mouseX - pmouseX)*0.01;
    upDownHeadAngle += (mouseY - pmouseY)*0.01;
  }

  focusX = eyeX + cos(leftRightHeadAngle)*300;
  focusZ = eyeZ + sin(leftRightHeadAngle)*300;
  focusY = eyeY + tan(upDownHeadAngle)*300;

  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5;
  if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5;


  if (mouseX > width-2) {
    rbt.mouseMove(2, mouseY);
    skipFrame = true;
  } else if (mouseX < 2) {
    rbt.mouseMove(width-2, mouseY);
    skipFrame = true;
  } else {
    skipFrame = false;
  }


  if (spacekey == true) eyeY -= 10;
   
  
  //if (dist(eyeX, eyeY, ) <= size/2 + obj.size) {
  //  obj.lives = 0;
  //  lives--;
  //}
}

void drawFocalPoint() {
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(5);
  popMatrix();
}

void drawMap() {
  for (int x = 0; x < bottom.width; x++) {
    for (int y = 0; y < bottom.height; y++) {
      color c = bottom.get(x, y);
      if (c == green) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, snow, snowSide, dirt, gridSize);
      }
    }
  }

  for (int x = 0; x < mid.width; x++) {
    for (int y = 0; y < mid.height; y++) {
      color c = mid.get(x, y);
      if (c == green) {
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, snow, snowSide, dirt, gridSize);
      }
    }
  }

  for (int x = 0; x < top.width; x++) {
    for (int y = 0; y < top.height; y++) {
      color c = top.get(x, y);
      if (c == green) {
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, snow, snowSide, dirt, gridSize);
      }
    }
  }
}

void keyPressed() {
  if (key == 'W' || key == 'w') wkey = true;
  if (key == 'A' || key == 'a') akey = true;
  if (key == 'S' || key == 's') skey = true;
  if (key == 'D' || key == 'd') dkey = true;
  if (key == ' ' ) spacekey = true;
}


void keyReleased() {
  if (key == 'W' || key == 'w') wkey = false;
  if (key == 'A' || key == 'a') akey = false;
  if (key == 'S' || key == 's') skey = false;
  if (key == 'D' || key == 'd') dkey = false;
  if (key == ' ' ) spacekey = false;
}
