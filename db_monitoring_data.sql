-- Membuat tabel max_suhu_daily untuk menyimpan suhu tertinggi harian

CREATE TABLE IF NOT EXISTS max_suhu_daily (
    id INT AUTO_INCREMENT PRIMARY KEY,
    max_value FLOAT NOT NULL,
    date DATE NOT NULL UNIQUE, -- Kolom 'date' akan unik untuk memastikan satu entri per hari
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Membuat tabel max_turbidity_daily untuk menyimpan turbidity tertinggi harian
CREATE TABLE IF NOT EXISTS max_turbidity_daily (
    id INT AUTO_INCREMENT PRIMARY KEY,
    max_value FLOAT NOT NULL,
    date DATE NOT NULL UNIQUE, -- Kolom 'date' akan unik untuk memastikan satu entri per hari
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
