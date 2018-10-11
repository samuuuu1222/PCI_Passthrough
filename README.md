# PCI_Passthrough

¡Hola a todos! En el siguiente texto les compartir algunas cosas acerca de mi computador, tips y recomendaciones para lograr tener una maquina virtual con PCI Passthrough, como optimizarlo y como usarlo de una manera cómoda. Supongo que si estas leyendo esto ya has de estar interesado en esta tecnología entonces no voy a perder tiempo explicando los múltiples beneficios de usar esta tecnología. 

## Mi "setup"

### Hardware
---

|Componente|Referencia|Link|
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

Ambas tarjetas graficas están conectadas al mismo monitor la GPU 1 (Linux) está conectada mediante VGA y la GPU 2 (Windows) está conectada mediante HDMI cuando deseo utilizar windows simplemente cambio la entrada del monitor a HDMI, posteriormente con un comando de Synergy activo el teclado y el mouse en uno u otro sistema.

El microfono y los audifonos están conectados a la tarjeta de sonido USB y ésta se ha pasado a la maquina virtual, esto me permite tener audio de relativamente buena calidad en Windows y aparte usar el chat de voz, pero tambien significa que mientras esté usando la maquina virtual no tengo audio en linux a menos que conecte otro dispositvo de audio.

## Pseudo Tutorial

asdf

El teclado y la tarjeta de sonido están conectadas a los puertos USB 3.1 de la placa madre esto es importante porque el controlador de USB 3.1 tambien se ha pasado a la maquina virtual a diferencia del mouse que simplemente se añadio como un dispositivo , esto resolvio varios problema de inestabilidad con los dipositivos USB,

## Referencias y agradecimientos

* Agradecimientos especiales a Wendell de [Levelonetechs](https://level1techs.com/) y su [foro](https://forum.level1techs.com/c/software/linux) enfocado el linux

* Subreddit sobre passthrough [r/VFIO](https://www.reddit.com/r/VFIO/)


