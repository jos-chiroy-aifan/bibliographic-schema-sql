-- ============================================================================
-- CONSULTA 1: Listado de préstamos activos ordenados por fecha prevista
-- ============================================================================
SELECT loan_id, copy_id, student_id, loan_date, due_date
FROM loan
WHERE return_date IS NULL
  AND is_active = TRUE
ORDER BY due_date ASC;

-- ============================================================================
-- CONSULTA 2: Libros publicados desde un año concreto y de una categoría
-- ============================================================================
SELECT b.book_id, b.isbn, b.title, b.publication_year, c.description AS category
FROM book b
INNER JOIN catalog c ON b.category_id = c.catalog_id
WHERE b.publication_year >= 2014
  AND c.code = 'BD'
  AND c.catalog_group = 'CATEGORY'
ORDER BY b.publication_year DESC;

-- ============================================================================
-- CONSULTA 3: Estudiantes que tienen préstamos activos
-- ============================================================================
SELECT DISTINCT s.student_id, s.enrollment_code, s.first_name, s.last_name, s.email
FROM student s
INNER JOIN loan l ON s.student_id = l.student_id
WHERE l.return_date IS NULL
ORDER BY s.last_name ASC;

-- ============================================================================
-- CONSULTA 4: Libros con su número total de préstamos
-- ============================================================================
SELECT b.book_id, b.title, COUNT(l.loan_id) AS total_loans
FROM book b
LEFT JOIN book_copy bc ON b.book_id = bc.book_id
LEFT JOIN loan l ON bc.copy_id = l.copy_id
GROUP BY b.book_id, b.title
ORDER BY total_loans DESC, b.title ASC;

-- ============================================================================
-- CONSULTA 5: Categorías con más de un préstamo registrado
-- ============================================================================
SELECT c.description AS category, COUNT(l.loan_id) AS total_loans
FROM catalog c
INNER JOIN book b ON c.catalog_id = b.category_id
INNER JOIN book_copy bc ON b.book_id = bc.book_id
INNER JOIN loan l ON bc.copy_id = l.copy_id
WHERE c.catalog_group = 'CATEGORY'
GROUP BY c.catalog_id, c.description
HAVING COUNT(l.loan_id) > 1
ORDER BY total_loans DESC;

-- ============================================================================
-- CONSULTA 6: Estudiantes con préstamos o reservas (Operación de conjunto)
-- ============================================================================
SELECT s.student_id, s.enrollment_code, s.first_name, s.last_name
FROM student s
INNER JOIN loan l ON s.student_id = l.student_id
UNION
SELECT s.student_id, s.enrollment_code, s.first_name, s.last_name
FROM student s
INNER JOIN reservation r ON s.student_id = r.student_id
ORDER BY student_id ASC;

-- ============================================================================
-- CONSULTA 7: Libros prestados y también reservados (Operación de conjunto)
-- ============================================================================
SELECT b.book_id, b.isbn, b.title
FROM book b
INNER JOIN book_copy bc ON b.book_id = bc.book_id
INNER JOIN loan l ON bc.copy_id = l.copy_id
INTERSECT
SELECT b.book_id, b.isbn, b.title
FROM book b
INNER JOIN reservation r ON b.book_id = r.book_id
ORDER BY book_id ASC;

-- ============================================================================
-- CONSULTA 8: Libros disponibles que nunca han sido prestados
-- ============================================================================
SELECT DISTINCT b.book_id, b.isbn, b.title
FROM book b
INNER JOIN book_copy bc ON b.book_id = bc.book_id
WHERE bc.status = 'Disponible'
  AND b.book_id NOT IN (
      SELECT bc2.book_id
      FROM book_copy bc2
      INNER JOIN loan l ON bc2.copy_id = l.copy_id
  );

-- ============================================================================
-- CONSULTA 9: Préstamos donde return_date es NULL
-- ============================================================================
SELECT l.loan_id, s.enrollment_code, s.first_name, s.last_name,
       b.title, bc.barcode, l.loan_date, l.due_date
FROM loan l
INNER JOIN student s ON l.student_id = s.student_id
INNER JOIN book_copy bc ON l.copy_id = bc.copy_id
INNER JOIN book b ON bc.book_id = b.book_id
WHERE l.return_date IS NULL
ORDER BY l.loan_date ASC;

-- ============================================================================
-- CONSULTA 10: Media de días de préstamo de los préstamos devueltos
-- ============================================================================
SELECT ROUND(AVG(return_date - loan_date), 2) AS avg_loan_days
FROM loan
WHERE return_date IS NOT NULL;