import sys
sys.path.append('../..')
from exten_util import *

def main(argv):
    if not CheckArgv(argv):
        return

    path = MergePath(argv[1], 'dockers/docker-orchagent')
    files = ['critical_processes.j2', 'supervisord.conf.j2']
    RestoreFiles(files, path)

    if CheckClean(argv):
        return

    filters = [
        [['set is_fabric_asic = 1', '{% endif %}'], ['if is_fabric_asic == 0', '{%- endif %}']],
        [['set is_fabric_asic = 1', '{%- endif %}'], ['[program:fdbsyncd]', '{%- endif %}']]
    ]
    contexts = [
        [
         '''{% if DEVICE_METADATA.localhost.switch_type == "ot" %}
{% set is_fabric_asic = 2 %}
{% endif %}\n''',
         '''{% if is_fabric_asic == 2 %}
program:otaimgrd
{%- endif %}\n'''
        ],
        [
         '''{% if DEVICE_METADATA.localhost.switch_type == "ot" %}
{% set is_fabric_asic = 2 %}
{%- endif %}\n''',
         '''\n{% if is_fabric_asic == 2 %}
[program:otaimgrd]
command=/usr/bin/otaimgrd
priority=18
autostart=false
autorestart=false
stdout_logfile=syslog
stderr_logfile=syslog
dependent_startup=true
dependent_startup_wait_for=swssconfig:exited
{% if ENABLE_ASAN == "y" %}
environment=ASAN_OPTIONS="log_path=/var/log/asan/otaimgrd-asan.log{{ asan_extra_options }}"
{% endif %}
{%- endif %}\n'''
        ]
    ]
    options = [
        ['after', 'after'],
        ['after', 'after']
    ]
    rfinds = [
        False,
        False
    ]

    for file, filter, context, option, rfind in zip(files, filters, contexts, options, rfinds):
        InsertContext(file, filter, context, option, rfind)


    GitAdd(path, files)


if __name__ == "__main__":
    main(sys.argv)
