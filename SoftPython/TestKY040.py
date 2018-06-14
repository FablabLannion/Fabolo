#KY040 Python Class
#Martin O'Hanlon
#stuffaboutcode.com

import RPi.GPIO as GPIO
from time import sleep
import os
import pygame #voor beeld en geluid
from pygame.locals import *

class KY040:

    CLOCKWISE = 0
    ANTICLOCKWISE = 1
    
    def __init__(self, clockPin, dataPin, switchPin,
                 rotaryCallback, switchCallback):
        #persist values
        self.clockPin = clockPin
        self.dataPin = dataPin
        self.switchPin = switchPin
        self.rotaryCallback = rotaryCallback
        self.switchCallback = switchCallback

        #setup pins
        GPIO.setup(clockPin, GPIO.IN)
        GPIO.setup(dataPin, GPIO.IN)
        GPIO.setup(switchPin, GPIO.IN, pull_up_down=GPIO.PUD_UP)

    def start(self):
        GPIO.add_event_detect(self.clockPin,
                              GPIO.FALLING,
                              callback=self._clockCallback,
                              bouncetime=250)
        GPIO.add_event_detect(self.switchPin,
                              GPIO.FALLING,
                              callback=self._switchCallback,
                              bouncetime=300)

    def stop(self):
        GPIO.remove_event_detect(self.clockPin)
        GPIO.remove_event_detect(self.switchPin)
    
    def _clockCallback(self, pin):
        if GPIO.input(self.clockPin) == 0:
            data = GPIO.input(self.dataPin)
            if data == 1:
                self.rotaryCallback(self.ANTICLOCKWISE)
            else:
                self.rotaryCallback(self.CLOCKWISE)
    
    def _switchCallback(self, pin):
        if GPIO.input(self.switchPin) == 0:
            self.switchCallback()

#test
if __name__ == "__main__":
    
    CLOCKPIN = 5
    DATAPIN = 6
    SWITCHPIN = 13
    Position = 0
    VideoLance = False

    def rotaryChange(direction):
        global Position
        if  direction == 0:
            Position += 1
            if Position >= 5:
                Position = 0
        else:
            Position -= 1
            if Position < 0:
                Position = 4
        print("turned - Position = ", Position, "\n")
        if Position == 0:
            img = pygame.image.load("/home/pi/Ecran15pouce/MenuRock15.png")
        elif Position == 1:
            img = pygame.image.load("/home/pi/Ecran15pouce/MenuMetal15.png")
        elif Position == 2:
            img = pygame.image.load("/home/pi/Ecran15pouce/MenuElectro15.png")
        elif Position == 3:
            img = pygame.image.load("/home/pi/Ecran15pouce/MenuHip-Hop15.png")
        elif Position == 4:
            img = pygame.image.load("/home/pi/Ecran15pouce/MenuFun15.png")
        windowSurface.blit(img, (0, 0))
        pygame.display.flip()
        pygame.mixer.music.load('/home/pi/Ecran15pouce/Menu.wav')
        pygame.mixer.music.set_volume(1.0)
        pygame.mixer.music.play()
#        while pygame.mixer.music.get_busy() == True:
#            continue

    def switchPressed():
        global Position
        global VideoLance
        print("Appui Bouton Position ", Position)
        if VideoLance == False:
            if Position == 0:
                os.spawnlp(os.P_NOWAIT, 'omxplayer', 'omxplayer', '--loop', '--no-keys', '--no-osd', '/home/pi/Ecran15pouce/Rock.mp4')
            elif Position == 1:
                os.spawnlp(os.P_NOWAIT, 'omxplayer', 'omxplayer', '--loop', '--no-keys', '--no-osd', '/home/pi/Ecran15pouce/Metal.mp4')
            elif Position == 2:
                os.spawnlp(os.P_NOWAIT, 'omxplayer', 'omxplayer', '--loop', '--no-keys', '--no-osd', '/home/pi/Ecran15pouce/Electro.mp4')
            elif Position == 3:
                os.spawnlp(os.P_NOWAIT, 'omxplayer', 'omxplayer', '--loop', '--no-keys', '--no-osd', '/home/pi/Ecran15pouce/HipHop.mp4')
            elif Position == 4:
                os.spawnlp(os.P_NOWAIT, 'omxplayer', 'omxplayer', '--loop', '--no-keys', '--no-osd', '/home/pi/Ecran15pouce/Fun.mp4')
            VideoLance = True
        else:
            os.system("pkill -SIGINT omxplayer")
            VideoLance = False

    GPIO.setmode(GPIO.BCM)
    
    ky040 = KY040(CLOCKPIN, DATAPIN, SWITCHPIN,
                  rotaryChange, switchPressed)

    ky040.start()
    Position = 0
    pygame.init()
    WIDTH = 1024
    HEIGHT = 768
    windowSurface = pygame.display.set_mode((WIDTH, HEIGHT), pygame.FULLSCREEN, 0)
    img = pygame.image.load("/home/pi/Ecran15pouce/MenuRock15.png")
    windowSurface.blit(img, (0, 0))
    pygame.display.flip()
    pygame.mixer.init()
    pygame.mixer.music.load('/home/pi/Ecran15pouce/StartupSound.mp3')
    pygame.mixer.music.set_volume(1.0)
    pygame.mixer.music.play()
    while pygame.mixer.music.get_busy() == True:
        continue

    try:
        while True:
            events = pygame.event.get()
            for event in events:
                if event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_ESCAPE:
                        quit()
            sleep(0.1)
    finally:
        ky040.stop()
        GPIO.cleanup()