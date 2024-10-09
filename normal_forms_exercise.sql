CREATE TABLE rendelesek (
    vasarlo_nev VARCHAR(100),
    vasarlo_adat VARCHAR(255),
    termek_nev VARCHAR(100),
    termek_mennyiseg INT,
    termek_ar VARCHAR(50),
    termek_nev_2 VARCHAR(100),
    termek_mennyiseg_2 INT,
    termek_ar_2 VARCHAR(50)
);



INSERT INTO rendelesek (vasarlo_nev, vasarlo_adat, termek_nev, termek_mennyiseg, termek_ar, termek_nev_2, termek_mennyiseg_2, termek_ar_2)
VALUES
('Kovács Anna', 'Budapest, 06-30-1234567', 'Laptop', 1, '250 000 Ft', 'Laptop tartó', 1, '3 000 Ft'),
('Kovács Anna', 'Budapest, 06-30-1234567', 'Egér', 2, '5 000 Ft', 'Billentyűzet', 1, '8 000 Ft'),
('Tóth Béla', 'Debrecen, 06-20-7654321', 'Monitor', 1, '50 000 Ft', 'Billentyűzet', 1, '8 000 Ft'),
('Kovács Anna', 'Budapest, 06-30-1234567', 'Billentyűzet', 1, '8 000 Ft', 'Monitor', 2, '50 000 Ft'),
('Kovács Anna', 'Budapest, 06-30-1234567', 'Laptop tartó', 1, '3 000 Ft', 'Billentyűzet', 1, '8 000 Ft'),
('Nagy Gábor', 'Szeged, 06-70-9876543', 'Nyomtató', 1, '70 000 Ft', 'Billentyűzet', 2, '8 000 Ft'),
('Nagy Gábor', 'Szeged, 06-70-9876543', 'Tinta', 3, '2 000 Ft', 'Billentyűzet', 2, '8 000 Ft');
