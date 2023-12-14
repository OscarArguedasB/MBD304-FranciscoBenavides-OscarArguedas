# README para MBD304_PROYECTO_FINAL_SSIS

## Requisitos para Ejecutar el Proyecto

Para ejecutar este proyecto correctamente, es necesario contar con las siguientes herramientas y extensiones instaladas en su sistema:

1. **Visual Studio 2019**: Este proyecto está desarrollado para ser compatible con Visual Studio 2019. Asegúrese de tener esta versión instalada.

2. **Analysis Services**: Necesitará Analysis Services para trabajar con bases de datos multidimensionales. Puede descargarlo desde [Microsoft Analysis Services Modeling Projects](https://marketplace.visualstudio.com/items?itemName=ProBITools.MicrosoftAnalysisServicesModelingProjects).

3. **Integration Services**: Para gestionar procesos ETL, se requiere Integration Services. Descárguelo desde [SQL Server Integration Services Projects](https://marketplace.visualstudio.com/items?itemName=SSIS.SqlServerIntegrationServicesProjects&ssr=false#overview).

## Pasos para la Configuración Inicial

Una vez instalado todo lo necesario:

1. **Cargue el Proyecto en su Sistema**: Clone o descargue el proyecto en su computadora local.

2. **Abrir el Proyecto en Visual Studio 2019**:
   - Localice y abra el archivo de solución principal (`MBD304_PROYECTO_FINAL_SSIS/MBD304_PROYECTO_FINAL_SSIS.sln`).

3. **Recargar Proyectos si es Necesario**:
   - En caso de que algún proyecto dentro de la solución no se cargue automáticamente, haga clic derecho sobre él y seleccione la opción "Reload".

## Introducción

Este proyecto es un completo desarrollo de Data Warehouse utilizando como base la base de datos transaccional de World Wide Importers. Abarca desde la creación de una base de datos Data Warehouse en SQL Server, implementación de procesos ETL con SSIS, hasta la creación de un cubo multidimensional con Analysis Services.

## Estructura de las Tablas

La base de datos del Data Warehouse incluye varias tablas de dimensiones y una tabla de hechos, siguiendo un modelo en estrella o copo de nieve. Las dimensiones cubren aspectos clave del negocio, como clientes, empleados, fechas, productos y proveedores. La tabla de hechos centraliza las métricas y KPIs relevantes para el análisis empresarial.

## Conclusión

Hemos logrado establecer una infraestructura sólida que no solo consolida y mejora la calidad de nuestra información sino que también nos permite extraer conocimientos valiosos a través de la inteligencia empresarial. Este es solo el comienzo de nuestro continuo esfuerzo por mejorar y adaptar nuestras capacidades de gestión de datos en un entorno empresarial en constante evolución.
