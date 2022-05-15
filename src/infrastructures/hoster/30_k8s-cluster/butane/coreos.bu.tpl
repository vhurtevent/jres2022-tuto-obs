variant: fcos
version: 1.4.0

storage:
  files:
    # by default, FCOS uses journald logging driver
    - path: /etc/sysconfig/docker
      overwrite: true
      contents:
        inline: |
          # Modify these options if you want to change the way the docker daemon runs
          OPTIONS="--selinux-enabled \
            --live-restore \
            --default-ulimit nofile=65536:65536 \
            --init-path /usr/libexec/docker/docker-init \
            --userland-proxy-path /usr/libexec/docker/docker-proxy \
          "

    - path: /etc/docker/daemon.json
      contents:
        inline: |
          {
            "log-driver": "json-file",
            "log-opts": {
              "max-size": "10m",
              "max-file": "3"
            }
          }

passwd:
  users:
    - name: core
      groups:
        - docker
      ssh_authorized_keys:
        - ${ssh_pub_key}