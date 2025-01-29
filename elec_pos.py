import numpy as np
import os
import bpy

sub = 'MNI_05-08'
SL_dir = "/Users/pcorvilain/Documents/Source_localization"

fname = os.path.join(SL_dir, "Structure_scans", sub, "elecpos_mriframe.txt")

positions = np.loadtxt(fname, delimiter=',')/1000
# print(positions)

# remove the cube
bpy.data.objects.remove(bpy.data.objects['Cube'], do_unlink=True)
print('Cube removed')

# load mri


# draw spheres at sensors locations
for i in range(positions.shape[0]):
    x, y, z = positions[i, :]
    r = 1
    # print(f"Drawing sphere at ({x}, {y}, {z}) with radius {r}")
    bpy.ops.mesh.primitive_uv_sphere_add(radius=r, location=(x, y, z))


