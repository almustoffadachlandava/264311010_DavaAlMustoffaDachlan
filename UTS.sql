CREATE TABLE kelompok_akses (
    id_kelompok_akses INT AUTO_INCREMENT PRIMARY KEY,
    nama_kelompok     VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;
 
CREATE TABLE lab (
    id_lab   INT AUTO_INCREMENT PRIMARY KEY,
    nama_lab VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;
 
CREATE TABLE pengguna (
    id_pengguna       INT AUTO_INCREMENT PRIMARY KEY,
    nama              VARCHAR(100) NOT NULL,
    email             VARCHAR(100) NOT NULL UNIQUE,
    password_hash     VARCHAR(255) NOT NULL,
    status_aktif      TINYINT(1)   NOT NULL DEFAULT 1,
    id_kelompok_akses INT NOT NULL,
    CONSTRAINT chk_pengguna_status CHECK (status_aktif IN (0, 1)),
    CONSTRAINT fk_pengguna_kelompok FOREIGN KEY (id_kelompok_akses)
        REFERENCES kelompok_akses(id_kelompok_akses)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
 
CREATE TABLE perangkat (
    id_perangkat   INT AUTO_INCREMENT PRIMARY KEY,
    nama_perangkat VARCHAR(100) NOT NULL,
    sistem_operasi ENUM('Linux','Windows') NOT NULL,
    status         ENUM('online','offline','bermasalah') NOT NULL DEFAULT 'offline',
    id_lab         INT NOT NULL,
    CONSTRAINT fk_perangkat_lab FOREIGN KEY (id_lab)
        REFERENCES lab(id_lab)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
 
CREATE TABLE sesi_login (
    id_sesi      BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_pengguna  INT NOT NULL,
    id_perangkat INT NOT NULL,
    waktu_login  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    waktu_logout DATETIME NULL,
    CONSTRAINT chk_sesi_waktu CHECK (waktu_logout IS NULL OR waktu_logout >= waktu_login),
    CONSTRAINT fk_sesi_pengguna FOREIGN KEY (id_pengguna)
        REFERENCES pengguna(id_pengguna)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_sesi_perangkat FOREIGN KEY (id_perangkat)
        REFERENCES perangkat(id_perangkat)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
