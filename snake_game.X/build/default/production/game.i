# 1 "game.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "D:/Programas/MPLABX/packs/Microchip/PIC18Fxxxx_DFP/1.2.26/xc8\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "game.c" 2
# 1 "./renderer.h" 1
# 14 "./renderer.h"
    void setPixel(unsigned char x, unsigned char y, unsigned char val);
    void rendererInit();
    void rendererStart();
    void displayScreen();
    void cleanScreean();
# 1 "game.c" 2

# 1 "./lcd.h" 1


  void lcdCommand(char value);
  void lcdChar(char value);
  void lcdString(char msg[]);
  void lcdNumber(unsigned int value);
  void lcdPosition(int line, int col);
  void lcdInit(void);
# 2 "game.c" 2

# 1 "./serial.h" 1
# 23 "./serial.h"
 void serialSend(unsigned char c);
 unsigned char serialRead(void);
 void serialInit(void);
# 3 "game.c" 2

# 1 "./keypad.h" 1


 unsigned int kpRead(void);
    char kpReadKey(void);
    char kpReadKeyDown();
 void kpDebounce(void);
 void kpInit(void);
# 4 "game.c" 2

# 1 "./timer.h" 1
# 23 "./timer.h"
 char timerEnded(void);
 void timerWait(void);
    unsigned int getTimerValue(void);

 void timerReset(unsigned int tempo);
 void timerInit(void);
# 5 "game.c" 2

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
# 6 "game.c" 2

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
# 7 "game.c" 2





typedef struct {
    char x;
    char y;
} Point;

Point snake[20 + 1];
Point food;
unsigned char snake_size = 1;
char moving = 'R', direction = 'R';
unsigned char count = 0;
char points[3] = "000";
unsigned int random_seed = 0x78431;

unsigned int random() {
    random_seed = (random_seed << 3) >> 6;
    random_seed = (random_seed + 191) * random_seed;
    return random_seed;
}

void replaceFood() {
    food.x = random() % (3*5);
    food.y = random() % (2*8);
}

void addPoint() {

    points[2] += 1;
    for (int i = 2; i > 0; i--) {
        if (points[i] > '9') {
            points[i] -= 10;
            points[i-1] += 1;
        }
    }
}

void resetPoints() {
    for (int i = 0; i < 5; i ++) {
        points[i] = '0';
    }
}

void displayPoints() {
    lcdCommand(0x8C);

    for (int i = 0; i < 3; i++) {
        lcdChar(points[i]);
    }
}

void gameInit() {
    kpInit();
    mixerInit();
    timerInit();
    rendererInit();

    newGame();
}

void newGame() {

    snake[0].x = 1;
    snake[0].y = 0;
    snake[1].x = 0;
    snake[1].y = 0;
    snake_size = 1;

    resetPoints();

    replaceFood();

    cleanScreean();


    setPixel(snake[0].x, snake[0].y, 1);
    setPixel(snake[1].x, snake[1].y, 1);


    setPixel(food.x, food.y, 1);
}

void gameStart() {
    rendererStart();
    mixerRestart();
}

void updateSnake() {
    unsigned char i;

    for (i = snake_size; i > 0; i--) {
        snake[i] = snake[i - 1];
    }


    moving = direction;
    switch (moving) {
        case 'R': snake[0].x++;
            break;
        case 'L': snake[0].x--;
            break;
        case 'U': snake[0].y--;
            break;
        case 'D': snake[0].y++;
            break;
    }
    snake[0].x = snake[0].x + (3*5);
    snake[0].x = snake[0].x % (3*5);
    snake[0].y = snake[0].y + (2*8);
    snake[0].y = snake[0].y % (2*8);
}

void gameOver() {

    lcdCommand(0x01);

    lcdPosition(0, 2);

    lcdString("Voce perdeu");
    lcdPosition(1, 2);
    lcdString("Pontos: ");
    for (int i = 0; i < 3; i++) {
        lcdChar(points[i]);
    }

    for (int i = 0; i < 100; i++) {
        timerReset(20000);
        timerWait();
    }

}

char readSerialController() {
    static char last_key = 0;
    char key = serialRead();
    serialSend('!');
    if (key != last_key) {
        last_key = key;
        return key;
    }
    return 0;
}

char readInput() {


    char key = kpReadKeyDown();
    if (!key) {
        key = readSerialController();
    }

    switch (key) {
        case 'R':
            direction = (moving != 'L') ? key: direction;
            random_seed += snake[0].x;
            break;
        case 'L':
            direction = (moving != 'R') ? key: direction;
            random_seed += snake[0].y;
            break;
        case 'U':
            direction = (moving != 'D') ? key: direction;
            random_seed -= snake[0].x;
            break;
        case 'D':
            direction = (moving != 'U') ? key: direction;
            random_seed -= snake[0].y;
            break;
        case 'S':
            mixerStop();
            return STATUS_PAUSE;
            break;
    }
    return STATUS_PLAYING;
}

void checkFood() {



    if ((snake[0].x == food.x) && (snake[0].y == food.y)) {
        replaceFood();
        addPoint();
        if (snake_size < 20) {
            snake_size++;
            return;
        }
    }

    setPixel(snake[snake_size].x, snake[snake_size].y, 0);
}

char checkCollision() {
    for (int i = 2; i <= snake_size; i++) {
        if (snake[0].x == snake[i].x && snake[0].y == snake[i].y) {
            return 1;
        }
    }
    return 0;
}

char gameUpdate() {
    timerReset(5000);
    mixerUpdate();

    if (count < 30) {
        if (count & 1) {
            kpDebounce();
        }
        else {
            if (readInput() == STATUS_PAUSE) { return STATUS_PAUSE; }
        }
    }
    else if (count == 30) {
        checkFood();
    } else if (count == 30 + 1) {
        updateSnake();
    } else if (count == 30 + 2) {
        if (checkCollision()) {
            gameOver();
            return STATUS_GAME_OVER;
        }
    } else if (count == 30 + 3) {

        setPixel(snake[0].x, snake[0].y, 1);
    } else if (count == 30 + 4) {

        setPixel(food.x, food.y, 1);
    } else if (count == 30 + 5) {

        lcdCommand(0x8C);
        lcdChar(points[0]);
    } else if (count == 30 + 6) {

        lcdChar(points[1]);
        lcdChar(points[2]);
    } else {
        count = 0;
    }
    count++;
    timerWait();

    return STATUS_PLAYING;
}
