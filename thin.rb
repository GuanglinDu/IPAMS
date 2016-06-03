#!/usr/bin/env ruby
# A quick and dirty thin init script
# Based on https://gist.github.com/flores/839739
# Run thin.rb to see its usage.

# The argument list:
#address: 0.0.0.0
#port: 3000
#ssl: true
#ssl-key-file: ./server.key
#ssl-cert-file: ./server.crt
#user: www-data
#group: www-data
#pid: ./tmp/pids/thin.pid
#timeout: 30
#wait: 30
#log: log/thin.log
#max_conns: 1024
#require: []
#environment: production
#max_persistent_conns: 512
#servers: 1
#threaded: true
#no-epoll: true
#daemonize: true
#socket: ./tmp/sockets/thin.sock
#chdir: ./ 
#tag: IPAMS thin service 

# Which dir to run from
path = "./"

# The default IP address and port
address = "0.0.0.0"
port = "3000"

# The SSL key & cert files
key_file = "./server.key"
cert_file = "./server.crt"

# Let's keep it trackable
log = "./log/thin.log"
pid = "./tmp/thin.pid"

# http://goo.gl/glu6M9
# The backticks execute the command and return the output as a string.
def running?
  str = `ps aux|grep thin`
  str =~ /thin\s+server/i # Regexp
end

def get_rails_env
  env = ENV["RAILS_ENV"]
  if env =~ /development|test|production/
    puts "Your RAILS_ENV was found: #{env}."
  else
    env = "development"
    puts "Your RAILS_ENV was NOT found. Hence, it defaults to #{env}."
  end

  return env
end

def start_thin(env, pid, addr, port, kfile, cfile, log)
  puts "Starting thin in SSL mode..."
  system("thin start --environment #{env} -P #{pid}" \
         " --address #{addr} --port #{port}" \
         " --ssl --ssl-key-file #{kfile} --ssl-cert-file #{cfile}" \
         " -l #{log} -d")
  puts "Awesome, thin was started. Enjoy using it..."
end

def stop_thin(pid)
  system("thin stop -P #{pid}")
  #`rm -f #{pid}`
  puts "Bye, thin was stopped."
end

def help
  puts "Usage: #{__FILE__} status|start|stop|restart" \
    "\nNote: This script starts thin in the SSL mode. Both the SSL key and" \
    " certificate files have to be ready under the project root folder." \
    " RAILS_ENV must be one of development, test, and production." \
    " Otherwise, it defaults to development."
end

# The main part
# RAILS_ENV has to be determined first.
environment = get_rails_env

case ARGV.first
when 'status'
  if running?
    puts "Hi, thin is running joyfully..."
  else
    puts "Oops, thin is Not running at all. Sad! :)"
  end
when 'start'
  if running?
    puts "Oops, thin was already started."
  else
    start_thin environment, pid, address, port, key_file, cert_file, log
  end
when 'stop'
  if running?
    stop_thin pid
  else
    puts "It seems thin is not running. No further action."
  end
when 'restart'
  if running?
    stop_thin pid
    puts "Waiting a couple of seconds to let everybody bid farewell..."
    sleep 5
  else
    puts "Oops, thin was not started yet & is going to be started."
  end

  start_thin environment, pid, address, port, key_file, cert_file, log
else
  help
end
