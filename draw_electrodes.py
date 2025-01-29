import sys
sys.path.append(r"/Users/pcorvilain/Documents/eeg_source_loc/.venv/lib/python3.13/site-packages")
import os
import scipy.io as io
import bpy


sub = 'MNI_05-08'
SL_dir = "/Users/pcorvilain/Documents/Source_localization"

matfile = io.loadmat(os.path.join(SL_dir, "Structure_scans", sub, "elecpos_mriframe.mat"))
positions = matfile['elecpos_mriframe']
print(positions)

for i in range(positions.shape[0]):
    x, y, z = positions[i, :]
    r = 1
    print(f"Drawing sphere at ({x}, {y}, {z}) with radius {r}")
    # Uncomment the following lines to draw spheres in Blender
    bpy.ops.mesh.primitive_uv_sphere_add(radius=r, location=(x, y, z))

# bpy.ops.mesh.primitive_ico_sphere_add(size=r, location=(x, y, z))