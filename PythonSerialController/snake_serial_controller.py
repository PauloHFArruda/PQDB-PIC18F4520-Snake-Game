import keyboard
import serial

def get_key():
    if keyboard.is_pressed('esc'):
        raise Exception('Fechando')
    for key, resp in zip('WASD', 'ULDR'):
        if keyboard.is_pressed(key):
            return resp.encode()
    return 0

com = serial.Serial('COM2', 4800, timeout=1)
print('Comunicando')
timeout_count = 0

while True:
    if not com.read():
        timeout_count += 1
        if timeout_count == 5:
            break

    com.write(get_key())

com.close()