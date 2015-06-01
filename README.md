
LICENSE
=======
* BSD 2-Clause

Background
==========
* XAMPP Apache + MySQL + PHP + Perl for FreeBSD Jails

Benefits of Goal Setting
========================
* XAMPP Apache + MySQL + PHP + Perl for FreeBSD Jails

WARNING
=======
* jampp is experimental and its not ready for production. Do it at your own risk.

Dependencies
============
* FreeBSD
   * Jail (Support)
```
   #/ Kernel Modules
   echo 'accf_data_load="YES" # Wait for data accept filter' >> /boot/loader.conf
   echo 'accf_http_load="YES" # Wait for full HTTP request accept filter' >> /boot/loader.conf
   kldload accf_data
   kldload accf_http

   #/ GIT Repository
   pkg update
   pkg install -y git
   git clone https://github.com/plitc/JAMPP.git
   cd JAMPP
   ./jampp.sh install
```

* free hard disk space requirement: 2-3 GB

JAIL (Package) Dependencies
=================
* apache24
* php56
* php56-extensions
* php56-gd
* mod_php56
* mysql56-server
* php56-mysql

```
```

Features
========
* install

* start

* stop

* uninstall

usage:
```
```

Platform
========
* FreeBSD
   * 10+

Usage
=====
```
    WARNING: jampp is experimental and its not ready for production. Do it at your own risk.

    # usage: ./jampp.sh { install | start | stop | uninstall }
```

Example
=======
* install
```
```

* start
```
```

* stop
```
```

* uninstall
```
```

Diagram
=======

Screencast
==========

Errata
======
* 31.05.2015:
```

TODO
====
* 31.05.2015:

