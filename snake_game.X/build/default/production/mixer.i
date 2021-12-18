# 1 "mixer.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "D:/Programas/MPLABX/packs/Microchip/PIC18Fxxxx_DFP/1.2.26/xc8\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "mixer.c" 2
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
# 1 "mixer.c" 2

# 1 "./serial.h" 1
# 23 "./serial.h"
 void serialSend(unsigned char c);
 unsigned char serialRead(void);
 void serialInit(void);
# 2 "mixer.c" 2

# 1 "./pwm.h" 1
# 23 "./pwm.h"
 void pwmSet(unsigned char porcento);
 void pwmFrequency(unsigned int freq);
 void pwmInit(void);
# 3 "mixer.c" 2

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
# 4 "mixer.c" 2




unsigned char current_note=0, note_time=0, pause_time=0, playing_note=0;

Song song;
Song playlist[3];
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

        pause_time = song.duration[current_note] >> 3;

        current_note++;
    }
}

void mixerNextSong() {
    song_idx = (song_idx + 1)%3;
    song = playlist[song_idx];
}

char* mixerGetSongName() {
    return song.name;
}
