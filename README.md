# PCI_Passthrough (trabajo en proceso)

Por *David Londoño Montoya*.

## Tabla de contenidos

* auto-gen TOC:
{:toc}

## Indroducción

¡Hola a todos! (Si bien no soy de ninguna manera un experto en el tema) en el siguiente texto les quiero compartir como tengo configurado mi computador, tips y recomendaciones para lograr tener una maquina virtual con PCI Passthrough, como optimizarlo y como usarlo de una manera cómoda en el día a día. 

Nuestro objetivo será crear una maquina virtual con **Windows 10** donde podamos usar algunas aplicaciones que no están disponibles para Linux o que por un motivo u otro queramos usar en Windows 

### Algunas notas antes de empezar
+ Si bien se que son dos cosas diferentes, por cuestiones de simplicidad voy a usar de manera indiferente el termino "Tarjeta gráfica" y "GPU"

+ Voy a usar algunas abreviaciones como CPU (Procesador), VM (Maquina virtual)

+ Voy a suponer que el lector tiene instalado un sistema operativo basado en Ubuntu 18.04 (Kubuntu en mi caso)

+ Ademas espero que el lector tenga experiencia instalando Windows (cosa que no voy a explicar en detalle)

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

### Software
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

El micrófono y los audífonos están conectados a la tarjeta de sonido USB y ésta se ha pasado a la maquina virtual, esto me permite tener audio de relativamente buena calidad en Windows y aparte usar el chat de voz, pero también significa que mientras esté usando la maquina virtual no tengo audio en Linux a menos que conecte otro dispositvo de audio.

## ¿Cómo funciona?
(por escribir)

## Pseudo Tutorial

### Consideraciones iniciales
---
Y digo **pseudo tutorial** porque no pretendo dar una lección exhaustiva que funcione en la mayoría de sistemas, sea pulcra y contenga la mejores practicas. Solo quiero explicar que método usé, como solucione los problemas que encontré en el camino y que configuraciones me funcionaron. Ademas vamos a tener que editar varios archivos de texto, en mi caso voy a usar el editor Vim, si desea usar otro editor solo debe cambiar la palabra vim de los comandos por el editor de texto que usted prefiera. Teniendo ésto en cuenta empecemos.


1. **El CPU y las extenciones de virtualizacion:** Es vital que nuestro CPU soporte las extensiones de virtualización sean de Intel o AMD. estas extensiones en mi caso VT-x. Ademas de que nuestro procesador soporte las susodichas extensiones debemos tenerlas activadas en la BIOS.

2. **Suficiente memoria RAM:** Es evidente que la cantidad de RAM necesaria para un equipo cambia dependiendo de que uso le demos, para éste caso (Juegos y edición ligera de foto y vídeo ) no recomiendo menos de 12GB de RAM.

3. **Suficiente espacio de almacenamiento:** Windows utilizará al menos 40gb de espacio en disco (pero si queremos instalar al menos uno o dos juegos puede usar 100 o más gb en disco, 110gb en mi caso) por lo que es importante tener suficiente espacio en nuestro disco duro o SSD preferiblemente.

4. **Un mouse y teclado extra es muy útil:** Cuando comencemos a instalar Windows nos será de gran utilidad tener un mouse y teclado adicional.  

5. **Más de una GPU:** Vamos a pasar una GPU completa a la maquina virtual, por lo que vamos a necesitar otra GPU para Linux. En mi caso el CPU que uso no tiene GPU integrada, por lo que es absolutamente necesario que tenga una dos GPU's discretas, en caso de que el CPU tenga GPU integrada solo hace falta una GPU discreta.

6. **Una GPU con soporte UEFI:** También es posible hacer el passthrough si la gráfica no soporta UEFI pero es necesario otro proceso. Aunque el punto que realmente quiero recalcar son las GPU's con múltiples BIOS. Mi GPU por ejemplo tiene dos BIOS y un interruptor para cambiarlas, por lo que es importante seleccionar la BIOS compatible con UEFI o el passthrough no será posible con éste método  

7. **La grafica de Linux en el primer slot!!** Las placas madre tienen varios slots donde conectar las GPU's, en mi caso fue imposible hacer el passthrough si la GPU que usa Linux estaba en un slot diferente al primero.

8. **El tema del sonido...** El sonido es algo complicado, hay varias formas de de obtener sonido desde la maquina virtual, pero en mi experiencia la mejor solución es comprar una tarjeta de audio USB (puede ser una extremadamente barata) y pasarla a la maquina virtual, es una solución solida y barata. También existe la opción de pasar la tarjeta de sonido de la placa madre, pero ésto no le he probado, por lo que no puedo hacer comentarios al respecto.

### Ahora si, manos a la obra
---

#### Grub

Primero vamos a activar IOMMU y para ésto debemos editar el archivo de configuración de Grub de la siguiente manera:

En la terminal escribimos:
```
sudo nvim /etc/default/grub
```
Introducimos nuestra contraseña y nos encontraremos con un archivo que debemos editar de la siguiente forma:
Buscamos en el archivo la linea que empieza de ésta forma:

```
GRUB_CMDLINE_LINUX_DEFAULT=
```

Después del igual es posible que existan algunas palabras encerradas por comillas, en mi caso la linea completa es:

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

Vamos a verificar que el paso anterior funcionó correctamente y ademas que nuestros grupos IOMMU sean favorables para hacer el passthrough, para ésto vamos a usar el siguiente script tomado [Levelonetechs](https://forum.level1techs.com/t/ubuntu-17-04-vfio-pcie-passthrough-kernel-update-4-14-rc1/119639)

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
Ésto nos mostrará un resultado similar a éste (este es una fracción del resultado de correr el script en mi maquina):

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

El anterior es una lista con los dispositivos pci que tenemos en nuestra maquina, de éste resultado nos interesan por ahora lo que tenga que ver con nuestras GPU's, en mi caso son las siguientes lineas:

```

IOMMU Group 29 03:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Hawaii PRO [Radeon R9 290/390] [1002:67b1] (rev 80)         
IOMMU Group 29 03:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Hawaii HDMI Audio [Radeon R9 290/290X / 390/390X] [1002:aac8]            
IOMMU Group 30 04:00.0 VGA compatible controller [0300]: NVIDIA Corporation G94GL [Quadro FX 1800] [10de:0638] (rev a1)                                   
```

Es importante notar que si bien tengo únicamente dos GPU's en mi equipo he listado tres lineas del script anterior, y esto se debe a que algunas GPU's tienen ademas un controlador de audio, esto será importante más adelante.

De éstas lineas nos dos varias cosas:

1. **IOMMU Group:** El numero que se encuentra luego de estas palabras es el grupo al que pertenece nuestras GPU's, en mi caso la GPU AMD se encuentra el en grupo 29 y la Nvidia en el grupo 30. Es vital que la GPU que queramos pasar a la maquina virtual sea el único elemento en ese grupo (en caso de que la GPU tenga controlador de audio integrado éste también debe estar el en mismo grupo que la GPU) si éste no es el caso se debe aplicar un parche al kernel (ACS) lo cual no voy a cubrir en éste documento.

2. **Los numeros en corchetes al final de la linea:** Estos son conocidos como **Identificador de dispositivos PCI** o **PCI device IDs** en ingles, en el caso de mi GPU r9 390 **1002:67b1** y el controlador de audio **1002:aac8**. Es importante que anotemos estos números, tanto el de la GPU como el del controlador de audio (si es el caso) de la GPU que a la cual vamos a hacerle el passthrough.


### El driver de la GPU

Como preparación para hacer el passthrough solo nos queda conocer el driver de nuestra tarjeta, para esto usamos el siguiente comando:

```
lspci -k
```

Este comando nos dará por resultado algo similar a ésto:

```
00:1f.2 SATA controller: Intel Corporation C610/X99 series chipset 6-Port SATA Controller [AHCI mode] (rev 05)                                              
        Subsystem: Micro-Star International Co., Ltd. [MSI] C610/X99 series chipset 6-Port SATA Controller [AHCI mode]                                      
        Kernel driver in use: ahci                                                                                                                          
        Kernel modules: ahci                                                                                                                                
00:1f.3 SMBus: Intel Corporation C610/X99 series chipset SMBus Controller (rev 05)                                                                          
        Subsystem: Micro-Star International Co., Ltd. [MSI] C610/X99 series chipset SMBus Controller                                                        
        Kernel modules: i2c_i801                                                                                                                            
03:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Hawaii PRO [Radeon R9 290/390] (rev 80)                                           
        Subsystem: PC Partner Limited / Sapphire Technology Sapphire Nitro R9 390                                                                           
        Kernel driver in use: radeon                                                                                                                      
        Kernel modules: radeon, amdgpu                                                                                                                      
03:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Hawaii HDMI Audio [Radeon R9 290/290X / 390/390X]                                              
        Subsystem: PC Partner Limited / Sapphire Technology Hawaii HDMI Audio [Radeon R9 290/290X / 390/390X]                                               
        Kernel driver in use: snd_hda_intel                                                                                                                      
        Kernel modules: snd_hda_intel                                                                                                                       
04:00.0 VGA compatible controller: NVIDIA Corporation G94GL [Quadro FX 1800] (rev a1)                                                                       
        Subsystem: NVIDIA Corporation G94GL [Quadro FX 1800]
        Kernel driver in use: nvidia
        Kernel modules: nvidiafb, nouveau, nvidia
06:00.0 USB controller: VIA Technologies, Inc. VL805 USB 3.0 Host Controller (rev 01)
        Subsystem: Micro-Star International Co., Ltd. [MSI] VL805 USB 3.0 Host Controller
        Kernel driver in use: xhci_hcd
07:00.0 USB controller: ASMedia Technology Inc. ASM1142 USB 3.1 Host Controller
        Subsystem: Micro-Star International Co., Ltd. [MSI] ASM1142 USB 3.1 Host Controller
        Kernel driver in use: xhci_hcd

```

Buscamos la GPU que queramos pasar a la maquina virtual y nos fijamos que driver está usando:

```
03:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Hawaii PRO [Radeon R9 290/390] (rev 80)                                           
        Subsystem: PC Partner Limited / Sapphire Technology Sapphire Nitro R9 390                                                                           
        Kernel driver in use: radeon                                                                                                                      
        Kernel modules: radeon, amdgpu                                                                                                                      
```
Notemos la linea:

**kernel driver in use: radeon**

Ésto nos dice que el driver en uso es **radeon** ésto será importante en un momento.

### El passthrough per se

En resumen; de los pasos anteriores tenemos los siguientes datos:

1. los **PCI device IDs** de la GPU y de su controlador de audio: **1002:67b1** y **1002:aac8** respectivamente.

2. El driver de la GPU: **radeon** en mi caso.

Ahora vamos a prevenir que Linux tome control de la GPU y dar oportunidad al driver vfio-pci de que tome control de la GPU. Para ésto vamos a editar algunos archivos.

Escribimos el siguiente comando:
```
sudo nvim /etc/initramfs-tools/modules
```
Y añadimos al final del archivo las siguientes lineas:
```
softdep radeon pre: vfio vfio_pci

vfio
vfio_iommu_type1
vfio_virqfd
options vfio_pci ids=1002:67b1,1002:aac8
vfio_pci ids=1002:67b1,1002:aac8
vfio_pci
radeon
```
Teniendo cuidado de reemplazar **radeon** por el driver de la GPU, y **1002:67b1,1002:aac8** por los **PCI device IDs**.

Escribimos el siguiente comando:
```
sudo nvim /etc/modules
```
Y añadimos al final del archivo las siguientes lineas

```
vfio
vfio_iommu_type1
vfio_pci ids=1002:67b1,1002:aac8
```
Nuevamente reemplazamos **1002:67b1,1002:aac8** por los **PCI device IDs**.

Escribimos el siguiente comando:
```
sudo nvim /etc/modprobe.d/amdgpu.conf
```
(Si tenemos una GPU Nvidia cambiamos **amdgpu.config** por **nvidiagpu.config**)

Añadimos la siguiente linea al archivo:

```
softdep radeon pre: vfio vfio_pci
```
Reemplazando nuevamente radeon por el driver de la GPU.

Escribimos el siguiente comando:
```
sudo nvim /etc/modprobe.d/vfio_pci.conf
```
Añadimos la siguiente linea:

```
options vfio_pci ids=1002:67b1,1002:aac8
```
Guardamos el archivo y salimos del editor. Finalmente ejecutamos el siguiente comando:
```
sudo grub-mkconfig; sudo update-grub; sudo update-initramfs -k all -c
```
Ahora reinicie su computador. Terminado esto el passthrough debería estar terminado.

Para comprobarlo ejecutamos el siguiente comando:

```
lspci -k
```
Buscamos la GPU que queremos pasar a la maquina virtual y deberíamos ver que el driver ha cambiado a **vfio-pci**. En mi caso:

```
03:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Hawaii PRO [Radeon R9 290/390] (rev 80)
        Subsystem: PC Partner Limited / Sapphire Technology Sapphire Nitro R9 390                                           
        Kernel driver in use: vfio-pci                                                                                              
        Kernel modules: radeon, amdgpu                                                                                                           
```

Ahora solo resta crear la maquina virtual y disfrutar de nuestro passthrough.

## Creando la maquina virtual.

### Consideraciones iniciales

Vamos a necesitar dos archivos:

1. El .iso de instalación de **windows 10**, que se puede descargar desde éste [Link](https://www.microsoft.com/en-us/software-download/windows10ISO)
2. Los drivers **virtio**, que se pueden descargar desde éste [Link](https://docs.fedoraproject.org/en-US/quick-docs/creating-windows-virtual-machines-using-virtio-drivers/index.html#virtio-win-direct-downloads)

Para instalar el software necesario para crear la maquina virtual usamos el siguiente comando:

```
sudo apt install virt-manager qemu-kvm ovmf ifupdown
```
Para crear la maquina virtual vamos a usar una virt-manager y para hacer algunas configuraciones más profundas vamos a editar algunos archivos en usando la terminal.

Nota: Es probable que virt-manager nos arroje un error cuando la utilicemos por primera vez, por lo que es mejor usar el siguiente comando para ejecutarla por primera vez:

```
sudo virt-manager
```
### Pasos para la creación de una maquina virtual usando virt-manager

+ Una vez ejecutemos virt-manager hacemos clic en `archivo -> Nueva maquina virtual` 

+ Seleccionamos **Medio de instalacion local** 

+ Asegurarse de que **Utilizar imagen ISO** esté seleccionado y clickeamos **explorar** -> clickeamos **explore localmente**, buscamos el archivo ISO de instalación de windows, lo seleccionamos y clickeamos **open** y clickeamos siguiente.

+ En la siguiente pagina nos pedirá introducir la cantidad de memoria RAM y CPU's. Introducimos 8192 para la RAM y clickeamos siguiente (la configuración del CPU la cambiaremos después)

+ En la siguiente pantalla crearemos el "disco duro" de la maquina virtual, en éste caso podemos introducir la cantidad de almacenamiento que deseemos para nuestra maquina virtual, en mi caso 110gb pero puede introducir la cantidad que desee siempre que tenga suficiente espacio en el disco duro (y sea lo suficientemente grande para poder instalar Windows, al menos 40gb). 

+ En la última pantalla seleccionamos **Personalizar configuración antes de instalar** y clickeamos siguiente.

Después de todo ésto se abrirá una nueva pantalla donde podremos configurar a más detalle la maquina virtual. 

+ En la pestaña **repaso** cambiamos Firmware de **BIOS** a **UEFI x86_64** y Chipset de **i440fx** a **Q35** y clickeamos aceptar.

+ En la pestaña **CPUs** seleccionamos **Copiar configuración de la CPU del anfitrion** luego clickeamos topologia, clickeamos **Establecer manualmente la topologia de la CPU** y cambiamos la configuración de la siguiente manera:
    * Sockets: 1
    * Centros: (Éste es un parámetro con el cual se puede experimentar pero la mitad de los núcleos de nuestro CPU es un buen comienzo, 3 en mi caso)
    * Hilos: 2

 Cambiamos asignación actual al valor que tenga asignación máxima y clickeamos aceptar.

+ En la pestaña **IDE disco 1** clickeamos **Opciones avanzadas**, cambiamos **Bus de disco** a **VirtIO**, clickeamos **Opciones de rendimiento** y cambiamos **Modo caché** a **Writeback**, clickeamos aceptar.

+ En la pestaña **IDE CDROM 1** clickeamos **Conect** y luego **explorar**, clickeamos **explore localmente**, buscamos el iso de Windows, clickeamos open y luego OK. Luego clickeamos opciones avanzadas y cambiamos **Bus de disco** a **SATA**. clickeamos aplicar.

+ En la parte inferior izquierda de la pantalla clickeamos **Agregar hardware**, Cambiamos **Tipo de dispositivo** a **Dispositivo CDROM**, clickeamos **Finalizar**, seleccionamos **SATA CDROM 2**, clickeamos **Conect** y luego **explorar**, clickeamos **explore localmente**, buscamos el iso de los drivers **virtio**, clickeamos open, luego OK y por último **aplicar**

+ En la pestaña **Opciones de arranque** clickeamos **Habilite menú de arranque**, seleccionamos **VirtIO Disco 1, SATA CDROM 1** y **SATA CDROM 2**, luego clickeamos **SATA CDROM 1** y con las flechas que se encuentran acia la derecha, movemos **SATA CDROM 1** hasta arriba. Luego clickeamos **aplicar**

+ En la pestaña **NIC** cambiamos **Modelo de dispositivo** a **virtio**, clickeamos aplicar.

+ En la pestaña **Controller USB** cambiamos **Modelo** a **USB 3**

+ Eliminamos las siguientes pestañas: **Tableta, Audio, Monitor spice, Consola, Canal spice, Vídeo QXL, Redirector USB 1, Redirector USB 2**. para hacer esto seleccionamos cada pestaña y en la parte inferior derecha clickeamos **Remove**, luego **aceptar** 

+ Clickeamos **Agregar hardware**, luego **Dispositivo PCI anfitrion** y seleccionamos la GPU, clickeamos **Finalizar**. Repetimos el procedimiento para agregar el controlador de audio.

+ Clickeamos **Agregar hardware**, luego **Dispositivo USB anfitrión**, seleccionamos el teclado extra, clickeamos **Finalizar**. Repetimos el procedimiento para agregar el **mouse** y la **tarjeta de sonido USB**. 

+ Por último en la parte superior izquierda clickeamos iniciar instalación.

Terminado ésto la maquina virtual comenzará el proceso de instalación. En unos segundos la GPU de la maquina virtual debería comenzar a generar señal. y en unos segundos iniciará el instalador de Windows.

### Instalando Windows

En general vamos a instalar Windows como se haría en un caso normal. Pero notaremos dos peculiaridades:

1. No vamos a ver un disco duro a la hora de instalar Windows.

2. No tendremos Internet durante o después de la instalación.

Para solucionar estos problemas vamos a usar los drivers que descargamos. Cuando el instalador de nos pida un disco duro para instalar Windows clickeamos **Cargar driver** luego **buscar**, seleccionamos el CD con los drivers **virtio** y esto desplegará varias carpetas, seleccionamos **viostor**, luego **W10** y por último **amd64**, luego clickeamos **aceptar**, y por último **siguiente**.

Luego de cargar el driver vamos a ver un disco de la capacidad que especificamos cuando creamos la maquina virtual. Procedemos con la instalacion de manera normal.

Cuando termine la instalacion notaremos que no tenemos Internet, por lo que debemos instalar otro driver. En el buscador de Windows escribimos **administrador de dispositivos**, clickeamos **Otros dispositivos**, luego click derecho en **Controlador de Ethernet**, luego clickeamos **actualizar controlador**, **Buscar software controlador en el equipo** y finalmente **Examinar**. Ahora como buscamos el **CD** con los drivers **virtio**, lo clickeamos y buscamos la carpeta **NetKVM**, la abrimos y seleccionamos **w10**, luego **amd64**. Aceptamos todas las ventanas emergentes y listo, ya tenemos Internet, ahora podemos configurar Windows como lo haríamos normalmente, teniendo en cuenta que aun nos falta descargar e instalar los drivers de la GPU.

A éste punto ya tendremos instalado Windows y listo para utilizar (obviando el tema del audio, que cubriré en la siguiente sección **Optimizaciones y configuraciones adicionales**) 

## Optimizaciones y configuraciones adicionales
(Por redactar)

## Referencias y agradecimientos

* Agradecimientos especiales a Wendell de [Levelonetechs](https://level1techs.com/) su [foro](https://forum.level1techs.com/c/software/linux) enfocado en Linux y sus canales en YouTube [Level1Techs](https://www.youtube.com/user/teksyndicate), [Level1Linux](https://www.youtube.com/channel/UCOWcZ6Wicl-1N34H0zZe38w)

* Subreddit sobre passthrough [r/VFIO](https://www.reddit.com/r/VFIO/)

* La wiki de Arch linux. [PCI passthrough arch wiki](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF)


