-- ============================================================================
-- 1. DEFINICIÓN DE ESQUEMA (DDL)
-- ============================================================================

CREATE TABLE catalog (
    catalog_id      INT PRIMARY KEY,
    catalog_group   VARCHAR(30)  NOT NULL,
    code            VARCHAR(20)  NOT NULL,
    description     VARCHAR(100) NOT NULL,
    is_active       BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by      VARCHAR(50)  NOT NULL,
    updated_at      TIMESTAMP,
    updated_by      VARCHAR(50),
    CONSTRAINT uq_catalog_group_code UNIQUE (catalog_group, code)
);

CREATE TABLE student (
    student_id      INT PRIMARY KEY,
    user_type_id    INT          NOT NULL,
    enrollment_code VARCHAR(15)  NOT NULL UNIQUE,
    first_name      VARCHAR(60)  NOT NULL,
    last_name       VARCHAR(80)  NOT NULL,
    email           VARCHAR(100) NOT NULL UNIQUE,
    is_active       BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by      VARCHAR(50)  NOT NULL,
    updated_at      TIMESTAMP,
    updated_by      VARCHAR(50),
    CONSTRAINT fk_student_user_type FOREIGN KEY (user_type_id) REFERENCES catalog(catalog_id)
);

CREATE TABLE author (
    author_id       INT PRIMARY KEY,
    first_name      VARCHAR(60) NOT NULL,
    last_name       VARCHAR(80) NOT NULL,
    nationality     VARCHAR(50),
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by      VARCHAR(50) NOT NULL,
    updated_at      TIMESTAMP,
    updated_by      VARCHAR(50)
);

CREATE TABLE book (
    book_id          INT PRIMARY KEY,
    material_type_id INT          NOT NULL,
    category_id      INT          NOT NULL,
    isbn             VARCHAR(20)  NOT NULL UNIQUE,
    title            VARCHAR(150) NOT NULL,
    publication_year INT          NOT NULL CHECK (publication_year > 1450),
    is_active        BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by       VARCHAR(50)  NOT NULL,
    updated_at       TIMESTAMP,
    updated_by       VARCHAR(50),
    CONSTRAINT fk_book_material_type FOREIGN KEY (material_type_id) REFERENCES catalog(catalog_id),
    CONSTRAINT fk_book_category      FOREIGN KEY (category_id)      REFERENCES catalog(catalog_id)
);

CREATE TABLE book_author (
    book_id         INT         NOT NULL,
    author_id       INT         NOT NULL,
    author_order    INT         NOT NULL DEFAULT 1,
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by      VARCHAR(50) NOT NULL,
    updated_at      TIMESTAMP,
    updated_by      VARCHAR(50),
    PRIMARY KEY (book_id, author_id),
    CONSTRAINT fk_ba_book   FOREIGN KEY (book_id)   REFERENCES book(book_id)     ON DELETE CASCADE,
    CONSTRAINT fk_ba_author FOREIGN KEY (author_id) REFERENCES author(author_id) ON DELETE CASCADE
);

CREATE TABLE book_copy (
    copy_id         INT PRIMARY KEY,
    book_id         INT         NOT NULL,
    barcode         VARCHAR(20) NOT NULL UNIQUE,
    status          VARCHAR(20) NOT NULL CHECK (status IN ('Disponible', 'Prestado', 'Mantenimiento')),
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by      VARCHAR(50) NOT NULL,
    updated_at      TIMESTAMP,
    updated_by      VARCHAR(50),
    CONSTRAINT fk_copy_book FOREIGN KEY (book_id) REFERENCES book(book_id)
);

CREATE TABLE loan (
    loan_id         INT PRIMARY KEY,
    copy_id         INT         NOT NULL,
    student_id      INT         NOT NULL,
    loan_date       DATE        NOT NULL,
    due_date        DATE        NOT NULL,
    return_date     DATE,
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by      VARCHAR(50) NOT NULL,
    updated_at      TIMESTAMP,
    updated_by      VARCHAR(50),
    CONSTRAINT fk_loan_copy    FOREIGN KEY (copy_id)    REFERENCES book_copy(copy_id),
    CONSTRAINT fk_loan_student FOREIGN KEY (student_id) REFERENCES student(student_id),
    CONSTRAINT chk_loan_dates  CHECK (due_date >= loan_date)
);

CREATE TABLE reservation (
    reservation_id   INT PRIMARY KEY,
    book_id          INT         NOT NULL,
    student_id       INT         NOT NULL,
    reservation_date DATE        NOT NULL,
    status           VARCHAR(20) NOT NULL CHECK (status IN ('Activa', 'Completada', 'Cancelada')),
    is_active        BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by       VARCHAR(50) NOT NULL,
    updated_at       TIMESTAMP,
    updated_by       VARCHAR(50),
    CONSTRAINT fk_res_book    FOREIGN KEY (book_id)    REFERENCES book(book_id),
    CONSTRAINT fk_res_student FOREIGN KEY (student_id) REFERENCES student(student_id)
);