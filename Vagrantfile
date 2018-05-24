# -*- mode: ruby -*-
# vi: set ft=ruby :

# Jedes Item dieses Arrays definiert eine Virtuelle Machine, die mit Ansible
# verwaltet werden kann. Die Schlüssel name und box müssen in jedem Item
# vorhanden sein. Der Rest der Schlüssel ist optional.
guests = [
    { name: 'centos', box: 'centos/7' },
#   { name: 'ubuntu', box: 'bento/ubuntu-18.04' },
#   { name: 'debian', box: 'debian/testing64' },
#   { name: 'example1', box: 'centos/6', groups: ['web', 'mon'], ip: '192.168.23.10', hostvars: { test: 42 } },
#   { name: 'example2', box: 'centos/7', groups: ['db', 'mon'], cpus: 2, mem: 1024 },
]

ansible_cfg       = 'vagrant/ansible.cfg'
ansible_playbook  = 'vagrant/test.yml'
vbox_default_cpus = 1
vbox_default_mem  = 512
vagrant_ip_prefix = '192.168.23'
vagrant_ip_mask   = '255.255.255.0'

# Hier können zusätzliche Ansible Gruppen für das von Vagrant erstellte Inventar
# angegeben werden. Die Gruppenzugehörigkeit von Clients sollte nicht hier
# sondern in der in der groups Liste in der Definition der VM festgelegt werden.
# So kann Vagrant die Namen mit denen die VMs erstellt werden selbst verwalten.
# Auch sollten, obwohl ich ihre Verwendung im Beispiel demonstriere,
# Gruppenvariablen besser in ein group_vars Verzeichnis ausgelagert werden.
# Siehe hierzu auch die Ansible Dokumentation:
# http://docs.ansible.com/ansible/latest/intro_inventory.html#splitting-out-host-and-group-specific-data
# Wenn man trotzdem Gruppenvariablen hier definiert, ist zu beachten, dass
# Booleans nur korrekt erkannt werden, wenn sie genau als 'True' und 'False'
# geschrieben sind.
ansible_groups = {
#   'web:children': ['db'],
#   'db:vars': { secure_setup: 'True' },
#   'mon:vars': { monitoring_server: 'mon.example.com', monitorin_port: '1234' },
}

# Dieser Vagrantfile kann Ansible entweder vom Host aus ausführen, oder eine
# zuätzliche VM hochfahren, die als Ansible Controller fungiert. Dieses
# Verhalten kann über die Variable ansible_mode angepasst werden. Als Werte
# akzeptiert werden:
# host  => Verwende Ansible auf dem Host mit dem 'ansible' Provisioner
# guest => Fahre noch eine VM hoch und verwende 'ansible_local' als Provisioner
# auto  => Verwende den 'ansible' Provisioner, wenn Abnsible auf dem Host
#          installiert ist, ansonsten verwende 'ansible_local' mit zusätzlicher
#          VM
ansible_mode = 'auto'

################################################
# Ab hier sollte der Vagrantfile im Normalfall #
# nicht mehr angepasst werden müssen!          #
################################################

# Bestimme den Namen des Moduls das zu testen ist aus dem Basename des 
# Directories in dem sich der Vagrantfile befindet
project_name = File.basename( File.absolute_path('.') )
ansible_groups.default = []
vagrant_ip_pool = [ "#{vagrant_ip_prefix}.0" ]
ansible_hostvars = Hash.new()

VAGRANTFILE_API_VERSION = "2"

guests.each do |guest|
    if guest.has_key?(:ip)
        vagrant_ip_pool << guest[:ip]
    end
end

# Funktion um bestimmen zu können ob Ansible installiert ist
def which(cmd)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each { |ext|
            exe = File.join(path, "#{cmd}#{ext}")
            return exe if File.executable?(exe) && !File.directory?(exe)
        }
    end
    return nil
end

if ansible_mode == 'auto'
    ansible_mode = which('ansible-playbook') ? 'host' : 'guest'
end

unless ['host','guest'].include? ansible_mode
    raise 'Could not determine how to execute Ansible. Maybe ansible_mode has a wrong value?'
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    # Konfiguration aller Maschinen die in guests definiert sind
    guests.each_with_index do |guest, index|

        vagrant_name = "#{project_name}-#{guest[:name]}"

        config.vm.define vagrant_name do |machine|
            machine.vm.hostname = vagrant_name
            machine.vm.box = guest[:box]

            # Jede Maschine bekommt eine IP im privaten Default Netzwerk von
            # Virtualbox, die sowohl von anderen VMs als auch vom Host aus
            # erreichbar ist. Für komplexere Tests sollte hier wahrscheinlich
            # trotzdem ein anderer Weg gewählt werden
            if guest.has_key?(:ip)
                vagrant_ip = guest[:ip]
            else
                test_ip = 2
                loop do
                    vagrant_ip = "#{vagrant_ip_prefix}.#{test_ip}"
                    break unless vagrant_ip_pool.include? vagrant_ip
                    test_ip += 1
                end
                vagrant_ip_pool << vagrant_ip
            end
            machine.vm.network 'private_network',
                ip: vagrant_ip,
                netmask: vagrant_ip_mask,
                virtualbox__intnet: "vagrant-#{project_name}-network"

            ansible_hostvars[vagrant_name.to_sym] = {}
            if guest.has_key?(:hostvars)
                ansible_hostvars[vagrant_name.to_sym].update(guest[:hostvars])
            end

            if ansible_mode == 'guest'
                connector = {
                    ansible_ssh_host: vagrant_ip,
                    ansible_ssh_private_key_file: "/machines/#{vagrant_name}/virtualbox/private_key",
                }
                ansible_hostvars[vagrant_name.to_sym].update(connector)
            end

            # Allgemeine Einstellungen die jede Maschine in Virtualbox bekommt.
            # Dieser Bereich kann an die Fähigkeiten des Hosts angepasst werden.
            machine.vm.provider 'virtualbox' do |vbox|
                vbox.name = "vagrant_#{project_name}_#{guest[:name]}"
                vbox.cpus = guest.has_key?(:cpus) ? guest[:cpus] : vbox_default_cpus
                vbox.memory = guest.has_key?(:mem) ? guest[:mem] : vbox_default_mem
            end

            if guest.has_key?(:groups)
                guest[:groups].each do |group|
                    ansible_groups[group.to_sym] += [ vagrant_name ]
                end
            end

            # Provisioniere, wenn die letzte Maschine hochgefahren wurde, alle
            # Maschinen mit Ansible. Würde dieser Block außerhalb einer einzigen
            # Maschinendefinition stehen, würde Ansible beim Hochfahren jeder
            # Maschine versuchen alle Maschinen zu konfigurieren
            if ansible_mode == 'host' and index == guests.size - 1
                machine.vm.provision 'ansible', run: 'always' do |ansible|
                    ansible.playbook = ansible_playbook
                    ansible.config_file = ansible_cfg
                    ansible.limit = 'all'
                    ansible.become = false
                    ansible.groups = ansible_groups
                    ansible.host_vars = ansible_hostvars
                    ansible.extra_vars = {
                        project_name: project_name,
                    }
                end
            end
        end
    end

    if ansible_mode == 'guest'
        config.vm.define "#{project_name}-provisioner" do |master|
            master.vm.hostname = "#{project_name}-provisioner"
            master.vm.box = "centos/7"
            vagrant_ip = ''
            test_ip = 2
            loop do
                vagrant_ip = "#{vagrant_ip_prefix}.#{test_ip}"
                break unless vagrant_ip_pool.include? vagrant_ip
                test_ip += 1
            end
            master.vm.network 'private_network',
                ip: vagrant_ip,
                netmask: vagrant_ip_mask,
                virtualbox__intnet: "vagrant-#{project_name}-network"
            master.vm.provider 'virtualbox' do |vbox|
                vbox.name = "vagrant_#{project_name}_provisioner"
                vbox.cpus = 1
                vbox.memory = 256
            end

            guests.each do |guest|
                ansible_groups[:slaves] += [ "#{project_name}-#{guest[:name]}" ]
            end

            config.vm.synced_folder '.', '/vagrant', disabled: true
            master.vm.synced_folder ".", "/#{project_name}", type: "rsync"
            master.vm.synced_folder "./.vagrant/machines", "/machines", type: "rsync"
            master.vm.provision 'ansible_local', run: 'always' do |ansible|
                ansible.provisioning_path = "/#{project_name}"
                ansible.playbook = ansible_playbook
                ansible.config_file = ansible_cfg
                ansible.limit = 'slaves'
                ansible.become = false
                ansible.groups = ansible_groups
                ansible.host_vars = ansible_hostvars
                ansible.extra_vars = {
                    project_name: project_name,
                }
            end
        end
    end
end

