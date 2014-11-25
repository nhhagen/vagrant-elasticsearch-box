# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"

    # Example forwarded_port
    config.vm.network :forwarded_port, guest: 3000, host: 3000
    config.vm.network :forwarded_port, guest: 9200, host: 9200
    config.vm.network :forwarded_port, guest: 9300, host: 9300
    config.vm.network :forwarded_port, guest: 5672, host: 5672
    config.vm.network :forwarded_port, guest: 8080, host: 8080 


    # P300orovisioning
    config.vm.synced_folder "salt/roots/", "/srv/"
    config.vm.provision :salt do |salt|
        salt.minion_config = "salt/minion"
        salt.run_highstate = true
        salt.verbose = true
    end
end
