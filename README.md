# ubuntu-parental-controller
Parental controls (scheduled locking) for Ubuntu machines.

Allows scheduled locking and unlocking of targeted accounts on Ubuntu systems.

The service configured to run regularly in cron, so that if the target machine is shut down during the desired lock / unlock time, the desired action will still occur within 1 minute of the system being powered on.

# Usage

Config is managed via repo so that config can be updated remotely.

To use this yourself, fork this repo and set whichever lock / unlock config you need.

# Installation

1) Clone the repo the desired location on disk.

2) Install the necessary dependencies:

```
$ sudo /path/to/ubuntu-parental-controller/setup.sh
```

2) Set up automatic fetch/pull on the repo in `/etc/crontab` - recommended every 5 minutes. This must be done as the user that "owns" the repo locally (i.e. who cloned it):

```
/5 *    * * *   my_user cd /path/to/ubuntu-parental-controller && git pull --autostash
```

3) For each user account that needs to be managed, set up the utility in `/etc/crontab` and pass the username to the script - recommended every minute. This must be done as `root` to ensure sufficient access.

```
*  *    * * *   root     /path/to/ubuntu-parental-controller/run.sh managed_user
```
