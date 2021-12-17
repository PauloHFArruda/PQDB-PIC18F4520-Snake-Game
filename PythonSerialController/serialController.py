import keyboard
import serial
import json
import pygame as pg
import time

with open('PythonSerialController/notes.json', 'r') as f:
    notes = json.load(f)

pg.init()
pg.mixer.init()

sounds = {i: pg.mixer.Sound(f'PythonSerialController/sounds/{note}.wav') 
        for i, note in enumerate(notes.keys())}

com = serial.Serial('COM2', 4800, timeout=0.5)
com.reset_input_buffer()
print('Comunicando')

current_sound = sounds[0]

key_map = {key: val.encode() for key, val in zip(list('wasd')+['space'], 'ULDRS')}

def get_key():
    for key, val in key_map.items():
        if keyboard.is_pressed(key):
            return val
    return 0

while True:
    c = com.read()
    if c:
        if c == b'!':
            com.write(get_key())
        else:
            i = ord(c) - ord('0')
            if i == -2:
                current_sound.stop()
            elif i not in sounds.keys():
                print(f'nota {i} ínvalida')
            else:
                current_sound = sounds[i]
                current_sound.play()

    time.sleep(0.0001)
    if keyboard.is_pressed('esc'):
        break

com.close()