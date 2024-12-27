
# Proyecto de Automatización con Karate

Este repositorio contiene una colección de pruebas automatizadas desarrolladas con [Karate](https://github.com/karatelabs/karate), un framework diseñado para la automatización de pruebas para servicios REST, SOAP, bases de datos, y más.

## Contenido

- **`/src/test/java`**: Contiene los scripts de prueba organizados por módulos o funcionalidades.
- **`karate-config.js`**: Archivo de configuración global donde se pueden definir variables y configuraciones reutilizables en todas las pruebas.


## Requisitos

Antes de ejecutar las pruebas, asegúrate de tener instalados los siguientes componentes:

- **Java 8 o superior**
- **Gradle 6.0 o superior**
- **IDE** (IntelliJ, Eclipse, etc.) con soporte para proyectos Gradle

## Configuración

1. **Clonar el repositorio:**

```bash
   git clone https://github.com/Dayana56-hol/RetoWompi.git
   cd Karate
```

   2. **Instalar las dependencias:**

   Ejecuta el siguiente comando para descargar las dependencias necesarias:

   ```bash
   ./gradlew clean build
   ```

## Ejecución de Pruebas

Puedes ejecutar las pruebas usando Gradle. A continuación se presentan algunos comandos útiles:

- **Ejecutar todas las pruebas:**

  ```bash
  ./gradlew test
  ```

- **Ejecutar un conjunto específico de pruebas:**

  ```bash
  ./gradlew test --tests "NombreDelTest"
  ```

- **Generar un reporte:**

  Los reportes se generan automáticamente en el directorio `build/reports/tests/test`. Puedes abrir el archivo `index.html` en un navegador para ver los resultados.

## Estructura de Archivos

- **`/src/test/java`**: Contiene las clases Java que configuran y ejecutan los tests.
- **`/src/test/resources`**: Contiene los archivos `.feature` que definen los escenarios de prueba utilizando la sintaxis Gherkin.
- **`karate-config.js`**: Archivo de configuración global para variables y configuraciones comunes.
- **`build.gradle`**: Archivo de configuración de Gradle donde se definen las dependencias y configuraciones del proyecto.
