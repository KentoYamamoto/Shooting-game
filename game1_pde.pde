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
int beam_count = 0;
int beam_h = 0;
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
Bullet[] bullet_data = new Bullet[3];

void setup(){
    size(800,500);
    keyState = new boolean[256];
    imageMode(CENTER);
    //name cost damage number now timer_time speed charge unlock
    bullet_data[0] = new Bullet("normal",1,1,20,0,15, 10,false,true);
    bullet_data[1] = new Bullet("beam", 2, 10, 3, 0, 60, 20,false, true);
    bullet_data[2] = new Bullet("ricochet", 5, 3, 3, 0, 15, 10, false, true);
    for(int i=0; i<256; ++i){ keyState[i] = false; }
    for(int i=0; i<bullet_data[0].number; ++i){ bullet_data[0].xy[0][i]=0; bullet_data[0].xy[1][i]=0;  }
    for(int i=0; i<bullet_data[0].number; ++i){ bullet_data[0].hit[i] = false; }
    img = loadImage("chara.gif");
}

void draw(){
    background( 255 );
    println(beam_count);
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
    for( int i=0; i< bullet_data[0].number; i++){
      if(bullet_data[0].xy[0][i] != 0 && bullet_data[0].xy[1][i] != 0)
        ellipse(bullet_data[0].xy[0][i]+=bullet_speed, bullet_data[0].xy[1][i], 10, 10);
        if(bullet_data[0].xy[0][i] > width || bullet_data[0].hit[i]){ //bullet reset
            bullet_data[0].xy[0][i] = 0;
            bullet_data[0].xy[1][i] = 0;
            bullet_data[0].hit[i] = false;
            for(int j = i; j < bullet_data[0].number-1; j++){
                bullet_data[0].xy[0][j] = bullet_data[0].xy[0][j+1];
                bullet_data[0].xy[1][j] = bullet_data[0].xy[1][j+1];
            }
            bullet_data[0].now --;
        }
    }
    for(int i = 0; i< bullet_data[1].number; i++){
      fill(0,0,255);
      if(bullet_data[1].xy[0][i] != 0 && bullet_data[1].xy[1][i] != 0)
          rect(bullet_data[1].xy[0][i] += bullet_data[1].speed, bullet_data[1].xy[1][i], 10 * beam_h, beam_h);
      if(bullet_data[1].xy[0][i] > width || bullet_data[1].hit[i]){ //bullet reset
          bullet_data[1].xy[0][i] = 0;
          bullet_data[1].xy[1][i] = 0;
          bullet_data[1].hit[i] = false;
          for(int j = i; j < bullet_data[1].number-1; j++){
              bullet_data[1].xy[0][j] = bullet_data[1].xy[0][j+1];
              bullet_data[1].xy[1][j] = bullet_data[1].xy[1][j+1];
          }
          bullet_data[1].now --;
      }
      fill( 0 );
    }
    if(! bullet_timer){
        bullet_timer_count++;
        if(bullet_timer_count > bullet_data[0].timer_time){
            bullet_timer = true;
            bullet_timer_count = 0;
        }
    }
    if(keyState[32]){ //SPACE
      if(bullet_data[0].now < bullet_data[0].number-1){
        if(bullet_timer && chara_MP - bullet_data[0].cost >= 0){ 
            bullet_data[0].xy[0][bullet_data[0].now] = chara_x;
            bullet_data[0].xy[1][bullet_data[0].now] = chara_y;
            chara_MP -= bullet_data[0].cost;
            bullet_data[0].now ++;
            bullet_timer = false;
        }
      }
    }
    if(keyState['a'%256]){
      if(beam_count < 180){
          beam_count ++;
      }
      if(beam_count >= 180){
        fill(0,0,255);
      }
      else{
        fill( 0 );
      }
      ellipse(chara_x + chara_w/5, chara_y, beam_count / 6, beam_count / 6);
    }else if(beam_count > 0){
        bullet_data[1].damage = beam_count / 18;
        if(bullet_data[1].now < bullet_data[1].number -1 ){
         if(bullet_timer && chara_MP - bullet_data[1].cost >= 0){
           bullet_data[1].xy[0][bullet_data[1].now] = chara_x;
           bullet_data[1].xy[1][bullet_data[1].now] = chara_y;
           beam_h = beam_count / 6;
           chara_MP -= bullet_data[1].cost;
           bullet_data[1].now++;
           bullet_timer = false;
           
         }
       }
       beam_count = 0;
    }
    if(keyState['s'%256]){
        text("BURST!!", 30, 10);
        bullet_data[0].timer_time = 3;
    }else{
        bullet_data[0].timer_time = 15;
    }
    
}

void chara_data(){
    if(chara_MP < chara_MAX_MP && frameCount%60 == 0){
        chara_MP ++;
    }
    float last_MP =  (float)chara_MP/ chara_MAX_MP;
    fill(0,0,255);
    rect(0, 0, width/2 *last_MP, 10);
    fill( 0 );

}



void chara_boss(){
  if(boss_HP > 0){
    rect(width, height/2, -100, 100);
    text("boss"+boss_HP  , width - 50, height ,10);
    for(int j = 0; j < bullet_data.length; j++){
      for(int i = 0; i < bullet_data[j].number; i++){
          if(width-100 < bullet_data[j].xy[0][i] && bullet_data[j].xy[0][i] < width && height /2 < bullet_data[j].xy[1][i] && bullet_data[j].xy[1][i] < height/2 + 100){
            bullet_data[j].hit[i] = true;
            boss_HP -= bullet_data[j].damage;
          }
      }
    }
  }
}

//↓ここから下いじらない
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
