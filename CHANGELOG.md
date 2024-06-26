## [1.2.2](https://github.com/gliech/ansible-role-skeleton/compare/v1.2.1...v1.2.2) (2024-03-31)


### Bug Fixes

* **files:** unintentional single quotes in readme title from untemplating tripple brackets ([8397b9a](https://github.com/gliech/ansible-role-skeleton/commit/8397b9a2acd7733588392205fcf8d93140e8a4e0))
* **vars:** prefix variables from defaults and vars uniformly ([d49aeef](https://github.com/gliech/ansible-role-skeleton/commit/d49aeefc1f587fbc4ab2cfe6505c796429e0dbc4))


### Styles

* yml line length ([8453ecb](https://github.com/gliech/ansible-role-skeleton/commit/8453ecbbdc71aa258b9772427d05679cf98ef1f6))

## [1.2.1](https://github.com/gliech/ansible-role-skeleton/compare/v1.2.0...v1.2.1) (2024-03-16)


### Dependency Updates

* update ansible-lint version ([76a145e](https://github.com/gliech/ansible-role-skeleton/commit/76a145e511234ce2e036d96745d51f05f28575a7))

# [1.2.0](https://github.com/gliech/ansible-role-skeleton/compare/v1.1.0...v1.2.0) (2024-03-16)


### Features

* template molecule.yml to customize container names ([82dc3ff](https://github.com/gliech/ansible-role-skeleton/commit/82dc3ff88fb474de5f7ae9a1f4bd1ff0e005d019))


### Bug Fixes

* mirror some minor alterations to the role into the role template ([025525e](https://github.com/gliech/ansible-role-skeleton/commit/025525e36bf1c3c4349f2a8d7e3aad4db44608ab))
* **molecule:** clean up some errors in the prepare and cleanup playbooks ([a5006b2](https://github.com/gliech/ansible-role-skeleton/commit/a5006b2813084f93593fd5d8704675e71de900a2))


### Documentation

* fix typo in readme ([7f2d789](https://github.com/gliech/ansible-role-skeleton/commit/7f2d789995cd6b5a3c9b20c91130cca91a88f6d1))


### Dependency Updates

* update package version for the test environment ([d9fa6c0](https://github.com/gliech/ansible-role-skeleton/commit/d9fa6c0f525da8cb6e614bd7ee26df70f948ae2f))

# [1.1.0](https://github.com/gliech/ansible-role-skeleton/compare/v1.0.0...v1.1.0) (2023-12-23)


### Features

* generate a README.md file in the role skeleton ([2fb7a55](https://github.com/gliech/ansible-role-skeleton/commit/2fb7a55b6304a0a79810889d35c092be465ec4b9))


### Bug Fixes

* **docs:** html table formatting ([fc135b3](https://github.com/gliech/ansible-role-skeleton/commit/fc135b314e13ddb4dce4069d8779044ce3c72914))
* remove suffix from files when templating ([9d55962](https://github.com/gliech/ansible-role-skeleton/commit/9d55962a8f4854150d11d4c7cf379b6eabc87372))


### Documentation

* **fix:** link to semrel sharable config ([f41dff0](https://github.com/gliech/ansible-role-skeleton/commit/f41dff013e36a015df2a5efb72c06000b1b03bb1))
* **readme:** link to ansible galaxy ([766e281](https://github.com/gliech/ansible-role-skeleton/commit/766e28198d1fdd76c2ea4e1aed65e58b62e936e5))

# 1.0.0 (2023-12-22)


### Features

* install skeleton from subdir instead of git branch ([d2a7221](https://github.com/gliech/ansible-role-skeleton/commit/d2a72210e4b359d8bd20a86baededa9b6042471b))
* skeleton now uses molecule instead of vagrant ([0205db9](https://github.com/gliech/ansible-role-skeleton/commit/0205db9eb34faff5a113a2a7e1c31213cb36b536))
* template author name ([0ea4ae8](https://github.com/gliech/ansible-role-skeleton/commit/0ea4ae88b6e492b4d0d78e5f9dd76a98b9d2348e))


### Bug Fixes

* prefix role variable correctly ([f1e0c6e](https://github.com/gliech/ansible-role-skeleton/commit/f1e0c6ea6b8773d38cda6093d85b89f087c23f87))
* simplify copy logic ([0271582](https://github.com/gliech/ansible-role-skeleton/commit/0271582ddbecfb892ea784db2541f6c22b51c48b))
