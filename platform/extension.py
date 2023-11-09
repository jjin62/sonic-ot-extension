import sys
sys.path.append('..')
from exten_util import *

def main(argv):
    if not CheckArgv(argv):
        return

    clean = CheckClean(argv)
    if clean:
        return

    path = MergePath(argv[1], 'platform')
    CopyFolder('./molex', path)
    CopyFolder('./ot-kvm', path)

    GitAdd(path, ['molex', 'ot-kvm'])


if __name__ == "__main__":
    main(sys.argv)
