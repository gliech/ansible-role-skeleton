# -*- mode: ruby -*-
# vi: set ft=ruby :

# Jedes Item dieses Arrays definiert den Namen, das Box Image und die Ansible 
# Gruppen einer Virtuellen Machine die zum testen der Rolle gestartet werden
# soll. In dieser Liste können je nach Bedarf Zeilen hinzugefügt oder entfernt
# werden. Der Rest des Vagrantfiles sollte nur angepasst werden müssen wenn man
# ein komplexeres Testszenario braucht.
guests = [
    { name: 'centos', box: 'centos/7',           groups: [] },
#   { name: 'ubuntu', box: 'bento/ubuntu-18.04', groups: [] },
#   { name: 'debian', box: 'debian/testing64',   groups: [] },
#   { name: 'example1', box: 'centos/7', groups: ['web', 'mon'] },
#   { name: 'example2', box: 'centos/7', groups: ['db', 'mon'] },
]

# Hier können zusätzliche Ansible Gruppen für das von Vagrant erstellte Inventory
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
#          installiert ist, ansonsten verwende 'ansible_local'
ansible_mode = 'auto'

# Bestimme den Namen des Moduls das zu testen ist aus dem Basename des 
# Directories in dem sich der Vagrantfile befindet
project_name = File.basename( File.absolute_path('.') )
ansible_groups.default = []
ansible_hostvars = {}
ansible_hostvars.default = {}
VAGRANTFILE_API_VERSION = "2"

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

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    # Konfiguration aller Maschinen die in guests definiert sind
    guests.each_with_index do |guest, index|

        config.vm.define "#{project_name}-#{guest[:name]}" do |machine|
            machine.vm.hostname = "#{project_name}-#{guest[:name]}"
            machine.vm.box = guest[:box]
            # Jede Maschine bekommt eine IP im privaten Default Netzwerk von
            # Virtualbox, die sowohl von anderen VMs als auch vom Host aus
            # erreichbar ist. Für komplexere Tests sollte hier wahrscheinlich
            # trotzdem ein anderer Weg gewählt werden
            machine.vm.network 'private_network', type: 'dhcp'

            # Allgemeine Einstellungen die jede Maschine in Virtualbox bekommt.
            # Dieser Bereich kann an die Fähigkeiten des Hosts angepasst werden.
            machine.vm.provider 'virtualbox' do |vbox|
                vbox.name = "ansibe_#{project_name}_#{guest[:name]}"
                vbox.cpus = 2
                vbox.memory = 2048
            end

            guest[:groups].each do |group|
                ansible_groups[group] += ["#{project_name}-#{guest[:name]}"]
            end

            # Provisioniere, wenn die letzte Maschine hochgefahren wurde, alle
            # Maschinen mit Ansible. Würde dieser Block außerhalb einer einzigen
            # Maschinendefinition stehen, würde Ansible beim Hochfahren jeder
            # Maschine versuchen alle Maschinen zu konfigurieren
            if index == guests.size - 1
                machine.vm.provision 'ansible', run: 'always' do |ansible|
                    ansible.playbook = 'vagrant/test.yml'
                    ansible.config_file = 'vagrant/ansible.cfg'
                    #ansible.verbose = 'vvvv'
                    #ansible.host_key_checking = false
                    ansible.limit = 'all'
                    ansible.become = false
                    ansible.groups = ansible_groups
                    ansible.extra_vars = {
                        project_name: project_name,
                    }
                end
            end
        end
    end
end

