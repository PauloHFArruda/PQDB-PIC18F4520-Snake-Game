#include "lcd.h"
#include "renderer.h"
#include "bits.h"

unsigned char screen[SCREEN_H*SCREEN_COLUMNS] = {0};

void setPixel(unsigned char x, unsigned char y, unsigned char val) {
    int i = 0;
    unsigned char x_ = x;
    
    if (x > 9) { 
        i += 32;
        x_ = x - 10;
    }
    else if (x > 4) { 
        i += 16;
        x_ = x - 5;
    }
    i += y;
    if (val) {
        bitSet(screen[i], 4 - x_);
    }
    else {
        bitClr(screen[i], 4 - x_);
    }
    
    lcdCommand(0x40 + i);
    lcdChar(screen[i]);
}

void displayScreen() {
    lcdCommand(0x01);
    lcdPosition(0, 0);
    lcdChar(0);
    lcdChar(2);
    lcdChar(4);
    lcdPosition(1, 0);
    lcdChar(1);
    lcdChar(3);
    lcdChar(5);
}

void cleanScreean() {
    for (char x = 0; x < SCREEN_W; x++) {
        for (char y = 0; y < SCREEN_H; y++) {
            setPixel(x, y, PIXEL_OFF);
        }
    }
}

void rendererInit() {
    lcdInit();
    
    cleanScreean();
    
    // parede a direita 
    lcdCommand(0x46);
    for (char i = 0; i < 8; i++) {
        lcdChar(0b11000);
    }
}

void rendererStart() {
    displayScreen();
    
    lcdPosition(0, 3);
    lcdChar(6);
    lcdPosition(1, 3);
    lcdChar(6);
    
    lcdPosition(0, 4);
    lcdString("Pontos:");
}
