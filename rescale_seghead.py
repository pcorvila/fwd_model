import bpy
import numpy as np
import os

sub = 'MNI_02-05'
SL_dir = "/Users/pcorvilain/Documents/Source_localization"

# remove the cube
bpy.data.objects.remove(bpy.data.objects['Cube'], do_unlink=True)
print('Cube removed')

print('Importing seghead.stl')
bpy.ops.import_mesh.stl(filepath=os.path.join(SL_dir, "Freesurfer_output", sub, "bem", "stl", "seghead.stl"), global_scale=1)
ob = bpy.context.object

origin = [0, 0, 0]
height_seghead = np.transpose([ob.ray_cast(origin, [0, 0, 1])[1]])[2]
L = np.transpose([ob.ray_cast(origin, [-1, 0, 0])[1]])[0]
R = np.transpose([ob.ray_cast(origin, [1, 0, 0])[1]])[0]
width_seghead = L-R
front = np.transpose([ob.ray_cast(origin, [0, 1, 0])[1]])[1]
back = np.transpose([ob.ray_cast(origin, [0, -1, 0])[1]])[1]
length_seghead = front-back

print("height seghead " + str(height_seghead))
print("width seghead " + str(width_seghead))
print("length seghead " + str(length_seghead))


print('Importing outer_skin.stl')
bpy.ops.import_mesh.stl(filepath=os.path.join(SL_dir, "Freesurfer_output", sub, "bem", "stl", "outer_skin.stl"), global_scale=1)
ob = bpy.context.object

origin = [0, 0, 0]
height_outer_skin = np.transpose([ob.ray_cast(origin, [0, 0, 1])[1]])[2]
L = np.transpose([ob.ray_cast(origin, [-1, 0, 0])[1]])[0]
R = np.transpose([ob.ray_cast(origin, [1, 0, 0])[1]])[0]
width_outer_skin = L-R
front = np.transpose([ob.ray_cast(origin, [0, 1, 0])[1]])[1]
back = np.transpose([ob.ray_cast(origin, [0, -1, 0])[1]])[1]
length_outer_skin = front-back

print("height outer_skin " + str(height_outer_skin))
print("width outer_skin " + str(width_outer_skin))
print("length outer_skin " + str(length_outer_skin))

ratio = np.zeros(3)
ratio[0] = height_outer_skin/height_seghead
ratio[1] = width_outer_skin/width_seghead
ratio[2] = length_outer_skin/length_seghead
print("ratio: " + str(ratio))
print("mean: " + str(np.average(ratio)))

print('Importing seghead.stl')
bpy.ops.import_mesh.stl(filepath=os.path.join(SL_dir, "Freesurfer_output", sub, "bem", "stl", "seghead.stl"), global_scale=1*np.average(ratio))
ob = bpy.context.object