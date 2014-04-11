PImage img;
int i = 0;
int game_score = 0;
int bullet_now = 0;
int bullet_number = 50;
int bullet_timer_count = 0;
int bullet_timer_time = 15; //60fps = 1 second
float chara_x = 850/2, chara_y = 850/2;
float chara_w = 200 , chara_h = 200;
float chara_move_speed = 5;
float bullet_speed = 10;
float[][] bullet_x_y = new float[2][bullet_number];
boolean bullet_timer = true;
boolean keyState[];


void setup(){
    frameRate(120);
    size(850,850);
    keyState = new boolean[256];
    imageMode(CENTER);
    for(int i=0; i<256; ++i){ keyState[i] = false; }
    for(int i=0; i<bullet_number; ++i){ bullet_x_y[0][i]=0; bullet_x_y[1][i]=0;  }
    img = loadImage("chara.gif");
}

void draw(){
    background( 255 );
    image(img, chara_x, chara_y, chara_w, chara_h);
    println(keyCode);
    chara_move();
    score_display();
    game_score ++;
    bullet();
}

void score_display(){
    fill( 0 );
    text(game_score,10,10);
}

void bullet(){
    for( int i=0; i< bullet_number; i++){
      if(bullet_x_y[0][i] != 0 && bullet_x_y[1][i] != 0)
        ellipse(bullet_x_y[0][i]+=bullet_speed, bullet_x_y[1][i], 10, 10);
        if(bullet_x_y[0][i] > width){
            bullet_x_y[0][i] = 0;
            bullet_x_y[1][i] = 0;
            for(int j = i; j < bullet_number-1; j++){
                bullet_x_y[0][j] = bullet_x_y[0][j+1];
                bullet_x_y[1][j] = bullet_x_y[1][j+1];
            } 
            bullet_now --;
        }
    }
    if(! bullet_timer){
        bullet_timer_count++;
        if(bullet_timer_count > bullet_timer_time){
            bullet_timer = true;
            bullet_timer_count = 0;
        }
    }
    if(keyState[32]){ //SPACE
      if(bullet_now < bullet_number-1){
        if(bullet_timer){
          bullet_x_y[0][bullet_now] = chara_x;
          bullet_x_y[1][bullet_now] = chara_y;
          bullet_now ++;
          bullet_timer = false;
        }
      }
  }
  if(keyState['s'%256]){
      text("BURST!!", 30, 10);
      bullet_timer_time = 3;
  }else{
      bullet_timer_time = 15;
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

void keyPressed() {
  if(0<=key && key<256){ keyState[key] = true; }
  else if(0<=keyCode && keyCode<256){ keyState[keyCode] = true; }    
  
}

void keyReleased() {
  if(0<=key && key<256){ keyState[key] = false; }
  else if(0<=keyCode && keyCode<256){ keyState[keyCode] = false; }    
}




