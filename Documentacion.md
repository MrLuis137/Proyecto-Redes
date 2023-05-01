# Proyecto I

  

### Curso: Redes (IC-7602)

  

### Sede: Campus Tecnológico Central Cartago

  

### Periodo: Primer semestre 2023

  

### Profesor: Nereo Campos Araya

  

### Estudiantes:

  

- Fiorella Arias Arias 2020023639

- Jarod Cervantes Gutiérrez 2019243821

- Esteban Ignacio Durán Vargas 2020388144

- Luis Diego Alemán Zúñiga 2018135386

- Leonardo David Fariña Ozamis 20200045272

  
  
  

# Ejecución

  

## Red Virtual

  

La red virtual está creada con terraform, este crea la infraestructura básica, el security group, las subredes, load balancer firewall y genera las ip necesarias. Las máquinas virtuales son generadas con Ubuntu 18.04-LTS.

Todo esto puede ser ejecutado con el comando terraform apply --var-file=conf/group.tfvars comando estando conectado a una cuenta de Azure con la suscripción adecuada.

  

## DNS

  

Para crear el dns se utilizó chef en una máquina virtual, específicamente se utilizó el cookbook de bind. Una vez que se crea la máquina virtual que aloja el dns, se ejecutan los comandos que se encuentran en el archivo llamado “chef-dns.sh”. Los comandos de ese archivo se utilizan para instalar chef dentro de la máquina y descargar el repositorio donde se encuentra el cookbook de bind y los archivos de configuración de las zonas, y se ejecuta el comando de “sudo chef-solo -c solo.rb -j node.json --log-level debug” para aplicar el recipe del dns creado. Lo descrito anteriormente se encuentra automatizado.

  
  

Dentro de la configuración de recipe del DNS, se crearon 3 archivos de zona, uno por cada zona solicitada para el proyecto y para cada zona se configuraron las entradas indicadas, con dos ips distintos, una para cada servidor apache. Los archivos de la creación de las zonas siguen el formato del siguiente ejemplo:

  

```python

  

$TTL 3H

@  IN  SOA  ns.dostoievski.io.  admin.dostoievski.io. (

2023042201 ; serial

1D ; refresh

1H ; retry

1W ; expiry

3H ; minimum

)

IN NS ns.dostoievski.io.

  

ns IN A 20.124.112.195

isaac IN A 20.232.188.2

* IN A 40.88.130.113

  

```

  

Donde:

$TTL: Define el tiempo de vida (TTL) en segundos para los registros de recursos en esta zona. En este ejemplo, se establece en 3 horas.

  

@: Representa el nombre de dominio raíz.

  

IN: Indica el tipo de registro de recursos.

  

SOA: Es el registro de recursos de "Start of Authority", que indica la autoridad de la zona y proporciona información sobre la zona. Los siguientes elementos son los parámetros del SOA:

  

ns.dostoievski.io.: El nombre del servidor de nombres primario.

admin.dostoievski.io.: El correo electrónico del administrador de la zona.

2023042201: El número de serie de la zona, que debe aumentar cada vez que se realice una actualización en la zona.

1D: El intervalo de tiempo en segundos después del cual los servidores secundarios deben actualizar la zona.

1H: El intervalo de tiempo en segundos después del cual los servidores secundarios deben intentar de nuevo si no pueden actualizar la zona.

1W: El intervalo de tiempo en segundos después del cual los servidores secundarios deben dejar de intentar actualizar la zona.

3H: El tiempo de vida en segundos para los registros de recursos negativos.

NS: Es el registro de recursos de "Name Server", que indica el nombre del servidor de nombres para la zona.

  

ns: Es el nombre del servidor de nombres.

  

A: Es el registro de recursos de "Address", que se utiliza para asociar un nombre de dominio con una dirección IP.

  
  
  
  

Además, se configuró un DNS forwarder que utiliza los servidores del DNS de google.

  
  

## Web Servers

  

## VPN

  

Se ejecuta corriendo los scripts en /vpn/scripts, ya sea corriendo vpn.sh o corriendo infrastructure.sh y luego vm.sh.

En cualquier de los dos casos preguntará por el ip de la VM creada, este IP se imprimirá en consola, también se pedirá el nombre del usuario para crear su configuración.

Conforme se corre el script se solicitara la confirmación de diversos pasos, como al correr el comando ssh para conectarse a la VM, o al correr el comando chef-solo.

  

## Proxy Reverso

El proxy para el proxy reverso se crea una máquina virtual por medio de terraform, también utilizando terraform se corre uns .sh que instala chef y apache, además realiza un git clone del chef-repo. En el chef repo se encuentra el cookbook de nginx junto a un cookbook que sirve como wrapper para la instalación de nginx y la configuración de dos instancias de apache que sirvan en dos puertos diferentes.

  

Toda la instalación se hace de manera automatizada y queda el proxy configurado junto a los servidores apache con solo aplicar la el terraform

  

## Web Cache

El proxy reverso necesita de una máquina virtual que corra el chef preparado para el servidor web proxy cache, y una ip pública con la cual se pueda acceder desde un navegador en cualquier computadora. Para esto, se corre en primer lugar el terraform que se encuentra en la carpeta de “webproxycache” del proyecto. Este contiene la configuración con todo lo necesario para la instalación y ejecución del servidor. La mayoría de las configuraciones son estándar para un terraform, entonces se enfocará en los archivos necesarios para la ejecución de las máquinas.

- **vmfiles/node.json & vmfiles/solo.rb:** configuración de chef (como los atributos de squid y rutas que este sigue). No se recomienda tocar solo.rb, pero se puede modificar los atributos en node.json de squid para cambiar la asignación de memoria del caché (cache_mem) o el puerto del proxy (port).

- **squid.conf.erb:** Esta es la configuración que se preparó para el web cache. Las únicas líneas que se le agregaron fue *http_access allow all* para permitir el acceso a todas las computadoras y además *refresh_pattern . 5  50% 20160 override-expire ignore-no-store ignore-private*. Esta última línea dice que a todas las rutas (.) se almacenarán como mínimo 5 minutos, y que la mitad de ese tiempo tiene que pasar antes de que empiece a buscar refrescar las direcciones almacenadas, que se quedarán en memoria por 20160 minutos. Finalmente, se debe agregar que las banderas que se encuentran al final tienen el propósito de pasar restricciones las cuales puedan hacer que los navegadores ignoren el caché web.

- **vmfiles/install.sh**: Este es un sh que se ejecuta una vez que se mueven todos los archivos necesarios y la máquina virtual empieza a correr. Este lo que hace es instalar los paquetes necesarios (chef), crear el repo en la dirección /, instalar el cookbook de squid desde el supermarket, mover cada uno de los archivos a la ruta requerida y ejecutar el comando de chef-solo.

  

Una vez el terraform complete su *apply*, el servidor estará corriendo en la dirección que regrese el output de este y en el puerto 3128. Esta dirección se debe configurar como el proxy de la computadora o del navegador (algunos navegadores no dan esta opción).

  
  

# Pruebas realizadas

  

## Red Virtual

  

## DNS

### Prueba de que el DNS se está ejecutando:

  

Para verificar el estado del DNS configurado, se utilizó el comando “systemctl status bind9”, y se obtuvo como resultado de que el servidor DNS se encontraba activo y que cargó todas las zonas indicadas, como se muestra a continuación:

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445405968535562/image1.png)

  
  

Para las siguientes pruebas, es importante indicar que para estas pruebas, la ip de apache 1 fue 20.232.188.2 y la de apache 2 fue 40.88.130.113, entonces, se debe cumplir lo siguiente:

  

www.google.com: Resuelve al IP del servidor Apache 1 (20.232.188.2) y al servidor Apache 2 (40.88.130.113).

*.asimov.io: Resuelve al IP del servidor Apache 1(20.232.188.2).

*. dostoievski.io: Resuelve al IP del servidor Apache2 (40.88.130.113).

fiodor.asimov.io: Resuelve al IP del servidor Apache 2 (40.88.130.113).

isaac.dostoievski.io: Resuelve al IP del servidor Apache 1(20.232.188.2).

Además, se debe tener en cuenta que si se ingresa un nombre de dominio que no está dentro de las zonas definidas, se utilizará el DNS forwarder configurado y se enviará el nombre de dominio al DNS de google para que lo resuelva (Como se ve en el caso de yahoo.com).

  

### Pruebas usando nslookup desde una máquina virtual:

  

Para realizar estas pruebas, se escribe nslookup en la terminal de la máquina virtual, luego al ingresar en la consola interactiva, se escribe “server <ip del servidor DNS>” y seguidamente, se pueden ingresar los nombres de dominio que se quieren resolver.

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445406236975205/image2.png)

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445406824177725/image4.png)

  
  

### Pruebas cambiando el DNS de máquina local por el DNS configurado para el proyecto

  

**Probando el nslookup desde la máquina local**

  
  

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445407923089468/image8.png)

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445407361044511/image6.png)

  
  

**Probando hacer ping desde la máquina local**

  

Como se puede comprobar en las siguientes dos imágenes, al realizar ping a www.google.com, se obtiene respuesta de alguna de las dos ips configuradas para esa entrada.

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445429259513886/image18.png)

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445405427474442/image9.png)

  

Podemos ver que las entradas *.asimov.io resuelven en la ip1, es decir, 20.232.188.2, esto sin importar lo que haya en lugar del *.

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445428328370236/image15.png)

  

Sin embargo, en el caso de fiodor.asimov.io, se tiene configurado que debe resolver con la ip 2, 40.88.130.113, es decir, aunque anteriormente si había dicho que aunque siempre que terminara en asimov.io se debía resolver con la ip1, en este caso se especifica que siempre que se utilice fiodor en la zona asimov.io, se debe resolver con la ip2.

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445407621095474/image7.png)

  
  

Lo mismo explicado en las dos imágenes anteriores ocurre con las siguientes dos imágenes.

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445406522191972/image3.png)

  
  
  

Finalmente, en esta imágen se puede evidenciar el funcionamiento del DNS forwarder configurado, ya que como el dominio indicado no pertenece a ninguna zona del DNS creado, este nombre de dominio se envía al DNS de google a ver si puede resolverlo.

  
  

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445407080034364/image5.png)

  
  
  
  
  
  
  

## Web Servers

  

## VPN

Para verificar el funcionamiento de este servicio se utilizó la página [What is my IP](https://whatismyipaddress.com/)

donde el primer resultado sin el vpn activo es el siguiente:

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445428936560680/image17.jpg)

  
  

y una vez activado cambia el ip al siguiente:

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445427606950029/image13.jpg)

  

También se podría probar con alguna plataforma de streaming que brinde contenido por locación, y ver cómo usando el vpn cambia la información mostrada.

  

## Proxy Reverso

  

### IP mostrada en el servidor

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445428001222676/image14.png)

  

### Acceder al servidor 1

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445405712691261/image10.png)

  

### Acceder al servidor 2

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445429767016458/image12.png)

  

### Acceder a cualquier dirección no contemplada en el proxy

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445429523763260/image11.png)

  

### Acceder solo a la IP

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1102445428613591092/image16.png)

  

## Web Cache

Para estas pruebas se centró en ver el funcionamiento en vivo del caché web mientras se navegaba por páginas web populares. Estas serían las escogidas.

- google.com

- youtube.com

- amazon.com

- www.tec.ac.cr

- www.ucr.ac.cr/

- www.una.ac.cr/

- www.uned.ac.cr/

- www.utn.ac.cr/

- www.ebay.com/

- www.mercadolibre.co.cr/

- www.tiktok.com/

- www.instagram.com/

- twitter.com

- wikipedia.org

- bing.com

- reddit.com

- twitch.com

- yahoo.com

- outlook.live.com/owa/

  

Primero se tomó nota del estado del access.log (que indica todas las interacciones del servidor con los hosts como revalidar o conexiones) y se nota que este está vacío.

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1101398449494183966/image.png)

  

Del mismo modo, se nota el tamaño de la memoria caché previo a registrar algo en las páginas.

![](https://cdn.discordapp.com/attachments/462125259382849546/1101398635645771836/image.png)

  

Luego, después de ingresar a los sitos web, se nota como el access log se llena de varias entradas, donde se ven estos sitios. En las imágenes solo se muestran las de las universidades públicas por brevedad.

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1101401668576346112/image.png)

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1101401892690595892/image.png)

  

También se nota que el tamaño del caché aumentó al final de las pruebas.

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1101413254527467560/image.png)

  

Finalmente, como por motivos de prueba se tenía un mínimo muy bajo para el refreshrate, se pudo observar que el caché refrescaba algunas páginas que salían del caché en este tiempo. Estas se ven con el TCP/Miss:

  

![](https://cdn.discordapp.com/attachments/462125259382849546/1101410690683646022/image.png)

  

![](https://media.discordapp.net/attachments/462125259382849546/1101410778587861022/image.png)

  

Por lo tanto, si se están guardando las páginas visitadas al caché y refrescando según las reglas establecidas, por ende el servidor squid cumple con los requisitos.

  

# Conclusiones

  

- Se evidencia en todo el proyecto la gran ventaja que permite el uso de terraform o chef como herramientas de automatización.

- Hay que ser precavidos a la hora de crear la infraestructura, especialmente nombrando los objetos porque hubieron momentos en que por una mala referencia saltaban multitud de errores.

- El proyecto permitió que todos aprendiéramos más sobre el uso de cloud, aspecto que es tan importante conocer actualmente, ya que muchas empresas están migrando sus servicios al cloud.

- Se pudieron adquirir y desarrollar habilidades en la implementación y configuración de redes virtuales y automatización de procesos.

- Al tener que implementar un DNS, se comprendió de una forma más específica el funcionamiento del mismo, ya que en el proceso de investigación para realizarlo, se aprendió cómo implementar un servidor DNS y cómo configurar las diferentes zonas, además, se adquirieron conocimientos sobre cómo configurar entradas en el DNS.

- Con este proyecto, se aprendió a configurar un proxy reverso utilizando NGINX y a utilizarlo para redirigir tráfico a diferentes servidores web basados en la ruta solicitada.

- Al utilizar chef, se aprendieron formas eficientes para automatizar procesos, ya que al investigar, se conocieron datos sobre cómo configurar un servicio mediante un cookbook específico, cuáles archivos están relacionados con un recipe, etc; y cada uno de estos aspectos serán de gran utilidad para futuros proyectos.

- Al implementar un VPN con la tecnología OpenVPN, se logra establecer una conexión segura y cifrada entre dos redes, lo que permite enviar todo el tráfico de red generado a través del VPN, por lo que se adquieren habilidades en la configuración de la seguridad de una red.

- Con el proyecto se aprendió a establecer políticas de expiración para el caché, lo que permite determinar cuánto tiempo se almacenan los datos en el caché antes de ser eliminados y se adquiere conocimiento de cómo utilizar Squid Proxy Cache, para mejorar la eficiencia del tráfico de red y reducir el consumo de ancho de banda.

- Al investigar, se aprendió que se puede mejorar la velocidad de carga de las páginas web mediante la utilización del caché de Squid, lo que puede mejorar la experiencia del usuario, este conocimiento puede ser de utilidad para futuros proyectos.

  

# Recomendaciones

  

- Se recomienda probar los componentes del proyecto por aparte, ya que   -azure brinda algunos recursos de forma limitada, por lo que no hay suficientes ips para ejecutar todo el proyecto en un solo momento.

- Se recomienda que todos tengan acceso a la cuenta de azure o que usarán cuentas por separado para hacer las pruebas, con el fin no tener que depender de una sola persona para que acceda al portal y borre los recursos.

- Como parte del proceso de destruir las máquinas virtuales a utilizar, se recomienda eliminar manualmente los discos de cada una de estas máquinas cada vez que se quiera llevar a cabo. Esto debido a que terraform no los elimina cuando destruye las máquinas y, al repetirse su nombre durante cada ejecución del terraform, no se podrán crear de nuevo después de aplicar el terraform apply.

- Se recomienda tener claro cuál es la IP a conectarse para el VPN, debido a las diversas instalaciones de la infraestructura, hubieron pruebas en las que se usaban IP viejas y no disponibles.

- Es importante conocer que para utilizar el cookbook de NGINX es necesario crear un wrapper para instalarlo.

- En este proyecto se realizaron varios componentes por separado en distintas máquinas virtuales, un mejor método sería utilizar una única máquina virtual y compartir recursos.

- Es recomendable que si un equipo está trabajando bajo una misma suscripción de amazon, es importante que tengan acceso a eliminar recursos ya que en durante este proyecto fué necesario que el dueño de la cuenta con subscripción realizara estas acciones cuando era requerido.

- Es importante asegurarse de que todos los miembros del equipo pueden utilizar WSL correctamente.

- En caso de que la suscripción de Azure tenga recursos limitados y se requiera compartirlos, es importante asegurarse de eliminar estos recursos compartidos al terminar de utilizarlos de modo que el siguiente compañero lo pueda utilizar sin tener que experimentar errores.

- Debido a la limitación de recursos que presenta la suscripción de estudiantes, sería buena idea establecer ips fijas en azure y asignarlas o desasignarlas a los distintos recursos que las requieran, ya que al tener que compartir ips al crear varios recursos, era complicado tener que cambiar las ips en varios archivos de configuración de una parte del proyecto debido a que se eliminó y creó una ip nueva para probar otra parte del proyecto (aspecto que era necesario debido a la limitación de ips)