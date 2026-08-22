-- =====================================================================
-- BT&Airways — Modelo Entidad-Relacion (MER) llevado a script SQL (DDL)
-- Variante para importar en Oracle SQL Developer Data Modeler
-- Sitio de Base de Datos: Oracle Database 12c (o 12cR2)
-- Actividad Semana 2 — Base de Datos
-- Autor: Gabriel Urra
-- =====================================================================
-- Notacion de dominios usada en los comentarios de cada columna:
--   [PK]  atributo identificador (clave primaria)
--   [FK]  atributo de relacion (clave foranea)
--   [OBL] atributo obligatorio (NOT NULL)
--   [OPC] atributo opcional (permite NULL)
--
-- Diferencias respecto a MER_BTAirways.sql (version SQL generica):
--   VARCHAR   -> VARCHAR2   (tipo de cadena preferido por Oracle)
--   DECIMAL   -> NUMBER(p,s) (Oracle no tiene DECIMAL nativo con ese nombre)
--   INT       -> NUMBER(p)   (Oracle no tiene tipo INT propio)
--   TIME      -> VARCHAR2(5) con formato HH24:MI (Oracle no tiene tipo TIME;
--                DATE incluiria un dia completo que no aplica aqui)
-- =====================================================================


-- ---------------------------------------------------------------------
-- ENTIDAD: AVION
-- Flota de 25 aviones de la aerolinea.
-- ---------------------------------------------------------------------
CREATE TABLE AVION (
    matricula           NUMBER(10)      NOT NULL,  -- [PK][OBL] matricula numerica unica
    marca                VARCHAR2(50)    NOT NULL,  -- [OBL]
    modelo               VARCHAR2(50)    NOT NULL,  -- [OBL]
    capacidad            NUMBER(4)       NOT NULL,  -- [OBL] dominio: 200 a 800 asientos
    CONSTRAINT pk_avion PRIMARY KEY (matricula),
    CONSTRAINT ck_avion_capacidad CHECK (capacidad BETWEEN 200 AND 800)
);


-- ---------------------------------------------------------------------
-- ENTIDAD: EMPLEADO (supertipo)
-- 450 empleados. Especializacion total y exclusiva: Piloto | Administrativo.
-- ---------------------------------------------------------------------
CREATE TABLE EMPLEADO (
    rut                  VARCHAR2(12)    NOT NULL,  -- [PK][OBL]
    nombre_completo       VARCHAR2(100)  NOT NULL,  -- [OBL]
    direccion             VARCHAR2(150)  NOT NULL,  -- [OBL]
    sueldo_base           NUMBER(10,2)   NOT NULL,  -- [OBL]
    fecha_ingreso         DATE           NOT NULL,  -- [OBL]
    genero                CHAR(1)        NOT NULL,  -- [OBL] dominio: M, F, O
    telefono_movil        VARCHAR2(20)   NOT NULL,  -- [OBL]
    telefono_contacto     VARCHAR2(20)   NULL,      -- [OPC]
    tipo_empleado         VARCHAR2(15)   NOT NULL,  -- [OBL] dominio: Piloto, Administrativo
    CONSTRAINT pk_empleado PRIMARY KEY (rut),
    CONSTRAINT ck_empleado_genero CHECK (genero IN ('M','F','O')),
    CONSTRAINT ck_empleado_tipo CHECK (tipo_empleado IN ('Piloto','Administrativo'))
);


-- ---------------------------------------------------------------------
-- ENTIDAD: PILOTO (subtipo de EMPLEADO)
-- ---------------------------------------------------------------------
CREATE TABLE PILOTO (
    rut                   VARCHAR2(12)   NOT NULL,  -- [PK][FK -> EMPLEADO.rut][OBL]
    horas_vuelo_acumuladas NUMBER(8,2)   NOT NULL,  -- [OBL]
    afp                    VARCHAR2(50)  NOT NULL,  -- [OBL]
    CONSTRAINT pk_piloto PRIMARY KEY (rut),
    CONSTRAINT fk_piloto_empleado FOREIGN KEY (rut) REFERENCES EMPLEADO (rut)
);


-- ---------------------------------------------------------------------
-- ENTIDAD: ADMINISTRATIVO (subtipo de EMPLEADO)
-- ---------------------------------------------------------------------
CREATE TABLE ADMINISTRATIVO (
    rut                   VARCHAR2(12)   NOT NULL,  -- [PK][FK -> EMPLEADO.rut][OBL]
    horas_extras           NUMBER(6,2)   NOT NULL,  -- [OBL]
    afp                    VARCHAR2(50)  NOT NULL,  -- [OBL]
    CONSTRAINT pk_administrativo PRIMARY KEY (rut),
    CONSTRAINT fk_administrativo_empleado FOREIGN KEY (rut) REFERENCES EMPLEADO (rut)
);


-- ---------------------------------------------------------------------
-- ENTIDAD: PASAJERO
-- ---------------------------------------------------------------------
CREATE TABLE PASAJERO (
    pasaporte_cedula      VARCHAR2(20)   NOT NULL,  -- [PK][OBL]
    nombre_completo        VARCHAR2(100) NOT NULL,  -- [OBL]
    fecha_nacimiento       DATE          NOT NULL,  -- [OBL]
    nacionalidad           VARCHAR2(50)  NOT NULL,  -- [OBL]
    telefono_contacto      VARCHAR2(20)  NULL,      -- [OPC]
    correo_electronico     VARCHAR2(100) NULL,      -- [OPC]
    CONSTRAINT pk_pasajero PRIMARY KEY (pasaporte_cedula),
    -- Regla de negocio: debe existir al menos un medio de contacto (telefono o correo)
    CONSTRAINT ck_pasajero_contacto CHECK (telefono_contacto IS NOT NULL OR correo_electronico IS NOT NULL)
);


-- ---------------------------------------------------------------------
-- ENTIDAD: VUELO
-- Cada vuelo se asocia a un unico avion; un avion vuela muchas veces.
-- ---------------------------------------------------------------------
CREATE TABLE VUELO (
    numero_vuelo          VARCHAR2(10)   NOT NULL,  -- [PK][OBL]
    fecha_despegue         DATE          NOT NULL,  -- [OBL]
    fecha_llegada          DATE          NOT NULL,  -- [OBL]
    hora_salida            VARCHAR2(5)   NOT NULL,  -- [OBL] formato HH24:MI, ej: 13:00
    ciudad_origen          VARCHAR2(50)  NOT NULL,  -- [OBL]
    ciudad_destino         VARCHAR2(50)  NOT NULL,  -- [OBL]
    matricula_avion        NUMBER(10)    NOT NULL,  -- [FK -> AVION.matricula][OBL]
    CONSTRAINT pk_vuelo PRIMARY KEY (numero_vuelo),
    CONSTRAINT fk_vuelo_avion FOREIGN KEY (matricula_avion) REFERENCES AVION (matricula)
);


-- ---------------------------------------------------------------------
-- ENTIDAD: RESERVA
-- Una reserva pertenece a un unico pasajero y a un unico vuelo, y es
-- procesada por un unico empleado administrativo.
-- ---------------------------------------------------------------------
CREATE TABLE RESERVA (
    numero_reserva         NUMBER(10)    NOT NULL,  -- [PK][OBL]
    fecha_reserva          DATE          NOT NULL,  -- [OBL]
    fecha_viaje            DATE          NOT NULL,  -- [OBL]
    asiento                 VARCHAR2(5)  NULL,      -- [OPC] solo si se selecciono al reservar
    estado                  VARCHAR2(12) NOT NULL,  -- [OBL] dominio: Confirmada, Nula
    pasaporte_cedula        VARCHAR2(20) NOT NULL,  -- [FK -> PASAJERO.pasaporte_cedula][OBL]
    numero_vuelo            VARCHAR2(10) NOT NULL,  -- [FK -> VUELO.numero_vuelo][OBL]
    rut_empleado            VARCHAR2(12) NOT NULL,  -- [FK -> ADMINISTRATIVO.rut][OBL]
    CONSTRAINT pk_reserva PRIMARY KEY (numero_reserva),
    CONSTRAINT ck_reserva_estado CHECK (estado IN ('Confirmada','Nula')),
    CONSTRAINT fk_reserva_pasajero FOREIGN KEY (pasaporte_cedula) REFERENCES PASAJERO (pasaporte_cedula),
    CONSTRAINT fk_reserva_vuelo FOREIGN KEY (numero_vuelo) REFERENCES VUELO (numero_vuelo),
    CONSTRAINT fk_reserva_empleado FOREIGN KEY (rut_empleado) REFERENCES ADMINISTRATIVO (rut)
);


-- ---------------------------------------------------------------------
-- ENTIDAD: EQUIPAJE
-- Identificado por su dueno (pasajero).
-- ---------------------------------------------------------------------
CREATE TABLE EQUIPAJE (
    codigo                  VARCHAR2(15) NOT NULL,  -- [PK][OBL]
    color                    VARCHAR2(30) NOT NULL, -- [OBL]
    peso                     NUMBER(5,2)  NOT NULL, -- [OBL] kilogramos, ej: 25.90
    descripcion               VARCHAR2(200) NULL,   -- [OPC]
    tipo_embarque             VARCHAR2(12) NOT NULL, -- [OBL] dominio: Prioritario, Normal
    fragil                    CHAR(2)      NULL,     -- [OPC] dominio: 'Si' (ausente = no fragil)
    pasaporte_cedula          VARCHAR2(20) NOT NULL, -- [FK -> PASAJERO.pasaporte_cedula][OBL]
    CONSTRAINT pk_equipaje PRIMARY KEY (codigo),
    CONSTRAINT ck_equipaje_embarque CHECK (tipo_embarque IN ('Prioritario','Normal')),
    CONSTRAINT ck_equipaje_fragil CHECK (fragil IS NULL OR fragil = 'Si'),
    CONSTRAINT fk_equipaje_pasajero FOREIGN KEY (pasaporte_cedula) REFERENCES PASAJERO (pasaporte_cedula)
);


-- ---------------------------------------------------------------------
-- RELACION N:M — RESERVA_EQUIPAJE
-- Un equipaje puede incluirse en varias reservas (viajes) del mismo dueno,
-- y una reserva puede incluir varias maletas.
-- ---------------------------------------------------------------------
CREATE TABLE RESERVA_EQUIPAJE (
    numero_reserva          NUMBER(10)   NOT NULL,  -- [PK][FK -> RESERVA.numero_reserva][OBL]
    codigo_equipaje          VARCHAR2(15) NOT NULL, -- [PK][FK -> EQUIPAJE.codigo][OBL]
    CONSTRAINT pk_reserva_equipaje PRIMARY KEY (numero_reserva, codigo_equipaje),
    CONSTRAINT fk_reserva_equipaje_reserva FOREIGN KEY (numero_reserva) REFERENCES RESERVA (numero_reserva),
    CONSTRAINT fk_reserva_equipaje_equipaje FOREIGN KEY (codigo_equipaje) REFERENCES EQUIPAJE (codigo)
);


-- =====================================================================
-- Notas de reglas de negocio que exceden el alcance del DDL declarativo
-- (requeririan triggers o logica de aplicacion si se desea forzarlas):
--   1) Un vuelo debe tener como minimo 1 pasajero y como maximo la
--      capacidad del avion asignado (VUELO.matricula_avion -> AVION.capacidad).
--   2) tipo_empleado en EMPLEADO debe ser consistente con la existencia
--      de una fila hija en PILOTO o ADMINISTRATIVO (exclusividad total).
-- =====================================================================
