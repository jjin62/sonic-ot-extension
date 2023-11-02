# sonic-ot-extension

This repository contains software modification for support optical transport devices. All changes required to support OT devices are in this repo and its submodules. Extension scripts are provided to apply these changes to the SONiC code base. As a result SONiC images can be built and installed on the optical devices. The purpose to consolidate all the OT changes in single source:
-  SONiC is a very active project and frequently changed. Directly changing SONiC code base would introduce big effort to sync with latest upstream. By patching OT modification on top of SONiC code base, there is no sync needed, as you can run extension script on any version of SONiC code base.
-  The eventual objective is to merge all the OT changes to upstream SONiC repository. By consolidate all the changes together, it would make easier to submit pull request later, as changes in each module are together. 
-  Since it would take sometime for SONiC community review and accept OT changes, we are able to deliver OT capable SONiC right now with this approach.

There are two type of changes that extension python scripts perform to the SONiC code base:
- add new files such as files for new optical platforms and devices. Most changes are new files.
- modify the existing SONiC code, this would change the code files and diff is also saved for reference purpose.

## Getting started
First clone sonic-buildimage to local dist, assume the directory is '~/sonic/sonic-buildimage'.

initialize sonic-buildimage
```
cd ~/sonic/sonic-buildimage
make init
```

Make all ot extensions to sonic-buildimage by the following command:
```
cd sonic-ot-extension
git submodule update --init --recursive
./extension.sh
```

Clean all ot extensions in sonic-buildimage by the following command:
```
cd sonic-ot-extension
./extension.sh clean
```
