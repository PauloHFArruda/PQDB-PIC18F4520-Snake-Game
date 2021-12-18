# 1 "main.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "D:/Programas/MPLABX/packs/Microchip/PIC18Fxxxx_DFP/1.2.26/xc8\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "main.c" 2
# 1 "./keypad.h" 1


 unsigned int kpRead(void);
    char kpReadKey(void);
    char kpReadKeyDown();
 void kpDebounce(void);
 void kpInit(void);
# 2 "main.c" 2
# 1 "./lcd.h" 1


  void lcdCommand(char value);
  void lcdChar(char value);
  void lcdString(char msg[]);
  void lcdNumber(unsigned int value);
  void lcdPosition(int line, int col);
  void lcdInit(void);
# 3 "main.c" 2
# 1 "./mixer.h" 1



    enum {MIXER_OUTPUT_SERIAL, MIXER_OUTPUT_BUZZER};

    void mixerInit();
    void mixerSetOutput(char out);
    char mixerGetOutput();
    char* mixerGetSongName();
    void mixerNextSong();
    void mixerRestart();
    void mixerStop();
    void mixerUpdate();
# 4 "main.c" 2
# 1 "./game.h" 1



    enum status{
        STATUS_MENU,
        STATUS_START,
        STATUS_PLAYING,
        STATUS_PAUSE,
        STATUS_GAME_OVER
    };

    void gameInit();
    void newGame();
    void gameStart();
    char gameUpdate();
# 5 "main.c" 2



char status=STATUS_PAUSE, menu_opt=0;

void displayMenuOption(char opt) {
    switch (opt) {
        case 0:
            lcdString("Novo Jogo");
            break;
        case 1:
            lcdString("Continuar Jogo");
            break;
        case 2:
            lcdString("Mus: ");
            lcdString(mixerGetSongName());
            break;
        case 3:
            lcdString("Som: ");
            if (mixerGetOutput() == MIXER_OUTPUT_SERIAL) {
                lcdString("serial");
            } else {
                lcdString("buzzer");
            }
            break;
    }
}

void displayMenu() {
    lcdCommand(0x01);
    lcdPosition(0,0);
    lcdChar('>');
    displayMenuOption(menu_opt);
    lcdPosition(1, 0);
    displayMenuOption((menu_opt + 1)%4);
}

char menuUpdate() {
    char key;

    kpDebounce();
    if (kpReadKey() != key) {
        key = kpReadKeyDown();

        switch (key) {
            case 'D':
                menu_opt++;
                menu_opt %= 4;
                displayMenu(menu_opt);
                break;
            case 'U':
                menu_opt--;
                menu_opt += 4;
                menu_opt %= 4;
                displayMenu(menu_opt);
                break;
            case 'S':
                switch (menu_opt) {
                    case 0:
                        newGame();
                        return STATUS_START;
                    case 1:
                        return STATUS_START;
                    case 2:
                        mixerNextSong();
                        displayMenu(menu_opt);
                        return STATUS_MENU;
                    case 3:
                        if (mixerGetOutput() == MIXER_OUTPUT_SERIAL) {
                            mixerSetOutput(MIXER_OUTPUT_BUZZER);
                        } else {
                            mixerSetOutput(MIXER_OUTPUT_SERIAL);
                        }
                        displayMenu(menu_opt);
                        return STATUS_MENU;
                }
                break;
        }
    }

    return STATUS_MENU;
}

void main() {
    gameInit();

    for (;;) {
        if (status == STATUS_MENU) {
            status = menuUpdate();
        } else if (status == STATUS_PLAYING) {
            status = gameUpdate();
        } else if (status == STATUS_START) {
            gameStart();
            status = STATUS_PLAYING;
        } else if (status == STATUS_PAUSE) {
            displayMenu(0);
            status = STATUS_MENU;
        } else if (status == STATUS_GAME_OVER) {
            newGame();
            displayMenu(0);
            status = STATUS_MENU;
        }
    }
}
