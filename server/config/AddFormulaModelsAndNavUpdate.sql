-- Migration: AddFormulaModelsAndNavUpdate
-- Created: 2025-08-19

-- Create products table
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    sku VARCHAR(50) NOT NULL UNIQUE,
    unit VARCHAR(20) NOT NULL DEFAULT 'UNIDAD',
    is_finished_product BOOLEAN NOT NULL DEFAULT false,
    precio FLOAT,
    stock INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create inventory_items table
CREATE TABLE IF NOT EXISTS inventory_items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    sku VARCHAR(50) NOT NULL UNIQUE,
    unit VARCHAR(20) NOT NULL DEFAULT 'KG',
    unit_cost FLOAT NOT NULL,
    quantity_on_hand FLOAT NOT NULL DEFAULT 0,
    row_version INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create formulas table
CREATE TABLE IF NOT EXISTS formulas (
    id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Create formula_items table
CREATE TABLE IF NOT EXISTS formula_items (
    id SERIAL PRIMARY KEY,
    formula_id INTEGER NOT NULL,
    inventory_item_id INTEGER NOT NULL,
    quantity_per_unit FLOAT NOT NULL,
    FOREIGN KEY (formula_id) REFERENCES formulas(id) ON DELETE CASCADE,
    FOREIGN KEY (inventory_item_id) REFERENCES inventory_items(id) ON DELETE CASCADE
);

-- Insert seed data for testing
INSERT INTO products (name, sku, unit, is_finished_product, precio, stock) VALUES 
('Pan Integral', 'PAN-INT-001', 'UNIDAD', true, 2500, 0),
('Empanada de Pollo', 'EMP-POL-001', 'UNIDAD', true, 1500, 0)
ON CONFLICT (sku) DO NOTHING;

INSERT INTO inventory_items (name, sku, unit, unit_cost, quantity_on_hand) VALUES 
('Harina Integral', 'HAR-INT-001', 'KG', 1200, 50),
('Sal', 'SAL-001', 'KG', 800, 25),
('Levadura', 'LEV-001', 'GR', 2500, 5),
('Pollo Desmechado', 'POL-DES-001', 'KG', 8500, 10),
('Masa para Empanadas', 'MAS-EMP-001', 'KG', 3500, 20)
ON CONFLICT (sku) DO NOTHING;
