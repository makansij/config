config
======
- setup network
- install sudo
- visudo enable wheel
- add user:
```
useradd -m -g users -G wheel -s /bin/bash [username] && passwd [username]
```
- install git
- login as [username]
- clone this repo
```
mkdir git && cd git && git clone https://github.com/jandob/config.git && cd config
```
- run setup.sh
