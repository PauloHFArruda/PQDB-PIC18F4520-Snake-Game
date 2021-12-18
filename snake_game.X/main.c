#include "keypad.h"
#include "lcd.h"
#include "mixer.h"
#include "game.h"

#define MENU_OPTIONS_NUMBER 4

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
    displayMenuOption((menu_opt + 1)%MENU_OPTIONS_NUMBER);
}

char menuUpdate() {
    char key;
    
    kpDebounce();
    if (kpReadKey() != key) {
        key = kpReadKeyDown();
        
        switch (key) {
            case 'D': 
                menu_opt++;
                menu_opt %= MENU_OPTIONS_NUMBER;
                displayMenu(menu_opt);
                break;
            case 'U': 
                menu_opt--; 
                menu_opt += MENU_OPTIONS_NUMBER;
                menu_opt %= MENU_OPTIONS_NUMBER;
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