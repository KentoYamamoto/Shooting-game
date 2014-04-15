class Bullet{
    String name;
    int cost;
    int damage;
    int number;
    int now;
    int timer_time; //60fps = 1 second
    int speed;
    boolean charge; 
    boolean unlock;
    float[][] xy;
    boolean[] hit;
    Bullet(String a, int b, int c, int d, int e, int f, int g, boolean h, boolean i){
          name = a;
          cost =b;
          damage =c;
          number =d;
          speed =g;
          charge = h;
          unlock = i;
          xy = new float[2][number]; 
          hit = new boolean[number];
     }
}
PImage img;
int i = 0;
int game_score = 0;
int chara_MAX_MP = 10;
int chara_MP = chara_MAX_MP;
int boss_HP = 10;
int bullet_timer_count = 0;
float chara_x = 850/2, chara_y = 850/2;
float chara_w = 200 , chara_h = 200;
float chara_move_speed = 5;
float bullet_speed = 10;
boolean bullet_timer = true;
boolean keyState[];
//name cost damage number now timer_time speed charge unlock
Bullet normal = new Bullet("normal",1,1,20,0,15, 10,false,true);
Bullet beam = new Bullet("beam", 2, 2, 3, 0, 60, 20,false, true);

void setup(){
    size(800,500);
    keyState = new boolean[256];
    imageMode(CENTER);
    for(int i=0; i<256; ++i){ keyState[i] = false; }
    for(int i=0; i<normal.number; ++i){ normal.xy[0][i]=0; normal.xy[1][i]=0;  }
    for(int i=0; i<normal.number; ++i){ normal.hit[i] = false; }
    img = loadImage("chara.gif");
}

void draw(){
    background( 255 );
    image(img, chara_x, chara_y, chara_w, chara_h);
    chara_move();
    score_display();
    game_score ++;
    bullet();
    chara_data();
    chara_boss();
}

void score_display(){
    fill( 0 );
    text(game_score,10,10);
}

void bullet(){
    for( int i=0; i< normal.number; i++){
      if(normal.xy[0][i] != 0 && normal.xy[1][i] != 0)
        ellipse(normal.xy[0][i]+=bullet_speed, normal.xy[1][i], 10, 10);
        if(normal.xy[0][i] > width || normal.hit[i]){ //bullet reset
            normal.xy[0][i] = 0;
            normal.xy[1][i] = 0;
            normal.hit[i] = false;
            for(int j = i; j < normal.number-1; j++){
                normal.xy[0][j] = normal.xy[0][j+1];
                normal.xy[1][j] = normal.xy[1][j+1];
            }
            normal.now --;
        }
    }
    for(int i = 0; i< beam.number; i++){
      fill(128);
      if(beam.xy[0][i] != 0 && beam.xy[1][i] != 0)
          rect(beam.xy[0][i], beam.xy[1][i], 100, 10);
      if(beam.xy[0][i] > width || beam.hit[i]){ //bullet reset
          beam.xy[0][i] = 0;
          beam.xy[1][i] = 0;
          beam.hit[i] = false;
          for(int j = i; j < beam.number-1; j++){
              beam.xy[0][j] = beam.xy[0][j+1];
              beam.xy[1][j] = beam.xy[1][j+1];
          }
          beam.now --;
      }
      fill( 0 );
    }
    if(! bullet_timer){
        bullet_timer_count++;
        if(bullet_timer_count > normal.timer_time){
            bullet_timer = true;
            bullet_timer_count = 0;
        }
    }
    if(keyState[32]){ //SPACE
      if(normal.now < normal.number-1){
        if(bullet_timer && chara_MP - normal.cost >= 0){ 
            normal.xy[0][normal.now] = chara_x;
            normal.xy[1][normal.now] = chara_y;
            chara_MP -= normal.cost;
            normal.now ++;
            bullet_timer = false;
        }
      }
    }
    if(keyState['a'%256]){
       if(beam.now < beam.number -1){
         if(bullet_timer && chara_MP - beam.cost >= 0){
           beam.xy[0][beam.now] = chara_x;
           beam.xy[1][beam.now] = chara_y;
           chara_MP -= beam.cost;
           beam.now++;
           bullet_timer = false;
         }
       }
    }
    if(keyState['s'%256]){
        text("BURST!!", 30, 10);
        normal.timer_time = 3;
    }else{
        normal.timer_time = 15;
    }
    
}

void chara_data(){
    if(chara_MP < 10 && frameCount%60 == 0){
        chara_MP ++;
    }
    for(int i=0; i<chara_MP; i++){
        fill(0,0,255);
        rect(i*width/chara_MAX_MP/2, 0, width/chara_MAX_MP/2, 10);
        fill( 0 );
    }
}

void chara_move(){
    if(keyState[UP%256]){
        chara_y -= chara_move_speed;
        if(keyState[RIGHT%256])
            chara_x += chara_move_speed;
        if(keyState[LEFT%256])
            chara_x -= chara_move_speed;
    }
    if(keyState[DOWN%256]){
        chara_y += chara_move_speed;
        if(keyState[RIGHT%256])
            chara_x += chara_move_speed;
        if(keyState[LEFT%256])
            chara_x -= chara_move_speed;
    }
    if(keyState[RIGHT%256]&& !(keyState[UP%256] || keyState[DOWN%256])){
        chara_x += chara_move_speed;
    }
    if(keyState[LEFT%256]&& !(keyState[UP%256] || keyState[DOWN%256])){
        chara_x -= chara_move_speed;
    }
    if(chara_w/2 > chara_x) {
        chara_x = chara_w/2;
    }
    if(chara_x > width-chara_w/2 ) {
        chara_x = width-chara_w/2;
    }
    if(chara_h/2 > chara_y){
        chara_y = chara_h/2;
    }
    if(chara_y > height - chara_h/2){
        chara_y = height - chara_h/2;
    }
}

void chara_boss(){
  if(boss_HP > 0){
    rect(width, height/2, -100, 100);
    text("boss"+boss_HP  , width - 50, height ,10);
    for(int i = 0; i < normal.number; i++){
        if(width-100 < normal.xy[0][i] && normal.xy[0][i] < width && height /2 < normal.xy[1][i] && normal.xy[1][i] < height/2 + 100){
          normal.hit[i] = true;
          boss_HP --;
        }
    }
  }
}

void keyPressed() {
  if(0<=key && key<256){ keyState[key] = true; }
  else if(0<=keyCode && keyCode<256){ keyState[keyCode] = true; }    
  
}

void keyReleased() {
  if(0<=key && key<256){ keyState[key] = false; }
  else if(0<=keyCode && keyCode<256){ keyState[keyCode] = false; }    
}
