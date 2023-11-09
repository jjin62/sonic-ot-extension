import sys
sys.path.append('../..')
from exten_util import *

def main(argv):
    if not CheckArgv(argv):
        return

    clean = CheckClean(argv)
    path = MergePath(argv[1], 'files/image_config')

    if not clean:
        CopyFolder('./optical', path)

    path = MergePath(argv[1], 'files/build_templates')
    files = ['sonic_debian_extension.j2']
    RestoreFiles(files, path)

    if clean:
        return
    
    filters = [
        [['# Copy CoPP configuration files and templates', 'echo "copp-config.service"']]
    ]
    contexts = [
        ['''\n# Copy Optical configuration files and templates
sudo cp $IMAGE_CONFIGS/optical/optical-config.service $FILESYSTEM_ROOT_USR_LIB_SYSTEMD_SYSTEM
sudo cp $IMAGE_CONFIGS/optical/optical-config.sh $FILESYSTEM_ROOT/usr/bin/
echo "optical-config.service" | sudo tee -a $GENERATED_SERVICE_FILE\n'''
        ]
    ]
    options = [
        ['after']
    ]
    rfinds = [
        False
    ]

    for file, filter, context, option, rfind in zip(files, filters, contexts, options, rfinds):
        InsertContext(file, filter, context, option, rfind)

    GitAdd(path, ['optical'])
    GitAdd(path, files)


if __name__ == "__main__":
    main(sys.argv)
