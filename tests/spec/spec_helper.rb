require 'serverspec'
require 'net/ssh'
require 'tempfile'

host = ENV['TARGET_HOST']

case host
when 'localhost' then
  `ansible-playbook -i localhost.ini site.yml`

  set :backend, :exec
else
  `vagrant up #{host} --provision`

  config = Tempfile.new('', Dir.tmpdir)
  config.write(`vagrant ssh-config #{host}`)
  config.close

  options = Net::SSH::Config.for(host, [config.path])

  options[:user] ||= Etc.getlogin

  set :host,        options[:host_name] || host
  set :ssh_options, options

  set :backend, :ssh
end
