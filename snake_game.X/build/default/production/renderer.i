# 1 "renderer.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "D:/Programas/MPLABX/packs/Microchip/PIC18Fxxxx_DFP/1.2.26/xc8\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "renderer.c" 2
# 1 "./lcd.h" 1


  void lcdCommand(char value);
  void lcdChar(char value);
  void lcdString(char msg[]);
  void lcdNumber(unsigned int value);
  void lcdPosition(int line, int col);
  void lcdInit(void);
# 1 "renderer.c" 2

# 1 "./renderer.h" 1
# 14 "./renderer.h"
    void setPixel(unsigned char x, unsigned char y, unsigned char val);
    void rendererInit();
    void rendererStart();
    void displayScreen();
    void cleanScreean();
# 2 "renderer.c" 2

# 1 "./bits.h" 1
# 3 "renderer.c" 2


unsigned char screen[(2*8)*3] = {0};

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
        ((screen[i]) |= (1<<(4 - x_)));
    }
    else {
        ((screen[i]) &= ~(1<<(4 - x_)));
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
    for (char x = 0; x < (3*5); x++) {
        for (char y = 0; y < (2*8); y++) {
            setPixel(x, y, 0);
        }
    }
}

void rendererInit() {
    lcdInit();

    cleanScreean();


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
