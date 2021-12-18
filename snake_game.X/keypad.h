#ifndef TECLADO_H
#define TECLADO_H
	unsigned int kpRead(void);
    char kpReadKey(void);
    char kpReadKeyDown();
	void kpDebounce(void);
	void kpInit(void);
#endif
