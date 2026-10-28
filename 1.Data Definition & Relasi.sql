CREATE TABLE pengguna (
    id_pengguna        INT AUTO_INCREMENT PRIMARY KEY,
    nama               VARCHAR(100) NOT NULL,
    email              VARCHAR(100) NOT NULL UNIQUE,
    password_hash      VARCHAR(255) NOT NULL,
    status_aktif       TINYINT(1)   NOT NULL DEFAULT 1,
    id_kelompok_akses  INT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE perangkat (
    id_perangkat    INT AUTO_INCREMENT PRIMARY KEY,
    nama_perangkat  VARCHAR(100) NOT NULL,
    sistem_operasi  ENUM('Linux','Windows') NOT NULL,
    status          ENUM('online','offline','bermasalah') NOT NULL DEFAULT 'offline',
    id_lab          INT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE sesi_login (
    id_sesi       BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_pengguna   INT NOT NULL,
    id_perangkat  INT NOT NULL,
    waktu_login   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    waktu_logout  DATETIME NULL,

    CONSTRAINT fk_sesi_pengguna FOREIGN KEY (id_pengguna)
        REFERENCES pengguna(id_pengguna)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_sesi_perangkat FOREIGN KEY (id_perangkat)
        REFERENCES perangkat(id_perangkat)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
