require 'spec_helper'

pkgs = case os[:family]
       when 'redhat'
         %w(vim-enhanced git fish tmux)
       when os[:family]
         %w(nvim git fish tmux)
       end

files = %w( .vimrc
            .vimrc.plugin
            .gitconfig
            .config/fish
            .config/nvim
            .tmux.conf
            .gemrc)

user = case Specinfra::Configuration.defaults[:backend]
       when :exec
         `whoami`.chomp
       when :ssh
         Specinfra::Configuration.defaults[:ssh_options][:user]
       end

pips = %w( neovim
           vim-vint
           ansible-lint )

# gems = %w( rubocop tmuxinator )

describe os[:family] do
  pkgs.each do |pkg|
    context package(pkg) do
      it { should be_installed }
    end
  end
end

files.each do |cfg|
  describe file("/home/#{user}/#{cfg}") do
    it { should be_exist }
    it { should be_symlink }
  end
end

describe 'Ruby environment' do
  describe file('/usr/local/rbenv/bin/rbenv') do
    it { should be_file }
    it { should be_executable }
  end

  describe command('/usr/local/rbenv/shims/ruby --version') do
    its(:stdout) { should match '2.3.3' }
  end

  # gems.each do |gem|
  # describe package(gem) do
  # it { should be_installed.by('gem') }
  # end
  # end
end

describe 'Python environment' do
  describe file("/home/#{user}/.pyenv/bin/pyenv") do
    it { should exist }
  end

  describe command("/home/#{user}/.pyenv/shims/python --version") do
    its(:stdout) { should match '3.5.0' }
  end

  pips.each do |pip|
    describe command("/home/#{user}/.pyenv/shims/pip list") do
      its(:stdout) { should match pip }
    end
  end
end
