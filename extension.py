import os
import sys

from exten_util import *

def main(argv):
    folders = ['device',
               'dockers/docker-orchagent',
               'files/image_config',
               'platform',
               'rules']
    
    RunSubModules(argv, folders)


if __name__ == "__main__":
    main(sys.argv)