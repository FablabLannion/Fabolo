/* Copyright Vincent LAMBERT. Contributor Sylvain GARNAVAULT. (2016)
email: vincent@influence-pc.fr
This software is a computer program whose purpose is to generate the 2D plan of a pyramid or a prism for making a hologram based on the Pepper's Ghost effect.
This software is governed by the CeCILL-B license under French law and abiding by the rules of distribution of free software.  You can  use, modify and/ or redistribute the software under the terms of the CeCILL-B license as circulated by CEA, CNRS and INRIA at the following URL "http://www.cecill.info".
As a counterpart to the access to the source code and  rights to copy, modify and redistribute granted by the license, users are provided only with a limited warranty  and the software's author,  the holder of the economic rights, and the successive licensors  have only  limited liability.
In this respect, the user's attention is drawn to the risks associated with loading,  using,  modifying and/or developing or reproducing the software by the user in light of its specific status of free software, that may mean  that it is complicated to manipulate,  and  that  also therefore means  that it is reserved for developers  and  experienced professionals having in-depth computer knowledge. Users are therefore encouraged to load and test the software's suitability as regards their requirements in conditions enabling the security of their systems and/or data to be ensured and,  more generally, to use and operate it in the same conditions as regards security.
The fact that you are presently reading this means that you have had knowledge of the CeCILL-B license and that you accept its terms. */

/*** VARIABLES YOU NEED TO FILL ***/

/* Configurable parameters in millimeters */
screen_width = 198;     // Screen surface only,
screen_height = 143;    // not including the monitor's border.

/* Configurable percentage of free space (not usable by the screen) on top of the pyramid */
free_space_area_percentage = 10;   // In % of screen_height. The pyramid top will be cut to create a hole. It reduces faces height and pyramid height.

/* Configurable angle in degrees */
// The angle between a pyramid face and the screen or the floor.
// Most tutorials use 54.7° because it creates equilateral triangles, easier to build.
// If the angle of reflection is 45°, the light will reflect at 90° of the screen (horizontally).
pyramid_face_angle = 45;    // Other slope to try: 35.3°.

show_in_3D = false;  // Use F5



/*** AUTOMATED SCRIPT  ***/

top_edge_length = screen_width - screen_height; // Distance between the two tops (it's not really a pyramid, it's a polyhedron)
free_space_height = free_space_area_percentage * screen_height / 100;
//free_space_width = free_space_area_percentage * screen_width / 100;
initial_pyramid_face_height = (screen_height/2) / cos(pyramid_face_angle);   // Hypotenuse = triangle height
initial_pyramid_height = (screen_height/2) * tan(pyramid_face_angle);  // Pyramid height (not the triangle height)
final_pyramid_height = (screen_height/2 - free_space_height/2) * tan(pyramid_face_angle);
final_pyramid_face_height = (screen_height/2 - free_space_height/2) / cos(pyramid_face_angle);
margin_between_parts = 10;  // On the plan, just to space them.

/* Parts' definitions */
module face_for_screen_height() {
    polygon([[0, 0], [screen_height, 0], [screen_height/2 + free_space_height/2, final_pyramid_face_height], [screen_height/2 - free_space_height/2, final_pyramid_face_height]]);
}
module face_for_screen_width() {
    polygon([[0, 0], [screen_width, 0], [screen_width/2 + free_space_height/2 + top_edge_length/2, final_pyramid_face_height], [screen_width/2 - top_edge_length/2 - free_space_height/2, final_pyramid_face_height]]);
}

/* Build the prism */
if (show_in_3D) {
    rotate([pyramid_face_angle, 0, 0])
        face_for_screen_height();

    translate([screen_height, 0, 0])
        rotate([pyramid_face_angle, 0, 90])
            face_for_screen_width();

    translate([0, screen_width, 0])
        rotate([-(pyramid_face_angle), 0, 0])
            translate([0, 0, 0])
                rotate([180, 0, 0])
                    face_for_screen_height();

    translate([0, 0, 0])
        rotate([-(pyramid_face_angle), 0, 90])
            translate([0, 0, 0])
                rotate([180, 0, 0])
                    face_for_screen_width();
} else {
    face_for_screen_height();
    translate([screen_height + 10, 0, 0])
        face_for_screen_width();
    translate([screen_height + 10 + screen_width + 10, 0, 0])
        face_for_screen_height();
    translate([screen_height + 10 + screen_width + 10 + screen_height + 10, 0, 0])
        face_for_screen_width();
}
