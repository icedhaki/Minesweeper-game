int[][] array1;
boolean[][] closed; // whether cell is open or not
int rows;
int cols;
int x;
int y;
float cellWidth;
float cellHeight;
PImage flagImg;
PImage bombImg;
boolean gameOver;
boolean win;
boolean click;
boolean start;
boolean initial;
boolean check;
int totalNoMines;
int totalFlags;

Cell[][] board;

void setup(){
  size(800,800);
  
  flagImg=loadImage("flag.png");
  bombImg=loadImage("bomb.png");
  
  gameOver=false;
  win=false;
  start=false;
  initial=false;
  totalNoMines=0;
  totalFlags=0;
}

void draw(){
  background(255);
  if(start==false){
    startPage();
    totalNoMines=0;
    totalFlags=0;
  }
  else{
    // initial generation of everything
    if(initial==false){
          cellWidth=width/rows;
          cellHeight=height/cols;
          
          array1=new int[rows][cols];
          board=new Cell[rows][cols];
          
          // Initializing cells
          for(int i=0;i<rows;i++){
            for(int j=0;j<cols;j++){
              board[i][j]=new Cell(cellWidth*i,cellHeight*j);
            }
          }
          
          // Generating mines
          for(int i=0;i<rows;i++){
              x=int(random(rows));
              y=int(random(cols));
              
              if(array1[x][y]==-1){
                i--;
              }
              else{
                array1[x][y]=-1;
              }
          }
          
          // Calculating number of mines around each cell
          for(int i=0;i<rows;i++){
            for(int j=0;j<cols;j++){
              if(array1[i][j]!=-1){
                for(int a=i-1;a<=i+1;a++){
                  for(int b=j-1;b<=j+1;b++){
                    if(a>-1 && a<cols && b>-1 && b<rows){
                      if(array1[a][b]==-1){
                       array1[i][j]=array1[i][j]+1;
                      }
                    }
                  }
                }
              }
            }
          }
          
          for(int i=0;i<rows;i++){
            for(int j=0;j<cols;j++){
              if(array1[i][j]==-1){
                println("location:"+i+","+j);
              }
            }
          }
      initial=true;
    }
    
    if(gameOver==false){
      for(int i=0;i<rows;i++){
        for(int j=0;j<cols;j++){
          board[i][j].display(array1[i][j]);
        }
      }
      checkWin();
      if(win==true){
        fill(0);
        textSize(18);
        fill(#21890B);
        rect(width/3,height/2,width/3,height/6);
        fill(255);
        text("Congratulations, you won!",width/2.8,height/1.8);
        text("Press to restart",width/2.4,height/1.6);
        
        if(mousePressed==true && mouseX>=width/3 && mouseX<=width/3+width/3 && mouseY>=height/2 && mouseY<=height/2+height/6){
          background(255);
          gameOver=false;
          start=false;
          initial=false;
          win=false;
        }
      }
    }
    else if(gameOver==true){
      for(int i=0;i<rows;i++){
        for(int j=0;j<cols;j++){
          
            board[i][j].display(array1[i][j]);
          
        }
      }
      for(int i=0;i<rows;i++){
            for(int j=0;j<cols;j++){
              if(array1[i][j]==-1){
                image(bombImg,board[i][j].cellX,board[i][j].cellY,board[i][j].cellW,board[i][j].cellH);
              }
            }
      }
      fill(0);
      textSize(18);
      fill(#21890B);
      rect(width/3,height/2,width/3,height/6);
      fill(255);
      text("Game is over",width/2.3,height/1.8);
      text("Press to restart",width/2.35,height/1.6);
      
      
    }
    
  }
}

void mousePressed(){
  if(start==false){
    check=true;
  }
  else{
    if(mouseButton==LEFT){
      for(int i=0;i<rows;i++){
        for(int j=0;j<cols;j++){
          if(mouseX>=board[i][j].cellX && mouseX<=board[i][j].cellX + board[i][j].cellW && mouseY>=board[i][j].cellY && mouseY<=board[i][j].cellY + board[i][j].cellH){
            board[i][j].open=true;
            emptyCell(i,j);
            totalNoMines++;
          }
        }
      }
    }
    if(mouseButton==RIGHT){
      for(int i=0;i<rows;i++){
        for(int j=0;j<cols;j++){
          if(mouseX>=board[i][j].cellX && mouseX<=board[i][j].cellX + board[i][j].cellW && mouseY>=board[i][j].cellY && mouseY<=board[i][j].cellY + board[i][j].cellH){
            if(board[i][j].open!=true){
              board[i][j].flag=true;
              board[i][j].countFlag++;
              if(board[i][j].countFlag%2==0){
                board[i][j].flag=false;
              }
              if(board[i][j].flag==true){
                totalFlags++;
              }
              else{
                totalFlags--;
              }
            }
          }
        }
      }
    }
    if(gameOver==true){
      click=true;
      if(mousePressed==true && mouseX>=width/3 && mouseX<=width/3+width/3 && mouseY>=height/2 && mouseY<=height/2+height/6){
        background(255);
        gameOver=false;
        start=false;
        initial=false;
      }
    }
  }
}

void startPage(){
  fill(255);
  stroke(0);
  rect(width/15,height/1.4,width/4,height/5); // 10*10 mode button
  rect(width/2.7,height/1.4,width/4,height/5); // 20*20 mode button
  rect(width/1.5,height/1.4,width/4,height/5); // 30*30 mode button
  fill(0);
  textSize(20);
  text("Minesweeper",width/2.4,height/8);
  text("Click left mouse button to open cell. If cell contains mine, game is over. If not, then cell will display number of mines around it.",width/15,height/5,width/1.1,height/4);
  text("Click right mouse button to flag cell. To remove flag, click right mouse button again.",width/15,height/2.8,width/1.1,height/4);
  text("Choose grid configuration by clicking one of the buttons below: 10x10, 20x20, 30x30.", width/15,height/1.9,width/1.1,height/4);
  text("10x10 mode",width/9,height/1.2);
  text("20x20 mode",width/2.4,height/1.2);
  text("30x30 mode",width/1.4,height/1.2);
  
   // When one of the buttons are pressed
  if(check==true){
    if(mouseX>=width/15 && mouseX<=width/15+width/4 && mouseY>=height/1.4 && mouseY<=height/1.4+height/5){
      rows=10;
      cols=10;
      start=true;
    }
    else if(mouseX>=width/2.7 && mouseX<=width/2.7+width/4 && mouseY>=height/1.4 && mouseY<=height/1.4+height/5){
      rows=20;
      cols=20;
      start=true;
    }
    else if(mouseX>=width/1.5 && mouseX<=width/1.5+width/4 && mouseY>=height/1.4 && mouseY<=height/1.4+height/5){
      rows=30;
      cols=30;
      start=true;
    }
  }
  check=false;
}


class Cell{
  float cellX;
  float cellY;
  float cellW;
  float cellH;
  boolean open;
  boolean flag;
  int countFlag;
  float rectColor;
  
  Cell(float tempX, float tempY){
    cellX=tempX;
    cellY=tempY;
    
    cellW=width/rows;
    cellH=height/cols;
    open=false;
    flag=false;
    countFlag=0;
    rectColor=255;
  }
  
  void display(int a){
    fill(rectColor);
    rect(cellX,cellY,cellWidth,cellHeight);
    if(open==true){
      if(a==-1){
        imageMode(CORNER);
        image(bombImg,cellX,cellY,cellW,cellH);
        gameOver=true;
      }
      else{
        rectColor=150;
        fill(0);
        if(rows==10){
          textSize(30);
        }
        else if(rows==20){
          textSize(18);
        }
        else if(rows==30){
          textSize(12);
        }
        if(a>0){
          text(a,cellX+cellW/2,cellY+cellH/2);
        }
      }
    }
    if(flag==true){
      imageMode(CORNER);
      image(flagImg,cellX,cellY,cellW,cellH);
    }
  }
}

void emptyCell(int x, int y){
  if(array1[x][y]==0){
    for(int a=x-1;a<x+2;a++){
      for(int b=y-1;b<y+2;b++){
        if(a>-1 && b>-1 && a<rows && b<rows){  
          if(board[a][b].open==false){
            totalNoMines++;
            board[a][b].open=true;
            if(array1[a][b]==0){
               emptyCell(a,b);
            }
          }
        }
     }
    }
  }
 
}

void checkWin(){
  if(totalFlags==rows && totalNoMines==(rows*cols)-rows && gameOver==false){
    win=true;
  }
  
  println(win);
  println("no mines:"+totalNoMines);
  println("flags:"+totalFlags);
}
