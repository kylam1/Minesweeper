public void mousePressed() {
  if(startScreen) {
    if(mouseX >= 350 && mouseX <= 650 && mouseY >= 250 && mouseY <= 350) { //Beginner
      numRow = 9;
      numCol = 9;
      numBomb = 10;
      flags = numBomb;
      gameStart = true;
      startScreen = false;
    }
    
    if(mouseX >= 350 && mouseX <= 650 && mouseY >= 450 && mouseY <= 550) { //Intermediate
      numRow = 16;
      numCol = 16;
      numBomb = 40;
      flags = numBomb;
      gameStart = true;
      startScreen = false;
    }
    
    if(mouseX >= 350 && mouseX <= 650 && mouseY >= 650 && mouseY <= 750) { //Advanced
      numRow = 30;
      numCol = 16;
      numBomb = 99;
      flags = numBomb;
      gameStart = true;
      startScreen = false;
    }
    
    if(mouseX >= 200 && mouseX <= 450 && mouseY >= 860 && mouseY <= 940) { //Custom
      custom1 = true;
      custom2 = false;
      customizeBomb = false;
    }
    else if(mouseX >= 550 && mouseX <= 800 && mouseY >= 860 && mouseY <= 940) {
      custom1 = false;
      custom2 = true;
      customizeBomb = false;
    }
    else if(mouseX >= 50 && mouseX <= 150 && mouseY >= 860 && mouseY <= 940) {
      custom1 = false;
      custom2 = false;
      customizeBomb = true;
    }
    else {
      custom1 = false;
      custom2 = false;
      customizeBomb = false;
    }
    if(mouseX >= 850 && mouseX <= 950 && mouseY >= 860 && mouseY <= 940) { //Go button
      numRow = parseInt(customRow);
      numCol = parseInt(customCol);
      numBomb = parseInt(customBomb);
      flags = numBomb;
      gameStart = true;
      startScreen = false;
    }
    
    if(gameStart) { //Draw the buttons
      startTime = millis();
      noStroke();
      
      buttons = new SimpleButton[numRow][numCol];  //Place the buttons
      for ( int ix = firstButtonX, k = numCol*(w+4) + firstButtonX, column = 0; ix < k; ix += w+4 ) //Value added to k must equal ix
      {
          for ( int iy = firstButtonY, n = numRow*(w+4) + firstButtonY, row = 0; iy < n; iy += w+4 ) //Value added to n must equal iy
          {
              buttons[row][column] = new SimpleButton(ix, iy, w, w, row, column);
              //new SimpleButton(ix, iy, w, w);
              row++;
          }
          column++;
      }
      return; //Stops the bombs from being placed before firstButtonPressed
    } //End of drawing buttons
  } //End of startScreen
  
  
  if(gameStart || gameOver) {
    if(mouseX >= firstButtonX - 2 + (numCol/2.)*(w+4) - 13 && mouseX <= firstButtonX - 2 + (numCol/2.)*(w+4) + 12 && mouseY >= firstButtonY - 15 - 5 - 8 - 13 && mouseY <= firstButtonY - 15) { //Reset Button
      resetButtonIsPressed = true;
      tempResetButtonIsPressed = true;
    }
    
  } //End of gameStart
  
} //End of mousePressed

/////////////////////////////////////////////////////////////////////////////////// MouseReleased

public void mouseReleased() {
  if(gameStart || gameOver) {
    if(resetButtonIsPressed && mouseX >= firstButtonX - 2 + (numCol/2.)*(w+4) - 13 && mouseX <= firstButtonX - 2 + (numCol/2.)*(w+4) + 12 && mouseY >= firstButtonY - 15 - 5 - 8 - 13 && mouseY <= firstButtonY - 15) //Reset Button
      reset();
    else
      tempResetButtonIsPressed = false;
  } //End of gameStart
}
