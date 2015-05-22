#!/bin/sh
# Starts thin in https mode and put the process in background
# Please see http://www.napcsweb.com/blog/2013/07/21/rails_ssl_simple_wa/ for how to create certificates 
thin start --ssl  --ssl-key-file server.key --ssl-cert-file server.crt 2>&1 &
