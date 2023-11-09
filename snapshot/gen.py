import sys

sys.path.append('..')
from exten_util import *


g_gits={'./': 'sonic-buildimage',
          'src/sonic-sairedis': 'sonic-sairedis',
          'src/sonic-sairedis/SAI': 'SAI',
          'src/sonic-swss-common': 'sonic-swss-common',
          'src/sonic-swss': 'sonic-swss'}


def diff(cur, sonic):
    diff = 'git show HEAD --color | ' + cur + '/ansi2html.sh > ' + cur + '/'

    for key,value in g_gits.items():
        f = MergePath(sonic, key)
        sha = GitSha(f)

        GitCommit(f)
        cmd = 'cd ' + f
        cmd += '; '
        cmd += diff + value + '.html'
        ShellCmd(cmd)
        GitReset(f, sha)


def gen(cur):
    context = ''
    flag = False
    with open(cur + '/template', 'rt') as rf:
        for line in rf:
            if not flag and line.find('<ul>') == -1:
                context += line
                continue
            
            if not flag:
                flag = True
                context += line
                continue

            for v in g_gits.values():
                context += '                    <li><a href="./' + v + '.html">' + v + '</a></li>\n'
            context += line
            flag = False

    with open(cur + '/index.html', 'wt') as wf:
        wf.write(context)


def main(argv):
    if not CheckArgv(argv):
        return

    clean = CheckClean(argv)
    if clean:
        return

    diff(argv[3], argv[1])
    gen(argv[3])


if __name__ == "__main__":
    main(sys.argv)
