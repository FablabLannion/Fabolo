# http://www.fileformat.info/format/mpeg/sample/index.dir
import pygame

FPS = 60

pygame.init()
clock = pygame.time.Clock()
#movie = pygame.movie.Movie('/home/pi/Ecran15pouce/Rock.mp4')
movie = pygame.movie.Movie('/home/thierry/Videos/Rock.mp4')
screen = pygame.display.set_mode(movie.get_size())
movie_screen = pygame.Surface(movie.get_size()).convert()

movie.set_display(movie_screen)
movie.play()


playing = True
while playing:
    events = pygame.event.get()
    for event in events:
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                quit()

    screen.blit(movie_screen,(0,0))
    pygame.display.update()
    clock.tick(FPS)

pygame.quit()