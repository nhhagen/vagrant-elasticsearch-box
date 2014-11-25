rabbitmq-server:
  pkg.installed:
    - name: rabbitmq-server
  service:
    - running
    - enable: True
    - watch:
      - pkg: rabbitmq-server
