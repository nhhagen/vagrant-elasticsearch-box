node_ppa:
  pkgrepo.managed:
    - ppa: chris-lea/node.js

nodejs:
  pkg.installed:
    - pkgrepo: node_ppa

node_modules:
  npm.installed:
    - names:
      - grunt-cli
      - supervisor
      - node-inspector
      - forever
      
