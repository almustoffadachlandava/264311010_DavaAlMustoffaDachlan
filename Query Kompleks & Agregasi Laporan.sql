SELECT
    l.nama_lab, COUNT(s.id_sesi) AS jumlah_sesi_aktif
FROM lab_komputer AS l
JOIN perangkat AS p
    ON p.id_lab = l.id_lab
JOIN sesi_login AS s
    ON s.id_perangkat = p.id_perangkat
WHERE s.waktu_logout IS NULL
GROUP BY l.id_lab, l.nama_lab;
