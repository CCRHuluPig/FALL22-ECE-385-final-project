# FALL22-ECE-385-final-project
This is the final project for ECE 385 in UIUC fall22 semester.. We made a simple version of the popular game Doodle Jump on FPGA. Based on the previous labs about the moving ball, we implemented the basic functions of the original game, including jumping, obstacles (monsters, moving stairs), additional tools (springs) and the score record. The goal of the game is to let the character (doodler) jump as high as it can. The doodler will keep jumping until it touches a monster or fail to stand on a stair on the screen. The doodler will jump higher and faster if it jumps on a spring on the stair. The monster can be destroyed if shot by the bullets from the doodler or trampled under the doodler’s feet. 
When we start the game, there will be a starting page. After pressing the ENTER button, it comes to the playing page. You can press key “A” or “D” to move the doodler to left or right. You can also press key “” to shoot the bullet straight up, “” to shoot diagonally to the upper left, and “” to shoot diagonally to the upper right (one bullet per press). When the doodler jumps out of one side of the screen, it will jump back to the screen from another side. When the doodler jumps to the upper half of the screen, the background (including the stairs) will move down to make sure that the doodler will not jump off the screen. The stairs will appear and move randomly. The spring can help the doodler jump faster and higher. The score increases as the distances increases. When the doodler touched the monster or fail to stand in a stair, it will die and there will be an ending page showing your score. After pressing the ENTER button, it will come back to the start page and wait for another round. 
