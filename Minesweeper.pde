import de.bezier.guido.*;
public PImage img, flag_img;

public boolean[][] bombs;
public SimpleButton[][] buttons;
public SimpleButton theOne;
public boolean firstButtonPressed;

public boolean startScreen, gameStart, gameOver, gameLost; //Screen control booleans
public boolean custom1, custom2, customizeBomb; public String customRow, customCol, customBomb; //For custom grid size options
public int numRow, numCol, numBomb;
public int flags; //Remaining number of flags -- Top left corner
public int timer, startTime; //For the timer
public boolean resetButtonIsPressed, tempResetButtonIsPressed; public int face; // 0 = smiling, 1 = :O, 2 = Dead
public boolean gameWon = false; //Checks if all bombs are flagged

public int w; //Width & Height of buttons
public int firstButtonX, firstButtonY; //Position of the top-left button - The gray square excluding the border (Border is 2 pixels wide)

//////////////////////////////////////////////////////////////////////////////////// SETUP

public void setup() {
  size(1000, 1000);
  background(0);
  img = loadImage("Untitled.png");
  flag_img = loadImage("FLAG_IMAGE.png");
  imageMode(CENTER);
  
  Interactive.make( this );
  w = 15; //Width of buttons
  firstButtonX = 25; firstButtonY = 75;
  
  bombs = null;
  buttons = null;
  theOne = null;
  firstButtonPressed = false;
  
  startScreen = true;
    customRow = "30"; customCol = "30"; customBomb = "1";
    custom1 = false; custom2 = false; customizeBomb = false;
  gameStart = false;
  gameOver = false;
  gameLost = false;
  
  timer = 0;
  face = 0;
  resetButtonIsPressed = false;
  tempResetButtonIsPressed = false;
  gameWon = false;
} //End of setup()


public void reset() { //Things needed to reinitialize when game resets
  background(0);
  
  for(int r = 0; r < buttons.length; r++) {
    for(int c = 0; c < buttons[r].length; c++) {
      buttons[r][c].resetFlagged();
      buttons[r][c] = null;
    }
  }
  bombs = null;
  buttons = null;
  theOne = null;
  firstButtonPressed = false;
  
  startScreen = true;
    custom1 = false; custom2 = false; customizeBomb = false;
  gameStart = false;
  gameOver = false;
  gameLost = false;
  
  face = 0;
  timer = 0;
  resetButtonIsPressed = false;
  tempResetButtonIsPressed = false;
  gameWon = false;
}
/////////////////////////////////////////////////////////////////////////////////// DRAW

public void draw() {
  if(startScreen) {
    background(0);
    textAlign(CENTER);
    textSize(60);
    fill(210, 0, 0);
    text("Welcome to Minesweeper!", width/2, 130);
    
    textSize(30);
    stroke(200); //Beginner mode button
    strokeWeight(2);
    if(mouseX >= 350 && mouseX <= 650 && mouseY >= 250 && mouseY <= 350) {
      strokeWeight(4);
      stroke(17, 140, 79);
    }
    fill(210, 0, 0);
    rect(350, 250, 300, 100);
    fill(255);
    text("BEGINNER", width/2, 290);
    text("9 x 9", width/2, 330); //End of Beginner mode button
    
    stroke(200); //Intermediate mode button
    strokeWeight(2);
    if(mouseX >= 350 && mouseX <= 650 && mouseY >= 450 && mouseY <= 550) {
      strokeWeight(4);
      stroke(17, 140, 79);
    }
    fill(210, 0, 0);
    rect(350, 450, 300, 100);
    fill(255);
    text("INTERMEDIATE", width/2, 490);
    text("16 x 16", width/2, 530); //End of Intermediate mode button

    stroke(200); //Advanced mode button
    strokeWeight(2);
    if(mouseX >= 350 && mouseX <= 650 && mouseY >= 650 && mouseY <= 750) {
      strokeWeight(4);
      stroke(17, 140, 79);
    }
    fill(210, 0, 0);
    rect(350, 650, 300, 100);
    fill(255);
    text("ADVANCED", width/2, 690);
    text("16 x 30", width/2, 730); //End of Advanced mode button
    
    text("CUSTOM", width/2, 830); //Custom area
    text("X", width/2, 910);
    text("Bombs:", 100, 830);
    stroke(200);
    strokeWeight(2);
    fill(0);
    if((mouseX >= 200 && mouseX <= 450 && mouseY >= 860 && mouseY <= 940) || custom1) {
      strokeWeight(4);
      stroke(17, 140, 79);
    }
    rect(200, 860, 250, 80);
    fill(255);
    text(customRow, 325, 910);
    strokeWeight(2); //Custom 2
    stroke(200);
    fill(0);
    if((mouseX >= 550 && mouseX <= 800 && mouseY >= 860 && mouseY <= 940) || custom2) {
      strokeWeight(4);
      stroke(17, 140, 79);
    }
    rect(550, 860, 250, 80);
    fill(255);
    text(customCol, 675, 910);
    strokeWeight(2); //CostomizeBomb
    stroke(200);
    fill(0);
    if((mouseX >= 50 && mouseX <= 150 && mouseY >= 860 && mouseY <= 940) || customizeBomb) {
      strokeWeight(4);
      stroke(17, 140, 79);
    }
    rect(50, 860, 100, 80);
    fill(255);
    text(customBomb, 100, 910);
    strokeWeight(2); //Go button
    stroke(200);
    fill(210, 0, 0);
    if(mouseX >= 850 && mouseX <= 950 && mouseY >= 860 && mouseY <= 940) {
      strokeWeight(4);
      stroke(17, 140, 79);
    }
    rect(850, 860, 100, 80);
    fill(255);
    text("GO", 900, 910);
    
  } //End of startScreen

/////////////////////////////////////////////////////////////////////////////////// gameStart

  if(gameStart) {
    background(0);
    
    //Timer
      if(millis() - startTime >= 1000 && timer < 999) {
        timer++;
        startTime = millis();
      }
    //End of Timer
    
    //Play Area   
      fill(189);
      rect(firstButtonX - 9, firstButtonY - 4 - 50, numCol*(w+4) + 13, numRow*(w+4) + 50 + 10); //Border of everything
      
      fill(123); //Border of buttons
      rect(firstButtonX-4, firstButtonY-4, 2, numRow*(w+4) + 3); //Left edge
      rect(firstButtonX-2, firstButtonY-4, numCol*(w+4) + 2, 2); //Top edge
      fill(255);
      rect(firstButtonX - 2 + numCol*(w+4), firstButtonY - 3, 2, numRow*(w+4) + 1); //Right edge
      rect(firstButtonX-3, firstButtonY -2 + numRow*(w+4), numCol*(w+4) + 3, 2); //Bottom edge
      fill(189); //Corners
      rect(firstButtonX - 2 + numCol*(w+4), firstButtonY - 3, 1, 1); 
      rect(firstButtonX - 1 + numCol*(w+4), firstButtonY - 4, 1, 1);
      rect(firstButtonX - 3, firstButtonY - 2 + numRow*(w+4), 1, 1);
      rect(firstButtonX - 4, firstButtonY - 1 + numRow*(w+4), 1, 1);
      
      fill(255); //Border of scoreboard
      rect(firstButtonX - 3, firstButtonY - 12, numCol*(w+4) + 3, 2); //Bottom edge
      rect(firstButtonX - 2 + numCol*(w+4), firstButtonY - 12 - 34, 2, 34); //Right edge
      fill(123);
      rect(firstButtonX - 4, firstButtonY - 12 - 35, numCol*(w+4) + 3, 2); //Top edge
      rect(firstButtonX - 4, firstButtonY - 12 - 35, 2, 36); //Left edge
      
      fill(0); //Scoreboard
      rect(firstButtonX + 4, firstButtonY - 40, 47, 23); //Flags left
      rect(firstButtonX + (numCol-3)*(w+4) + 1, firstButtonY - 40, 47, 23); //Timer
      fill(254, 15, 23); //Color of text
      textSize(22);
      textAlign(CENTER);
      if(flags < 10)
        text("00" + flags, firstButtonX + 4 + 47/2 +1, firstButtonY - 40 + 20);
      else if (flags < 100)
        text("0" + flags, firstButtonX + 4 + 47/2 +1, firstButtonY - 40 + 20);
      else
        text(flags, firstButtonX + 4 + 47/2 +1, firstButtonY - 40 + 20);
      textAlign(RIGHT);
      if(timer < 10)
        text("00" + timer, firstButtonX + (numCol-3)*(w+4) + 1 + 47, firstButtonY - 40 + 20);
      else if(timer < 100)
        text("0" + timer, firstButtonX + (numCol-3)*(w+4) + 1 + 47, firstButtonY - 40 + 20);
      else
        text(timer, firstButtonX + (numCol-3)*(w+4) + 1 + 47, firstButtonY - 40 + 20);
      
      if(tempResetButtonIsPressed && mousePressed && mouseX >= firstButtonX - 2 + (numCol/2.)*(w+4) - 13 && mouseX <= firstButtonX - 2 + (numCol/2.)*(w+4) + 12 && mouseY >= firstButtonY - 15 - 5 - 8 - 13 && mouseY <= firstButtonY - 15) { //If the reset button is being pressed
        resetButton(firstButtonX - 2 + (numCol/2.)*(w+4), firstButtonY - 15 - 5 - 8, 8, true, 0);
      }
      else {
        resetButton(firstButtonX - 2 + (numCol/2.)*(w+4), firstButtonY - 15 - 5 - 8, 8, false, 0);
        resetButtonIsPressed = false;
      }     
    
    /////////////////////////////////////////////////////////////////////////////////// End of Play Area
    
    int nonpressed = 0;
    if(bombs != null) {
      for(int r = 0; r < bombs.length; r++) {
        for(int c = 0; c < bombs[r].length; c++) {
          if(!bombs[r][c] && !buttons[r][c].getPressed())
            nonpressed++;
        }
      }
      gameWon = nonpressed == 0;
    }
    
    int nonflagged = 0;
    if(!gameWon && bombs != null) {
      for(int r = 0; r < bombs.length; r++) {
        for(int c = 0; c < bombs[r].length; c++) {
          if(bombs[r][c] && !buttons[r][c].getFlagged())
            nonflagged++;
        }
      }
      gameWon = nonflagged == 0;
    }
    
    if(gameWon) {
      //System.out.println("WIN");
      gameOver = true;
      gameStart = false;      
    }
    
  } //End of gameStart
  
  /////////////////////////////////////////////////////////////////////////////////// Game over
  
  if(gameOver) {
    background(0);     
      
    if(gameWon) {
      fill(192);
      rect(firstButtonX, firstButtonY + numCol * (w+4) + 10, numRow * (w+4), 50);
      fill(255, 0, 0);
      textAlign(CENTER);
      textSize(30);
      text("You win!", firstButtonX + (numRow * (w+4))/2., (firstButtonY + numCol * (w+4) + 10) + 35);
    }
      
      //Play Area   
        fill(189);
        rect(firstButtonX - 9, firstButtonY - 4 - 50, numCol*(w+4) + 13, numRow*(w+4) + 50 + 10); //Border of everything
        
        fill(123); //Border of buttons
        rect(firstButtonX-4, firstButtonY-4, 2, numRow*(w+4) + 3); //Left edge
        rect(firstButtonX-2, firstButtonY-4, numCol*(w+4) + 2, 2); //Top edge
        fill(255);
        rect(firstButtonX - 2 + numCol*(w+4), firstButtonY - 3, 2, numRow*(w+4) + 1); //Right edge
        rect(firstButtonX-3, firstButtonY -2 + numRow*(w+4), numCol*(w+4) + 3, 2); //Bottom edge
        fill(189); //Corners
        rect(firstButtonX - 2 + numCol*(w+4), firstButtonY - 3, 1, 1); 
        rect(firstButtonX - 1 + numCol*(w+4), firstButtonY - 4, 1, 1);
        rect(firstButtonX - 3, firstButtonY - 2 + numRow*(w+4), 1, 1);
        rect(firstButtonX - 4, firstButtonY - 1 + numRow*(w+4), 1, 1);
        
        fill(255); //Border of scoreboard
        rect(firstButtonX - 3, firstButtonY - 12, numCol*(w+4) + 3, 2); //Bottom edge
        rect(firstButtonX - 2 + numCol*(w+4), firstButtonY - 12 - 34, 2, 34); //Right edge
        fill(123);
        rect(firstButtonX - 4, firstButtonY - 12 - 35, numCol*(w+4) + 3, 2); //Top edge
        rect(firstButtonX - 4, firstButtonY - 12 - 35, 2, 36); //Left edge
        
        fill(0); //Scoreboard
        rect(firstButtonX + 4, firstButtonY - 40, 47, 23); //Flags left
        rect(firstButtonX + (numCol-3)*(w+4) + 1, firstButtonY - 40, 47, 23); //Timer
        fill(254, 15, 23); //Color of text
        textSize(22);
        textAlign(CENTER);
        if(flags < 10)
          text("00" + flags, firstButtonX + 4 + 47/2 +1, firstButtonY - 40 + 20);
        else if (flags < 100)
          text("0" + flags, firstButtonX + 4 + 47/2 +1, firstButtonY - 40 + 20);
        else
          text(flags, firstButtonX + 4 + 47/2 +1, firstButtonY - 40 + 20);
        textAlign(RIGHT);
        if(timer < 10)
          text("00" + timer, firstButtonX + (numCol-3)*(w+4) + 1 + 47, firstButtonY - 40 + 20);
        else if(timer < 100)
          text("0" + timer, firstButtonX + (numCol-3)*(w+4) + 1 + 47, firstButtonY - 40 + 20);
        else
          text(timer, firstButtonX + (numCol-3)*(w+4) + 1 + 47, firstButtonY - 40 + 20);
          
        if(tempResetButtonIsPressed && mousePressed && mouseX >= firstButtonX - 2 + (numCol/2.)*(w+4) - 13 && mouseX <= firstButtonX - 2 + (numCol/2.)*(w+4) + 12 && mouseY >= firstButtonY - 15 - 5 - 8 - 13 && mouseY <= firstButtonY - 15) { //If the reset button is being pressed
          resetButton(firstButtonX - 2 + (numCol/2.)*(w+4), firstButtonY - 15 - 5 - 8, 8, true, 0);
        }
        else {
          resetButton(firstButtonX - 2 + (numCol/2.)*(w+4), firstButtonY - 15 - 5 - 8, 8, false, 0);
          resetButtonIsPressed = false;
        }
      //End of Play Area
      
  } //End of gameOver
} //End of draw()

/////////////////////////////////////////////////////////////////////////////////// KeyTyped

public void keyTyped() {
  if(startScreen) {
    final String numbers = "1234567890";
    if(custom1) {
      if(key >= 48 && key <= 57)
        customRow+=String.fromCharCode(key);
      if(key == 8 && customRow.length() > 0)
        customRow = customRow.substring(0, customRow.length()-1);
    }
    if(custom2) {
      if(key >= 48 && key <= 57)
          customCol+=String.fromCharCode(key);
      if(key == 8 && customCol.length() > 0)
        customCol = customCol.substring(0, customCol.length()-1);
    }
    if(customizeBomb) {
      if(key >= 48 && key <= 57)
          customBomb+=String.fromCharCode(key);
      if(key == 8 && customBomb.length() > 0)
        customBomb = customBomb.substring(0, customBomb.length()-1);
    }
  } //End of startScreen
} //End of keyTyped

/////////////////////////////////////////////////////////////////////////////////// 

public void reveal(int myRow, int myCol) { 
  for(int r = 0; r < bombs.length; r++) {
    for(int c = 0; c < bombs[r].length; c++) {
      if((r != myRow || c != myCol) && bombs[r][c])
        buttons[r][c].press();
    }
  }
}
