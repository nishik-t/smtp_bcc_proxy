#!/usr/local/bin/ruby
# Title  : smtp_bcc_proxy
# Author : original(ver.1.0) Makoto ODA <oda [at-mark] cobaltresq.com>,
#          modified(ver.1.1) Tateyuki Nishikata <nishik-t@nishik-t.com>
# Version: 1.10
# Date   : 2015/11/05 1.1
# Update :  - Thread generation code modified.
# Update :  - ADD BCC RCPT TO code modified.
# Date   : 2009/08/02 1.0
# Date   : 2007/02/04 0.4
# Article: SMTP Proxy. Alway add to bcc.
# Bug    : if 2 or more "RCTO TO header", bcc add.(But sometimes SMTP Server is smart 1 message only bcc)
# Lisence: GPL v2
#
#Copyright (C) 2015  Tateyuki Nishikata
#
#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation; either version 2
#of the License, or (at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require 'socket'
require 'thread'
require 'syslog'
require 'dbm'

LOGLEVEL=10

#SMTP Server
SMTPServerName="127.0.0.1"
SMTPServerPort=587

#SMTP Proxy Port
LocalPort=xxxx

Relay_DB="/etc/mail/allow_relay_table"
Pid_file="/var/run/smtp_bcc_proxy.pid"

def write_log(level,msg,mode)
        if LOGLEVEL >= mode  then
                Syslog.open("smtpbccproxy")
                if level == "INFO" then
                        Syslog.info(msg)
                elsif level == "WARN" then  
                        Syslog.warning(msg)
                elsif level == "ERR" then
                        Syslog.err(msg)
                end
                Syslog.close
        end
end

def check_allow_ip(ipaddress)
        mynetwork=["127.0.0.1","xxx.xxx.xxx.xxx"]
  	mynetwork.each{|network|
	if ipaddress =~ /#{network}/ then
		msg = "ACCEPT(NonScan) #{ipaddress}"
		write_log("INFO",msg,10)
		return 0
	end 
	}
	relay_db = DBM.open(Relay_DB,0644,DBM::READER)
	if relay_db[ipaddress] != nil  then
		msg = "ACCEPT #{ipaddress}"
		write_log("INFO",msg,10)
		return 0
	else
		msg = "DENY #{ipaddress}"
		write_log("INFO",msg,10)
		return 1  
	end
	current_db.close
end

def proxy(cli, prx)
	last_from = nil
	while(true)
	ary = IO::select([cli, prx])
  		begin
		#------ MESSAGE FROM CLIENT ---------
		if ary[0].member? cli
       			data = cli.sysread(1024)
			# data.each_line{|line| print line.dump,"\n" }
       		 	prx.syswrite data
       		 	last_from = cli
       			#--------- ADD BCC RCPT TO -----------
			if data =~ /^RCPT TO:/
				data = prx.sysread(1024)
				bcc = "RCPT TO: <bcc mailaddress>\r\n"
				prx.syswrite bcc
				last_from = cli
       			end
     		 end

		#--------- MESSAGE FROM SERVER --------
		if ary[0].member? prx
			data = prx.sysread(1024)
			# data.each_line{|line| print line.dump,"\n" }
			cli.syswrite data
			last_from = prx
		end
		rescue EOFError
		cli.close
		prx.close
		return
		end
	end
end

def smtp_bcc_proxy_daemon
        exit!(0) if fork
        Process.setsid()
        exit!(0) if fork
        File.umask(0)
        Dir.chdir "/"
        trap("SIGINT"){
                msg = "Stopping smtp_bcc_proxy daemon."
		write_log("INFO",msg,0)
                exit! 0
        }
        STDIN.close
        STDOUT.close
        STDERR.close

end
# main
smtp_bcc_proxy_daemon

# init
pid = File.open(Pid_file,"w+")
pid.puts $$
pid.close

msg = "Starting smtp_bcc_proxy daemon."
write_log("INFO",msg,0)

srv = TCPServer.new('0.0.0.0',LocalPort)
while(true)
  Thread.fork(srv.accept) {|ns|
    cli = ns
    ipaddress = ns.peeraddr[3]
    res = check_allow_ip(ipaddress)
    if res == 0 then
        prx = TCPSocket.new(SMTPServerName,SMTPServerPort)
        proxy(cli, prx) 
    else
        cli.syswrite  "550 Sorry You Don't Accept...\r\n"
        cli.close
    end
    Thread.exit
  }
end

