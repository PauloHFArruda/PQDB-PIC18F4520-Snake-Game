#ifndef RENDERER_H
    #define	RENDERER_H

    #define CHAR_W 5
    #define CHAR_H 8
    #define SCREEN_COLUMNS 3
    #define SCREEN_ROWS 2
    #define SCREEN_W (SCREEN_COLUMNS*CHAR_W)
    #define SCREEN_H (SCREEN_ROWS*CHAR_H)

    #define PIXEL_ON 1
    #define PIXEL_OFF 0

    void setPixel(unsigned char x, unsigned char y, unsigned char val);
    void rendererInit();
    void rendererStart();
    void displayScreen();
    void cleanScreean();
    
#endif

