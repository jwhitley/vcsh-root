# Bootstrap test Vagrantfile
#
# This Vagrantfile tests the bootstrap process for my top-level homedir
# configuration process, represented by this repo.  The intended workflow is:
#
# 1.  git clone -p jwhitley/vcsh-root  # (**)
# 2.  cd vcsh-root
# 3.  <make changes>
# 4.  <commit but DO NOT PUSH changes>
# 5.  vagrant destroy -f && vagrant up
# 6.  vagrant ssh
# 7.  <do ad-hoc testing and inspection of the environment>
#
# NOTE: This clones from the local repo via the `/vagrant` share.  Any changes
# to be tested by the VM must therefore be committed locally.  This is
# a requirement because the bootstrap script uses `vcsh clone` to test
# important bootstrap-time functionality implemented via vcsh hooks.
#
# Assumptions: your host machine has [Vagrant](https://www.vagrantup.com/) and
# [VirtualBox](https://www.virtualbox.org/) properly installed.

Vagrant.configure(2) do |config| config.ssh.forward_agent = true

  config.vm.box = "ubuntu/trusty64"
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
  vim-nox
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

# Bootstrap from the repo at /vagrant
#   The bootstrap process here should remain as similar to
#   https://raw.github.com/jwhitley/vcsh-root/bootstrap/bootstrap.sh
#   as possible.
  config.vm.provision "shell" do |s|
    s.privileged = false
    s.inline = <<-EOF
# BEGIN bootstrap.sh work-alike
mkdir $HOME/tmp
cd $HOME/tmp

cp /vagrant/local/bin/vcsh .
cp /vagrant/local/bin/mr .

chmod 755 mr vcsh

cd $HOME

export PATH=$HOME/tmp:$PATH

# Clone the bootstrap repo, containing the mr configuration
vcsh clone /vagrant mr

# Force an upgrade to run our vcsh hooks on the mr repo
vcsh upgrade mr

# Fixup mr's working tree for the sparse checkout settings
vcsh mr read-tree -mu HEAD

mr update

rm -rf $HOME/tmp
# END bootstrap.sh work-alike
    EOF
  end

  # Do remaining environment setup
  config.vm.provision "shell" do |s|
    s.privileged = false
    s.inline = <<-EOF
sudo chsh -s /bin/zsh $USER

# Install linuxbrew
git clone https://github.com/Homebrew/linuxbrew.git ~/.linuxbrew
brew=~/.linuxbrew/bin/brew
brew_pkgs=(
  fzf
  hub
)
$brew install ${brew_pkgs[@]}

bash -lc 'vim -c :PlugInstall -c :qall! >& /dev/null'

mkdir ~/.zlocal/this
cat > ~/.zlocal/this/zenviron <<END
# Override our default prompt birdtrack mark:
pr_birdtrack='$'
END
EOF
  end
end


