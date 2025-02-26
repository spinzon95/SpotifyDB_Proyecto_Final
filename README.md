# 🎵 SpotifyDB - Proyecto Final

Este proyecto consiste en la creación de una base de datos relacional basada en datos de **Spotify** extraídos de **Kaggle**.  
Su propósito es modelar la estructura de una plataforma de streaming musical, permitiendo almacenar información sobre artistas, álbumes, canciones, usuarios y reproducciones.

## 📂 Contenido del Repositorio

- **`SpotifyDB_Script.sql`** → Script SQL con la estructura y datos de la base de datos.
- **`SpotifyDB_Proyecto_Final.pdf`** → Documento del proyecto con análisis y metodología.
- **`SpotifyDB_ERD.png`** → Diagrama Entidad-Relación (E-R).

## 📊 Funcionalidades

- Almacenar información de **artistas, álbumes y canciones**.
- Registrar **usuarios y sus playlists**.
- Guardar un **historial de reproducciones**.
- Generar informes sobre **popularidad de canciones y artistas**.

## 🔍 Ejemplo de Consulta SQL

```sql
SELECT titulo, reproducciones 
FROM Canciones 
ORDER BY reproducciones DESC 
LIMIT 10;

## 🛠️ Tecnologías Utilizadas

- **MySQL** → Gestión de la base de datos.
- **SQL** → Creación de tablas, vistas y procedimientos almacenados.
- **Kaggle** → Fuente de datos utilizados en el análisis.
- **GitHub** → Control de versiones y almacenamiento de código.

