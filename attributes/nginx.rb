default['nginx']['port'] = 80

default['thumbor']['nginx']['server_name'] = '_'
default['thumbor']['nginx']['proxy_cache']['enabled'] = false
default['thumbor']['nginx']['proxy_cache']['path'] = '/var/www/thumbor_cache'
default['thumbor']['nginx']['proxy_cache']['key_zone'] = 'thumbor_cache'
