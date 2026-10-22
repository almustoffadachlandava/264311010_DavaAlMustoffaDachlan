-- [CREATE] --

INSERT INTO pengguna
    (id_pengguna, nama, email, password_hash,
     status_aktif, id_kelompok_akses)
VALUES
    (101, 'Andi Pratama', 'andi.crud101@nexora.test', 'dummy_hash_101', 1, 1),

    (102, 'Bunga Lestari', 'bunga.crud102@nexora.test', 'dummy_hash_102', 1, 2),

    (103, 'Citra Maharani', 'citra.crud103@nexora.test', 'dummy_hash_103', 1, 3);

INSERT INTO perangkat
    (id_perangkat, nama_perangkat, sistem_operasi, status, id_lab)
VALUES
    (101, 'CRUD-PC-01', 'Windows', 'online', 1),
    (102, 'CRUD-PC-02', 'Linux', 'offline', 2),
    (103, 'CRUD-PC-03', 'Windows', 'bermasalah', 3);

INSERT INTO sesi_login
    (id_sesi, id_pengguna, id_perangkat, waktu_login, waktu_logout)
VALUES
    (101, 101, 101, '2026-10-22 08:00:00', '2026-10-22 09:00:00'),

    (102, 102, 102, '2026-10-22 09:15:00', NULL),

    (103, 103, 103, '2026-10-22 10:00:00', NULL);

-- [READ] --

SELECT * FROM pengguna;

-- [UPDATE] --

UPDATE sesi_login
SET waktu_logout = '2026-10-22 11:00:00'
WHERE id_sesi = 102;

-- [DELETE] --

DELETE FROM sesi_login
WHERE id_sesi = 103;
