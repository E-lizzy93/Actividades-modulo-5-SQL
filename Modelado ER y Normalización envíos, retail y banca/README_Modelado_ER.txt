# Actividad: Modelado ER y Normalización
Estudiante: [Tu Nombre]

## Descripción
Este proyecto contiene el diseño e implementación de tres sistemas independientes:
1. Sistema de Envío de Encomiendas.
2. Sistema de Venta de Productos (Retail).
3. Sistema Administrador de Cuentas Bancarias.

## Contenido del Proyecto
- script_modelado.sql: Código DDL con la creación de tablas, restricciones (CHECK, UNIQUE) y relaciones (FK). Incluye carga de datos iniciales y consultas de prueba.
- /diagramas: Imágenes de los modelos Entidad-Relación de cada sistema.
- /evidencias: Capturas de pantalla de las consultas JOIN ejecutadas exitosamente.

## Especificaciones Técnicas
- Motor: PostgreSQL 17
- Normalización: Todos los modelos han sido normalizados hasta la 3ra Forma Normal (3FN).
- Integridad: Se aplicaron reglas de ON DELETE CASCADE para historiales y ON DELETE RESTRICT para tablas maestras para asegurar la integridad referencial.