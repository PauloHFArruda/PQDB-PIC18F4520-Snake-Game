#ifndef SONGS_H
    #define SONGS_H

typedef struct {
        unsigned char name[15];
        unsigned char* size;
        unsigned char* notes;
        unsigned char* duration;
    } Song;

    const unsigned int notes_freq[];

    Song pacman_song;;
    Song tetris_song;;
    Song sw_song;;
#endif