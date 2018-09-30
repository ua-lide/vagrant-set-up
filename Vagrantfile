# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
current_dir = File.dirname(File.expand_path(__FILE__))
hosts = YAML.load_file("#{current_dir}/configuration/server-config.yml")
API_VERSION = "2"

def custom_synced_folders(vm, host)
  if host.has_key?('synced_folders')
    folders = host['synced_folders']
    folders.each do |folder|
      vm.synced_folder folder['src'], folder['dest'], folder['options']
      if folder.has_key?('type')
        if folder['type'] == "symfony"
          symfony_setup = "provision/symfony/symfony_setup.sh"
          vm.provision :shell, path: "#{symfony_setup}", args: folder['dest']
        end
      end
    end
  end
end

def provisionning(vm, host)
  if host.has_key?('provision')
    provision = host['provision']
    provision.each do |provision_path|
      vm.provision :shell, path: provision_path
    end
  end
end

def conf_apache(vm, host)
  if host.has_key?('apache')
    apache_conf_dir_host = "files/apache.conf.d"
    apache_conf_dir_guest = "/home/vagrant"
    apache_setup = "provision/apache/apache2_setup.sh"
    conf = host['apache']
    vm.provision "file", source: "#{apache_conf_dir_host}/#{conf}", destination: "#{apache_conf_dir_guest}/#{conf}"
    vm.provision :shell, path: "#{apache_setup}", args: "#{conf}"
  end
end

Vagrant.configure(API_VERSION) do |config|
  hosts.each do |host|
    config.vm.define host['hostname'] do |node|
      node.vm.box = host['box']
      node.vm.hostname = host['hostname']
      node.vm.network "private_network", ip: host['ip']
      provisionning(node.vm,host)
      custom_synced_folders(node.vm,host)
      conf_apache(node.vm,host)
    end
  end
end
