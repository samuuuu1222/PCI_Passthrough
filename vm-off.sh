#!/bin/bash

# libera los nucleos
cset set -d system

# resetea a 0 las hugepages
sudo sysctl -w vm.nr_hugepages=0
