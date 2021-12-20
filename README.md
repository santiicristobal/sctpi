# Polycon

Plantilla para comenzar con el Trabajo Práctico Integrador de la cursada 2021 de la materia
Taller de Tecnologías de Producción de Software - Opción Ruby, de la Facultad de Informática
de la Universidad Nacional de La Plata.

Polycon es una herramienta para gestionar los turnos y profesionales de un policonsultorio.

Este proyecto es simplemente una plantilla para comenzar a implementar la herramienta e
intenta proveer un punto de partida para el desarrollo, simplificando el _bootstrap_ del
proyecto que puede ser una tarea que consume mucho tiempo y conlleva la toma de algunas
decisiones que más adelante pueden tener efectos tanto positivos como negativos en el
proyecto.

## Uso de `polycon`

Para ejecutar el comando principal de la herramienta se utiliza el script `bin/polycon`,
el cual puede correrse de las siguientes manera:

```bash
$ ruby bin/polycon [args]
```

O bien:

```bash
$ bundle exec bin/polycon [args]
```

O simplemente:

```bash
$ bin/polycon [args]
```

Si se agrega el directorio `bin/` del proyecto a la variable de ambiente `PATH` de la shell,
el comando puede utilizarse sin prefijar `bin/`:

```bash
# Esto debe ejecutarse estando ubicad@ en el directorio raiz del proyecto, una única vez
# por sesión de la shell
$ export PATH="$(pwd)/bin:$PATH"
$ polycon [args]
```

> Notá que para la ejecución de la herramienta, es necesario tener una versión reciente de
> Ruby (2.6 o posterior) y tener instaladas sus dependencias, las cuales se manejan con
> Bundler. Para más información sobre la instalación de las dependencias, consultar la
> siguiente sección ("Desarrollo").

Documentar el uso para usuarios finales de la herramienta queda fuera del alcance de esta
plantilla y **se deja como una tarea para que realices en tu entrega**, pisando el contenido
de este archivo `README.md` o bien en uno nuevo. Ese archivo deberá contener cualquier
documentación necesaria para entender el funcionamiento y uso de la herramienta que hayas
implementado, junto con cualquier decisión de diseño del modelo de datos que consideres
necesario documentar.

## Desarrollo

Esta sección provee algunos tips para el desarrollo de tu entrega a partir de esta
plantilla.

### Instalación de dependencias

Este proyecto utiliza Bundler para manejar sus dependencias. Si aún no sabés qué es eso
o cómo usarlo, no te preocupes: ¡lo vamos a ver en breve en la materia! Mientras tanto,
todo lo que necesitás saber es que Bundler se encarga de instalar las dependencias ("gemas")
que tu proyecto tenga declaradas en su archivo `Gemfile` al ejecutar el siguiente comando:

```bash
$ bundle install
```

> Nota: Bundler debería estar disponible en tu instalación de Ruby, pero si por algún
> motivo al intentar ejecutar el comando `bundle` obtenés un error indicando que no se
> encuentra el comando, podés instalarlo mediante el siguiente comando:
>
> ```bash
> $ gem install bundler
> ```

Una vez que la instalación de las dependencias sea exitosa (esto deberías hacerlo solamente
cuando estés comenzando con la utilización del proyecto), podés comenzar a probar la
herramienta y a desarrollar tu entrega.

### Estructura de la plantilla

El proyecto te provee una estructura inicial en la cual podés basarte para implementar tu
entrega. Esta estructura no es necesariamente rígida, pero tené en cuenta que modificarla
puede requerir algún trabajo adicional de tu parte.

* `lib/`: directorio que contiene todas las clases del modelo y de soporte para la ejecución
  del programa `bin/polycon`.
  * `lib/polycon.rb` es la declaración del namespace `Polycon`, y las directivas de carga
    de clases o módulos que estén contenidos directamente por éste (`autoload`).
  * `lib/polycon/` es el directorio que representa el namespace `Polycon`. Notá la convención
    de que el uso de un módulo como namespace se refleja en la estructura de archivos del
    proyecto como un directorio con el mismo nombre que el archivo `.rb` que define el módulo,
    pero sin la terminación `.rb`. Dentro de este directorio se ubicarán los elementos del
    proyecto que estén bajo el namespace `Polycon` - que, también por convención y para
    facilitar la organización, deberían ser todos. Es en este directorio donde deberías
    ubicar tus clases de modelo, módulos, clases de soporte, etc. Tené en cuenta que para
    que todo funcione correctamente, seguramente debas agregar nuevas directivas de carga en la
    definición del namespace `Polycon` (o dónde corresponda, según tus decisiones de diseño).
  * `lib/polycon/commands.rb` y `lib/polycon/commands/*.rb` son las definiciones de comandos
    de `dry-cli` que se utilizarán. En estos archivos es donde comenzarás a realizar la
    implementación de las operaciones en sí, que en esta plantilla están provistas como
    simples disparadores.
  * `lib/polycon/version.rb` define la versión de la herramienta, utilizando [SemVer](https://semver.org/lang/es/).
* `bin/`: directorio donde reside cualquier archivo ejecutable, siendo el más notorio `polycon`
  que se utiliza como punto de entrada para el uso de la herramienta.


###Documentación

Proyecto de la materia Taller de Tecnologías de Producción de Software - Ruby 2021

###Alumno

Nombre: Santiago Gabriel Cristóbal
Legajo: 14413/4
Email: santiago.cristobal.sc@gmail.com


###TPI 1

###Persistencia de profesionales y turnos

  Para la persistencia de datos, decidí crear una carpeta models que contenga dos archivos, uno llamado appointment y otro llamado professional, donde puedo gestionar todo lo que refiere a los turnos y a los profesionales, gracias a las clases Dir y File que proveé el lenguaje. Además, también se realizan validaciones como lo son el formato de la fecha, si el directorio .polycon donde se encuentran los profesionales y sus turnos ya fue o no creado.
  Ya en la parte de commands se invocan los métodos ubicados los archivos anteriormente mencionados para poder realizar distintas operaciones como lo son la creación, la edición y la eliminación, entre otras, e informando si las mismas fueron exitosas por medio de un puts o si sus salidas presentan errores, a través de un warn.

###Formato de directorios y archivos

Utilice el formato dicho por el enunciado del trabajo práctico integrador, los directorios con los nombres de lo profesionales están guardados en el directorio .polycon en el directorio personal "Home". El formato para los nombre de los directorio de los profesionales consiste del nombre del profesional y si el nombre lleva espacio se reemplaza con un "_" por ejemplo: El directorio de la profesional Jose Gonzalez seria Jose_Gonzalez. Y para el nombre de los archivos para los turnos sería el siguiente formato de fecha: AAAA-MM-DD_HH-II.


###TPI 2

Para hacer las grilla utilice el sistema de plantilla que proporciona la librería ERB, para la creación del documento html. En los turnos decidí asumir que los turnos sean cada 30 minutos

grilladiaria crea un documento html que muestra una grilla de todos los turnos de un día en particular de uno de los profesionales, esta grilla contiene la información del horario del turno, la información del paciente y el profesional a que le corresponde el turno.

grillasemanal crea un documento html que muestra en una grilla todos los turnos de una semana en particular de un o de los profesionales, esta grilla contiene los horarios de los turno verticalmente (para los horarios asumí que los turnos solo se puedan sacar entre las 8 y las 18 y que solo se pueda sacar turno en la hora o en la hora y media), y horizontalmente los días de la semana y el profesional del turno. En la grilla si existe el turno en la semana mostrara el nombre y apellido del paciente, si en la semana no tiene turno para un horario, en la grilla se mostrara "Sin turno". Las semanas decidí que arranquen desde los domingos, como un calendario convencional.

Ambas grilla quedan guardadas en la carpeta en la carpeta "home", por lo tanto si se ejecuta uno de los dos comando sobrescribe lo que tenia antes.


###TPI 3

###Rails y Gemas

La aplicación rails se encuentra en el directorio tpi-rails, y la gemas que utilizo para esta entrega son:

1. Cancancan: Para crear los permisos de los distintos tipos de roles de los usuarios.
2. Devise: Para la implementación de autenticación de usuario que ingrese al sistema.
3. Validates_timeliness: Para la validación de fechas.

###Validaciones de turnos

No pueden existir 2 turnos para un mismo profesional en el mismo día y hora.

No se pueden sacar turnos para fechas pasadas o el mismo día.

En el campo teléfono de un turno solo deben ingresar números. 

En relación a los profesionales, no se añadió ninguna validación a la hora de crearlos, ya que al poseer solo el nombre y apellido y el hecho de que un nombre y apellido no suele ser único, se permitió la carga de profesionales con mismo nombre y apellido. De todas maneras, si se presenta una validación a la hora de eliminarlos, ya que en caso de tener turnos asignados no podrá ser eliminado.

Los usuarios de la aplicación tienen un nombre de usuario unico y su contraseña debe ser de al menos 6 caracteres.


El nombre y apellido, tanto del paciente como de los profesionales tienen un limite de 30 caracteres como maximo.

Aclaración: Con respecto a los turnos decidí que los mismos sean cada media hora, para estar mejor organizado.

###Interacción con el usuario

Para ver los profesionales y turnos uno primero debe iniciar sesión con una cuenta ya registrada o crear un nuevo usuario, este por defecto se creará con el rol de consulta.

Una vez que se inicio la sesión se verá todos los profesionales del sistema donde según los permiso del rol, se podrá crear, ver, eliminar, editar y ver los turnos de un profesional en particular, también se podrá generar una grilla de un día o semana de una fecha en particular de todo los turnos que se encuentre en la base de datos.

Si se mira los turnos de un profesional se podrá según los permiso del rol, crear, ver, eliminar (uno en particular o todos) y editar un turno en particular del profesional, también se podrá eliminar todos sus turnos o generar grilla de los turno del profesional por día o semanal de una fecha en particular que se encuentre en la base de datos.

Las grillas tanto por profesional como en general se descargan en formato html, y los horarios para crear un turno son de 8 a 18 en la horas puntuales o en la media hora.

En la navegación todos los roles podrán ir al inicio haciendo click en profesionales y en su email podrá cambiar la contraseña o eliminar su cuenta y el rol de administración adicionalmente puede en usuarios gestionar a los de más usuario cambiando su rol.


###Base de Datos

Para la base de datos decidí utilizar SQlite, y cargado en la seed se encuentran tres usuario con distintos roles.

La cuentas son: usuario

1. Para el de administración email: admin@gmail.com y contraseña: 123456.
2. Para el de consulta email: consulta@gmail.com y contraseña: 123456.
3. Para el de asistencia email: asistencia@gmail.com y contraseña: 123456.

También se encuentran, cargados en la seed, varios profesionales y turnos.