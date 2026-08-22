Semana 2 - Base de Datos: Modelamiento BT&Airways
Actividad formativa "Representando procesos de Modelamiento Entidad-Relación (MER)", desarrollada en pareja con Oracle SQL Developer Data Modeler, dando continuidad al levantamiento inicial de la Semana 1.

Contexto de negocio
BT&Airways es una línea aérea con más de 25 años en el mercado, con del orden de 35.000 vuelos registrados (cifra que podría triplicarse en los próximos años). En esta segunda etapa se detalló el negocio a nivel de módulo de venta de vuelos: una flota de 25 aviones, 450 empleados (pilotos y administrativos), y el proceso completo de reserva de pasajes, incluyendo el registro de equipaje, como base para diseñar una base de datos de buena calidad a largo plazo.

Entidades identificadas
Se identificaron 9 entidades: AVION, EMPLEADO, PASAJERO, VUELO, EQUIPAJE como entidades principales del negocio; PILOTO y ADMINISTRATIVO como subtipos de EMPLEADO (especialización total y excluyente); RESERVA como entidad asociativa que conecta a PASAJERO, VUELO y al empleado ADMINISTRATIVO que la gestiona; y RESERVA_EQUIPAJE como entidad asociativa que resuelve la relación N:M entre RESERVA y EQUIPAJE.

AVION
Atributo	Tipo	Clave
Matricula	NUMBER(10)	PK
Marca	VARCHAR2(50)	Obligatorio
Modelo	VARCHAR2(50)	Obligatorio
Capacidad	NUMBER(4)	Obligatorio (dominio 200–800)

EMPLEADO
Atributo	Tipo	Clave
RUT	VARCHAR2(12)	PK
Nombre_completo	VARCHAR2(100)	Obligatorio
Direccion	VARCHAR2(150)	Obligatorio
Sueldo_base	NUMBER(10,2)	Obligatorio
Fecha_ingreso	DATE	Obligatorio
Genero	CHAR(1)	Obligatorio (M / F / O)
Telefono_movil	VARCHAR2(20)	Obligatorio
Telefono_contacto	VARCHAR2(20)	Opcional
Tipo_empleado	VARCHAR2(15)	Obligatorio (Piloto / Administrativo)

PILOTO (subtipo de EMPLEADO)
Atributo	Tipo	Clave
RUT	VARCHAR2(12)	PK / FK → EMPLEADO
Horas_vuelo_acumuladas	NUMBER(8,2)	Obligatorio
AFP	VARCHAR2(50)	Obligatorio

ADMINISTRATIVO (subtipo de EMPLEADO)
Atributo	Tipo	Clave
RUT	VARCHAR2(12)	PK / FK → EMPLEADO
Horas_extras	NUMBER(6,2)	Obligatorio
AFP	VARCHAR2(50)	Obligatorio

PASAJERO
Atributo	Tipo	Clave
Pasaporte_cedula	VARCHAR2(20)	PK
Nombre_completo	VARCHAR2(100)	Obligatorio
Fecha_nacimiento	DATE	Obligatorio
Nacionalidad	VARCHAR2(50)	Obligatorio
Telefono_contacto	VARCHAR2(20)	Opcional (al menos uno entre teléfono y correo)
Correo_electronico	VARCHAR2(100)	Opcional (al menos uno entre teléfono y correo)

VUELO
Atributo	Tipo	Clave
Numero_vuelo	VARCHAR2(10)	PK
Fecha_despegue	DATE	Obligatorio
Fecha_llegada	DATE	Obligatorio
Hora_salida	VARCHAR2(5)	Obligatorio
Ciudad_origen	VARCHAR2(50)	Obligatorio
Ciudad_destino	VARCHAR2(50)	Obligatorio
Matricula_avion	NUMBER(10)	FK → AVION

RESERVA
Atributo	Tipo	Clave
Numero_reserva	NUMBER(10)	PK
Fecha_reserva	DATE	Obligatorio
Fecha_viaje	DATE	Obligatorio
Asiento	VARCHAR2(5)	Opcional
Estado	VARCHAR2(12)	Obligatorio (Confirmada / Nula)
Pasaporte_cedula	VARCHAR2(20)	FK → PASAJERO
Numero_vuelo	VARCHAR2(10)	FK → VUELO
RUT_empleado	VARCHAR2(12)	FK → ADMINISTRATIVO

EQUIPAJE
Atributo	Tipo	Clave
Codigo	VARCHAR2(15)	PK
Color	VARCHAR2(30)	Obligatorio
Peso	NUMBER(5,2)	Obligatorio (kg, ej: 25,90)
Descripcion	VARCHAR2(200)	Opcional
Tipo_embarque	VARCHAR2(12)	Obligatorio (Prioritario / Normal)
Fragil	CHAR(2)	Opcional ("Si")
Pasaporte_cedula	VARCHAR2(20)	FK → PASAJERO

RESERVA_EQUIPAJE (asociativa N:M)
Atributo	Tipo	Clave
Numero_reserva	NUMBER(10)	PK / FK → RESERVA
Codigo_equipaje	VARCHAR2(15)	PK / FK → EQUIPAJE

Relaciones
AVION (1,1) — VUELO (0,N): un avión puede tener cero o muchos vuelos; todo vuelo pertenece exactamente a un avión.
VUELO (1,N) — RESERVA (0,N): un vuelo debe tener al menos una reserva y hasta la capacidad del avión asignado; toda reserva es de exactamente un vuelo.
PASAJERO (1,1) — RESERVA (0,N): un pasajero puede tener cero o muchas reservas; toda reserva pertenece a exactamente un pasajero.
ADMINISTRATIVO (1,1) — RESERVA (0,N): un empleado administrativo puede gestionar cero o muchas reservas; toda reserva es gestionada por exactamente un administrativo.
PASAJERO (1,1) — EQUIPAJE (0,N): un pasajero puede tener cero o muchas maletas; todo equipaje pertenece a exactamente un pasajero (su dueño).
RESERVA (0,N) — EQUIPAJE (0,N): una reserva puede incluir cero o muchas maletas, y una maleta puede incluirse en cero o muchas reservas del mismo dueño; relación N:M resuelta mediante RESERVA_EQUIPAJE.
EMPLEADO (1,1) — PILOTO / ADMINISTRATIVO (1,1): especialización total y excluyente; todo empleado es piloto o administrativo, nunca ambos ni ninguno.

La mayoría de las relaciones son no identificadoras, ya que RESERVA, VUELO y EQUIPAJE cuentan con su propia clave primaria natural y no dependen de las entidades relacionadas para su identidad. Son excepción la especialización EMPLEADO–PILOTO/ADMINISTRATIVO y la asociativa RESERVA_EQUIPAJE, que sí son identificadoras: PILOTO y ADMINISTRATIVO heredan el RUT de EMPLEADO como su propia PK, y RESERVA_EQUIPAJE construye su PK combinando las claves migradas de RESERVA y EQUIPAJE.

Modelos entregados
Modelo Entidad-Relación (MER) en notación Barker: representa las 9 entidades, sus atributos (marcados como clave #, obligatorio * u opcional o) y las relaciones con su cardinalidad/opcionalidad, incluyendo la especialización de EMPLEADO.
Modelo Relacional en notación Bachman / Information Engineering: generado mediante Engineer to Relational Model a partir del modelo lógico, mostrando las tablas resultantes con tipos de dato nativos de Oracle y las llaves primarias/foráneas.

Herramienta utilizada
Oracle SQL Developer Data Modeler (sitio de base de datos: Oracle Database 12c)

Archivos del repositorio
Semana2_BasedeDatos_GabrielUrra/ — proyecto completo de Data Modeler (modelo lógico y relacional).
Semana2_BasedeDatos_GabrielUrra/MER_BTAirways.sql — DDL del modelo en SQL genérico/ANSI.
Semana2_BasedeDatos_GabrielUrra/MER_BTAirways_Oracle.sql — DDL adaptado a sintaxis Oracle, usado para el import en Data Modeler.
Semana2_BadedeDatos_GabrielUrra.dmd — archivo de apertura rápida del proyecto.
Semana2_BadedeDatos_GabrielUrra.zip — copia comprimida del proyecto.
