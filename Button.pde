public class SimpleButton
{
    private float x, y, width, height;
    private int myRow, myCol;
    private boolean pressed;
    private boolean beenReset;
    private boolean isFlagged;
    
    public SimpleButton ( float xx, float yy, float w, float h, int row, int col )
    {
        x = xx-1; y = yy-1; width = w+2; height = h+2;
        pressed = false;
        myRow = row;
        myCol = col;
        isFlagged = false;
        
        Interactive.add( this ); // register it with the manager
    }
    
    // called by manager
    
    void mousePressed () 
    {
      if(!beenReset && gameStart) {
        if(mouseButton == LEFT && !isFlagged) {
            //Place the bombs
          if(!firstButtonPressed) {
            bombs = new boolean[numRow][numCol]; //Place the bombs
            for(int r = 0; r < numRow; r++) {
              for(int c = 0; c < numCol; c++)
                bombs[r][c] = false;
            }
            for(int i = 1; i <= numBomb; i++) {
              int bombRow = (int)(Math.random()*numRow);
              int bombCol = (int)(Math.random()*numCol);
              if(bombs[bombRow][bombCol] || (bombRow == myRow && bombCol == myCol))
                i--;
              else
                bombs[bombRow][bombCol] = true;
            }
          } //End of !firstButtonPressed
        
          
          /*if(firstButtonPressed && bombs!=null) { //Prints the layout of the bombs
            for(int r = 0; r < bombs.length; r++) {
              for(int c = 0; c < bombs[r].length; c++)
                System.out.print(bombs[r][c] + " ");
            System.out.println();
            }
          }
          System.out.println(); */
          
          firstButtonPressed = true;
          if(!pressed)
            pressed = true;
          
          if(!isFlagged && !isBomb(myRow, myCol) && neighborBombs(bombs, myRow, myCol) == 0) {
             for(int i = -1; i <= 1; i++) {
               J_LOOP: for(int j = -1; j <= 1; j++) {
                 if(!inBounds(myRow + i, myCol + j))
                   continue J_LOOP;
                 if(buttons[myRow + i][myCol + j].getPressed() || buttons[myRow + i][myCol + j].getFlagged())
                   continue J_LOOP;
                 else
                   buttons[myRow + i][myCol + j].mousePressed();
              } //End of J_LOOP
            } //End of i loop
          } //End of clicking neighbors
          
          else if(!isFlagged && isBomb(myRow, myCol)) {
            theOne = this;
            gameLost = true;
            gameOver = true;
            gameStart = false;
            reveal(myRow, myCol);
          }
        } //End of mouseButton == LEFT
        
        
        else if(!beenReset && mouseButton == RIGHT && !pressed) {
          if(!isFlagged) {
            //System.out.println("Flagging");
            isFlagged = true;
            flags--;
          }
          else {
            isFlagged = false;
            flags++;
          }
        } //End of mouseButton == RIGHT
      } //End of gameStart
      
    } //End of mousePressed()

////////////////////////////////////////////////////////////////////////////////////

    void draw () 
    {
      if(!beenReset && (gameOver || gameStart)) {
        noStroke();
        
        if ( pressed )  {
          fill( 189 );
          rect(x-1, y-1, width + 1, height + 1);
          fill( 169 );
          rect(x, y + 1, 1, height); //Inner left edge
          rect(x + 1, y, width, 1); // Inner top edge
          fill( 155 );
          rect(x, y, 1, 1); //Inner corner
          fill( 123 );
          rect(x - 1, y - 1, 1, height + 2); //Outer left edge
          rect(x, y - 1, width + 1, 1); //Outer top edge
        
          if(isBomb(myRow, myCol)) {
            if(this == theOne) {
              fill(254, 14, 23);
              rect(x, y, width + 1, height + 2);
              fill(215, 47, 53);
              rect(x, y, 1, height + 1);
              rect(x, y, width + 1, 1);
              image(img,  x + width/2. + 1, y + height/2. + 1, 15, 15);
            }
            else {
              fill(189);
              rect(x, y, width + 1, height + 2);
              fill(169);
              rect(x, y, 1, height + 1);
              rect(x, y, width + 1, 1);
              image(img,  x + width/2. + 1, y + height/2. + 1, 15, 15);
            }
          }
          
          else {
            if(neighborBombs(bombs, myRow, myCol) == 1)
              fill(0, 0, 255);
            else if(neighborBombs(bombs, myRow, myCol) == 2)
              fill(0, 123, 255);
            else if(neighborBombs(bombs, myRow, myCol) == 3)
              fill(255, 0, 0);
            else if(neighborBombs(bombs, myRow, myCol) == 4)
              fill(0, 0, 123);
            else if(neighborBombs(bombs, myRow, myCol) == 5)
              fill(126, 3, 3);
            else if(neighborBombs(bombs, myRow, myCol) == 6)
              fill(0, 128, 128);
            else if(neighborBombs(bombs, myRow, myCol) == 7)
              fill(1);
            else if(neighborBombs(bombs, myRow, myCol) == 8)
              fill(128);
            else
              fill( 189 );
              
            textSize(15);
            textAlign(CENTER);
            text(neighborBombs(bombs, myRow, myCol), x + width/2, y + height/2 + 5);
          }  
          
        } //End of pressed
        
        else {
          fill( 189 );
          
          rect(x+1, y+1, width-2, height-2);
          
          fill(255); //Outer edges of button
          rect(x-1, y-1, 2, height+1); //Left edge
          rect(x+1, y-1, width-1, 2); //Top edge
          fill(123);
          rect(x, y+height-1, width-1, 2); //Bottom edge
          rect(x+width-2+1, y, 2, height+1); //Right edge
          fill(200); //Corners
          rect(x+width-1, y, 1, 1); 
          rect(x+width, y-1, 1, 1);
          rect(x, y+height-1, 1, 1);
          rect(x-1, y+height, 1, 1);
        }
      }
      else
        beenReset = true;
        
      if(!beenReset && isFlagged && !pressed)
        image(flag_img, x + width/2. + 1, y + height/2., 15, 15);
    } //End of draw()
    
    
    public int neighborBombs(boolean [][] bombArray, int row, int col) {
      int sum = 0;
      for(int rPlus = -1; rPlus <= 1; rPlus++) {
        for(int cPlus = -1; cPlus <= 1; cPlus++) {
          if(cPlus == 0 && rPlus == 0)
            cPlus++;
          if(inBounds(row+rPlus, col+cPlus) && bombArray[row + rPlus][col + cPlus])
            sum++;
        }
      }
      return sum;
    }
   
    
    public boolean inBounds(int r, int c) {
      return r >= 0 && c >= 0 && r < numRow && c < numCol;
    }
    
    public boolean isBomb(int r, int c) {
      return bombs[r][c];
    }
    
    public boolean getPressed() {return pressed;}
    public void press() {pressed = true;}
    public boolean getFlagged() {return isFlagged;}
    public void resetFlagged() {isFlagged = false;}
    
} //End of SimpleButton class

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public void resetButton(float x, float y, float rad, boolean pressed, int faceNum) {
  noStroke();
  fill(123);
  rect(x - rad - 5, y - rad - 5, 9 + rad*2, 9 + rad*2);
  fill(255);
  if(pressed)
    fill(123);
  rect(x - rad - 4, y - rad - 4, 2, 6 + rad*2);
  rect(x - rad - 2, y - rad - 4, 4 + rad*2, 2);
  fill(189);
  rect(x - rad - 2, y - rad - 2, 3 + rad*2, 3 + rad*2);
  rect(x - rad - 3, y + rad + 1, 1, 1);
  rect(x - rad - 4, y + rad + 2, 1, 1);
  rect(x - rad - 5, y + rad + 3, 1, 1);
  rect(x + rad + 1, y - rad - 3, 1, 1);
  rect(x + rad + 2, y - rad - 4, 1, 1);
  rect(x + rad + 3, y - rad - 5, 1, 1);
  
  if(pressed) { //Face
    x++; y++;
    fill(0); 
    ellipse(x, y, (rad-0.25)*2, (rad-0.25)*2);
    fill(255, 255, 67);
    ellipse(x, y, (rad-1.25)*2, (rad-1.25)*2);
    if(faceNum == 0) { //Smile
      fill(0);
      rect(x - 3, y - 3, 2, 2);
      rect(x + 1, y - 3, 2, 2);
      rect(x - 4, y + 2, 1, 1);
      rect(x - 3, y + 3, 1, 1);
      rect(x - 2, y + 4, 4, 1);
      rect(x + 2, y + 3, 1, 1);
      rect(x + 3, y + 2, 1, 1);
    }
    x--; y--;
  }
  else {
    fill(0); 
    ellipse(x, y, rad*2, rad*2);
    fill(255, 255, 67);
    ellipse(x, y, (rad-1)*2, (rad-1)*2);
    if(faceNum == 0) { //Smile
      fill(0);
      rect(x - 3, y - 3, 2, 2);
      rect(x + 1, y - 3, 2, 2);
      rect(x - 4, y + 2, 1, 1);
      rect(x - 3, y + 3, 1, 1);
      rect(x - 2, y + 4, 4, 1);
      rect(x + 2, y + 3, 1, 1);
      rect(x + 3, y + 2, 1, 1);
    }  
  }
}
