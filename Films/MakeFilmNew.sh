#!/bin/bash
# make holographic video

############################################################################""
##	Variables a modifier suivant les besoins
#A Modifier suivant résolution choisie finale
ScreenSizeX=1024
ScreenSizeY=768
#A modifier suivant les besoins. Convient pour un écran 4/3 de 1024x768
ImagetteX=280
ImagetteY=280
#Taille video entree
InputSizeX=1440
InputSizeY=1080
#A Modifier Pour le "crop" du fichier entree
SizeCropX=1080
SizeCropY=1080
#A Modifier si l'image conservée n'est pas centree
let "XBaseCrop = ($InputSizeX - $SizeCropX) / 2"
let "YBaseCrop = ($InputSizeY - $SizeCropY) / 2"
#A Modifier suivant la position souhaitée des imagettes
MargeX=5
MargeY=5
##Fin des modifications
##################################################################################

#definition des Positions des imagettes
let "XUpBot = ($ScreenSizeX -$ImagetteX) / 2"
let "YUp = $MargeY"
let "YBot = $ScreenSizeY - $ImagetteY - $MargeY"
let "XLeft = $MargeX"
let "XRight = $ScreenSizeX - $ImagetteX - $MargeX"
let "YLeftRight = ($ScreenSizeY - $ImagetteY)/2"

echo XBaseCrop $XBaseCrop
echo YBaseCrop $YBaseCrop
echo XUpBot $XUpBot
echo YUp $YUp
echo YBot $YBot 
echo XLeft $XLeft
echo XRight $XRight
echo YLeftRight $YLeftRight

if [ $# = "1" ]
then
	NomSortie=out.mp4
	Debut="00:00:00.0"
	Duree=10000
elif [ $# = "2" ]
then
	NomSortie=out.mp4
	Debut=$2
	Duree=10000
elif [ $# = "3" ]
then
	NomSortie=out.mp4
	Debut=$2
	Duree=$3
elif [ $# = "4" ]
then
	NomSortie=$4
	Debut=$2
	Duree=$3
else
	echo "Creation film holographique"
	echo "Fonctionne pour ecran final ${ScreenSizeX}x${ScreenSizeY}, ajuster pour d'autres tailles"
	echo "Résolution film en entrée ${InputSizeX}x${InputSizeY} coupée à ${SizeCropX}x${SizeCropY}, ajutser suivant les besoins"
	echo "Taille des imagettes ${ImagetteX}x${ImagetteY} à ajutser"
	echo "Marges des imagettes en X : $MargeX Y : $MargeY pixels"
	echo Syntaxe $0 FilmEntree [Debut] [Duree] [NomSortie]
	exit 1
fi

# beaucoup d'aide de http://wiki.joanillo.org/index.php/Pyramid_hologram
# la video d'origine ($1) est d'abord coupée
## au milieu horizontalement mais décalé vers le bas en vertical
ffmpeg -y -i $1 -vf "crop=$SizeCropX:$SizeCropX:$XBaseCrop:$YBaseCrop" -ss $Debut-t $Duree  orig1.mp4

## création de videos avec rotation
# option transpose :
# 0 = 90CounterCLockwise and Vertical Flip (default)
# 1 = 90Clockwise
# 2 = 90CounterClockwise
# 3 = 90Clockwise and Vertical Flip
ffmpeg -y -i orig1.mp4 -y -b 10000k -vf "transpose = 1" orig2.mp4
ffmpeg -y -i orig1.mp4 -y -b 10000k -vf "transpose = 1, transpose = 1" orig3.mp4
ffmpeg -y -i orig1.mp4 -y -b 10000k -vf "transpose = 2" orig4.mp4


## mosaique
# filter_complex: https://trac.ffmpeg.org/wiki/Create%20a%20mosaic%20out%20of%20several%20input%20videos
# black bg: https://stackoverflow.com/questions/47042473/ffmpeg-complex-filter-multiple-crops-on-black-background
ffmpeg -y -i orig3.mp4 -i orig4.mp4 -i orig1.mp4 -i orig2.mp4 \
-b 10000k -filter_complex "
color=s=1024x768:c=black[base];
[0:v] setpts=PTS-STARTPTS, scale=${ImagetteX}x${ImagetteY} [up];
[1:v] setpts=PTS-STARTPTS, scale=${ImagetteX}x${ImagetteY} [right];
[2:v] setpts=PTS-STARTPTS, scale=${ImagetteX}x${ImagetteY} [bot];
[3:v] setpts=PTS-STARTPTS, scale=${ImagetteX}x${ImagetteY} [left];
[base][up] overlay=shortest=1:x=$XUpBot:y=$YUp [tmp2];
[tmp2][right] overlay=shortest=1:x=$XRight:y=$YLeftRight [tmp3];
[tmp3][bot] overlay=shortest=1:x=$XUpBot:y=$YBot [tmp4];
[tmp4][left] overlay=shortest=1:x=$XLeft:y=$YLeftRight" $NomSortie

