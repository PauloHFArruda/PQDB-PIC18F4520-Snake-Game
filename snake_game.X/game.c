#include "renderer.h"
#include "lcd.h"
#include "serial.h"
#include "keypad.h"
#include "timer.h"
#include "mixer.h"
#include "game.h"

#define SNAKE_SPEED 30
#define SNAKE_MAX_SIZE 20

typedef struct {
    char x;
    char y;
} Point;

Point snake[SNAKE_MAX_SIZE + 1];
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
    food.x = random() % SCREEN_W;
    food.y = random() % SCREEN_H;
}

void addPoint() {
    /* Incrementa os pontos em 1 */ 
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
    //lcdString(points);
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
    //define a posição inicial da cobra
    snake[0].x = 1;
    snake[0].y = 0;
    snake[1].x = 0;
    snake[1].y = 0;
    snake_size = 1; // reseta tamanho da cobra
    
    resetPoints(); // reseta os pontos;
    
    replaceFood();
    
    cleanScreean();
    
    // desenha cobra
    setPixel(snake[0].x, snake[0].y, PIXEL_ON);
    setPixel(snake[1].x, snake[1].y, PIXEL_ON);

    // desenha comida
    setPixel(food.x, food.y, PIXEL_ON);
}

void gameStart() {
    rendererStart();
    mixerRestart();
}

void updateSnake() {
    unsigned char i;
    // atualiza corpo
    for (i = snake_size; i > 0; i--) {
        snake[i] = snake[i - 1];
    }
    
    // atualiza cabeça
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
    snake[0].x = snake[0].x + SCREEN_W;
    snake[0].x = snake[0].x % SCREEN_W;
    snake[0].y = snake[0].y + SCREEN_H;
    snake[0].y = snake[0].y % SCREEN_H;
}

void gameOver() {
    
    lcdCommand(0x01); // limpa tela

    lcdPosition(0, 2);
    //lcdString("Game Over");
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
    serialSend('!'); // indica que recebeu a tecla apertada
    if (key != last_key) {
        last_key = key;
        return key;
    }
    return 0;
}

char readInput() {
    /* Lê as entradas (teclado e serial)*/
    
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
            mixerStop(); // para a musica
            return STATUS_PAUSE;
            break;
    }
    return STATUS_PLAYING;
}

void checkFood() {
    /* Verifica se comeu a comida, adiona
     * pontos e aumenta a cobra se não estiver 
     * no tamanho máximo */
    if ((snake[0].x == food.x) && (snake[0].y == food.y)) {
        replaceFood();
        addPoint();
        if (snake_size < SNAKE_MAX_SIZE) {
            snake_size++;
            return;
        }
    }
    
    setPixel(snake[snake_size].x, snake[snake_size].y, PIXEL_OFF);
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
    
    if (count < SNAKE_SPEED) {
        if (count & 1) {
            kpDebounce();
        }
        else {
            if (readInput() == STATUS_PAUSE) { return STATUS_PAUSE; }
        }
    }
    else if (count == SNAKE_SPEED) {
        checkFood();
    } else if (count == SNAKE_SPEED + 1) {
        updateSnake();
    } else if (count == SNAKE_SPEED + 2) {
        if (checkCollision()) {
            gameOver();
            return STATUS_GAME_OVER;
        }
    } else if (count == SNAKE_SPEED + 3) {
        // desenha a cabeça da cobra
        setPixel(snake[0].x, snake[0].y, PIXEL_ON); 
    } else if (count == SNAKE_SPEED + 4) {
        // desenha a comida
        setPixel(food.x, food.y, PIXEL_ON);
    } else if (count == SNAKE_SPEED + 5) {
        // começa a mostrar os pontos
        lcdCommand(0x8C);
        lcdChar(points[0]);
    } else if (count == SNAKE_SPEED + 6) {
        //termina de mostrar os pontos
        lcdChar(points[1]);
        lcdChar(points[2]);
    } else {
        count = 0;
    }
    count++;
    timerWait();
    
    return STATUS_PLAYING;
}