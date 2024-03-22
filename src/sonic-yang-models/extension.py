import sys
sys.path.append('../..')
from exten_util import *


def main(argv):
    if not CheckArgv(argv):
        return
    path = MergePath(argv[1], 'src/sonic-yang-models')
    files = ['yang-models/sonic-device_metadata.yang']
    RestoreFiles(files, path)

    if CheckClean(argv):
        return
    
    filters = [
        [['pattern', 'BmcMgmtToRRouter|'], ['pattern', 'chassis-packet|']]
    ]
    contexts = [
        ['SonicOt|', 'ot|']]
    options = [
        ['append', 'append']
    ]
    rfinds = [
        False
    ]

    for file, filter, context, option, rfind in zip(files, filters, contexts, options, rfinds):
        InsertContext(file, filter, context, option, rfind)

    GitAdd(path, files)

if __name__ == "__main__":
    main(sys.argv)
