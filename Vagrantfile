Vagrant.configure(2) do |config|
  config.ssh.forward_agent = true

  config.vm.box = "ubuntu/bionic64"
  config.vm.hostname = "#{File.basename(File.dirname(__FILE__))}.dev"

  # To make sure packages are up to date
  config.vm.provision "shell" do |s|
    s.privileged = true
    s.inline = <<-EOF
export DEBIAN_FRONTEND=noninteractive
apt-get update >/dev/null
apt-get --yes --force-yes upgrade
deps=(
  build-essential
  git
  ncurses-dev
  sharutils
  silversearcher-ag
  neovim
  wget
  zsh
)
apt-get install -q -y ${deps[@]}

# Add the github.com public ssh key to the global known_hosts file so that
# automated github interactions over ssh work correctly in the VM
cat > /etc/ssh/ssh_known_hosts << GITHUB_PUBLIC_KEY
# github.com SSH-2.0-libssh-0.6.0
|1|rlFevnVCygW+FMiWIPMlW6OCpzg=|5D3fkWbkXrK+PT3LjxvNr0XFoC4= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
# github.com SSH-2.0-libssh-0.6.0
GITHUB_PUBLIC_KEY
    EOF
  end

  # Bootstrap using the local (worktree) bootstrap.sh script, but using
  # the vcsh-root master from the remote repository
  config.vm.provision "shell" do |s|
    s.privileged = false
    s.path = 'bootstrap.sh'
  end

  # Do remaining environment setup
  config.vm.provision "shell" do |s|
    s.privileged = false
    s.inline = <<-EOF
sudo chsh -s /bin/zsh $USER

# Install linuxbrew
[ ! -d ~/.linuxbrew ] && git clone https://github.com/Linuxbrew/brew.git ~/.linuxbrew
brew=~/.linuxbrew/bin/brew
brew_pkgs=(
  fzf
  hub
)
$brew install ${brew_pkgs[@]}

bash -lc 'vim -c :PlugInstall -c :qall! >& /dev/null'

[ ! -d ~/.zlocal/this ] && mkdir ~/.zlocal/this
cat > ~/.zlocal/this/zenviron <<END
# Override our default prompt birdtrack mark:
pr_birdtrack='$'
END
EOF
  end
end
