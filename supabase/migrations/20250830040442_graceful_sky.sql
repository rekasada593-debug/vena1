/*
  # Create Complete Database Schema for Vena Pictures

  1. New Tables
    - `users` - User accounts with roles and permissions
    - `profiles` - Company profile and configuration settings
    - `clients` - Client information and portal access
    - `leads` - Lead management and tracking
    - `packages` - Service packages with pricing
    - `add_ons` - Additional services and items
    - `team_members` - Freelancer and team member data
    - `projects` - Project management with status tracking
    - `transactions` - Financial transactions
    - `financial_pockets` - Budget and savings management
    - `cards` - Payment cards and accounts
    - `assets` - Equipment and asset tracking
    - `contracts` - Contract management with e-signatures
    - `promo_codes` - Discount codes and promotions
    - `sops` - Standard Operating Procedures
    - `notifications` - System notifications
    - `client_feedback` - Client satisfaction tracking
    - `social_media_posts` - Social media planning
    - `team_project_payments` - Freelancer payment tracking
    - `team_payment_records` - Payment records and slips
    - `reward_ledger_entries` - Reward system tracking

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
    - Create indexes for performance

  3. Features
    - UUID primary keys with auto-generation
    - Automatic timestamp updates
    - Foreign key relationships
    - Sample data for testing
*/

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    company_name VARCHAR(255),
    role VARCHAR(20) CHECK (role IN ('Admin', 'Member')) NOT NULL DEFAULT 'Member',
    permissions TEXT[], -- Array of ViewType permissions
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Profiles table
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    admin_user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    company_name VARCHAR(255) NOT NULL,
    website VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    bank_account VARCHAR(255) NOT NULL,
    authorized_signer VARCHAR(255) NOT NULL,
    id_number VARCHAR(50),
    bio TEXT NOT NULL,
    income_categories TEXT[] DEFAULT ARRAY[]::TEXT[],
    expense_categories TEXT[] DEFAULT ARRAY[]::TEXT[],
    project_types TEXT[] DEFAULT ARRAY[]::TEXT[],
    event_types TEXT[] DEFAULT ARRAY[]::TEXT[],
    asset_categories TEXT[] DEFAULT ARRAY[]::TEXT[],
    sop_categories TEXT[] DEFAULT ARRAY[]::TEXT[],
    package_categories TEXT[] DEFAULT ARRAY[]::TEXT[],
    project_status_config JSONB DEFAULT '[]'::JSONB,
    notification_settings JSONB DEFAULT '{}'::JSONB,
    security_settings JSONB DEFAULT '{}'::JSONB,
    briefing_template TEXT NOT NULL,
    terms_and_conditions TEXT,
    contract_template TEXT,
    logo_base64 TEXT,
    brand_color VARCHAR(7),
    public_page_config JSONB DEFAULT '{}'::JSONB,
    package_share_template TEXT,
    booking_form_template TEXT,
    chat_templates JSONB DEFAULT '[]'::JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Clients table
CREATE TABLE IF NOT EXISTS clients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    whatsapp VARCHAR(50),
    since VARCHAR(50) NOT NULL,
    instagram VARCHAR(255),
    status VARCHAR(50) NOT NULL,
    client_type VARCHAR(50) NOT NULL,
    last_contact VARCHAR(50) NOT NULL,
    portal_access_id VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Leads table
CREATE TABLE IF NOT EXISTS leads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    contact_channel VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    status VARCHAR(100) NOT NULL,
    date VARCHAR(50) NOT NULL,
    notes TEXT,
    whatsapp VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Packages table
CREATE TABLE IF NOT EXISTS packages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    price DECIMAL(15,2) NOT NULL,
    category VARCHAR(255) NOT NULL,
    physical_items JSONB DEFAULT '[]'::JSONB,
    digital_items TEXT[] DEFAULT ARRAY[]::TEXT[],
    processing_time VARCHAR(255) NOT NULL,
    default_printing_cost DECIMAL(15,2),
    default_transport_cost DECIMAL(15,2),
    photographers VARCHAR(255),
    videographers VARCHAR(255),
    cover_image TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add-ons table
CREATE TABLE IF NOT EXISTS add_ons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    price DECIMAL(15,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Team members table
CREATE TABLE IF NOT EXISTS team_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    role VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    standard_fee DECIMAL(15,2) NOT NULL,
    no_rek VARCHAR(255),
    reward_balance DECIMAL(15,2) DEFAULT 0,
    rating DECIMAL(3,2) DEFAULT 0 CHECK (rating >= 0 AND rating <= 5),
    performance_notes JSONB DEFAULT '[]'::JSONB,
    portal_access_id VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Projects table
CREATE TABLE IF NOT EXISTS projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_name VARCHAR(255) NOT NULL,
    client_name VARCHAR(255) NOT NULL,
    client_id UUID REFERENCES clients(id) ON DELETE CASCADE,
    project_type VARCHAR(255) NOT NULL,
    package_name VARCHAR(255) NOT NULL,
    package_id UUID REFERENCES packages(id),
    add_ons JSONB DEFAULT '[]'::JSONB,
    date VARCHAR(50) NOT NULL,
    deadline_date VARCHAR(50),
    location VARCHAR(255) NOT NULL,
    progress INTEGER DEFAULT 0 CHECK (progress >= 0 AND progress <= 100),
    status VARCHAR(255) NOT NULL,
    active_sub_statuses TEXT[],
    total_cost DECIMAL(15,2) NOT NULL,
    amount_paid DECIMAL(15,2) DEFAULT 0,
    payment_status VARCHAR(100) NOT NULL,
    team JSONB DEFAULT '[]'::JSONB,
    notes TEXT,
    accommodation TEXT,
    drive_link VARCHAR(500),
    client_drive_link VARCHAR(500),
    final_drive_link VARCHAR(500),
    start_time VARCHAR(50),
    end_time VARCHAR(50),
    image VARCHAR(500),
    revisions JSONB DEFAULT '[]'::JSONB,
    promo_code_id UUID,
    discount_amount DECIMAL(15,2),
    shipping_details TEXT,
    dp_proof_url VARCHAR(500),
    printing_details JSONB DEFAULT '[]'::JSONB,
    printing_cost DECIMAL(15,2),
    transport_cost DECIMAL(15,2),
    is_editing_confirmed_by_client BOOLEAN DEFAULT FALSE,
    is_printing_confirmed_by_client BOOLEAN DEFAULT FALSE,
    is_delivery_confirmed_by_client BOOLEAN DEFAULT FALSE,
    confirmed_sub_statuses TEXT[],
    client_sub_status_notes JSONB DEFAULT '{}'::JSONB,
    sub_status_confirmation_sent_at JSONB DEFAULT '{}'::JSONB,
    completed_digital_items TEXT[],
    invoice_signature TEXT,
    custom_sub_statuses JSONB DEFAULT '[]'::JSONB,
    booking_status VARCHAR(100),
    rejection_reason TEXT,
    chat_history JSONB DEFAULT '[]'::JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Transactions table
CREATE TABLE IF NOT EXISTS transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    date VARCHAR(50) NOT NULL,
    description VARCHAR(500) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    type VARCHAR(100) NOT NULL,
    project_id UUID REFERENCES projects(id),
    category VARCHAR(255) NOT NULL,
    method VARCHAR(100) NOT NULL,
    pocket_id UUID,
    card_id UUID,
    printing_item_id VARCHAR(255),
    vendor_signature TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Financial pockets table
CREATE TABLE IF NOT EXISTS financial_pockets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    icon VARCHAR(100) NOT NULL,
    type VARCHAR(100) NOT NULL,
    amount DECIMAL(15,2) DEFAULT 0,
    goal_amount DECIMAL(15,2),
    lock_end_date VARCHAR(50),
    members JSONB DEFAULT '[]'::JSONB,
    source_card_id UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Cards table
CREATE TABLE IF NOT EXISTS cards (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    card_holder_name VARCHAR(255) NOT NULL,
    bank_name VARCHAR(255) NOT NULL,
    card_type VARCHAR(100) NOT NULL,
    last_four_digits VARCHAR(4) NOT NULL,
    expiry_date VARCHAR(10),
    balance DECIMAL(15,2) DEFAULT 0,
    color_gradient VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Assets table
CREATE TABLE IF NOT EXISTS assets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    category VARCHAR(255) NOT NULL,
    purchase_date VARCHAR(50) NOT NULL,
    purchase_price DECIMAL(15,2) NOT NULL,
    serial_number VARCHAR(255),
    status VARCHAR(100) NOT NULL,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Contracts table
CREATE TABLE IF NOT EXISTS contracts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    contract_number VARCHAR(255) UNIQUE NOT NULL,
    client_id UUID REFERENCES clients(id) ON DELETE CASCADE,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    signing_date VARCHAR(50) NOT NULL,
    signing_location VARCHAR(255) NOT NULL,
    client_name1 VARCHAR(255) NOT NULL,
    client_address1 TEXT NOT NULL,
    client_phone1 VARCHAR(50) NOT NULL,
    client_name2 VARCHAR(255),
    client_address2 TEXT,
    client_phone2 VARCHAR(50),
    shooting_duration VARCHAR(255) NOT NULL,
    guaranteed_photos VARCHAR(255) NOT NULL,
    album_details TEXT NOT NULL,
    digital_files_format VARCHAR(255) NOT NULL,
    other_items TEXT NOT NULL,
    personnel_count VARCHAR(255) NOT NULL,
    delivery_timeframe VARCHAR(255) NOT NULL,
    dp_date VARCHAR(50) NOT NULL,
    final_payment_date VARCHAR(50) NOT NULL,
    cancellation_policy TEXT NOT NULL,
    jurisdiction VARCHAR(255) NOT NULL,
    vendor_signature TEXT,
    client_signature TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Promo codes table
CREATE TABLE IF NOT EXISTS promo_codes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) UNIQUE NOT NULL,
    discount_type VARCHAR(50) NOT NULL,
    discount_value DECIMAL(15,2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    usage_count INTEGER DEFAULT 0,
    max_usage INTEGER,
    expiry_date VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- SOPs table
CREATE TABLE IF NOT EXISTS sops (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    category VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    last_updated VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notifications table
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    timestamp VARCHAR(50) NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    icon VARCHAR(100) NOT NULL,
    link JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Client feedback table
CREATE TABLE IF NOT EXISTS client_feedback (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_name VARCHAR(255) NOT NULL,
    satisfaction VARCHAR(100) NOT NULL,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5) NOT NULL,
    feedback TEXT NOT NULL,
    date VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Social media posts table
CREATE TABLE IF NOT EXISTS social_media_posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    client_name VARCHAR(255) NOT NULL,
    post_type VARCHAR(100) NOT NULL,
    platform VARCHAR(100) NOT NULL,
    scheduled_date VARCHAR(50) NOT NULL,
    caption TEXT NOT NULL,
    media_url VARCHAR(500),
    status VARCHAR(100) NOT NULL,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Team project payments table
CREATE TABLE IF NOT EXISTS team_project_payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    team_member_name VARCHAR(255) NOT NULL,
    team_member_id UUID REFERENCES team_members(id) ON DELETE CASCADE,
    date VARCHAR(50) NOT NULL,
    status VARCHAR(100) NOT NULL,
    fee DECIMAL(15,2) NOT NULL,
    reward DECIMAL(15,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Team payment records table
CREATE TABLE IF NOT EXISTS team_payment_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    record_number VARCHAR(255) UNIQUE NOT NULL,
    team_member_id UUID REFERENCES team_members(id) ON DELETE CASCADE,
    date VARCHAR(50) NOT NULL,
    project_payment_ids TEXT[] NOT NULL,
    total_amount DECIMAL(15,2) NOT NULL,
    vendor_signature TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Reward ledger entries table
CREATE TABLE IF NOT EXISTS reward_ledger_entries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    team_member_id UUID REFERENCES team_members(id) ON DELETE CASCADE,
    date VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    project_id UUID REFERENCES projects(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_clients_portal_access_id ON clients(portal_access_id);
CREATE INDEX IF NOT EXISTS idx_team_members_portal_access_id ON team_members(portal_access_id);
CREATE INDEX IF NOT EXISTS idx_projects_client_id ON projects(client_id);
CREATE INDEX IF NOT EXISTS idx_projects_package_id ON projects(package_id);
CREATE INDEX IF NOT EXISTS idx_transactions_project_id ON transactions(project_id);
CREATE INDEX IF NOT EXISTS idx_contracts_client_id ON contracts(client_id);
CREATE INDEX IF NOT EXISTS idx_contracts_project_id ON contracts(project_id);

-- Add updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Add triggers to update updated_at automatically
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_profiles_updated_at') THEN
        CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_clients_updated_at') THEN
        CREATE TRIGGER update_clients_updated_at BEFORE UPDATE ON clients FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_leads_updated_at') THEN
        CREATE TRIGGER update_leads_updated_at BEFORE UPDATE ON leads FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_packages_updated_at') THEN
        CREATE TRIGGER update_packages_updated_at BEFORE UPDATE ON packages FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_add_ons_updated_at') THEN
        CREATE TRIGGER update_add_ons_updated_at BEFORE UPDATE ON add_ons FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_team_members_updated_at') THEN
        CREATE TRIGGER update_team_members_updated_at BEFORE UPDATE ON team_members FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_projects_updated_at') THEN
        CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_transactions_updated_at') THEN
        CREATE TRIGGER update_transactions_updated_at BEFORE UPDATE ON transactions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_financial_pockets_updated_at') THEN
        CREATE TRIGGER update_financial_pockets_updated_at BEFORE UPDATE ON financial_pockets FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_cards_updated_at') THEN
        CREATE TRIGGER update_cards_updated_at BEFORE UPDATE ON cards FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_assets_updated_at') THEN
        CREATE TRIGGER update_assets_updated_at BEFORE UPDATE ON assets FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_contracts_updated_at') THEN
        CREATE TRIGGER update_contracts_updated_at BEFORE UPDATE ON contracts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_promo_codes_updated_at') THEN
        CREATE TRIGGER update_promo_codes_updated_at BEFORE UPDATE ON promo_codes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_sops_updated_at') THEN
        CREATE TRIGGER update_sops_updated_at BEFORE UPDATE ON sops FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_notifications_updated_at') THEN
        CREATE TRIGGER update_notifications_updated_at BEFORE UPDATE ON notifications FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_client_feedback_updated_at') THEN
        CREATE TRIGGER update_client_feedback_updated_at BEFORE UPDATE ON client_feedback FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_social_media_posts_updated_at') THEN
        CREATE TRIGGER update_social_media_posts_updated_at BEFORE UPDATE ON social_media_posts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_team_project_payments_updated_at') THEN
        CREATE TRIGGER update_team_project_payments_updated_at BEFORE UPDATE ON team_project_payments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_team_payment_records_updated_at') THEN
        CREATE TRIGGER update_team_payment_records_updated_at BEFORE UPDATE ON team_payment_records FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_reward_ledger_entries_updated_at') THEN
        CREATE TRIGGER update_reward_ledger_entries_updated_at BEFORE UPDATE ON reward_ledger_entries FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END $$;

-- Enable Row Level Security on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE packages ENABLE ROW LEVEL SECURITY;
ALTER TABLE add_ons ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_pockets ENABLE ROW LEVEL SECURITY;
ALTER TABLE cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE contracts ENABLE ROW LEVEL SECURITY;
ALTER TABLE promo_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE sops ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE client_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE social_media_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_project_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_payment_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE reward_ledger_entries ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for authenticated users
CREATE POLICY "Allow all operations for authenticated users" ON users FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON profiles FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON clients FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON leads FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON packages FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON add_ons FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON team_members FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON projects FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON transactions FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON financial_pockets FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON cards FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON assets FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON contracts FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON promo_codes FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON sops FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON notifications FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON client_feedback FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON social_media_posts FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON team_project_payments FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON team_payment_records FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all operations for authenticated users" ON reward_ledger_entries FOR ALL TO authenticated USING (true);

-- INSERT MOCK DATA
-- Users
INSERT INTO users (email, password, full_name, company_name, role, permissions) VALUES
('admin@vena.com', 'password123', 'Admin Vena', 'Vena Photography', 'Admin', ARRAY['Dashboard', 'Prospek', 'Booking', 'Manajemen Klien', 'Proyek', 'Freelancer', 'Keuangan', 'Kalender', 'Laporan Klien', 'Input Package', 'Kode Promo', 'Manajemen Aset', 'Kontrak Kerja', 'Perencana Media Sosial', 'SOP', 'Pengaturan'])
ON CONFLICT (email) DO NOTHING;

-- Profiles
INSERT INTO profiles (admin_user_id, full_name, email, phone, company_name, website, address, bank_account, authorized_signer, bio, briefing_template, public_page_config, project_status_config, notification_settings, security_settings) VALUES
((SELECT id FROM users WHERE email = 'admin@vena.com'), 'Vena Photography Studio', 'hello@vena.com', '+62812345678', 'Vena Photography', 'https://vena.com', 'Jl. Photography No. 123, Jakarta', 'BCA 1234567890', 'John Doe', 'Professional photography studio specializing in weddings and events.', 'Default briefing template', '{"template": "classic", "title": "Vena Photography", "introduction": "Professional photography services", "galleryImages": []}', '[{"id": "new", "name": "Baru", "color": "#3b82f6", "subStatuses": [{"name": "Diskusi Awal", "note": "Membahas kebutuhan klien"}], "note": "Proyek baru masuk"}]', '{"newProject": true, "paymentConfirmation": true, "deadlineReminder": true}', '{"twoFactorEnabled": false}')
ON CONFLICT DO NOTHING;

-- Cards
INSERT INTO cards (card_holder_name, bank_name, card_type, last_four_digits, expiry_date, balance, color_gradient) VALUES
('John Doe', 'BCA', 'Debit', '1234', '12/25', 5000000, 'from-blue-500 to-blue-600'),
('Jane Smith', 'Mandiri', 'Kredit', '5678', '06/26', 2000000, 'from-green-500 to-green-600')
ON CONFLICT DO NOTHING;

-- Financial Pockets
INSERT INTO financial_pockets (name, description, icon, type, amount, goal_amount) VALUES
('Dana Operasional', 'Dana untuk kebutuhan operasional harian', 'clipboard-list', 'Anggaran Pengeluaran', 3000000, 5000000),
('Tabungan Emergency', 'Dana darurat untuk keperluan mendadak', 'piggy-bank', 'Nabung & Bayar', 10000000, 20000000)
ON CONFLICT DO NOTHING;

-- Clients
INSERT INTO clients (name, email, phone, whatsapp, since, instagram, status, client_type, last_contact, portal_access_id) VALUES
('Sarah Johnson', 'sarah@email.com', '+62812345679', '+62812345679', '2024-01-15', '@sarahjohnson', 'Aktif', 'Langsung', '2024-03-15', 'client_sarah_2024'),
('Michael Chen', 'michael@email.com', '+62812345680', '+62812345680', '2024-02-01', '@michaelchen', 'Aktif', 'Langsung', '2024-03-10', 'client_michael_2024')
ON CONFLICT (portal_access_id) DO NOTHING;

-- Leads
INSERT INTO leads (name, contact_channel, location, status, date, notes, whatsapp) VALUES
('Amanda Williams', 'WhatsApp', 'Jakarta', 'Sedang Diskusi', '2024-03-01', 'Tertarik paket wedding premium', '+62812345681'),
('David Kim', 'Instagram', 'Bandung', 'Menunggu Follow Up', '2024-03-05', 'Butuh photographer untuk acara kantor', '+62812345682')
ON CONFLICT DO NOTHING;

-- Packages
INSERT INTO packages (name, price, category, physical_items, digital_items, processing_time, default_printing_cost, default_transport_cost, photographers, videographers) VALUES
('Wedding Premium', 15000000, 'Wedding', '[{"name": "Album Wedding", "price": 500000}, {"name": "USB Flashdisk", "price": 200000}]', ARRAY['300 Foto Digital', 'Video Highlight 5 menit'], '14 hari', 800000, 500000, 'Fotografer utama + asisten', 'Videographer profesional'),
('Prewedding Basic', 3500000, 'Prewedding', '[{"name": "Cetak 10 Foto", "price": 150000}]', ARRAY['50 Foto Digital'], '7 hari', 200000, 300000, 'Fotografer utama', NULL)
ON CONFLICT DO NOTHING;

-- Add-ons
INSERT INTO add_ons (name, price) VALUES
('Extra Hour Shooting', 800000),
('Additional Photographer', 1200000),
('Drone Photography', 1500000)
ON CONFLICT DO NOTHING;

-- Team Members
INSERT INTO team_members (name, role, email, phone, standard_fee, no_rek, reward_balance, rating, performance_notes, portal_access_id) VALUES
('Alex Photographer', 'Fotografer', 'alex@team.com', '+62812345683', 1500000, 'BCA 9876543210', 500000, 4.8, '[]', 'freelancer_alex_2024'),
('Lisa Videographer', 'Videographer', 'lisa@team.com', '+62812345684', 1800000, 'Mandiri 5432167890', 300000, 4.9, '[]', 'freelancer_lisa_2024')
ON CONFLICT (portal_access_id) DO NOTHING;

-- Projects
INSERT INTO projects (project_name, client_name, client_id, project_type, package_name, package_id, date, location, progress, status, total_cost, amount_paid, payment_status, team) VALUES
('Wedding Sarah & John', 'Sarah Johnson', (SELECT id FROM clients WHERE name = 'Sarah Johnson'), 'Wedding', 'Wedding Premium', (SELECT id FROM packages WHERE name = 'Wedding Premium'), '2024-04-15', 'Jakarta Convention Center', 30, 'Dalam Proses', 15000000, 5000000, 'DP Terbayar', '[{"memberId": "'||(SELECT id FROM team_members WHERE name = 'Alex Photographer')||'", "name": "Alex Photographer", "role": "Fotografer", "fee": 1500000, "reward": 200000}]'),
('Corporate Event Michael', 'Michael Chen', (SELECT id FROM clients WHERE name = 'Michael Chen'), 'Corporate', 'Wedding Premium', (SELECT id FROM packages WHERE name = 'Wedding Premium'), '2024-04-20', 'Hotel Grand Indonesia', 0, 'Baru', 8000000, 0, 'Belum Bayar', '[]')
ON CONFLICT DO NOTHING;

-- Transactions
INSERT INTO transactions (date, description, amount, type, project_id, category, method) VALUES
('2024-03-15', 'DP Wedding Sarah & John', 5000000, 'Pemasukan', (SELECT id FROM projects WHERE project_name = 'Wedding Sarah & John'), 'Pembayaran Project', 'Transfer Bank'),
('2024-03-10', 'Pembelian Lensa Baru', -2500000, 'Pengeluaran', NULL, 'Equipment', 'Transfer Bank')
ON CONFLICT DO NOTHING;

-- Assets
INSERT INTO assets (name, category, purchase_date, purchase_price, serial_number, status, notes) VALUES
('Canon EOS R5', 'Kamera', '2024-01-15', 45000000, 'CR5-2024-001', 'Tersedia', 'Kamera utama untuk wedding'),
('DJI Mavic Pro', 'Drone', '2024-02-01', 15000000, 'DJI-2024-001', 'Tersedia', 'Drone untuk aerial shot')
ON CONFLICT DO NOTHING;

-- Contracts
INSERT INTO contracts (contract_number, client_id, project_id, signing_date, signing_location, client_name1, client_address1, client_phone1, shooting_duration, guaranteed_photos, album_details, digital_files_format, other_items, personnel_count, delivery_timeframe, dp_date, final_payment_date, cancellation_policy, jurisdiction) VALUES
('CTR-2024-001', (SELECT id FROM clients WHERE name = 'Sarah Johnson'), (SELECT id FROM projects WHERE project_name = 'Wedding Sarah & John'), '2024-03-15', 'Jakarta', 'Sarah Johnson', 'Jl. Sudirman No. 123, Jakarta', '+62812345679', '10 jam', '300 foto minimum', 'Album premium 30x30cm', 'JPEG High Quality', 'USB Flashdisk, Video Highlight', '3 orang', '14 hari kerja', '2024-03-15', '2024-04-15', 'Pembatalan 7 hari sebelum acara', 'Jakarta')
ON CONFLICT (contract_number) DO NOTHING;

-- Promo Codes
INSERT INTO promo_codes (code, discount_type, discount_value, is_active, usage_count, max_usage, expiry_date) VALUES
('WEDDING2024', 'percentage', 10, true, 2, 50, '2024-12-31'),
('NEWCLIENT', 'fixed', 500000, true, 5, 100, '2024-06-30')
ON CONFLICT (code) DO NOTHING;

-- SOPs
INSERT INTO sops (title, category, content, last_updated) VALUES
('Prosedur Pengambilan Foto Wedding', 'Wedding', '## Persiapan\n1. Cek equipment\n2. Koordinasi dengan tim\n\n## Pelaksanaan\n1. Foto detail\n2. Foto prosesi\n3. Foto keluarga', '2024-03-01'),
('Editing Workflow', 'Post Production', '## Langkah Editing\n1. Import foto\n2. Basic adjustment\n3. Color grading\n4. Export', '2024-03-01')
ON CONFLICT DO NOTHING;

-- Notifications
INSERT INTO notifications (title, message, timestamp, is_read, icon) VALUES
('Project Baru', 'Wedding Sarah & John telah ditambahkan', '2024-03-15T10:00:00Z', false, 'lead'),
('Pembayaran Diterima', 'DP Wedding Sarah & John sebesar Rp 5.000.000 telah diterima', '2024-03-15T11:00:00Z', false, 'payment')
ON CONFLICT DO NOTHING;

-- Client Feedback
INSERT INTO client_feedback (client_name, satisfaction, rating, feedback, date) VALUES
('Sarah Johnson', 'Sangat Puas', 5, 'Pelayanan sangat memuaskan, hasil foto wedding kami sangat bagus!', '2024-03-20'),
('Michael Chen', 'Puas', 4, 'Profesional dan tepat waktu dalam pelayanan', '2024-03-18')
ON CONFLICT DO NOTHING;

-- Social Media Posts
INSERT INTO social_media_posts (project_id, client_name, post_type, platform, scheduled_date, caption, status) VALUES
((SELECT id FROM projects WHERE project_name = 'Wedding Sarah & John'), 'Sarah Johnson', 'Instagram Feed', 'Instagram', '2024-04-20', 'Beautiful wedding moments captured! #WeddingPhotography #Love', 'Terjadwal')
ON CONFLICT DO NOTHING;

-- Team Project Payments
INSERT INTO team_project_payments (project_id, team_member_name, team_member_id, date, status, fee, reward) VALUES
((SELECT id FROM projects WHERE project_name = 'Wedding Sarah & John'), 'Alex Photographer', (SELECT id FROM team_members WHERE name = 'Alex Photographer'), '2024-03-15', 'Unpaid', 1500000, 200000)
ON CONFLICT DO NOTHING;

-- Team Payment Records
INSERT INTO team_payment_records (record_number, team_member_id, date, project_payment_ids, total_amount) VALUES
('PAY-2024-001', (SELECT id FROM team_members WHERE name = 'Alex Photographer'), '2024-03-15', ARRAY[(SELECT id FROM team_project_payments WHERE team_member_name = 'Alex Photographer')::text], 1700000)
ON CONFLICT (record_number) DO NOTHING;

-- Reward Ledger Entries
INSERT INTO reward_ledger_entries (team_member_id, date, description, amount, project_id) VALUES
((SELECT id FROM team_members WHERE name = 'Alex Photographer'), '2024-03-15', 'Reward untuk Wedding Sarah & John', 200000, (SELECT id FROM projects WHERE project_name = 'Wedding Sarah & John'))
ON CONFLICT DO NOTHING;