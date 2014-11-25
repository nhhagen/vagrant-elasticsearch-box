python:
  pkg.installed:
    - names:
      - python
      - python-dev
      - python-virtualenv

python-pip:
  pkg.installed:
    - names:
      - python-pip

python-elasticsearch:
  pip.installed:
    - name: elasticsearch
    - require:
      - pkg: python-pip

python-pika:
  pip.installed:
    - name: pika
    - require:
      - pkg: python-pip
