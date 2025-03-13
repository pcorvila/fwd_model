import numpy as np
import os
import bpy
import bmesh
import mathutils

sub = 'MNI_02-05'
SL_dir = "/Users/pcorvilain/Documents/Source_localization"

# load positions
fname = os.path.join(SL_dir, "Structure_scans", sub, "elecpos_mriframe_7mm_inwards.txt")
positions = np.loadtxt(fname, delimiter=',')/1000
# print(positions)

# remove the cube
bpy.data.objects.remove(bpy.data.objects['Cube'], do_unlink=True)
print('Cube removed')

# draw spheres at sensors position
# for i in range(positions.shape[0]):
#     x, y, z = positions[i]
#     r = 0.01
#     # print(f"Drawing sphere at ({x}, {y}, {z}) with radius {r}")
#     bpy.ops.mesh.primitive_uv_sphere_add(radius=r, location=(x, y, z))
#

f = open("/Users/pcorvilain/Documents/eeg_data_analysis/chan_names.txt", "r")
chan_names = f.readlines()

# # load 3D scan
# print('Importing headshape.stl')
# bpy.ops.import_mesh.stl(filepath=os.path.join(SL_dir, "Structure_scans", sub, "headshape.stl"), global_scale=0.001)
# ob = bpy.context.object
# me = ob.data

print('Importing seghead rescaled')
bpy.ops.import_mesh.stl(filepath=os.path.join(SL_dir, "Freesurfer_output", sub, "bem", "stl", sub + "_seghead_rescaled.stl"), global_scale=0.001)
ob = bpy.context.object

print('Importing brain surface')
bpy.ops.import_mesh.stl(filepath=os.path.join(SL_dir, "Freesurfer_output", sub, "bem", "stl", sub + "_brain.stl"), global_scale=0.001)
ob = bpy.context.object

if bpy.data.collections.get("Electrodes"):
    vec_collection = bpy.data.collections["Electrodes"]
else:
    vec_collection = bpy.data.collections.new("Electrodes")
    bpy.context.scene.collection.children.link(vec_collection)

bpy.context.view_layer.active_layer_collection = \
    bpy.context.view_layer.layer_collection.children["Electrodes"]

for i in range(positions.shape[0]):
    o = positions[i]
    b = o / np.linalg.norm(o)
    a = np.array([0, 0, 1])
    sin_a = np.linalg.norm(np.cross(a, b))
    cos_a = np.dot(a, b)

    v1, v2, v3 = np.cross(a, b)

    M = np.array([[0, -v3, v2], [v3, 0, -v1], [-v2, v1, 0]])

    rot = np.identity(3) + M + M @ M * (1 - cos_a) / sin_a ** 2

    mat_temp = np.append(rot, o[np.newaxis].T, axis=1)
    mat_np = np.append(mat_temp, np.array([[0., 0., 0., 1.]]), axis=0)

    mat = mathutils.Matrix(mat_np)

    name = chan_names[i].strip()
    mesh = bpy.data.meshes.new(name)  # add the new mesh
    obj = bpy.data.objects.new(mesh.name, mesh)
    col = bpy.data.collections.get("Electrodes")
    col.objects.link(obj)
    bpy.context.view_layer.objects.active = obj

    bm = bmesh.new()
    bm.from_mesh(mesh)

    bmesh.ops.create_circle(bm,
                            cap_ends=True,
                            radius=0.006,
                            matrix=mat,
                            segments=32)

    # Select and make active
    bm.to_mesh(mesh)
    bm.free()

    bpy.context.view_layer.objects.active = obj
    obj.select_set(True)