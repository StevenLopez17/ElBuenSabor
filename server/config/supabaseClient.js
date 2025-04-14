import dotenv from 'dotenv';
import { createClient } from '@supabase/supabase-js';

dotenv.config();

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_KEY;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_KEY || supabaseKey;

// Client for public operations (respects RLS)
const supabase = createClient(supabaseUrl, supabaseKey);

// Admin client that bypasses RLS for server-side operations
const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey);

export { supabaseAdmin };
export default supabase;


