import sys
sys.path.append('../..')
from exten_util import *

def main(argv):
    if not CheckArgv(argv):
        return

    path = MergePath(argv[1], 'src/sonic-swss-common')
    files = ['common/schema.h']
    RestoreFiles(files, path)

    if CheckClean(argv):
        return
    
    filters = [
        [['/***** ASIC DATABASE *****/'], ['/***** EVENTS COUNTER KEYS *****/'], ['/***** CONFIGURATION DATABASE *****/'], ['/***** STATE DATABASE *****/'], ['/***** MISC *****/']]
    ]
    contexts = [
        ['''#define APP_ATTENUATOR_TABLE_NAME            "ATTENUATOR_APP_TABLE"
#define APP_OA_TABLE_NAME                    "AMPLIFIER_APP_TABLE"
#define APP_OCM_TABLE_NAME                   "OCM_APP_TABLE"
#define APP_OSC_TABLE_NAME                   "OSC_APP_TABLE"
#define APP_OTDR_TABLE_NAME                  "OTDR_APP_TABLE"\n\n''',
         '''#define COUNTERS_ATTENUATOR_NAME_MAP        "COUNTERS_ATTENUATOR_NAME_MAP"
#define COUNTERS_OA_NAME_MAP                "COUNTERS_AMPLIFIER_NAME_MAP"
#define COUNTERS_OCM_NAME_MAP               "COUNTERS_OCM_NAME_MAP"
#define COUNTERS_OSC_NAME_MAP               "COUNTERS_OSC_NAME_MAP"
#define COUNTERS_OTDR_NAME_MAP              "COUNTERS_OTDR_NAME_MAP"\n\n''',
         '''#define ATTENUATOR_COUNTER_STATS_LIST       "ATTENUATOR_COUNTER_STATS_LIST"
#define ATTENUATOR_STATS_PLUGIN_FIELD       "ATTENUATOR_STATS_PLUGIN_FIELD"
#define OA_COUNTER_STATS_LIST               "AMPLIFIER_COUNTER_STATS_LIST"
#define OA_STATS_PLUGIN_FIELD               "AMPLIFIER_STATS_PLUGIN_FIELD"
#define OCM_COUNTER_STATS_LIST              "OCM_COUNTER_STATS_LIST"
#define OCM_STATS_PLUGIN_FIELD              "OCM_STATS_PLUGIN_FIELD"
#define OSC_COUNTER_STATS_LIST              "OSC_COUNTER_STATS_LIST"
#define OSC_STATS_PLUGIN_FIELD              "OSC_STATS_PLUGIN_FIELD"
#define OTDR_COUNTER_STATS_LIST             "OTDR_COUNTER_STATS_LIST"
#define OTDR_STATS_PLUGIN_FIELD             "OTDR_STATS_PLUGIN_FIELD"\n\n''',
         '''#define CFG_ATTENUATOR_TABLE_NAME                   "ATTENUATOR_TABLE"
#define CFG_OA_TABLE_NAME                           "AMPLIFIER_TABLE"
#define CFG_OCM_TABLE_NAME                          "OCM_TABLE"
#define CFG_OSC_TABLE_NAME                          "OSC_TABLE"
#define CFG_OTDR_TABLE_NAME                         "OTDR_TABLE"\n\n''',
         '''#define STATE_ATTENUATOR_TABLE_NAME                 "ATTENUATOR_STATE_TABLE"
#define STATE_OA_TABLE_NAME                         "AMPLIFIER_STATE_TABLE"
#define STATE_OCM_TABLE_NAME                        "OCM_STATE_TABLE"
#define STATE_OSC_TABLE_NAME                        "OSC_STATE_TABLE"
#define STATE_OTDR_TABLE_NAME                       "OTDR_STATE_TABLE"\n\n'''
        ]
    ]
    options = [
        ['before', 'before', 'before', 'before', 'before']
    ]
    rfinds = [
        True
    ]

    for file, filter, context, option, rfind in zip(files, filters, contexts, options, rfinds):
        InsertContext(file, filter, context, option, rfind)


if __name__ == "__main__":
    main(sys.argv)
