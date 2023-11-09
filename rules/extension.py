import sys
sys.path.append('..')
from exten_util import *

def main(argv):
    if not CheckArgv(argv):
        return

    clean = CheckClean(argv)
    path = MergePath(argv[1], 'rules')
    files = ['config']
    RestoreFiles(files, path)

    if clean:
        return
    
    filters = [
        [['SONIC_USE_PDDF_FRAMEWORK = y'],
         ['INCLUDE_SFLOW = y'],
         ['INCLUDE_NAT = y'],
         ['INCLUDE_DHCP_RELAY = y'],
         ['ENABLE_AUTO_TECH_SUPPORT = y'],
         ['INCLUDE_MACSEC = y'],
         ['INCLUDE_GBSYNCD ?= y'],
         ['INCLUDE_TEAMD ?= y'],
         ['INCLUDE_ROUTER_ADVERTISER ?= y'],
         ['INCLUDE_MUX = y'],
         ['INCLUDE_FIPS ?= y']
        ]
    ]
    contexts = [
        ['SONIC_USE_PDDF_FRAMEWORK = n',
         'INCLUDE_SFLOW = n',
         'INCLUDE_NAT = n',
         'INCLUDE_DHCP_RELAY = n',
         'ENABLE_AUTO_TECH_SUPPORT = n',
         'INCLUDE_MACSEC = n',
         'INCLUDE_GBSYNCD ?= n',
         'INCLUDE_TEAMD ?= n',
         'INCLUDE_ROUTER_ADVERTISER ?= n',
         'INCLUDE_MUX = n',
         'INCLUDE_FIPS ?= n'
        ]
    ]
    options = [
        ['replace',
         'replace',
         'replace',
         'replace',
         'replace',
         'replace',
         'replace',
         'replace',
         'replace',
         'replace',
         'replace'
        ]
    ]
    rfinds = [
        False,
        False,
        False,
        False,
        False,
        False,
        False,
        False,
        False,
        False,
        False
    ]

    for file, filter, context, option, rfind in zip(files, filters, contexts, options, rfinds):
        InsertContext(file, filter, context, option, rfind)

    GitAdd(path, files)


if __name__ == "__main__":
    main(sys.argv)
