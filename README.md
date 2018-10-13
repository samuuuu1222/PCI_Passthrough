# PCI_Passthrough

¡Hola a todos! En el siguiente texto les compartir algunas cosas acerca de mi computador, tips y recomendaciones para lograr tener una maquina virtual con PCI Passthrough, como optimizarlo y como usarlo de una manera cómoda. Supongo que si estas leyendo esto ya has de estar interesado en esta tecnología entonces no voy a perder tiempo explicando los múltiples beneficios de usar esta tecnología. 

## Mi "setup"

### Hardware
---

|Componente|Referencia|Link a la pagina del fabricante|
|----------|----------|----|
|CPU|Intel core i7 5820k|[Link](https://ark.intel.com/es/products/82932/Intel-Core-i7-5820K-Processor-15M-Cache-up-to-3-60-GHz-)|
|CPU Cooler|Cooler master hyper 212 evo|[Link](http://www.coolermaster.com/cooling/cpu-air-cooler/hyper-212-evo/)|
|Placa madre|Msi x99s sli plus|[Link](https://www.msi.com/Motherboard/x99s-sli-plus.html)|
|RAM|Corsair vengance Lpx DDR4 2400mhz (16gb, 2x8)|[Link](https://www.corsair.com/uk/en/Memory-Size/Tested-Speed/vengeance-lpx-black/p/CMK16GX4M2A2400C14)|
|Fuente de poder| Evga 850 G+|[Link](https://www.evga.com/products/product.aspx?pn=120-GP-0850-X1)|
|SSD|PNY CS1311 240gb|[Link](https://www.pny.com/SSD-CS1311)|
|HDD|Toshiba 2tb| |
|GPU 1 (Host)|Nvidia quadro fx 1800|[Link](https://www.nvidia.es/object/product_quadro_fx_1800_es.html)|
|GPU 2 (Gest)|AMD R9 390 8G|[Link](http://www.sapphiretech.com/productdetial.asp?pid=FF539E23-7718-4BDE-9E02-CF174D2BFCC2&lang=esp)|
|Monitor|Samsung LS27F350FHLXZL|[Link](https://www.samsung.com/co/monitors/led-sf350/LS27F350FHLXZL/)|
|Mouse|Logitec g502 Proteus Spectrum|[Link](https://www.logitechg.com/es-roam/product/g502-proteus-spectrum-rgb-gaming-mouse)|
|Teclado|Teclado DIY con Firmware QMK y microcontrolador Teensy||
|Tarjeta de sonido|Tarjeta de sonido genérica USB||

### Sofware
---

|S.O (Host)|Kubuntu 18.04.1|
|:---------|---------------|
|S.O (Gest)|Windows 10|
|Uso compartido de mouse y teclado|Synergy
|Gestor de maquinas virtuales|Virt-manager|


### ¿Cómo utilizo mi setup?
---

Mi sistema operativo principal es Kubuntu (Linux) lo uso para navegar en Internet, programar, estudiar etc, básicamente para todo lo que no utilice la GPU. Para todo\* lo que si utiliza la GPU uso Windows, es decir: Juegos y edición de foto y vídeo. Por lo tanto solo enciendo la maquina virtual cuando la necesito.

Ambas tarjetas gráficas están conectadas al mismo monitor la GPU 1 (Linux) está conectada mediante VGA y la GPU 2 (Windows) está conectada mediante HDMI cuando deseo utilizar windows simplemente cambio la entrada del monitor a HDMI, posteriormente con un comando de Synergy activo el teclado y el mouse en uno u otro sistema.

El micrófono y los audífonos están conectados a la tarjeta de sonido USB y ésta se ha pasado a la maquina virtual, esto me permite tener audio de relativamente buena calidad en Windows y aparte usar el chat de voz, pero tambien significa que mientras esté usando la maquina virtual no tengo audio en linux a menos que conecte otro dispositvo de audio.

## ¿Cómo funciona?
(por escribir)

## Pseudo Tutorial

### Consideraciones iniciales
---
Y digo **pseudo tutorial** porque no pretendo dar una lección exhaustiva que funcione en la mayoría de sistemas, sea pulcra y contenga la mejores practicas. Solo quiero explicar que método usé, como solucione los problemas que encontré en el camino y que configuraciones me funcionaron. Ademas vamos a tener que editar varios archivos de texto, en mi caso voy a usar el editor Vim, si desea usar otro editor solo debe cambiar la palabra vim de los comandos por el editor de texto que usted prefiera. Teniendo ésto en cuenta empecemos.


1. **El CPU y las extenciones de virtualizacion:** Es vital que nuestro CPU soporte las extensiones de virtualización sean de Intel o AMD. estas extenciones en mi caso VT-x. Ademas de que nuestro procesador soporte las susodichas extenciones debemos tenerlas activadas en la BIOS.

2. **Suficiente memoria RAM:** Es evidente que la cantidad de RAM necesaria para un equipo cambia dependiendo de que uso le demos, para éste caso (Juegos y edicion ligera de foto y vídeo ) no recomiendo menos de 12GB de RAM.

3. **Más de una GPU:** Vamos a pasar una GPU completa a la maquina virtual, por lo que vamos a necesitar otra GPU para linux. En mi caso el CPU que uso no tiene GPU integrada, por lo que es absolutamente necesario que tenga una dos GPU's discretas, en caso de que el CPU tenga GPU integrada solo hace falta una GPU discreta.

4. **Una GPU con soporte UEFI:** También es posible hacer el passthrough si la gráfica no soporta UEFI pero es necesario otro proceso. Aunque el punto que realmente quiero recalcar son las GPU's con múltiples BIOS. Mi GPU por ejemplo tiene dos BIOS y un interruptor para cambiarlas, por lo que es importante seleccionar la BIOS compatible con UEFI o el passthrough no será posible con éste método  

5. **La grafica de Linux en el primer slot!!** Las placas madre tienen varios slots donde conectar las GPU's, en mi caso fue imposible hacer el passthrough si la GPU que usa Linux estaba en un slot diferente al primero.

### Ahora si, manos a la obra
---

#### Grub

Primero vamos a activar iommu y para ésto debemos editar el archivo de configuración de Grub de la siguiente manera:

En la terminal escribimos:
```
sudo nvim /etc/default/grub
```
Introducimos nuestra contraseña y nos encontraremos con un archivo que debemos editar de la siguiente forma:
Buscamos en el archivo la linea que empieza de ésta forma:

```
GRUB_CMDLINE_LINUX_DEFAULT=
```

Después del igual es posible que existan algunas palabras encerradas por commillas, en mi caso la linea completa es:

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"

```

Al final de la ultima palabra dejamos un espacio y agregamos las siguientes instrucciones: **iommu=pt iommu=1 intel_iommu=on**

La linea en mi caso la linea queda así:

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash iommu=pt iommu=1 intel_iommu=on"

```
Guardamos el archivo y salimos del editor.

Ejecutamos en la terminal:

```
sudo update-grub
```
Luego reiniciamos el equipo.

#### Grupos IOMMU

Vamos a verificar que el paso anterior funcionó correctamente y ademas que nuestros grupos IOMMU sean favorables para hacer el passthrough, para ésto vamos a usar el siguiente script tomado [Levelonetechs](https://forum.level1techs.com/t/ubuntu-17-04-vfio-pcie-passthrough-kernel-update-4-14-rc1/11963k)

```
#!/bin/bash
for d in /sys/kernel/iommu_groups/*/devices/*; do
  n=${d#*/iommu_groups/*}; n=${n%%/*}
  printf 'IOMMU Group %s ' "$n"
  lspci -nns "${d##*/}"
done

```
Para usarlo debemos escribir en la terminal los siguiente comandos

```
cd ~
nvim iommu-script.sh
```
Luego debemos copiar el script y pegarlo en nuestro editor de texto (normalmente en una terminal se puede pegar usando Ctrl+shift+v), guardamos el documento y salimos del editor, luego escribimos los siguientes comandos:

```
chmod +x iommu-script.sh
./iommu-script.sh
```
Ésto nos mostrará un resultado similar a éste (este es una fraccion del resultado de correr el script en mi maquina):

```
IOMMU Group 28 00:1f.3 SMBus [0c05]: Intel Corporation C610/X99 series chipset SMBus Controller [8086:8d22] (rev 05)                                        
IOMMU Group 29 03:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Hawaii PRO [Radeon R9 290/390] [1002:67b1] (rev 80)         
IOMMU Group 29 03:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Hawaii HDMI Audio [Radeon R9 290/290X / 390/390X] [1002:aac8]            
IOMMU Group 2 ff:0f.0 System peripheral [0880]: Intel Corporation Xeon E7 v3/Xeon E5 v3/Core i7 Buffered Ring Agent [8086:2ff8] (rev 02)                    
IOMMU Group 2 ff:0f.1 System peripheral [0880]: Intel Corporation Xeon E7 v3/Xeon E5 v3/Core i7 Buffered Ring Agent [8086:2ff9] (rev 02)                    
IOMMU Group 2 ff:0f.4 System peripheral [0880]: Intel Corporation Xeon E7 v3/Xeon E5 v3/Core i7 System Address Decoder & Broadcast Registers [8086:2ffc] (rev 02)
IOMMU Group 2 ff:0f.5 System peripheral [0880]: Intel Corporation Xeon E7 v3/Xeon E5 v3/Core i7 System Address Decoder & Broadcast Registers [8086:2ffd] (rev 02)
IOMMU Group 2 ff:0f.6 System peripheral [0880]: Intel Corporation Xeon E7 v3/Xeon E5 v3/Core i7 System Address Decoder & Broadcast Registers [8086:2ffe] (rev 02)
IOMMU Group 30 04:00.0 VGA compatible controller [0300]: NVIDIA Corporation G94GL [Quadro FX 1800] [10de:0638] (rev a1)                                   
IOMMU Group 31 06:00.0 USB controller [0c03]: VIA Technologies, Inc. VL805 USB 3.0 Host Controller [1106:3483] (rev 01)                                     
IOMMU Group 32 07:00.0 USB controller [0c03]: ASMedia Technology Inc. ASM1142 USB 3.1 Host Controller [1b21:1242]                                           
```

El anterior es una lista con los dispotivos pci que tenemos en nuestra maquina, de éste resultado nos interesan por ahora lo que tenga que ver con nuestras GPU's, en mi caso son las siguientes lineas:

```

IOMMU Group 29 03:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Hawaii PRO [Radeon R9 290/390] [1002:67b1] (rev 80)         
IOMMU Group 29 03:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Hawaii HDMI Audio [Radeon R9 290/290X / 390/390X] [1002:aac8]            
IOMMU Group 30 04:00.0 VGA compatible controller [0300]: NVIDIA Corporation G94GL [Quadro FX 1800] [10de:0638] (rev a1)                                   
```

Es importante notar que si bien tengo unicamente dos GPU's en mi equipo he listado tres lineas del script anterior, y esto se debe a que algunas GPU's tienen ademas un controlador de audio, esto será importante más adelante.

De éstas lineas nos dos varias cosas:

1. **IOMMU Group:** El numero que se encuentra luego de estas palabras es el grupo al que pertenece nuestras GPU's, en mi caso la GPU AMD se encuentra el en grupo 29 y la Nvidia en el grupo 30. Es vital que la GPU que querramos pasar a la maquina virtual sea el único elemento en ese grupo (en caso de que la GPU tenga controlador de audio integrado éste también debe estar el en mismo grupo que la GPU) si éste no es el caso se debe aplicar un parche al kernel (ACS) lo cual no voy a cubrir en éste documento.

2. **Los numeros en corchetes al final de la linea:** Estos son conocidos como **Identificador de dispositivos PCI** o **PCI device IDs** en ingles, en el caso de mi GPU r9 390 **1002:67b1** y el controlador de audio **1002:aac8**. Es importante que anotemos estos numeros, tanto el de la GPU como el del controlador de audio (si es el caso) de la GPU que a la cual vamos a hacerle el passthrough.


### Dispositivos PCI




El teclado y la tarjeta de sonido están conectadas a los puertos USB 3.1 de la placa madre esto es importante porque el controlador de USB 3.1 tambien se ha pasado a la maquina virtual a diferencia del mouse que simplemente se añadio como un dispositivo , esto resolvio varios problema de inestabilidad con los dipositivos USB,

## Referencias y agradecimientos

* Agradecimientos especiales a Wendell de [Levelonetechs](https://level1techs.com/) y su [foro](https://forum.level1techs.com/c/software/linux) enfocado el linux

* Subreddit sobre passthrough [r/VFIO](https://www.reddit.com/r/VFIO/)


