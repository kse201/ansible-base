require 'spec_helper'

pkgs = case os[:family]
       when 'redhat'
         %w(vim-enhanced git fish tmux)
       when os[:family]
         %w(vim git fish tmux)
       end

files = %w(
          .vimrc
          .vimrc.plugin
          .gitconfig
          .config/fish
          .config/nvim
          .tmux.conf
          .gemrc
)

describe os[:family] do
  pkgs.each do |pkg|
    context package(pkg) do
      it { should be_installed }
    end
  end
end

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
