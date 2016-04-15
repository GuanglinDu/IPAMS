#!/usr/bin/env ruby

# Param list
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

# A quick and dirty thin init script
# Based on https://gist.github.com/flores/839739

# Which dir to run from
path = "./"

# The default IP address and port
address = "0.0.0.0"
port = "3000"

#environment = "development"
environment = "production"

# SSL key & cert files
key_file = "./server.key"
cert_file = "./server.crt"

# let's keep it trackable
log = "./log/thin.log"
pid = "./tmp/thin.pid"

# http://goo.gl/glu6M9
# The backticks execute the command and return the output as a string.
def running?
  str = `ps aux|grep thin`
  str.index "thin server" 
end

case ARGV.first
when 'status'
  if File.exist?(log)
    pid = `pidof thin`.chomp # Note the backticks
    #log_pid = `cat #{log}`.chomp

    #puts "--- pid ---"
    #puts "pid = #{pid}\n"
    #puts "\n--- log_pid ---"
    #puts "log_pid = #{log_pid}\n"
    #puts "--- log_pid ---\n"
    #puts "#{pid.to_i}, #{log_pid.to_i}"

    if running?
      puts "Hi, thin is running joyfully ..."
    elsif(pid =~ /\d+/)
      puts "Running, but the process does not match the PID in #{pid}!" \
           "\nKeep it as is."
    else
      puts "Not running, removing the stale PID ..."
      `rm -f #{pid}`
    end
  else
    puts "Not running. Sad! :)"
  end
when 'start'
  if running?
    puts "Oops, thin was already started."
  else
    system("thin start --environment #{environment} -P #{pid}" \
      " --address #{address} --port #{port}" \
      " --ssl --ssl-key-file #{key_file} --ssl-cert-file #{cert_file}" \
      " -l #{log} -d")
    puts "Awesome, thin was started. Enjoy using it ..."
  end
when 'stop'
  if running?
    system("thin stop -P #{pid}")
    puts "Bye, thin was stopped."
  else
    puts "It seems thin is not running."
  end
when 'restart'
  if running?
    system("thin stop -P #{pid}")
    puts "Waiting a couple of seconds to let everything die ..."
    sleep 5
  else
    puts "Oops, thin was not started yet & is going to be started."
  end

  system("thin start --environment #{environment} -P #{pid}" \
    " --address #{address} --port #{port}" \
    " --ssl --ssl-key-file #{key_file} --ssl-cert-file #{cert_file}" \
    " -l #{log} -d")
  puts "Great, thin was started/restarted successfully."
else
  puts "Usage: #{__FILE__} status|start|stop|restart"
end
