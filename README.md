smtp_bcc_proxy
====
## Overview

SMTP Proxy Daemon ,automatically adds the BCC. 
It is similar to always_bcc option at postfix.

## Description

When you want to work with e-mail archiver in sendmail, there is no option such as always_bcc of postfix.
This program is a daemon that has been made with Ruby, will operate as an SMTP proxy server .
What you are doing is simple . This program inserts a RCPT TO of BCC after the RCPT TO command of the SMTP communication .

The authors of this program , according to the original code , is Makoto ODA <oda [at-mark] cobaltresq.com>.
I modified this program , available at the GPLv2 license .

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
    bcc = "RCPT TO: <bcc mailaddress>\r\n"

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
