import sys
sys.path.append('../..')
from exten_util import *


def MergePatch():
    # TODO
    # pull request patch for quesion #3222
    # It will be deleted after this pull request merge into master.
    #
    # 2023/03/22
    ShellCmd('git remote add upstream https://github.com/sonic-net/sonic-utilities.git')
    rs = ShellCmd('git fetch upstream pull/3222/head')
    print(rs)
    rs = ShellCmd('git cherry-pick 8dd25a9caa6605eda1786aa506648eb63a1e4393')
    print(rs)


def main(argv):
    if not CheckArgv(argv):
        return

    path = MergePath(argv[1], 'src/sonic-utilities')
    RestoreAll(path)

    if CheckClean(argv):
        return

    MergePatch()


if __name__ == "__main__":
    main(sys.argv)
