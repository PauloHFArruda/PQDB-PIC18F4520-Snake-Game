#ifndef GAME_H
    #define	GAME_H

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

#endif
