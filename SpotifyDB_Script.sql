-- Creación de la base de datos
-- En este proyecto buscamos modelar una base de datos que refleje la experiencia de usuario en Spotify,
-- desde la interacción con canciones hasta la personalización de playlists.
CREATE DATABASE IF NOT EXISTS SpotifyDB;
USE SpotifyDB;

-- Creación de tablas principales
-- Los artistas son el alma de la música en Spotify, por lo que guardamos información clave sobre ellos.
CREATE TABLE IF NOT EXISTS Artistas (
    id_artista INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pais_origen VARCHAR(50),
    genero VARCHAR(50),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Los álbumes agrupan las canciones de un artista, permitiendo ordenar sus lanzamientos.
CREATE TABLE IF NOT EXISTS Albumes (
    id_album INT AUTO_INCREMENT PRIMARY KEY,
    id_artista INT NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    anio_lanzamiento YEAR NOT NULL,
    FOREIGN KEY (id_artista) REFERENCES Artistas(id_artista) ON DELETE CASCADE
);

-- Cada canción tiene un papel fundamental en la experiencia de los usuarios.
CREATE TABLE IF NOT EXISTS Canciones (
    id_cancion INT AUTO_INCREMENT PRIMARY KEY,
    id_album INT NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    duracion TIME NOT NULL,
    reproducciones INT DEFAULT 0,
    FOREIGN KEY (id_album) REFERENCES Albumes(id_album) ON DELETE CASCADE
);

-- Los usuarios son quienes hacen de Spotify un ecosistema vivo, por lo que guardamos sus datos básicos.
CREATE TABLE IF NOT EXISTS Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    pais VARCHAR(50),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Las playlists permiten a los usuarios crear colecciones personalizadas de música para cada momento.
CREATE TABLE IF NOT EXISTS Playlists (
    id_playlist INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

-- Cada reproducción registrada en el historial ayuda a entender las tendencias y hábitos de los usuarios.
CREATE TABLE IF NOT EXISTS Historial_Reproducciones (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_cancion INT NOT NULL,
    fecha_reproduccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion) ON DELETE CASCADE
);

-- Creación de vistas
-- ¿Cuáles son las canciones más escuchadas? Esta vista nos lo dirá en segundos.
CREATE VIEW v_top_canciones AS
SELECT c.id_cancion, c.titulo, a.titulo AS album, ar.nombre AS artista, c.reproducciones
FROM Canciones c
JOIN Albumes a ON c.id_album = a.id_album
JOIN Artistas ar ON a.id_artista = ar.id_artista
ORDER BY c.reproducciones DESC
LIMIT 10;

-- ¿Qué usuarios han estado activos recientemente?
CREATE VIEW v_usuarios_activos AS
SELECT id_usuario, nombre, correo, fecha_registro
FROM Usuarios
WHERE fecha_registro >= NOW() - INTERVAL 1 YEAR;

-- Creación de funciones
DELIMITER //
-- Función para calcular el total de reproducciones de un artista
CREATE FUNCTION f_total_reproducciones_artista(artista_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT SUM(c.reproducciones) INTO total
    FROM Canciones c
    JOIN Albumes a ON c.id_album = a.id_album
    WHERE a.id_artista = artista_id;
    RETURN COALESCE(total, 0);
END //

DELIMITER ;

-- Creación de Stored Procedures
DELIMITER //
-- Para actualizar las reproducciones de una canción cada vez que se escucha
CREATE PROCEDURE sp_actualizar_reproducciones(IN cancion_id INT, IN cantidad INT)
BEGIN
    UPDATE Canciones
    SET reproducciones = reproducciones + cantidad
    WHERE id_cancion = cancion_id;
END //

DELIMITER ;

-- Creación de Triggers
DELIMITER //
-- Cada vez que un usuario escucha una canción, actualizamos automáticamente las reproducciones.
CREATE TRIGGER tr_incrementar_reproducciones
AFTER INSERT ON Historial_Reproducciones
FOR EACH ROW
BEGIN
    UPDATE Canciones
    SET reproducciones = reproducciones + 1
    WHERE id_cancion = NEW.id_cancion;
END //

DELIMITER ;

-- Inserción de datos de prueba
-- Agregamos algunos artistas icónicos y sus canciones más populares.
INSERT INTO Artistas (nombre, pais_origen, genero) VALUES 
('Coldplay', 'Reino Unido', 'Rock'),
('Adele', 'Reino Unido', 'Pop'),
('Drake', 'Canadá', 'Hip-Hop');

INSERT INTO Albumes (id_artista, titulo, anio_lanzamiento) VALUES 
(1, 'Parachutes', 2000),
(2, '21', 2011),
(3, 'Views', 2016);

INSERT INTO Canciones (id_album, titulo, duracion, reproducciones) VALUES 
(1, 'Yellow', '04:29', 5000000),
(2, 'Someone Like You', '04:45', 7000000),
(3, 'Hotline Bling', '04:27', 8000000);

-- Consultas para verificar los datos
SELECT * FROM v_top_canciones;
SELECT f_total_reproducciones_artista(1) AS TotalReproduccionesColdplay;
SELECT * FROM v_usuarios_activos;
