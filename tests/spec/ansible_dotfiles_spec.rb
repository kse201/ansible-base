require 'spec_helper'

files = %w(
          .vimrc
          .vimrc.plugin
          .gitconfig
          .config/fish
          .config/nvim
          .tmux.conf
          .gemrc
)

files.each do |cfg|
  user = case Specinfra::Configuration.defaults[:backend]
         when :exec
           `whoami`.chomp
         when :ssh
           Specinfra::Configuration.defaults[:ssh_options][:user]
         end

  describe file("/home/#{user}/#{cfg}") do
    it { should be_exist }
    it { should be_symlink}
  end
end
