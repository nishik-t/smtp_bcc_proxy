smtp_bcc_proxy
====
## Overview

SMTP Proxy Daemon ,automatically adds the BCC. 
It is similar to always_bcc option at postfix.

## Description

## Requirement

Ruby 1.8.7 or over

libralies
- socket
- thread
- syslog
- dbm

## Usage

Change your ruby path

    #!/usr/local/bin/ruby

Change settings ... 

    SMTPServerName=127.0.0.1 
    SMTPServerPort=587 
    LocalPort=xxxx 
    mynetwork=["127.0.0.1","xxx.xxx.xxx.xxx"]

and Type command.

    $ smtp_bcc_proxy.rb

## Licence

GPLv2

Copyright (C) 2015  Tateyuki Nishikata

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

## Author

[nishik-t](https://github.com/nishik-t)
