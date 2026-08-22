# BT&Airways — Modelo Entidad-Relación (MER)

Actividad formativa Semana 2 — Base de Datos ("Representando procesos de Modelamiento Entidad-Relación (MER)").
Continuación del caso de negocio de la aerolínea **BT&Airways** trabajado en la Semana 1: diseño del modelo conceptual de datos para el módulo de venta de vuelos.

**Autor:** Gabriel Urra

## Contenido del repositorio

| Archivo | Descripción |
|---|---|
| [`MER_BTAirways.sql`](MER_BTAirways.sql) | DDL del modelo en SQL genérico/ANSI: `CREATE TABLE` de las 9 entidades con PK, FK y `CHECK` de dominio. |
| [`MER_BTAirways_Oracle.sql`](MER_BTAirways_Oracle.sql) | Misma estructura, adaptada a sintaxis Oracle (`VARCHAR2`, `NUMBER`, sin tipo `TIME`) para importar en **Oracle SQL Developer Data Modeler** (sitio de base de datos: Oracle Database 12c). |
| resto de carpetas (`businessinfo/`, `datatypes/`, `logical/`, `rdbms/`, `rel/`, `domains/`, etc.) | Proyecto de **Oracle SQL Developer Data Modeler** (formato CREST) con el modelo relacional importado y el diagrama MER (modelo lógico) ya generado. |

## Resumen del modelo

**Entidades:**
- `AVION` — flota de 25 aviones (matrícula, marca, modelo, capacidad 200–800 asientos)
- `EMPLEADO` (supertipo, 450 empleados) especializado de forma total y excluyente en:
  - `PILOTO` (horas de vuelo acumuladas, AFP)
  - `ADMINISTRATIVO` (horas extra, AFP)
- `PASAJERO` (pasaporte/cédula, datos personales, contacto obligatorio: teléfono o correo)
- `VUELO` (número de vuelo, fechas, hora de salida, ciudad origen/destino, avión asociado)
- `RESERVA` (número de reserva, fechas, asiento opcional, estado Confirmada/Nula; asociada a un pasajero, un vuelo y el empleado administrativo que la procesó)
- `EQUIPAJE` (código, color, peso en kg, tipo de embarque, frágil opcional; identificado por su dueño)
- `RESERVA_EQUIPAJE` — resuelve la relación N:M entre reserva y equipaje a nivel relacional/físico (a nivel lógico se modela como relación N:M directa)

**Relaciones principales:**

| Entidad A | Cardinalidad | Entidad B |
|---|---|---|
| AVION | 1:N | VUELO |
| VUELO | 1:N | RESERVA |
| PASAJERO | 1:N | RESERVA |
| ADMINISTRATIVO | 1:N | RESERVA |
| PASAJERO | 1:N | EQUIPAJE |
| RESERVA | N:M | EQUIPAJE |
| EMPLEADO | subtipo | PILOTO / ADMINISTRATIVO |

Reglas de negocio que exceden el alcance del DDL declarativo (requieren triggers o lógica de aplicación): cupo mínimo/máximo de pasajeros por vuelo según la capacidad del avión, y consistencia entre `EMPLEADO.tipo_empleado` y la existencia de la fila hija en `PILOTO`/`ADMINISTRATIVO`.

## Cómo importar en Oracle SQL Developer Data Modeler

1. Abrir el proyecto de este repositorio en Data Modeler (o crear uno nuevo).
2. `File → Import → DDL File...` → seleccionar `MER_BTAirways_Oracle.sql` → sitio de base de datos **Oracle Database 12c**. Esto genera el modelo **relacional**.
3. `File → Engineer to Logical Model...` para derivar el diagrama **MER** (modelo lógico) a partir del modelo relacional.
4. Ajustar a mano lo que el motor de ingeniería inversa no reconstruye automáticamente: la especialización `EMPLEADO` → `PILOTO`/`ADMINISTRATIVO` como Subtype/Supertype (Complete/Exclusive), y la relación `RESERVA`–`EQUIPAJE` como N:M directa.
