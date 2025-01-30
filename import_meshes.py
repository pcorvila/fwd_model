import bpy
import numpy as np
import bmesh
import mathutils
import subprocess
from pathlib import Path
import os
import sys
import getopt
import platform
import webbrowser

def check_args(argv):
    global scan_file_name, scale, mri_dir, scan_dir
    try:
        opts, args = getopt.getopt(argv, 'hs', ["help", "sub="])
    except getopt.GetoptError:
        print('wrong options, run -h or --help for help')
        sys.exit(2)
    for opt, arg in opts:
        if opt in ('-h', "--help"):
            print('\n\nOptions:\n'
                  '-h or --help\n'
                  '\tdisplay this help menu\n\n'
                
                  '-s or --sub\n'
                  '\tDefine the subject to be co-registered\n')
            sys.exit()
        elif opt == ("-s", "--sub"):
            sub = arg
            print('Subject is: ', sub)

argv = sys.argv
if '--' in argv:
    argv = argv[argv.index('--') + 1:]  # get all args after "--"
else:
    argv = ''
check_args(argv)

sub = 'MNI_05-08'

if "sub" not in globals():
    print('Please specify your subject')
    sys.exit(2)

SL_dir = "/Users/pcorvilain/Documents/Source_localization"

# remove the cube
bpy.data.objects.remove(bpy.data.objects['Cube'], do_unlink=True)
print('Cube removed')


print('Importing MRI surfaces')
bpy.ops.import_mesh.stl(filepath=os.path.join(SL_dir, "Freesurfer_output", sub, "bem", "stl", "seghead.stl"), global_scale=0.001)
bpy.ops.import_mesh.stl(filepath=os.path.join(SL_dir, "Freesurfer_output", sub, "bem", "stl", "outer_skin.stl"), global_scale=0.001)

file_transf = open(os.path.join(SL_dir, "Structure_scans", sub, "coreg.transform"), "r")
lines_transf = file_transf.readlines()
transf = np.empty((4, 4))

for i in range(4):
    for j in range(3):
        transf[i][j] = float(lines_transf[i].split(",")[j])
    transf[i][3] = float(lines_transf[i].split(",")[3])  # /1000
    # the factor 1000 is need if one used scale=1 in coreg.py
transf[3][3] = 1

matrix = mathutils.Matrix(transf)


print('Importing Model.stl')
bpy.ops.import_mesh.stl(filepath=os.path.join(SL_dir, "Structure_scans", sub, "Model.stl"), global_scale=1)
ob = bpy.context.object
me = ob.data

# transform the mesh with the matrix
me.transform(matrix)
me.update()
