#!/bin/bash

# isolate nucleos de cpu
cset set -c 4-5,10-11 -s system
cset proc -m -f root -t system
cset proc -k -f root -t system --force

echo " "
echo " "
echo " "

# separa 8GB de huge memory pages
sudo sysctl -w vm.nr_hugepages=5120
echo "paginas totales asignadas"
cat /proc/meminfo | grep HugePages_Total

echo " "
echo " "
echo " "

# inicia la maquina virtual
echo "Iniciando maquina virtual"
sudo nice -n20 virsh start windowsvm
echo "Maquina virtual iniciada"

# cambia el governador a performance
echo "ajustando governador a performance"
echo 'GOVERNOR="performance"' | sudo tee /etc/default/cpufrequtils
sudo systemctl disable ondemand

