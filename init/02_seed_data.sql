-- ============================================================================
-- 2. CARGA DE DATOS DE PRUEBA (DML)
-- ============================================================================

-- Catálogos maestros (Tipos de usuario, Tipos de material y Categorías)
INSERT INTO catalog (catalog_id, catalog_group, code, description, created_by) VALUES
(1,  'USER_TYPE',     'GRADO',   'Estudiante de Grado',     'admin_sys'),
(2,  'USER_TYPE',     'POSGR',   'Estudiante de Posgrado',  'admin_sys'),
(3,  'MATERIAL_TYPE', 'LIBRO',   'Libro Impreso',           'admin_sys'),
(4,  'MATERIAL_TYPE', 'MANUAL',  'Manual Técnico',          'admin_sys'),
(5,  'CATEGORY',      'BD',      'Bases de Datos',          'admin_sys'),
(6,  'CATEGORY',      'ISW',     'Ingeniería de Software',  'admin_sys'),
(7,  'CATEGORY',      'SO',      'Sistemas Operativos',     'admin_sys'),
(8,  'CATEGORY',      'REDES',   'Redes de Computadoras',   'admin_sys');

-- 5 Estudiantes (mínimo requerido: 5)
INSERT INTO student (student_id, user_type_id, enrollment_code, first_name, last_name, email, created_by) VALUES
(1, 1, 'MAT-2026-01', 'Ana',    'Gómez López',    'ana.gomez@universidad.edu',     'admin_sys'),
(2, 1, 'MAT-2026-02', 'Carlos', 'Ruiz Martín',    'carlos.ruiz@universidad.edu',   'admin_sys'),
(3, 2, 'MAT-2026-03', 'Lucía',  'Fernández Gil',  'lucia.fernandez@universidad.edu','admin_sys'),
(4, 1, 'MAT-2026-04', 'Miguel', 'Torres Díaz',    'miguel.torres@universidad.edu', 'admin_sys'),
(5, 2, 'MAT-2026-05', 'Sofía',  'Navarro Soto',   'sofia.navarro@universidad.edu', 'admin_sys');

-- 4 Autores (mínimo requerido: 4)
INSERT INTO author (author_id, first_name, last_name, nationality, created_by) VALUES
(1, 'Abraham',   'Silberschatz', 'Estadounidense', 'admin_sys'),
(2, 'Henry F.',  'Korth',        'Estadounidense', 'admin_sys'),
(3, 'Robert C.', 'Martin',       'Estadounidense', 'admin_sys'),
(4, 'Andrew S.', 'Tanenbaum',    'Estadounidense', 'admin_sys');

-- 6 Libros (mínimo requerido: 6)
INSERT INTO book (book_id, material_type_id, category_id, isbn, title, publication_year, created_by) VALUES
(1, 3, 5, '9788448146443', 'Fundamentos de Bases de Datos',         2014, 'admin_sys'),
(2, 3, 6, '9780132350884', 'Clean Code',                            2008, 'admin_sys'),
(3, 3, 7, '9786073203296', 'Sistemas Operativos Modernos',          2015, 'admin_sys'),
(4, 3, 6, '9788441539907', 'Arquitectura Limpia',                   2018, 'admin_sys'),
(5, 4, 5, '9788499645210', 'Diseño de Bases de Datos Relacionales', 2021, 'admin_sys'),
(6, 3, 8, '9786073208178', 'Redes de Computadoras',                 2012, 'admin_sys');

-- Relación N:M Libro - Autor (incluye coautoría en el libro 1)
INSERT INTO book_author (book_id, author_id, author_order, created_by) VALUES
(1, 1, 1, 'admin_sys'),
(1, 2, 2, 'admin_sys'),
(2, 3, 1, 'admin_sys'),
(3, 4, 1, 'admin_sys'),
(4, 3, 1, 'admin_sys'),
(5, 1, 1, 'admin_sys'),
(6, 4, 1, 'admin_sys');

-- 8 Ejemplares físicos (mínimo requerido: 8)
INSERT INTO book_copy (copy_id, book_id, barcode, status, created_by) VALUES
(1, 1, 'BC-001', 'Prestado',   'admin_sys'),
(2, 1, 'BC-002', 'Disponible', 'admin_sys'),
(3, 2, 'BC-003', 'Disponible', 'admin_sys'),
(4, 3, 'BC-004', 'Prestado',   'admin_sys'),
(5, 4, 'BC-005', 'Disponible', 'admin_sys'),
(6, 5, 'BC-006', 'Prestado',   'admin_sys'),
(7, 6, 'BC-007', 'Disponible', 'admin_sys'),
(8, 4, 'BC-008', 'Disponible', 'admin_sys');

-- 8 Préstamos (mínimo requerido: 8; incluye 3 activos con return_date = NULL)
INSERT INTO loan (loan_id, copy_id, student_id, loan_date, due_date, return_date, created_by) VALUES
(1, 1, 1, '2026-10-01', '2026-10-15', '2026-10-11', 'biblio_01'),
(2, 2, 2, '2026-10-05', '2026-10-19', '2026-10-19', 'biblio_01'),
(3, 3, 1, '2026-10-10', '2026-10-24', '2026-10-18', 'biblio_02'),
(4, 4, 3, '2026-10-12', '2026-10-26', '2026-10-24', 'biblio_01'),
(5, 5, 2, '2026-11-01', '2026-11-15', '2026-11-17', 'biblio_02'),
(6, 1, 3, '2026-11-15', '2026-11-29', NULL,         'biblio_01'),
(7, 4, 1, '2026-11-18', '2026-12-02', NULL,         'biblio_02'),
(8, 6, 2, '2026-11-20', '2026-11-27', NULL,         'biblio_01');

-- 4 Reservas (mínimo requerido: 4)
INSERT INTO reservation (reservation_id, book_id, student_id, reservation_date, status, created_by) VALUES
(1, 1, 4, '2026-11-16', 'Activa',     'biblio_01'),
(2, 3, 2, '2026-11-19', 'Activa',     'biblio_02'),
(3, 6, 1, '2026-11-21', 'Activa',     'biblio_01'),
(4, 4, 3, '2026-10-25', 'Completada', 'biblio_02');