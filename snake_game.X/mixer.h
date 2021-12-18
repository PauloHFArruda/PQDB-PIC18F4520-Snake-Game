#ifndef XC_HEADER_TEMPLATE_H
    #define	XC_HEADER_TEMPLATE_H

    enum {MIXER_OUTPUT_SERIAL, MIXER_OUTPUT_BUZZER};

    void mixerInit();
    void mixerSetOutput(char out);
    char mixerGetOutput();
    char* mixerGetSongName();
    void mixerNextSong();
    void mixerRestart();
    void mixerStop();
    void mixerUpdate();

#endif

