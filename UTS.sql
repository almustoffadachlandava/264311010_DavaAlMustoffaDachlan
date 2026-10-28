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

-- Sesi login lengkap dengan nama pengguna, kelompok akses, perangkat, dan lab
SELECT s.id_sesi, s.waktu_login, s.waktu_logout,
       u.nama AS pengguna,
       k.nama_kelompok AS kelompok_akses,
       pr.nama_perangkat AS perangkat,
       l.nama_lab AS lab,
       TIMESTAMPDIFF(MINUTE, s.waktu_login, s.waktu_logout) AS durasi_menit
FROM sesi_login s
JOIN pengguna u       ON s.id_pengguna = u.id_pengguna
JOIN kelompok_akses k ON u.id_kelompok_akses = k.id_kelompok_akses
JOIN perangkat pr     ON s.id_perangkat = pr.id_perangkat
JOIN lab l            ON pr.id_lab = l.id_lab;

-- Perangkat yang bermasalah beserta lab-nya
SELECT pr.id_perangkat, pr.nama_perangkat, pr.sistem_operasi, pr.status, l.nama_lab
FROM perangkat pr
JOIN lab l ON pr.id_lab = l.id_lab
WHERE pr.status = 'bermasalah';

-- Sesi yang masih aktif (belum logout)
SELECT s.id_sesi, u.nama, pr.nama_perangkat, s.waktu_login
FROM sesi_login s
JOIN pengguna u   ON s.id_pengguna = u.id_pengguna
JOIN perangkat pr ON s.id_perangkat = pr.id_perangkat
WHERE s.waktu_logout IS NULL;

-- Pengguna non-aktif
SELECT id_pengguna, nama, email
FROM pengguna
WHERE status_aktif = 0;

-- Total durasi pemakaian (menit) tiap pengguna
SELECT u.nama, COUNT(s.id_sesi) AS jumlah_sesi,
       SUM(TIMESTAMPDIFF(MINUTE, s.waktu_login, s.waktu_logout)) AS total_menit
FROM pengguna u
JOIN sesi_login s ON u.id_pengguna = s.id_pengguna
GROUP BY u.nama;

-- Jumlah perangkat tiap lab berdasarkan status
SELECT l.nama_lab, pr.status, COUNT(*) AS jumlah
FROM lab l
JOIN perangkat pr ON l.id_lab = pr.id_lab
GROUP BY l.nama_lab, pr.status;

-- Pengujian yang ditolak

-- Ditolak: email sudah ada (melanggar UNIQUE pada email)
INSERT INTO pengguna (nama, email, password_hash, id_kelompok_akses)
VALUES ('Tes', 'budi@kampus.ac.id', 'x', 1);

-- Ditolak: status_aktif bukan 0/1 (melanggar chk_pengguna_status)
INSERT INTO pengguna (nama, email, password_hash, status_aktif, id_kelompok_akses)
VALUES ('Tes', 'tes@kampus.ac.id', 'x', 5, 1);

-- Ditolak: kelompok akses 99 tidak ada (melanggar fk_pengguna_kelompok)
INSERT INTO pengguna (nama, email, password_hash, id_kelompok_akses)
VALUES ('Tes', 'tes2@kampus.ac.id', 'x', 99);

-- Ditolak: sistem operasi tidak ada di ENUM
INSERT INTO perangkat (nama_perangkat, sistem_operasi, status, id_lab)
VALUES ('PC-X', 'MacOS', 'online', 1);

-- Ditolak: lab 99 tidak ada (melanggar fk_perangkat_lab)
INSERT INTO perangkat (nama_perangkat, sistem_operasi, id_lab)
VALUES ('PC-X', 'Linux', 99);

-- Ditolak: logout lebih awal dari login (melanggar chk_sesi_waktu)
INSERT INTO sesi_login (id_pengguna, id_perangkat, waktu_login, waktu_logout)
VALUES (1, 1, '2026-10-28 10:00:00', '2026-10-28 09:00:00');

-- Ditolak: pengguna 99 tidak ada (melanggar fk_sesi_pengguna)
INSERT INTO sesi_login (id_pengguna, id_perangkat) VALUES (99, 1);

-- Ditolak: perangkat 99 tidak ada (melanggar fk_sesi_perangkat)
INSERT INTO sesi_login (id_pengguna, id_perangkat) VALUES (1, 99);

-- Ditolak: lab masih dipakai perangkat (melanggar ON DELETE RESTRICT)
DELETE FROM lab WHERE id_lab = 1;

-- Ditolak: pengguna masih punya riwayat sesi (melanggar ON DELETE RESTRICT)
DELETE FROM pengguna WHERE id_pengguna = 2;
