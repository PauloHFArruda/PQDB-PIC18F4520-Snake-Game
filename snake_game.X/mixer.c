#include "mixer.h"
#include "serial.h"
#include "pwm.h"
#include "songs.h"

#define PLAYLIST_SIZE 3

unsigned char current_note=0, note_time=0, pause_time=0, playing_note=0;

Song song;
Song playlist[PLAYLIST_SIZE];
char song_idx=0;
char mixer_output = MIXER_OUTPUT_SERIAL;

void mixerInit(void) {
    serialInit();
    pwmInit();
    
    playlist[0] = pacman_song;
    playlist[1] = tetris_song;
    playlist[2] = sw_song;
            
    song = playlist[song_idx];
}

void mixerRestart() {
    current_note = 0;
    note_time=0;
    pause_time=0;
    playing_note=0;
}

void mixerSetOutput(char out) {
    mixer_output = out;
}

char mixerGetOutput() {
    return mixer_output;
}

void startNote(char note) {
    if (mixer_output == MIXER_OUTPUT_SERIAL) {
        serialSend(note + '0');
    } else {
        pwmFrequency(notes_freq[note]);
        pwmSet(50);
    }
}

void stopNote() {
    if (mixer_output == MIXER_OUTPUT_SERIAL) {
        serialSend('0'-2);
    } else {
        pwmFrequency(100000);
    }
}

void mixerStop() {
    stopNote();
}

void mixerUpdate() {
    if (note_time > 0) {
        note_time--;
    }
    else if (playing_note) {
        playing_note = 0;
        stopNote();
    }
    else if (pause_time > 0) {
        pause_time--;
    }
    else {
        if (current_note == *song.size) {
            current_note = 0;
        }
        startNote(song.notes[current_note]);
        note_time = song.duration[current_note];
        playing_note = 1;
        //pause_time = song.duration[current_note]/10;
        pause_time = song.duration[current_note] >> 3; // duration/8
        
        current_note++;
    }
}

void mixerNextSong() {
    song_idx = (song_idx + 1)%PLAYLIST_SIZE;
    song = playlist[song_idx];
}

char* mixerGetSongName() {
    return song.name;
}