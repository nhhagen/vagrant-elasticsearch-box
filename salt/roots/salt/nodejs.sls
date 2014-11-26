node-ppa:
  pkgrepo.managed:
    - ppa: chris-lea/node.js
    - require_in:
      - pkg: nodejs

nodejs:
  pkg.installed:
    - pkgrepo: node-ppa

node-modules:
  npm.installed:
    - names:
      - grunt-cli
      - supervisor
      - node-inspector
      - forever

