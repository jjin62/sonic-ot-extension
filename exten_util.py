import os
import shutil


def RemoveFolder(path):
    if os.path.exists(path):
        shutil.rmtree(path)


def CreateFolder(path):
    if not os.path.exists(path):
        os.mkdir(path)


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
    path = parent
    if path[-1] != '/':
        path += '/'
    path += child
    return path


def CheckArgv(argv):
    if len(argv) < 2:
        print('Error!!! Please input argument!\nargv 1: mandatory, path of sonic-buildimage directory\nargv 2: optional, clean')
        return False
    return True


def CheckClean(argv):
    if len(argv) > 2 and argv[2] == 'clean':
        return True
    return False
