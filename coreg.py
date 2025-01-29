import bpy
import bmesh
import os
from pathlib import Path
import sys
import getopt


def ckeck_args(argv):

    global scan_file_name, scale, mri_dir, scan_dir
    try:
        opts, args = getopt.getopt(argv, 'he:s:', ["help", "mri_dir=", "scan_dir=", "ext=", "scale=", "sub="])
    except getopt.GetoptError:
        print('wrong options, run -h or --help for help')
        sys.exit(2)
    for opt, arg in opts:
        if opt in ('-h', "--help"):
            print('\n\nOptions:\n'
                  '-h or --help\n'
                  '\tdisplay this help menu\n\n'
                  '-e or --ext\n'
                  '\tSet an extension to the name of the optic scan "Scan.stl"\n\n'
                  '-s or --scale\n'
                  '\tSet the global scale for importing the .stl files (default is 0.001)\n')
            sys.exit()
        elif opt == "--mri_dir":
            mri_dir = arg
            print('mri_dir set to: ', mri_dir)
        elif opt == "--scan_dir":
            scan_dir = arg
            print('scan_dir set to: ', scan_dir)
        elif opt in ("-e", "--ext"):
            ext = arg
            scan_file_name = 'Scan' + ext + '.stl'
            print('Scan file name set to: ', scan_file_name)
        elif opt == ("-s", "--scale"):
            scale = float(arg)
            print('global scale is set to: ', scale)


scan_file_name = "Scan.stl"
subfolder = ''
scale = 0.001

argv = sys.argv
if '--' in argv:
    argv = argv[argv.index('--') + 1:]  # get all args after "--"
else:
    argv = ''
ckeck_args(argv)

if "mri_dir" not in globals():
    print('Please specify your MRI directory')
    sys.exit(2)
if "scan_dir" not in globals():
    print('Please specify your scans directory')
    sys.exit(2)

# remove the cube
bpy.data.objects.remove(bpy.data.objects['Cube'], do_unlink=True)
print('Cube removed')
print('Importing ' + scan_file_name + ',  scale = ' + str(scale))

bpy.ops.import_mesh.stl(filepath=os.path.join(scan_dir, scan_file_name), global_scale=scale)
# bpy.ops.import_mesh.stl(filepath=os.path.join(folder, scan_file_name))

print('Importing IRM,  scale = ' + str(scale))
bpy.ops.import_mesh.stl(filepath=os.path.join(mri_dir, "surf", "lh.seghead.stl"), global_scale=scale)
# bpy.ops.import_mesh.stl(filepath=os.path.join(subjects_dir, subject, "surf", "lh.seghead.stl"))



