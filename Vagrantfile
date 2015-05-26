
Vagrant.configure('2') do |config|
  config.vm.box = 'chef/ubuntu-14.04'
  config.omnibus.chef_version = :latest
  config.ssh.forward_agent = true

  config.librarian_chef.cheffile_dir = "chef"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]

    # Who has a single core cpu these days anyways?
    cpu_count = 2

    # Determine the available cores in host system.
    # This mostly helps on linux, but it couldn't hurt on MacOSX.
    if RUBY_PLATFORM =~ /linux/
      cpu_count = `nproc`.to_i
    elsif RUBY_PLATFORM =~ /darwin/
      cpu_count = `sysctl -n hw.ncpu`.to_i
    end

    # Assign additional cores to the guest OS.
    vb.customize ["modifyvm", :id, "--cpus", cpu_count]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]

    # This setting makes it so that network access from inside the vagrant guest
    # is able to resolve DNS using the hosts VPN connection.
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.vm.network :private_network, type: 'dhcp'
  config.vm.network :forwarded_port, guest: 3000, host: 4000
  config.vm.network :forwarded_port, guest: 1080, host: 4080 # Mailcatcher

  config.vm.provision :shell, path: "bootstrap.sh"
  nfs_setting = RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/
  config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", :nfs => nfs_setting

  chef_cookbooks_path = ["chef/cookbooks","chef/site-cookbooks"]
   config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = chef_cookbooks_path
    chef.add_recipe 'postgresql::server'
    chef.add_recipe 'vim'
    #chef.add_recipe "rbenv::default"
    #chef.add_recipe "rbenv::ruby_build"
    
    chef.json = {
      :postgresql => {
        :config   => {
          :listen_addresses => "*",
          :port             => "5432"
        },
        :pg_hba   => [
          {
            :type   => "local",
            :db     => "postgres",
            :user   => "postgres",
            :addr   => nil,
            :method => "trust"
          },
          {
            :type   => "host",
            :db     => "all",
            :user   => "all",
            :addr   => "0.0.0.0/0",
            :method => "md5"
          },
          {
            :type   => "host",
            :db     => "all",
            :user   => "all",
            :addr   => "::1/0",
            :method => "md5"
          }
        ],
        :password => {
          :postgres => "password"
        }
      }
    }
  end
  config.vm.provision :shell, path: "rbenv_install.sh", privileged: false
  config.vm.provision :shell, path: "ruby_install.sh", privileged: false

end
