# Ansible Galaxy Role Skeleton

[![main](https://github.com/gliech/ansible-role-skeleton/actions/workflows/main.yml/badge.svg)](https://github.com/gliech/ansible-role-skeleton/actions/workflows/main.yml)

This Ansible role creates my custom Ansible Galaxy role skeleton on the target
host. In addition to the normal components of an Ansible role, my role skeleton
contains a basic setup for testing with Ansible Molecule, yamllint and
ansible-lint, as well as a github actions pipeline that utilizes my own
(semantic-release sharable configuration)[1] to to create new versions of the
role and publish it to Ansible Galaxy.


## Requirements

Strictly speaking: None, but the created files will be of little use, if Ansible
is not installed on the target host.


## Role Variables

<table>
<tr><th>Name</th><th>Required</th><th>Type / Choices</th><th>Description</th></tr>
<tr><td><code>ansible_role_skeleton_author</code></td>
<td>no</td>
<td>string</td>
<td>

As the Ansible Galaxy command line utility allows you to only template the
`role_name` when initializing a new role, this role allows you to customize the
name of the author (and role namespace), which appears in various places in an
ansible role, when we put the skeleton on the host.

**Default:** `"change_me"`
</td></tr>
</table>


## Dependencies

None.


## Example Playbook

```yaml
- hosts: ansible_users
  tasks:
    - ansible.builtin.import_role:
        name: gliech.ansible_role_skeleton
      vars:
        ansible_role_skeleton_author: me
```


## License

This project is licensed under the terms of the [GNU General Public License v3.0](LICENSE)


[1]: https://github.com/gliech/semantic-release-config-github-ansible-role
