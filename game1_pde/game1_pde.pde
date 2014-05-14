PImage img;
PImage img2;
PImage img3;
PImage[] icon = new PImage[4];
int display_mode =0;
int beam_count = 0;
int beam_h = 0;
int beam_hit_count = 0;
int[] ricochet_hanten;
int game_score = 0;
int chara_MAX_HP = 100;
int chara_HP = chara_MAX_HP;
int chara_MAX_MP = 100;
int chara_MP = chara_MAX_MP;
int chara_exp = 0;
int chara_level = 0;
int chara_cool_count = 0;
int boss_HP = 10;
int wave_ring = 15;
int[] wave_r;
float[] moon_count;
float chara_x = 850/2, chara_y = 850/2;
float chara_w = 100 , chara_h = 100; 
float chara_move_speed = 5;
float bullet_speed = 10;
boolean keyState[];
boolean change_mode = false;
boolean chara_cool = false;
Bullet[] bullet_data = new Bullet[5];
Enemy[] enemy_data = new Enemy[4];

void setup(){
    size(800,500);
    frameRate(60);
    keyState = new boolean[256];
    imageMode(CENTER);
    textAlign(CENTER);
    //name cost damage number t_time t_count speed mode_MAX cooltime unlock
    bullet_data[0] = new Bullet("normal", 1, 10, 60, 0,15, 0, 10, 1, 5, true, true);
    bullet_data[1] = new Bullet("beam", 2, 10, 3, 0, 60, 0, 20, 1, 1, true, true);
    bullet_data[2] = new Bullet("ricochet", 5, 30, 5, 0,10, 0, 10, 1, 1, true, true);
    bullet_data[3] = new Bullet("wave", 10, 100, 10, 0,300, 0, 20, 1, 1, true, true);
    bullet_data[4] = new Bullet("moon", 10, 20, 4, 0, 15, 0, 10, 1, 1, true, true);//thunder 
    ricochet_hanten = new int[bullet_data[2].number];
    wave_r = new int[bullet_data[3].number];
    moon_count = new float[bullet_data[4].number];
    for(int i=0; i<256; ++i){ keyState[i] = false; }
    for(int h=0;h<bullet_data.length;h++){ //初期化
      for(int i=0; i<bullet_data[h].number; ++i){ bullet_data[h].xy[0][i]=0; bullet_data[h].xy[1][i]=0;  }
    }
    for(int i=0; i<bullet_data[0].number; ++i){ bullet_data[0].hit[i] = false; }
    for(int i=0; i<bullet_data[2].number; ++i){ ricochet_hanten[i] = 1; }
    for(int i=0; i<bullet_data[3].number; ++i){ wave_r[i] = 0; }
    //引数=> x y
    enemy_data[0] = new Enemy(width-100, height/2);
    enemy_data[1] = new Enemy(width -100, 10);
    enemy_data[2] = new Enemy(width/2, height/2);
    enemy_data[3] = new Enemy(width/2+30, height/2);    
    enemy_data[0].e_t01();
    enemy_data[1].e_t01();
    enemy_data[2].e_t01();
    enemy_data[3].e_t01();
    img = loadImage("chara.gif");
    img2 = loadImage("chara_charge.gif");
    img3 = loadImage("chara_status.gif");
    icon[0] = loadImage("normal.png");
    icon[1] = loadImage("beam.png");
    icon[2] = loadImage("ricochet.png");
    icon[3] = loadImage("wave.png");
}
 
void draw(){
  switch(display_mode){
    case 0:
      background( 255 );
      bullet(); //bullet3のwaveのせいで一番先に実行しないと後ろが消える ellipseで中の円を透過できればどこでも可
      enemy_show();
      chara();
      break;
    case 1:
      d_game_over();
      break;
  }
  //debug
  if(keyState['l'%256]){
    setup();
  }
}

void d_game_over(){
    background(0);
}

void background_setting(int m){
    switch(m){
      case 0:
        background(255);
        break;
    }  
}

void bullet(){
  for( int m = 0; m < bullet_data.length; m++){
    for( int i=0; i< bullet_data[m].number; i++){
      if(bullet_data[m].xy[0][i] != 0 || bullet_data[m].xy[1][i] != 0){
        if(m == 0 ){//normal
          switch( i / (bullet_data[m].number/bullet_data[m].mode_MAX)){
            case 0:
            ellipse(bullet_data[m].xy[0][i]+= bullet_data[m].speed, bullet_data[m].xy[1][i] , 10, 10);
            break;
            case 1:
            ellipse(bullet_data[m].xy[0][i]+= bullet_data[m].speed, bullet_data[m].xy[1][i]+=2 , 10, 10);
            break;  
            case 2:
            ellipse(bullet_data[m].xy[0][i]+= bullet_data[m].speed, bullet_data[m].xy[1][i]-=2 , 10, 10);
              break;
            case 3:
            ellipse(bullet_data[m].xy[0][i]+= bullet_data[m].speed, bullet_data[m].xy[1][i]+=4 , 10, 10);
            break;
            case 4:
            ellipse(bullet_data[m].xy[0][i]+= bullet_data[m].speed, bullet_data[m].xy[1][i]-=4 , 10, 10);
            break;
        }  
      }
        if(m == 1){//beam
          fill( 0 );
          rect(bullet_data[1].xy[0][i] += bullet_data[1].speed, bullet_data[1].xy[1][i], 20 * beam_h, beam_h);
        }
        if(m == 2){//ricochet
          rect(bullet_data[2].xy[0][i] += (bullet_data[2].speed),  bullet_data[2].xy[1][i] += (bullet_data[2].speed*4*ricochet_hanten[i]), 10, 10);
          if( bullet_data[2].xy[1][i] > height ){
            bullet_data[2].xy[1][i] = height;
            ricochet_hanten[i] = -1;
          }
          if( bullet_data[2].xy[1][i] <= 0 ){
            bullet_data[2].xy[1][i] = 10;
            ricochet_hanten[i] = 1;
          }
        }
        if(m == 3){ //wave
          fill(0,60);
          ellipse(bullet_data[3].xy[0][i], bullet_data[3].xy[1][i], wave_r[i], wave_r[i]);
          fill(255);
          ellipse(bullet_data[3].xy[0][i], bullet_data[3].xy[1][i], wave_r[i] - wave_ring, wave_r[i] - wave_ring);
          fill(0,60);
          wave_r[i] += bullet_speed*3;
        }
        if(m == 4 && moon_count[i] >= 0){ //moon
          moon_count[i] += 0.1;
          ellipse(-1*sin(moon_count[i])*90+chara_x,cos(moon_count[i])*90+chara_y,10,10);
          bullet_data[4].xy[0][i] = -1*sin(moon_count[i])*90+chara_x;
          bullet_data[4].xy[1][i] = cos(moon_count[i])*90+chara_y;
        }
      }
    }
    bullet_reset(m);
  }
  for(int i =0; i < bullet_data.length; i++){ //cooltime
    if(!bullet_data[i].cooltime){
      bullet_data[i].timer_count++;
      if(bullet_data[i].timer_count > bullet_data[i].timer_time){
        bullet_data[i].cooltime = true;
        bullet_data[i].timer_count = 0;
      }
    }
  }
  bullet_pressedkey();
}

void bullet_reset(int m){
  //bullet reset
    for( int i=0; i < bullet_data[m].number; i++){ 
      b_hit_check(m,i);
      if( (bullet_data[m].xy[0][i] >= width || bullet_data[m].hit[i]) && m != 4 ){
        bullet_data[m].xy[0][i] = 0;
        bullet_data[m].xy[1][i] = 0;
        bullet_data[m].hit[i] = false;
        if(m==1){ //beam
          beam_h = 0;
        }
        if(m==2){ //ricochet
          ricochet_hanten[i] = 1;
        }
      }
      if(m == 3){ //wave
        if(wave_r[i] > width*2 ){
          bullet_data[3].xy[0][i] = 0;
          bullet_data[3].xy[1][i] = 0;
          wave_r[i] = 0;
          bullet_data[3].hit[i] = false;
        } 
      }
      if(m == 4){ //moon
        if(moon_count[i] > 12){
          moon_count[i] = -1;
          bullet_data[m].xy[0][i] = 0;
          bullet_data[m].xy[1][i] = 0;
          bullet_data[m].hit[i] = false;
        }
      }
    }
}
void bullet_pressedkey(){
  if(keyState[32]){ //SPACE normal
    int nm_max = bullet_data[0].number/bullet_data[0].mode_MAX;
    if(bullet_data[0].now[0] < bullet_data[0].number-1){
      if(bullet_data[0].cooltime && chara_MP - bullet_data[0].cost >= 0){ 
        bullet_data[0].xy[0][bullet_data[0].now[0]] = chara_x;
        bullet_data[0].xy[1][bullet_data[0].now[0]] = chara_y;
        chara_MP -= bullet_data[0].cost;
        bullet_data[0].now[0] = (bullet_data[0].now[0]+1)%(nm_max);
         bullet_data[0].cooltime = false;
          switch (bullet_data[0].mode){
            case 3:
              if(bullet_data[0].xy[0][bullet_data[0].now[3]] == 0 && bullet_data[0].xy[1][bullet_data[0].now[3]] == 0){
                bullet_data[0].xy[0][bullet_data[0].now[3]] = chara_x;
                bullet_data[0].xy[1][bullet_data[0].now[3]] = chara_y;
                 bullet_data[0].now[3] =  (bullet_data[0].now[3]+1)%nm_max +nm_max*3;
              }
              if(bullet_data[0].xy[0][bullet_data[0].now[4]] == 0 && bullet_data[0].xy[1][bullet_data[0].now[4]] == 0){
                bullet_data[0].xy[0][bullet_data[0].now[4]] = chara_x;
                bullet_data[0].xy[1][bullet_data[0].now[4]] = chara_y;
                bullet_data[0].now[4] =  (bullet_data[0].now[4]+1)%nm_max +nm_max*4;
              }
            case 2:
              if(bullet_data[0].xy[0][bullet_data[0].now[1]] == 0 && bullet_data[0].xy[1][bullet_data[0].now[1]] == 0){
                bullet_data[0].xy[0][bullet_data[0].now[1]] = chara_x;
                bullet_data[0].xy[1][bullet_data[0].now[1]] = chara_y;
                bullet_data[0].now[1] =  (bullet_data[0].now[1]+1)%nm_max +nm_max;
              }
              if(bullet_data[0].xy[0][bullet_data[0].now[2]] == 0 && bullet_data[0].xy[1][bullet_data[0].now[2]] == 0){
                bullet_data[0].xy[0][bullet_data[0].now[2]] = chara_x;
                bullet_data[0].xy[1][bullet_data[0].now[2]] = chara_y;
                bullet_data[0].now[2] =  (bullet_data[0].now[2]+1)%nm_max +nm_max*2;
              }
              break;
          }
      }
    }
  }
  if(keyState['a'%256]){ //beam
    if(beam_count < 180){
      beam_count ++;
    }
    if(beam_count >= 180){
      fill(0,0,255);
    }else{
      fill( 0 );
    }
    ellipse(chara_x + chara_w/2, chara_y, beam_count / 6, beam_count / 6);
  }else if(beam_count > 0){
    bullet_data[1].damage = beam_count / 70;
    if(bullet_data[1].now[0] < bullet_data[1].number ){
      if(bullet_data[1].cooltime && chara_MP - bullet_data[1].cost >= 0){
        bullet_data[1].xy[0][bullet_data[1].now[0]] = chara_x;
        bullet_data[1].xy[1][bullet_data[1].now[0]] = chara_y;
        beam_h = beam_count / 6;
        chara_MP -= bullet_data[1].cost;
        bullet_data[1].now[0] = (bullet_data[1].now[0] + 1)%bullet_data[1].number;
        bullet_data[1].cooltime = false;
      }
    }
  beam_count = 0;
  }
  if(keyState['r'%256]){ //ricochet
      if(bullet_data[2].cooltime && chara_MP - bullet_data[2].cost >= 0){
       if(bullet_data[2].xy[0][bullet_data[2].now[0]] == 0 && bullet_data[2].xy[1][bullet_data[2].now[0]] == 0){
        bullet_data[2].xy[0][bullet_data[2].now[0]] = chara_x;
        bullet_data[2].xy[1][bullet_data[2].now[0]] = chara_y;
        chara_MP -= bullet_data[2].cost;
        bullet_data[2].now[0] = (bullet_data[2].now[0] + 1)%bullet_data[2].number;
        bullet_data[2].cooltime = false;
       }
    }
  }
  if(keyState['w'%256]){ //wave
    if(bullet_data[3].cooltime && chara_MP - bullet_data[3].cost >= 0){
      if(bullet_data[3].xy[0][bullet_data[3].now[0]] == 0 && bullet_data[3].xy[1][bullet_data[3].now[0]] == 0){
        bullet_data[3].xy[0][bullet_data[3].now[0]] = chara_x;
        bullet_data[3].xy[1][bullet_data[3].now[0]] = chara_y;
        wave_r[bullet_data[3].now[0]] = 100;
        chara_MP -= bullet_data[3].cost;
        bullet_data[3].now[0] = (bullet_data[3].now[0] + 1)%bullet_data[3].number;
        bullet_data[3].cooltime = false;
      } 
    }
  }
  if(keyState['m'%256]){ //moon
    if(bullet_data[4].cooltime && chara_MP - bullet_data[4].cost >= 0){
      if(bullet_data[4].xy[0][bullet_data[4].now[0]] == 0 && bullet_data[4].xy[1][bullet_data[4].now[0]] == 0){
        bullet_data[4].xy[0][bullet_data[4].now[0]] = chara_x;
        bullet_data[4].xy[1][bullet_data[4].now[0]] = chara_y;
        moon_count[bullet_data[4].now[0]] = 0;
        chara_MP -= bullet_data[4].cost;
        bullet_data[4].now[0] = (bullet_data[4].now[0] + 1)%bullet_data[4].number;
        bullet_data[4].cooltime = false;
      }
    }
  }
}

void enemy_show(){
  for (int i = 0; i < enemy_data.length; i++) {
    if(enemy_data[i].show){
      fill(0);
      rect(enemy_data[i].x, enemy_data[i].y, enemy_data[i].w, enemy_data[i].h); //画像でもok
      fill(0,255,0);
      float last_hp = (float)enemy_data[i].hp / enemy_data[i].hp_max;
      rect(enemy_data[i].x+(enemy_data[i].w-20)/2 , enemy_data[i].y - 10, 20*last_hp, 2);    
    }
  }
  enemy_data[0].move(0);
  enemy_data[1].move(0);
}

void b_hit_check(int m, int n){ // b =bullet
  bullet_data[m].hit[n] = false;
  for (int i = 0; i < enemy_data.length; i++) {
    if(enemy_data[i].show&& 0<= enemy_data[i].x && enemy_data[i].x <= width && 0 <= enemy_data[i].y && enemy_data[i].y <= height){
      for (int j = 0; j < enemy_data[i].hit_scale.length; j++) {
        int x1 = enemy_data[i].hit_scale[j][0] + enemy_data[i].x;
        int x2 = x1 + enemy_data[i].hit_scale[j][2];
        int y1 = enemy_data[i].hit_scale[j][1] + enemy_data[i].y;
        int y2 = y1 + enemy_data[i].hit_scale[j][3];
        if(x1 < bullet_data[m].xy[0][n] && bullet_data[m].xy[0][n] < x2 && y1 < bullet_data[m].xy[1][n] && bullet_data[m].xy[1][n] < y2){     
          if(m != 4 && m!= 1){
            bullet_data[m].xy[0][n] = 0;
            bullet_data[m].xy[1][n] = 0;
          }
          bullet_data[m].hit[n] = true;
            enemy_data[i].damage(m,n);
        }
        if(m == 1){
          if((bullet_data[m].xy[0][n]+beam_h*20 > x1) && (bullet_data[m].xy[0][n] < x2)){
            if((bullet_data[m].xy[1][n]+beam_h > y1) && (bullet_data[m].xy[1][n] < y2 )){
              enemy_data[i].damage(m,n);
            }
          }
        }
        if(m == 3){ //wave
          if( (x1-chara_x)*(x1-chara_x)+(y1-chara_y)*(y1-chara_y) <  wave_r[n]*wave_r[n]/4){ //とりあえず当たり判定は1箇所
            enemy_data[i].damage(m,n);
          }
        }
      }
    }
  }
}

void chara(){
  chara_data();
  chara_move();
  c_hit_check();
  if(chara_cool){
    chara_cool_count ++;
    if(chara_cool_count >= 60){
      chara_cool =false;
      chara_cool_count =0;
    }
  }
  if(chara_HP <= 0){
    display_mode = 1;
  }
}
void chara_data(){
  if(!chara_cool || frameCount%7 == 0){
    if(keyState['a'%256]){ //charge
      image(img2, chara_x, chara_y, chara_w, chara_h);
    }else { //
      image(img, chara_x, chara_y, chara_w, chara_h);
    }
    fill(0);
    text(chara_HP +"/"+ chara_MP,chara_x, chara_y - chara_h/2);
  }
    int[] chara_exp_table ={ 0, 0, 1, 2, 4, 8};
    if(chara_MP < chara_MAX_MP && frameCount%120 == 0){ //
        chara_MP +=10;
    }
    //HPバー
    float last_HP = (float)chara_HP/chara_MAX_HP;
    fill(0,255,0);
    rect(80, 15, 145 *last_HP, 10);
    //MPバー
    float last_MP =  (float)chara_MP/ chara_MAX_MP;
    fill(0,0,255);
    rect(80, 30, 145 *last_MP, 10);  
    fill( 0 );
    for(int i=0; i<chara_exp_table.length; i++){
      if(chara_exp >= chara_exp_table[i]){
        if(chara_level < i){
          chara_level = i;
          levelup(i);
        }
      }
    }
    image(img, 35,35, 90, 90);  //キャラ画像
    image(img3, 125, 35,250,70); //status画像
    for(int i =0; i < icon.length; i++){
      if(bullet_data[i].unlock){
        image(icon[i], 88+ 15*i, 53 ,15, 15); //icon
      }
      if(!bullet_data[i].cooltime){
        fill(0, 80);
        rect(80+15*i, 45, 15, 15);
        fill(0);
      }
    }
    //Level
    rect(10, 50, 30, 10);
    fill(255);
    text("Lv."+chara_level, 30, 60);
    fill(0);
}
void levelup(int n){
  switch ( n ){
    case 2:
      bullet_data[0].mode = 2;
      for(int i=0; i<bullet_data[0].number; ++i){ bullet_data[0].xy[0][i]=0; bullet_data[0].xy[1][i]=0;  }
      break;
    case 3:
      bullet_data[0].mode = 3;
      break;
  }
}

void c_hit_check(){ //敵から自キャラへの当たり判定  
  for(int i=0; i < enemy_data.length; i++){
    if((enemy_data[i].x - chara_x)*(enemy_data[i].x - chara_x) + (enemy_data[i].y - chara_y) * (enemy_data[i].y - chara_y) < chara_w*chara_w/4){
      if(!chara_cool){
        chara_HP -= enemy_data[i].atk;
        chara_cool = true;
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
    if(chara_h/2+100 > chara_y){
        chara_y = chara_h/2+100;
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
