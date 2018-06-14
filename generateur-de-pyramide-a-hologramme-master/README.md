# Générateur de pyramide à hologramme

## Description

Ce projet vise à exploiter l'effet [pepper's ghost](https://fr.wikipedia.org/wiki/Fant%C3%B4me_de_Pepper) pour faire flotter des images sur une surface transparente.

Vous trouverez toutes les infos complémentaires dans [l'article associé](http://influence-pc.fr/?p=1404).

![Pyramide](http://influence-pc.fr/envois/Capture-du-2016-05-22-18-49-39-950x535.png)

## Installation

- Télécharger [OpenSCAD](http://www.openscad.org/downloads.html)

## Utilisation

En ouvrant **peppers_ghost_pyramid.scad** dans le logiciel OpenSCAD, vous avez la possibilité de configurer quelques variables :

    screen_width = 400;
    screen_height = 300;

Les dimensions de votre écran (longueur, hauteur) en millimètres, seulement de la partie LCD, sans les bordures en plastique du moniteur.

    free_space_area_percentage = 10;

Pourcentage d'espace libre (inutilisable par l'écran) au sommet du prisme. En % de la hauteur de votre écran. La pyramide sera coupée pour former un trou. Cela réduit la hauteur des faces du prisme.

    pyramid_face_angle = 45;

Angle configurable en degrés. Il s'agit de l'angle entre une face de la pyramide et sa base ou l'écran.

Beaucoup de tutoriaux utilisent 54,7° car cela induit des faces en triangles équilatéraux, faciles à construire.

L'autre angle qui revient souvent est 45° car la réflexion de la lumière est alors de 90°, donc horizontale.

    show_in_3D = false;

En passant cette variable à `true` et en appuyant sur la touche *F5* de votre clavier, vous profiterez d'un rendu 3D théorique. La réalité dépendra de l'épaisseur de votre matériau.

Vous pouvez ensuite utiliser le menu *Fichier* / *Exporter* pour obtenir un fichier vectoriel SVG standard.

## Licence

Ceci est un logiciel libre placé sous [licence CeCILL-B](http://www.cecill.info/licences/Licence_CeCILL-B_V1-fr.html), inspirée par la licence BSD 2-Clause et adaptée au droit français. Elle vous permet d'utiliser, copier, modifier et partager ce projet, usage commercial inclus, à la principale contrainte de respecter la paternité du projet. Vous devez associer le lien suivant [http://influence-pc.fr/?p=1404](http://influence-pc.fr/?p=1404) à toute republication de l'oeuvre initiale ou d'une oeuvre dérivée, ainsi que conserver les entêtes de licence placées dans le code source. J'espère que cela vous va :)
