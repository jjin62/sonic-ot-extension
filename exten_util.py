import os
import shutil
import subprocess


def RemoveFolder(path):
    if os.path.exists(path):
        shutil.rmtree(path)


def CreateFolder(path):
    if not os.path.exists(path):
        os.mkdir(path)


def CopyFolder(src, dest):
    name = src.strip()
    if name[-1] == '/':
        name = name[:-1]

    name = os.path.basename(name)
    path = MergePath(dest, name)
    RemoveFolder(path)
    shutil.copytree(src, path, symlinks=True)


def CopyFiles(filelist, dir):
    for files in filelist:
        for file in files:
            shutil.copy(file, dir)


def RestoreFiles(files, dir):
    os.chdir(dir)

    for file in files:
        cmd = 'git checkout ' + file
        print(cmd)
        os.system(cmd)


def InsertContext(file, filters, contexts, options, rfind):
    """
    The options could be before|after|append|insert|replace
    """
    
    with open(file, 'rb') as rf:
        rb = rf.read()
        #coding = chardet.detect(rb)
        data = rb.decode()

        for filter, context, option in zip(filters, contexts, options):
            pos = len(data) if rfind else 0
            for piece in filter:
                if rfind:
                    pos = data.rfind(piece, 0, pos)
                else:
                    pos = data.find(piece, pos)

                if pos == -1:
                    print('Error: cannot find [',piece,'] in file [',file,']')
                    return False

                pos += len(piece)

            if option == 'before':
                pos = data.rfind('\n', 0, pos) + 1
            elif option == 'after':
                pos = data.find('\n', pos) + 1
            
            conv = list(data)
            if option == 'replace':
                pos -= len(filter[-1])
                del conv[pos: pos + len(filter[-1])]
            elif option == 'insert':
                pos -= len(filter[-1])
            conv.insert(pos, context)
            data = ''.join(conv)

        with open(file, 'wb') as wf:
            wf.write(data.encode())


def MergePath(parent, child):
    path = parent.strip()
    if path[-1] != '/':
        path += '/'
    path += child
    return path


def CheckArgv(argv):
    if len(argv) < 2:
        print('Incorrect argument!\nargv 1: mandatory, path of sonic-buildimage directory\nargv 2: optional, build|clean')
        return False
    return True


def CheckClean(argv):
    if len(argv) > 2 and argv[2] == 'clean':
        return True
    return False


def ShellCmd(cmd):
    result = subprocess.run(cmd, capture_output=True, shell=True)
    return result.stdout.decode().strip()


def GitSha(path):
     cmd = 'cd ' + path
     cmd += '; '
     cmd += 'git rev-parse HEAD'
     return ShellCmd(cmd)


def GitAdd(path, files):
    cmd = 'cd ' + path
    for file in files:
        cmd += '; '
        cmd += 'git add ' + file
    ShellCmd(cmd)


def GitCommit(path):
    cmd = 'cd ' + path
    cmd += '; '
    cmd += 'git commit -m "Support SONiC OT"'
    ShellCmd(cmd)


def GitReset(path, sha):
    cmd = 'cd ' + path
    cmd += '; '
    cmd += 'git reset '
    cmd += sha
    ShellCmd(cmd)