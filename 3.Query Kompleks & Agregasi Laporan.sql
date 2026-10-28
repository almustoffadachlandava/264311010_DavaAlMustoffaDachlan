SELECT p.nama_perangkat,
       COUNT(s.id_sesi) AS jumlah_sesi,
       SUM(TIMESTAMPDIFF(MINUTE, s.waktu_login, s.waktu_logout)) AS total_menit
FROM perangkat AS p
JOIN sesi_login AS s
    ON s.id_perangkat = p.id_perangkat
WHERE s.waktu_logout IS NOT NULL
GROUP BY p.id_perangkat, p.nama_perangkat;
