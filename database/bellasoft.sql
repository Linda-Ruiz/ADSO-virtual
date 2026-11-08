-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 09-11-2026 a las 00:19:29
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bellasoft`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria`
--

CREATE TABLE `auditoria` (
                             `id` bigint(20) NOT NULL,
                             `id_usuario` int(11) DEFAULT NULL,
                             `accion` varchar(50) NOT NULL,
                             `tabla_afectada` varchar(60) NOT NULL,
                             `id_registro` int(11) DEFAULT NULL,
                             `detalle` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`detalle`)),
                             `fecha` datetime NOT NULL DEFAULT current_timestamp(),
                             `ip` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `auditoria`
--

INSERT INTO `auditoria` (`id`, `id_usuario`, `accion`, `tabla_afectada`, `id_registro`, `detalle`, `fecha`, `ip`) VALUES
                                                                                                                      (1, 2, 'CREAR', 'facturas', 3, '{\"numero\": \"F-0003\", \"total\": 120000}', '2026-11-08 18:12:50', '192.168.1.10'),
                                                                                                                      (2, 2, 'CREAR', 'facturas', 3, '{\"numero\": \"F-0003\", \"total\": 120000}', '2026-11-08 18:13:27', '192.168.1.10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias_tratamiento`
--

CREATE TABLE `categorias_tratamiento` (
                                          `id_categoria` int(11) NOT NULL,
                                          `nombre` varchar(80) NOT NULL,
                                          `descripcion` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categorias_tratamiento`
--

INSERT INTO `categorias_tratamiento` (`id_categoria`, `nombre`, `descripcion`) VALUES
                                                                                   (1, 'Facial', 'Tratamientos de rostro'),
                                                                                   (2, 'Corporal', 'Tratamientos corporales'),
                                                                                   (3, 'Láser', 'Procedimientos con láser'),
                                                                                   (4, 'Inyectables', 'Botox, rellenos y similares');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `citas`
--

CREATE TABLE `citas` (
                         `id_cita` int(11) NOT NULL,
                         `id_paciente` int(11) NOT NULL,
                         `id_tratamiento` int(11) NOT NULL,
                         `id_profesional` int(11) NOT NULL,
                         `fecha` date NOT NULL,
                         `hora_inicio` time NOT NULL,
                         `hora_fin` time NOT NULL,
                         `estado` enum('Programada','Confirmada','Atendida','Cancelada','No asistió') NOT NULL DEFAULT 'Programada',
                         `motivo_cancelacion` varchar(200) DEFAULT NULL,
                         `observaciones` text DEFAULT NULL,
                         `created_by` int(11) DEFAULT NULL,
                         `created_at` datetime NOT NULL DEFAULT current_timestamp(),
                         `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

--
-- Volcado de datos para la tabla `citas`
--

INSERT INTO `citas` (`id_cita`, `id_paciente`, `id_tratamiento`, `id_profesional`, `fecha`, `hora_inicio`, `hora_fin`, `estado`, `motivo_cancelacion`, `observaciones`, `created_by`, `created_at`, `updated_at`) VALUES
                                                                                                                                                                                                                      (1, 2, 1, 4, '2026-07-19', '09:00:00', '10:00:00', 'Atendida', NULL, NULL, 2, '2026-11-08 18:12:50', '2026-11-08 18:12:50'),
                                                                                                                                                                                                                      (2, 4, 2, 4, '2026-07-19', '10:30:00', '11:15:00', 'Programada', NULL, NULL, 2, '2026-11-08 18:12:50', '2026-11-08 18:12:50'),
                                                                                                                                                                                                                      (3, 5, 3, 4, '2026-07-19', '11:45:00', '12:30:00', 'Programada', NULL, NULL, 2, '2026-11-08 18:12:50', '2026-11-08 18:12:50'),
                                                                                                                                                                                                                      (4, 1, 3, 4, '2026-07-15', '09:00:00', '09:45:00', 'Atendida', NULL, NULL, 2, '2026-11-08 18:12:50', '2026-11-08 18:12:50');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `consentimientos`
--

CREATE TABLE `consentimientos` (
                                   `id_consentimiento` int(11) NOT NULL,
                                   `id_paciente` int(11) NOT NULL,
                                   `id_tratamiento` int(11) NOT NULL,
                                   `fecha_firma` datetime NOT NULL DEFAULT current_timestamp(),
                                   `archivo_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `consentimientos`
--

INSERT INTO `consentimientos` (`id_consentimiento`, `id_paciente`, `id_tratamiento`, `fecha_firma`, `archivo_url`) VALUES
                                                                                                                       (1, 1, 3, '2026-07-15 08:50:00', '/consentimientos/ana_ruiz_laser.pdf'),
                                                                                                                       (2, 4, 2, '2026-07-17 10:00:00', '/consentimientos/miguel_molina_botox.pdf'),
                                                                                                                       (3, 1, 3, '2026-07-15 08:50:00', '/consentimientos/ana_ruiz_laser.pdf'),
                                                                                                                       (4, 4, 2, '2026-07-17 10:00:00', '/consentimientos/miguel_molina_botox.pdf');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturas`
--

CREATE TABLE `facturas` (
                            `id_factura` int(11) NOT NULL,
                            `numero_factura` varchar(20) NOT NULL,
                            `id_paciente` int(11) NOT NULL,
                            `fecha_emision` datetime NOT NULL DEFAULT current_timestamp(),
                            `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
                            `descuento` decimal(12,2) NOT NULL DEFAULT 0.00,
                            `impuesto` decimal(12,2) NOT NULL DEFAULT 0.00,
                            `total` decimal(12,2) NOT NULL DEFAULT 0.00,
                            `estado_pago` enum('Pendiente','Parcial','Pagada','Anulada') NOT NULL DEFAULT 'Pendiente',
                            `created_by` int(11) DEFAULT NULL
) ;

--
-- Volcado de datos para la tabla `facturas`
--

INSERT INTO `facturas` (`id_factura`, `numero_factura`, `id_paciente`, `fecha_emision`, `subtotal`, `descuento`, `impuesto`, `total`, `estado_pago`, `created_by`) VALUES
                                                                                                                                                                       (1, 'F-0001', 1, '2026-07-15 10:00:00', 180000.00, 0.00, 0.00, 180000.00, 'Anulada', 2),
                                                                                                                                                                       (2, 'F-0002', 4, '2026-07-17 11:00:00', 650000.00, 0.00, 0.00, 650000.00, 'Pendiente', 2),
                                                                                                                                                                       (3, 'F-0003', 2, '2026-07-18 12:00:00', 120000.00, 0.00, 0.00, 120000.00, 'Pagada', 2),
                                                                                                                                                                       (4, 'F-0004', 5, '2026-07-19 13:00:00', 180000.00, 0.00, 0.00, 180000.00, 'Parcial', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura_detalle`
--

CREATE TABLE `factura_detalle` (
                                   `id_detalle` int(11) NOT NULL,
                                   `id_factura` int(11) NOT NULL,
                                   `id_tratamiento` int(11) DEFAULT NULL,
                                   `descripcion` varchar(200) NOT NULL,
                                   `cantidad` int(11) NOT NULL DEFAULT 1,
                                   `precio_unitario` decimal(12,2) NOT NULL,
                                   `subtotal` decimal(12,2) NOT NULL
) ;

--
-- Volcado de datos para la tabla `factura_detalle`
--

INSERT INTO `factura_detalle` (`id_detalle`, `id_factura`, `id_tratamiento`, `descripcion`, `cantidad`, `precio_unitario`, `subtotal`) VALUES
                                                                                                                                           (1, 1, 3, 'Depilación láser', 1, 180000.00, 180000.00),
                                                                                                                                           (2, 2, 2, 'Botox', 1, 650000.00, 650000.00),
                                                                                                                                           (3, 3, 1, 'Facial', 1, 120000.00, 120000.00),
                                                                                                                                           (4, 4, 3, 'Depilación láser', 1, 180000.00, 180000.00),
                                                                                                                                           (5, 1, 3, 'Depilación láser', 1, 180000.00, 180000.00),
                                                                                                                                           (6, 2, 2, 'Botox', 1, 650000.00, 650000.00),
                                                                                                                                           (7, 3, 1, 'Facial', 1, 120000.00, 120000.00),
                                                                                                                                           (8, 4, 3, 'Depilación láser', 1, 180000.00, 180000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historia_clinica`
--

CREATE TABLE `historia_clinica` (
                                    `id_historia` int(11) NOT NULL,
                                    `id_paciente` int(11) NOT NULL,
                                    `alergias` text DEFAULT NULL,
                                    `enfermedades_previas` text DEFAULT NULL,
                                    `medicamentos_actuales` text DEFAULT NULL,
                                    `cirugias_previas` text DEFAULT NULL,
                                    `embarazo_lactancia` tinyint(1) NOT NULL DEFAULT 0,
                                    `tipo_piel` varchar(50) DEFAULT NULL,
                                    `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `historia_clinica`
--

INSERT INTO `historia_clinica` (`id_historia`, `id_paciente`, `alergias`, `enfermedades_previas`, `medicamentos_actuales`, `cirugias_previas`, `embarazo_lactancia`, `tipo_piel`, `updated_at`) VALUES
                                                                                                                                                                                                    (1, 1, 'Ninguna conocida', NULL, NULL, NULL, 0, 'Mixta', '2026-11-08 18:12:50'),
                                                                                                                                                                                                    (2, 2, 'Látex', 'Hipertensión', 'Losartán 50mg', NULL, 0, 'Seca', '2026-11-08 18:12:50'),
                                                                                                                                                                                                    (3, 3, NULL, NULL, NULL, 'Rinoplastia (2018)', 0, 'Grasa', '2026-11-08 18:12:50'),
                                                                                                                                                                                                    (4, 4, 'Penicilina', NULL, NULL, NULL, 0, 'Normal', '2026-11-08 18:12:50'),
                                                                                                                                                                                                    (5, 5, NULL, NULL, NULL, NULL, 0, 'Sensible', '2026-11-08 18:12:50');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pacientes`
--

CREATE TABLE `pacientes` (
                             `id_paciente` int(11) NOT NULL,
                             `tipo_documento` enum('CC','TI','CE','PA','RC') NOT NULL,
                             `numero_documento` varchar(20) NOT NULL,
                             `nombres` varchar(100) NOT NULL,
                             `apellidos` varchar(100) NOT NULL,
                             `fecha_nacimiento` date NOT NULL,
                             `sexo` enum('Femenino','Masculino','Otro') DEFAULT NULL,
                             `telefono` varchar(20) DEFAULT NULL,
                             `email` varchar(120) DEFAULT NULL,
                             `direccion` varchar(150) DEFAULT NULL,
                             `ciudad` varchar(80) DEFAULT NULL,
                             `contacto_emergencia_nombre` varchar(100) DEFAULT NULL,
                             `contacto_emergencia_telefono` varchar(20) DEFAULT NULL,
                             `estado` enum('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
                             `observaciones` text DEFAULT NULL,
                             `acepta_tratamiento_datos` tinyint(1) NOT NULL DEFAULT 0,
                             `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
                             `created_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `pacientes`
--

INSERT INTO `pacientes` (`id_paciente`, `tipo_documento`, `numero_documento`, `nombres`, `apellidos`, `fecha_nacimiento`, `sexo`, `telefono`, `email`, `direccion`, `ciudad`, `contacto_emergencia_nombre`, `contacto_emergencia_telefono`, `estado`, `observaciones`, `acepta_tratamiento_datos`, `fecha_registro`, `created_by`) VALUES
                                                                                                                                                                                                                                                                                                                                       (1, 'CC', '1002456', 'Ana', 'Ruiz', '1995-03-14', 'Femenino', '3001234567', 'ana@gmail.com', 'Cra 10 # 20-30', 'Bogotá', 'Marta Ruiz', '3009998877', 'Activo', NULL, 1, '2025-12-01 10:00:00', 2),
                                                                                                                                                                                                                                                                                                                                       (2, 'CC', '1009876', 'Laura', 'Díaz', '1990-08-02', 'Femenino', '3107654321', 'laura.d@gmail.com', 'Cll 45 # 12-08', 'Bogotá', 'Pedro Díaz', '3008887766', 'Activo', NULL, 1, '2026-01-15 11:30:00', 2),
                                                                                                                                                                                                                                                                                                                                       (3, 'CC', '1012456', 'María', 'López', '1985-11-23', 'Femenino', '3156543210', 'maria.l@gmail.com', 'Av 68 # 5-50', 'Bogotá', 'Juan López', '3007776655', 'Inactivo', NULL, 1, '2026-02-10 09:15:00', 2),
                                                                                                                                                                                                                                                                                                                                       (4, 'CC', '1020333', 'Miguel', 'Molina', '1988-05-30', 'Masculino', '3012223344', 'miguel.m@gmail.com', 'Cll 100 # 15-20', 'Bogotá', 'Rosa Molina', '3006665544', 'Activo', NULL, 1, '2026-03-05 14:00:00', 2),
                                                                                                                                                                                                                                                                                                                                       (5, 'CC', '1030444', 'Lola', 'Lolita', '1999-01-09', 'Femenino', '3023334455', 'lola.l@gmail.com', 'Cra 7 # 72-10', 'Bogotá', 'Carlos Lolita', '3005554433', 'Activo', NULL, 1, '2026-04-20 16:45:00', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paciente_tratamiento`
--

CREATE TABLE `paciente_tratamiento` (
                                        `id_paciente_tratamiento` int(11) NOT NULL,
                                        `id_paciente` int(11) NOT NULL,
                                        `id_tratamiento` int(11) NOT NULL,
                                        `id_profesional` int(11) NOT NULL,
                                        `fecha_inicio` date NOT NULL,
                                        `sesiones_totales` int(11) NOT NULL DEFAULT 1,
                                        `sesiones_realizadas` int(11) NOT NULL DEFAULT 0,
                                        `estado` enum('En curso','Finalizado','Cancelado') NOT NULL DEFAULT 'En curso',
                                        `notas` text DEFAULT NULL
) ;

--
-- Volcado de datos para la tabla `paciente_tratamiento`
--

INSERT INTO `paciente_tratamiento` (`id_paciente_tratamiento`, `id_paciente`, `id_tratamiento`, `id_profesional`, `fecha_inicio`, `sesiones_totales`, `sesiones_realizadas`, `estado`, `notas`) VALUES
                                                                                                                                                                                                    (1, 1, 3, 4, '2026-07-15', 6, 1, 'En curso', 'Depilación de piernas completas'),
                                                                                                                                                                                                    (2, 5, 3, 4, '2026-07-19', 6, 0, 'En curso', NULL),
                                                                                                                                                                                                    (3, 1, 3, 4, '2026-07-15', 6, 1, 'En curso', 'Depilación de piernas completas'),
                                                                                                                                                                                                    (4, 5, 3, 4, '2026-07-19', 6, 0, 'En curso', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
                         `id_pago` int(11) NOT NULL,
                         `id_factura` int(11) NOT NULL,
                         `fecha_pago` datetime NOT NULL DEFAULT current_timestamp(),
                         `monto` decimal(12,2) NOT NULL,
                         `metodo_pago` enum('Efectivo','Tarjeta','Transferencia','Nequi/Daviplata') NOT NULL,
                         `referencia` varchar(50) DEFAULT NULL,
                         `registrado_por` int(11) DEFAULT NULL
) ;

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`id_pago`, `id_factura`, `fecha_pago`, `monto`, `metodo_pago`, `referencia`, `registrado_por`) VALUES
                                                                                                                        (1, 3, '2026-07-18 12:05:00', 120000.00, 'Tarjeta', 'VOUCHER-8841', 2),
                                                                                                                        (2, 4, '2026-07-19 13:10:00', 80000.00, 'Nequi/Daviplata', 'NEQ-20260719', 2),
                                                                                                                        (3, 3, '2026-07-18 12:05:00', 120000.00, 'Tarjeta', 'VOUCHER-8841', 2),
                                                                                                                        (4, 4, '2026-07-19 13:10:00', 80000.00, 'Nequi/Daviplata', 'NEQ-20260719', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
                            `id_permiso` int(11) NOT NULL,
                            `modulo` varchar(50) NOT NULL,
                            `accion` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`id_permiso`, `modulo`, `accion`) VALUES
                                                              (6, 'citas', 'crear'),
                                                              (7, 'citas', 'editar'),
                                                              (8, 'citas', 'eliminar'),
                                                              (5, 'citas', 'ver'),
                                                              (19, 'configuracion', 'editar'),
                                                              (18, 'configuracion', 'ver'),
                                                              (14, 'facturacion', 'crear'),
                                                              (15, 'facturacion', 'editar'),
                                                              (16, 'facturacion', 'eliminar'),
                                                              (13, 'facturacion', 'ver'),
                                                              (2, 'pacientes', 'crear'),
                                                              (3, 'pacientes', 'editar'),
                                                              (4, 'pacientes', 'eliminar'),
                                                              (1, 'pacientes', 'ver'),
                                                              (17, 'reportes', 'ver'),
                                                              (10, 'tratamientos', 'crear'),
                                                              (11, 'tratamientos', 'editar'),
                                                              (12, 'tratamientos', 'eliminar'),
                                                              (9, 'tratamientos', 'ver');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
                         `id_rol` int(11) NOT NULL,
                         `nombre` varchar(100) DEFAULT NULL,
                         `descripcion` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id_rol`, `nombre`, `descripcion`) VALUES
                                                            (1, 'Administrador', 'Acceso total al sistema'),
                                                            (2, 'Recepción', 'Gestiona pacientes, citas y facturación'),
                                                            (3, 'Profesional', 'Atiende pacientes y registra tratamientos'),
                                                            (4, 'Contador', 'Consulta facturación y reportes de ingresos'),
                                                            (5, 'Administrador', 'Acceso total al sistema'),
                                                            (6, 'Recepción', 'Gestiona pacientes, citas y facturación'),
                                                            (7, 'Profesional', 'Atiende pacientes y registra tratamientos'),
                                                            (8, 'Contador', 'Consulta facturación y reportes de ingresos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rolpermiso`
--

CREATE TABLE `rolpermiso` (
                              `id_rol` int(11) NOT NULL,
                              `id_rol_permiso` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol_permiso`
--

CREATE TABLE `rol_permiso` (
                               `id_permiso` int(11) NOT NULL,
                               `modulo` varchar(50) DEFAULT NULL,
                               `accion` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sesiones_tratamiento`
--

CREATE TABLE `sesiones_tratamiento` (
                                        `id_sesion` int(11) NOT NULL,
                                        `id_paciente_tratamiento` int(11) NOT NULL,
                                        `id_cita` int(11) DEFAULT NULL,
                                        `fecha` datetime NOT NULL,
                                        `productos_utilizados` text DEFAULT NULL,
                                        `zona_tratada` varchar(100) DEFAULT NULL,
                                        `observaciones` text DEFAULT NULL,
                                        `foto_antes_url` varchar(255) DEFAULT NULL,
                                        `foto_despues_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sesiones_tratamiento`
--

INSERT INTO `sesiones_tratamiento` (`id_sesion`, `id_paciente_tratamiento`, `id_cita`, `fecha`, `productos_utilizados`, `zona_tratada`, `observaciones`, `foto_antes_url`, `foto_despues_url`) VALUES
                                                                                                                                                                                                   (1, 1, 4, '2026-07-15 09:00:00', 'Gel conductor', 'Piernas', 'Sin reacciones adversas', NULL, NULL),
                                                                                                                                                                                                   (2, 1, 4, '2026-07-15 09:00:00', 'Gel conductor', 'Piernas', 'Sin reacciones adversas', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tratamientos`
--

CREATE TABLE `tratamientos` (
                                `id_tratamiento` int(11) NOT NULL,
                                `id_categoria` int(11) NOT NULL,
                                `nombre` varchar(120) NOT NULL,
                                `descripcion` text DEFAULT NULL,
                                `duracion_minutos` int(11) NOT NULL DEFAULT 60,
                                `precio_base` decimal(12,2) NOT NULL DEFAULT 0.00,
                                `numero_sesiones_recomendadas` int(11) NOT NULL DEFAULT 1,
                                `requiere_consentimiento` tinyint(1) NOT NULL DEFAULT 0,
                                `activo` tinyint(1) NOT NULL DEFAULT 1
) ;

--
-- Volcado de datos para la tabla `tratamientos`
--

INSERT INTO `tratamientos` (`id_tratamiento`, `id_categoria`, `nombre`, `descripcion`, `duracion_minutos`, `precio_base`, `numero_sesiones_recomendadas`, `requiere_consentimiento`, `activo`) VALUES
                                                                                                                                                                                                   (1, 1, 'Facial', 'Limpieza e hidratación facial', 60, 132300.00, 1, 0, 1),
                                                                                                                                                                                                   (2, 4, 'Botox', 'Aplicación de toxina botulínica', 45, 650000.00, 1, 1, 1),
                                                                                                                                                                                                   (3, 3, 'Depilación láser', 'Depilación láser por zona', 45, 180000.00, 6, 1, 1),
                                                                                                                                                                                                   (4, 1, 'Peeling químico', 'Renovación celular', 50, 240000.00, 3, 1, 0),
                                                                                                                                                                                                   (5, 1, 'Facial', 'Limpieza e hidratación facial', 60, 126000.00, 1, 0, 1),
                                                                                                                                                                                                   (6, 4, 'Botox', 'Aplicación de toxina botulínica', 45, 650000.00, 1, 1, 1),
                                                                                                                                                                                                   (7, 3, 'Depilación láser', 'Depilación láser por zona', 45, 180000.00, 6, 1, 1),
                                                                                                                                                                                                   (8, 1, 'Peeling químico', 'Renovación celular', 50, 240000.00, 3, 1, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
                            `id_usuario` int(11) NOT NULL,
                            `id_rol` int(11) NOT NULL,
                            `nombres` varchar(100) NOT NULL,
                            `apellidos` varchar(100) NOT NULL,
                            `email` varchar(120) NOT NULL,
                            `password_hash` varchar(255) NOT NULL,
                            `telefono` varchar(20) DEFAULT NULL,
                            `activo` tinyint(1) NOT NULL DEFAULT 1,
                            `ultimo_acceso` datetime DEFAULT NULL,
                            `created_at` datetime NOT NULL DEFAULT current_timestamp(),
                            `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `id_rol`, `nombres`, `apellidos`, `email`, `password_hash`, `telefono`, `activo`, `ultimo_acceso`, `created_at`, `updated_at`) VALUES
                                                                                                                                                                         (1, 1, 'Laura', 'Rodríguez', 'laura@bellasoft.co', '$2a$10$EJEMPLOhashLauraRodriguez000000000000000000000000000', '3001110001', 1, '2026-07-19 08:12:00', '2026-11-08 18:12:50', '2026-11-08 18:12:50'),
                                                                                                                                                                         (2, 2, 'Camila', 'Torres', 'camila@bellasoft.co', '$2a$10$EJEMPLOhashCamilaTorres0000000000000000000000000000', '3001110002', 1, '2026-07-18 17:40:00', '2026-11-08 18:12:50', '2026-11-08 18:12:50'),
                                                                                                                                                                         (3, 3, 'Andrés', 'Pérez', 'andres@bellasoft.co', '$2a$10$EJEMPLOhashAndresPerez00000000000000000000000000000', '3001110003', 0, '2026-07-12 10:00:00', '2026-11-08 18:12:50', '2026-11-08 18:12:50'),
                                                                                                                                                                         (4, 3, 'Sofía', 'Gómez', 'sofia@bellasoft.co', '$2a$10$EJEMPLOhashSofiaGomez000000000000000000000000000000', '3001110004', 1, '2026-07-18 15:10:00', '2026-11-08 18:12:50', '2026-11-08 18:12:50'),
                                                                                                                                                                         (5, 4, 'Julián', 'Mora', 'julian@bellasoft.co', '$2a$10$EJEMPLOhashJulianMora000000000000000000000000000000', '3001110005', 1, '2026-07-15 09:30:00', '2026-11-08 18:12:50', '2026-11-08 18:12:50');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_citas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_citas` (
                               `id_cita` int(11)
    ,`fecha` date
    ,`hora_inicio` time
    ,`hora_fin` time
    ,`paciente` varchar(201)
    ,`tratamiento` varchar(120)
    ,`profesional` varchar(201)
    ,`estado` enum('Programada','Confirmada','Atendida','Cancelada','No asistió')
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_ingresos_mensuales`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_ingresos_mensuales` (
                                            `mes` varchar(7)
    ,`metodo_pago` enum('Efectivo','Tarjeta','Transferencia','Nequi/Daviplata')
    ,`total_recaudado` decimal(34,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_pacientes`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_pacientes` (
                                   `id_paciente` int(11)
    ,`tipo_documento` enum('CC','TI','CE','PA','RC')
    ,`numero_documento` varchar(20)
    ,`nombre_completo` varchar(201)
    ,`edad` bigint(21)
    ,`telefono` varchar(20)
    ,`email` varchar(120)
    ,`estado` enum('Activo','Inactivo')
    ,`fecha_registro` datetime
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_citas`
--
DROP TABLE IF EXISTS `vista_citas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_citas`  AS SELECT `c`.`id_cita` AS `id_cita`, `c`.`fecha` AS `fecha`, `c`.`hora_inicio` AS `hora_inicio`, `c`.`hora_fin` AS `hora_fin`, concat(`p`.`nombres`,' ',`p`.`apellidos`) AS `paciente`, `t`.`nombre` AS `tratamiento`, concat(`u`.`nombres`,' ',`u`.`apellidos`) AS `profesional`, `c`.`estado` AS `estado` FROM (((`citas` `c` join `pacientes` `p` on(`p`.`id_paciente` = `c`.`id_paciente`)) join `tratamientos` `t` on(`t`.`id_tratamiento` = `c`.`id_tratamiento`)) join `usuarios` `u` on(`u`.`id_usuario` = `c`.`id_profesional`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_ingresos_mensuales`
--
DROP TABLE IF EXISTS `vista_ingresos_mensuales`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_ingresos_mensuales`  AS SELECT date_format(`pagos`.`fecha_pago`,'%Y-%m') AS `mes`, `pagos`.`metodo_pago` AS `metodo_pago`, sum(`pagos`.`monto`) AS `total_recaudado` FROM `pagos` GROUP BY date_format(`pagos`.`fecha_pago`,'%Y-%m'), `pagos`.`metodo_pago` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_pacientes`
--
DROP TABLE IF EXISTS `vista_pacientes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_pacientes`  AS SELECT `p`.`id_paciente` AS `id_paciente`, `p`.`tipo_documento` AS `tipo_documento`, `p`.`numero_documento` AS `numero_documento`, concat(`p`.`nombres`,' ',`p`.`apellidos`) AS `nombre_completo`, timestampdiff(YEAR,`p`.`fecha_nacimiento`,curdate()) AS `edad`, `p`.`telefono` AS `telefono`, `p`.`email` AS `email`, `p`.`estado` AS `estado`, `p`.`fecha_registro` AS `fecha_registro` FROM `pacientes` AS `p` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `auditoria`
--
ALTER TABLE `auditoria`
    ADD PRIMARY KEY (`id`),
  ADD KEY `idx_aud_fecha` (`fecha`),
  ADD KEY `fk_aud_usuario` (`id_usuario`);

--
-- Indices de la tabla `categorias_tratamiento`
--
ALTER TABLE `categorias_tratamiento`
    ADD PRIMARY KEY (`id_categoria`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `citas`
--
ALTER TABLE `citas`
    ADD PRIMARY KEY (`id_cita`),
  ADD UNIQUE KEY `uq_profesional_horario` (`id_profesional`,`fecha`,`hora_inicio`),
  ADD KEY `idx_cita_fecha` (`fecha`),
  ADD KEY `fk_cita_paciente` (`id_paciente`),
  ADD KEY `fk_cita_tratamiento` (`id_tratamiento`),
  ADD KEY `fk_cita_creador` (`created_by`);

--
-- Indices de la tabla `consentimientos`
--
ALTER TABLE `consentimientos`
    ADD PRIMARY KEY (`id_consentimiento`),
  ADD KEY `fk_cons_paciente` (`id_paciente`),
  ADD KEY `fk_cons_tratamiento` (`id_tratamiento`);

--
-- Indices de la tabla `facturas`
--
ALTER TABLE `facturas`
    ADD PRIMARY KEY (`id_factura`),
  ADD UNIQUE KEY `numero_factura` (`numero_factura`),
  ADD KEY `fk_fac_paciente` (`id_paciente`),
  ADD KEY `fk_fac_usuario` (`created_by`);

--
-- Indices de la tabla `factura_detalle`
--
ALTER TABLE `factura_detalle`
    ADD PRIMARY KEY (`id_detalle`),
  ADD KEY `fk_det_factura` (`id_factura`),
  ADD KEY `fk_det_tratamiento` (`id_tratamiento`);

--
-- Indices de la tabla `historia_clinica`
--
ALTER TABLE `historia_clinica`
    ADD PRIMARY KEY (`id_historia`),
  ADD UNIQUE KEY `id_paciente` (`id_paciente`);

--
-- Indices de la tabla `pacientes`
--
ALTER TABLE `pacientes`
    ADD PRIMARY KEY (`id_paciente`),
  ADD UNIQUE KEY `uq_documento` (`tipo_documento`,`numero_documento`),
  ADD KEY `idx_paciente_nombre` (`apellidos`,`nombres`),
  ADD KEY `fk_paciente_usuario` (`created_by`);

--
-- Indices de la tabla `paciente_tratamiento`
--
ALTER TABLE `paciente_tratamiento`
    ADD PRIMARY KEY (`id_paciente_tratamiento`),
  ADD KEY `fk_pt_paciente` (`id_paciente`),
  ADD KEY `fk_pt_tratamiento` (`id_tratamiento`),
  ADD KEY `fk_pt_profesional` (`id_profesional`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
    ADD PRIMARY KEY (`id_pago`),
  ADD KEY `fk_pago_factura` (`id_factura`),
  ADD KEY `fk_pago_usuario` (`registrado_por`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
    ADD PRIMARY KEY (`id_permiso`),
  ADD UNIQUE KEY `uq_modulo_accion` (`modulo`,`accion`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
    ADD PRIMARY KEY (`id_rol`);

--
-- Indices de la tabla `rolpermiso`
--
ALTER TABLE `rolpermiso`
    ADD PRIMARY KEY (`id_rol`,`id_rol_permiso`),
  ADD KEY `id_rol_permiso` (`id_rol_permiso`);

--
-- Indices de la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
    ADD PRIMARY KEY (`id_permiso`);

--
-- Indices de la tabla `sesiones_tratamiento`
--
ALTER TABLE `sesiones_tratamiento`
    ADD PRIMARY KEY (`id_sesion`),
  ADD KEY `fk_ses_pt` (`id_paciente_tratamiento`),
  ADD KEY `fk_ses_cita` (`id_cita`);

--
-- Indices de la tabla `tratamientos`
--
ALTER TABLE `tratamientos`
    ADD PRIMARY KEY (`id_tratamiento`),
  ADD KEY `fk_trat_categoria` (`id_categoria`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
    ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_usuario_rol` (`id_rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `auditoria`
--
ALTER TABLE `auditoria`
    MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `categorias_tratamiento`
--
ALTER TABLE `categorias_tratamiento`
    MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `citas`
--
ALTER TABLE `citas`
    MODIFY `id_cita` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `consentimientos`
--
ALTER TABLE `consentimientos`
    MODIFY `id_consentimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `facturas`
--
ALTER TABLE `facturas`
    MODIFY `id_factura` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `factura_detalle`
--
ALTER TABLE `factura_detalle`
    MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historia_clinica`
--
ALTER TABLE `historia_clinica`
    MODIFY `id_historia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `pacientes`
--
ALTER TABLE `pacientes`
    MODIFY `id_paciente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `paciente_tratamiento`
--
ALTER TABLE `paciente_tratamiento`
    MODIFY `id_paciente_tratamiento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
    MODIFY `id_pago` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
    MODIFY `id_permiso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
    MODIFY `id_rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
    MODIFY `id_permiso` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `sesiones_tratamiento`
--
ALTER TABLE `sesiones_tratamiento`
    MODIFY `id_sesion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tratamientos`
--
ALTER TABLE `tratamientos`
    MODIFY `id_tratamiento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
    MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `auditoria`
--
ALTER TABLE `auditoria`
    ADD CONSTRAINT `fk_aud_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL;

--
-- Filtros para la tabla `citas`
--
ALTER TABLE `citas`
    ADD CONSTRAINT `fk_cita_creador` FOREIGN KEY (`created_by`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cita_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id_paciente`),
  ADD CONSTRAINT `fk_cita_profesional` FOREIGN KEY (`id_profesional`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `fk_cita_tratamiento` FOREIGN KEY (`id_tratamiento`) REFERENCES `tratamientos` (`id_tratamiento`);

--
-- Filtros para la tabla `consentimientos`
--
ALTER TABLE `consentimientos`
    ADD CONSTRAINT `fk_cons_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id_paciente`),
  ADD CONSTRAINT `fk_cons_tratamiento` FOREIGN KEY (`id_tratamiento`) REFERENCES `tratamientos` (`id_tratamiento`);

--
-- Filtros para la tabla `facturas`
--
ALTER TABLE `facturas`
    ADD CONSTRAINT `fk_fac_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id_paciente`),
  ADD CONSTRAINT `fk_fac_usuario` FOREIGN KEY (`created_by`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL;

--
-- Filtros para la tabla `factura_detalle`
--
ALTER TABLE `factura_detalle`
    ADD CONSTRAINT `fk_det_factura` FOREIGN KEY (`id_factura`) REFERENCES `facturas` (`id_factura`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_det_tratamiento` FOREIGN KEY (`id_tratamiento`) REFERENCES `tratamientos` (`id_tratamiento`) ON DELETE SET NULL;

--
-- Filtros para la tabla `historia_clinica`
--
ALTER TABLE `historia_clinica`
    ADD CONSTRAINT `fk_historia_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id_paciente`);

--
-- Filtros para la tabla `pacientes`
--
ALTER TABLE `pacientes`
    ADD CONSTRAINT `fk_paciente_usuario` FOREIGN KEY (`created_by`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL;

--
-- Filtros para la tabla `paciente_tratamiento`
--
ALTER TABLE `paciente_tratamiento`
    ADD CONSTRAINT `fk_pt_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id_paciente`),
  ADD CONSTRAINT `fk_pt_profesional` FOREIGN KEY (`id_profesional`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `fk_pt_tratamiento` FOREIGN KEY (`id_tratamiento`) REFERENCES `tratamientos` (`id_tratamiento`);

--
-- Filtros para la tabla `pagos`
--
ALTER TABLE `pagos`
    ADD CONSTRAINT `fk_pago_factura` FOREIGN KEY (`id_factura`) REFERENCES `facturas` (`id_factura`),
  ADD CONSTRAINT `fk_pago_usuario` FOREIGN KEY (`registrado_por`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL;

--
-- Filtros para la tabla `rolpermiso`
--
ALTER TABLE `rolpermiso`
    ADD CONSTRAINT `rolpermiso_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`) ON DELETE CASCADE,
  ADD CONSTRAINT `rolpermiso_ibfk_2` FOREIGN KEY (`id_rol_permiso`) REFERENCES `rol_permiso` (`id_permiso`) ON DELETE CASCADE;

--
-- Filtros para la tabla `sesiones_tratamiento`
--
ALTER TABLE `sesiones_tratamiento`
    ADD CONSTRAINT `fk_ses_cita` FOREIGN KEY (`id_cita`) REFERENCES `citas` (`id_cita`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_ses_pt` FOREIGN KEY (`id_paciente_tratamiento`) REFERENCES `paciente_tratamiento` (`id_paciente_tratamiento`);

--
-- Filtros para la tabla `tratamientos`
--
ALTER TABLE `tratamientos`
    ADD CONSTRAINT `fk_trat_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categorias_tratamiento` (`id_categoria`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
    ADD CONSTRAINT `fk_usuario_rol` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
