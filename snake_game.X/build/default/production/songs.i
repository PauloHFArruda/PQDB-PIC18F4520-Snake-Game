# 1 "songs.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "D:/Programas/MPLABX/packs/Microchip/PIC18Fxxxx_DFP/1.2.26/xc8\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "songs.c" 2
# 1 "./songs.h" 1



    typedef struct {
        unsigned char name[15];
        unsigned char* size;
        unsigned char* notes;
        unsigned char* duration;
    } Song;

    const unsigned int notes_freq[30];

    Song pacman_song;
    Song tetris_song;
    Song sw_song;
# 1 "songs.c" 2


enum notes{NOTE_F4, NOTE_FS4, NOTE_G4, NOTE_GS4, NOTE_A4, NOTE_AS4,
    NOTE_B4, NOTE_C5, NOTE_CS5, NOTE_D5, NOTE_DS5, NOTE_E5, NOTE_F5,
    NOTE_FS5, NOTE_G5, NOTE_GS5, NOTE_A5, NOTE_AS5, NOTE_B5,
    NOTE_C6, NOTE_CS6, NOTE_D6, NOTE_DS6, NOTE_E6, NOTE_F6, NOTE_FS6,
    NOTE_G6, NOTE_GS6, NOTE_A6, REST};

const unsigned int notes_freq[30] = {349, 370, 392, 415, 440, 466,
    494, 523, 554, 587, 622, 659, 698, 740, 784, 831, 880, 932,
    988, 1047, 1109, 1175, 1245, 1319, 1397, 1480, 1568, 1661,
    1760, 100000};

const unsigned char pacman_song_size = 31;
const unsigned char pacman_notes[] = {NOTE_B4, NOTE_B5, NOTE_FS5,
    NOTE_DS5, NOTE_B5, NOTE_FS5, NOTE_DS5, NOTE_C5, NOTE_C6,
    NOTE_G6, NOTE_E6, NOTE_C6, NOTE_G6, NOTE_E6, NOTE_B4, NOTE_B5,
    NOTE_FS5, NOTE_DS5, NOTE_B5, NOTE_FS5, NOTE_DS5, NOTE_DS5,
    NOTE_E5, NOTE_F5, NOTE_F5, NOTE_FS5, NOTE_G5, NOTE_G5, NOTE_GS5,
    NOTE_A5, NOTE_B5};
const unsigned char pacman_duration[] = {15, 15, 15, 15, 8, 23,
    30, 15, 15, 15, 15, 8, 23, 30, 15, 15, 15, 15, 8, 23, 30,
    8, 8, 8, 8, 8, 8, 8, 8, 15, 30};

const unsigned char tetris_song_size = 99;
const unsigned char tetris_notes[] = {NOTE_E5, NOTE_B4, NOTE_C5,
    NOTE_D5, NOTE_C5, NOTE_B4, NOTE_A4, NOTE_A4, NOTE_C5, NOTE_E5,
    NOTE_D5, NOTE_C5, NOTE_B4, NOTE_C5, NOTE_D5, NOTE_E5, NOTE_C5,
    NOTE_A4, NOTE_A4, NOTE_A4, NOTE_B4, NOTE_C5, NOTE_D5, NOTE_F5,
    NOTE_A5, NOTE_G5, NOTE_F5, NOTE_E5, NOTE_C5, NOTE_E5, NOTE_D5,
    NOTE_C5, NOTE_B4, NOTE_B4, NOTE_C5, NOTE_D5, NOTE_E5, NOTE_C5,
    NOTE_A4, NOTE_A4, REST, NOTE_E5, NOTE_B4, NOTE_C5, NOTE_D5,
    NOTE_C5, NOTE_B4, NOTE_A4, NOTE_A4, NOTE_C5, NOTE_E5, NOTE_D5,
    NOTE_C5, NOTE_B4, NOTE_C5, NOTE_D5, NOTE_E5, NOTE_C5, NOTE_A4,
    NOTE_A4, NOTE_A4, NOTE_B4, NOTE_C5, NOTE_D5, NOTE_F5, NOTE_A5,
    NOTE_G5, NOTE_F5, NOTE_E5, NOTE_C5, NOTE_E5, NOTE_D5, NOTE_C5,
    NOTE_B4, NOTE_B4, NOTE_C5, NOTE_D5, NOTE_E5, NOTE_C5, NOTE_A4,
    NOTE_A4, REST, NOTE_E5, NOTE_C5, NOTE_D5, NOTE_B4, NOTE_C5,
    NOTE_A4, NOTE_GS4, NOTE_B4, REST, NOTE_E5, NOTE_C5, NOTE_D5,
    NOTE_B4, NOTE_C5, NOTE_E5, NOTE_A5, NOTE_GS5};
const unsigned char tetris_duration[] = {40, 20, 20, 40, 20,
    20, 40, 20, 20, 40, 20, 20, 60, 20, 40, 40, 40, 40, 20, 40,
    20, 20, 60, 20, 40, 20, 20, 60, 20, 40, 20, 20, 40, 20, 20,
    40, 40, 40, 40, 40, 40, 40, 20, 20, 40, 20, 20, 40, 20, 20,
    40, 20, 20, 60, 20, 40, 40, 40, 40, 20, 40, 20, 20, 60, 20,
    40, 20, 20, 60, 20, 40, 20, 20, 40, 20, 20, 40, 40, 40, 40,
    40, 40, 80, 80, 80, 80, 80, 80, 80, 40, 20, 80, 80, 80, 80,
    40, 40, 80, 80};

const unsigned char sw_song_size = 88;
const unsigned char sw_notes[] = {NOTE_AS4, NOTE_AS4, NOTE_AS4,
    NOTE_F5, NOTE_C6, NOTE_AS5, NOTE_A5, NOTE_G5, NOTE_F6, NOTE_C6,
    NOTE_AS5, NOTE_A5, NOTE_G5, NOTE_F6, NOTE_C6, NOTE_AS5, NOTE_A5,
    NOTE_AS5, NOTE_G5, NOTE_C5, NOTE_C5, NOTE_C5, NOTE_F5, NOTE_C6,
    NOTE_AS5, NOTE_A5, NOTE_G5, NOTE_F6, NOTE_C6, NOTE_AS5, NOTE_A5,
    NOTE_G5, NOTE_F6, NOTE_C6, NOTE_AS5, NOTE_A5, NOTE_AS5, NOTE_G5,
    NOTE_C5, NOTE_C5, NOTE_D5, NOTE_D5, NOTE_AS5, NOTE_A5, NOTE_G5,
    NOTE_F5, NOTE_F5, NOTE_G5, NOTE_A5, NOTE_G5, NOTE_D5, NOTE_E5,
    NOTE_C5, NOTE_C5, NOTE_D5, NOTE_D5, NOTE_AS5, NOTE_A5, NOTE_G5,
    NOTE_F5, NOTE_C6, NOTE_G5, NOTE_G5, REST, NOTE_C5, NOTE_D5,
    NOTE_D5, NOTE_AS5, NOTE_A5, NOTE_G5, NOTE_F5, NOTE_F5, NOTE_G5,
    NOTE_A5, NOTE_G5, NOTE_D5, NOTE_E5, NOTE_C6, NOTE_C6, NOTE_F6,
    NOTE_DS6, NOTE_CS6, NOTE_C6, NOTE_AS5, NOTE_GS5, NOTE_G5,
    NOTE_F5, NOTE_C6};
const unsigned char sw_duration[] = {24, 24, 24, 96, 96, 24,
    24, 24, 96, 48, 24, 24, 24, 96, 48, 24, 24, 24, 96, 24, 24,
    24, 96, 96, 24, 24, 24, 96, 48, 24, 24, 24, 96, 48, 24, 24,
    24, 96, 36, 12, 72, 24, 24, 24, 24, 24, 24, 24, 24, 48, 24,
    48, 36, 12, 72, 24, 24, 24, 24, 24, 36, 12, 96, 24, 24, 72,
    24, 24, 24, 24, 24, 24, 24, 24, 48, 24, 48, 36, 12, 48, 24,
    48, 24, 48, 24, 48, 24, 192};

Song pacman_song = {
    .name = "pacman",
    .size = &pacman_song_size,
    .notes = &pacman_notes,
    .duration = &pacman_duration,
};

Song tetris_song = {
    .name = "tetris",
    .size = &tetris_song_size,
    .notes = &tetris_notes,
    .duration = &tetris_duration,
};

Song sw_song = {
    .name = "star wars",
    .size = &sw_song_size,
    .notes = &sw_notes,
    .duration = &sw_duration,
};
