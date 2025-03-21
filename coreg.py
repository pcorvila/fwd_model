import bpy
import bmesh
import os
from pathlib import Path
import sys
import getopt

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

# sub = 'MNI_05-08'
sub = 'MNI_02-05'

if "sub" not in globals():
    print('Please specify your subject')
    sys.exit(2)

SL_dir = '/Users/pcorvilain/Documents/Source_localization'

# remove the cube
bpy.data.objects.remove(bpy.data.objects['Cube'], do_unlink=True)

print('Cube removed')

print('Importing MRI surface')
bpy.ops.import_mesh.stl(filepath=os.path.join(SL_dir, "3D print", sub + ".stl"), global_scale=1)

print('Importing scanned headshape')
bpy.ops.import_mesh.stl(filepath=os.path.join(SL_dir, "Structure_scans", sub, sub + ".stl"), global_scale=0.001)


