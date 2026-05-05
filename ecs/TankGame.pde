// Emalee Sorensen | Apr 14 2026 | TankGame
PImage bg;
Tank tank1;
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
ArrayList<PowerUp> powerups = new ArrayList<PowerUp>();
int score;
Timer obsTimer, puTimer;

void setup() {
  size(500, 500);
  bg = loadImage("bg1.png");
  tank1 = new Tank();
  //obstacles.add(new Obstacle(300, 150));
  //obstacles.add(new Obstacle(500, 300));
  //obstacles.add(new Obstacle(250, 450));
  score = 0;
  obsTimer = new Timer(1000);
  obsTimer.start();
  puTimer = new Timer(5000);
  puTimer.start();
}

void draw() {
  background(127);
  imageMode(CORNER);
  image(bg, 0, 0);
  // Add timer to distribute obstacles
  if (obsTimer.isFinished()) {
    obstacles.add(new Obstacle(-100, int(random(height))));
    obsTimer.start();
  }
  if (puTimer.isFinished()) {
    // Add power up
    powerups.add(new PowerUp());
    // restart timer
    puTimer.start();
  }
  
  //Display and remove power ups
  for(int i = 0; i < powerups.size(); i ++) {
    PowerUp pu = powerups.get(i);
    pu.display();
    pu.move();
    if(pu.reachedEdge()) {
      powerups.remove(pu);
    }
    if(pu.intersect(tank1)) {
      if(pu.type == 'h') {
        tank1.health = tank1.health +100;
        powerups.remove(pu);
      } else if(pu.type == 'a') {
        tank1.laserCount = tank1.laserCount + 150;
        powerups.remove(pu);
      } else if(pu.type == 't') {
        tank1.turretCount = tank1.turretCount + 1;
        powerups.remove(pu);
      }
    }
  }
  
  //obstacles.add(new Obstacle(250,250,)

  // Displaying projectiles
  for (int i = 0; i < obstacles.size(); i++) {
    Obstacle o = obstacles.get(i);
    o.display();
    o.move();
    //if (o.reachedEdge()) {
     // obstacles.remove(i);
   // }
    // detect collision to tank
    if (tank1.intersect(o)) {
      tank1.health = tank1.health - 50;
      obstacles.remove(o);
      
      // impact to change score, health, obstacle
    }
    // impact to change score, health, obstacle
  }
  // Render and detect collision
  for (int i = 0; i < projectiles.size(); i++) {
    Projectile p = projectiles.get(i);
    for (int j = 0; j < obstacles.size(); j ++) {
      Obstacle o = obstacles.get(j);
      if (p.intersect(o)) {
        score = + 100;
        projectiles.remove(p);
        obstacles.remove(o);
        continue;
      }
    }
    p.display();
    p.move();
    if (p.reachedEdge()) {
      projectiles.remove(i);
    }
  }
  tank1.display();
  scorePanel();
  println("Objects in Memory:" +obstacles.size());
  println("Projectiles in Memory:" +projectiles.size());
}

void scorePanel() {
  fill(127, 127);
  rectMode(CENTER);
  rect(width/2, 30, width, 38);
  fill(255);
  textSize(30);
  textAlign(CENTER);
  text("Score:" + score, width/2,35);
  text("Health:" + tank1.health, width/2-150, 38);
  text("Ammo:" + tank1.laserCount, width/2+150, 38);
}

void keyPressed() {
  if (key == 'w') {
    tank1.move('w');
  } else if (key == 's') {
    tank1.move('s');
  } else if (key == 'd') {
    tank1.move('d');
  } else if (key == 'a') {
    tank1.move('a');
  }
}

void mousePressed() {
  if(tank1.turretCount == 1) {
    projectiles.add(new Projectile (int(tank1.x + 10), int(tank1.y)));
  } else if(tank1.turretCount==2) {
    projectiles.add(new Projectile (int(tank1.x + 10), int(tank1.y)));
    projectiles.add(new Projectile (int(tank1.x + 10), int(tank1.y)));
  }
  //projectiles.add(new Projectile (int(tank1.x), int(tank1.y)));
}
