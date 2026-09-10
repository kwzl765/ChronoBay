import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error(
    'Missing Supabase environment variables. Ensure VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY are set in .env'
  );
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: true,
  },
});

export type ProductStatus = 'draft' | 'active' | 'archived';
export type OrderStatus =
  | 'pending'
  | 'confirmed'
  | 'processing'
  | 'shipped'
  | 'delivered'
  | 'cancelled';
export type PaymentStatus =
  | 'unpaid'
  | 'pending'
  | 'paid'
  | 'failed'
  | 'refunded';
export type AddressType = 'shipping' | 'billing';
export type UserRole = 'customer' | 'staff' | 'admin';

export interface DatabaseBrand {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  logo_url: string | null;
  banner_url: string | null;
  visual_family: string | null;
  featured: boolean;
  active: boolean;
  sort_order: number;
  created_at: string;
  updated_at: string;
}

export interface DatabaseCategory {
  id: string;
  parent_id: string | null;
  name: string;
  slug: string;
  description: string | null;
  image_url: string | null;
  active: boolean;
  sort_order: number;
  created_at: string;
  updated_at: string;
}

export interface DatabaseProduct {
  id: string;
  brand_id: string;
  category_id: string;
  name: string;
  slug: string;
  sku: string;
  short_description: string | null;
  description: string | null;
  gender: string | null;
  movement: string | null;
  case_material: string | null;
  strap_material: string | null;
  water_resistance: string | null;
  warranty_months: number;
  price: number;
  original_price: number | null;
  currency: string;
  status: ProductStatus;
  featured: boolean;
  new_arrival: boolean;
  average_rating: number;
  review_count: number;
  seo_title: string | null;
  seo_description: string | null;
  created_at: string;
  updated_at: string;
}

export interface DatabaseProductImage {
  id: string;
  product_id: string;
  storage_path: string;
  alt_text: string | null;
  sort_order: number;
  created_at: string;
}

export interface DatabaseInventory {
  product_id: string;
  quantity: number;
  reserved_quantity: number;
  low_stock_threshold: number;
  updated_at: string;
}

export interface DatabaseProfile {
  id: string;
  full_name: string | null;
  phone: string | null;
  avatar_url: string | null;
  created_at: string;
  updated_at: string;
}

export interface DatabaseAddress {
  id: string;
  user_id: string;
  type: AddressType;
  recipient_name: string;
  phone: string;
  address_line_1: string;
  address_line_2: string | null;
  township: string | null;
  city: string;
  region: string | null;
  postal_code: string | null;
  country: string;
  is_default: boolean;
  created_at: string;
  updated_at: string;
}

export interface DatabaseOrder {
  id: string;
  user_id: string | null;
  order_number: string;
  status: OrderStatus;
  payment_status: PaymentStatus;
  payment_method: string | null;
  subtotal: number;
  delivery_fee: number;
  discount_amount: number;
  total: number;
  currency: string;
  shipping_name: string;
  shipping_phone: string;
  shipping_address: Record<string, unknown>;
  customer_note: string | null;
  tracking_number: string | null;
  placed_at: string;
  created_at: string;
  updated_at: string;
}

export interface DatabaseOrderItem {
  id: string;
  order_id: string;
  product_id: string | null;
  product_name: string;
  product_sku: string;
  product_image_url: string | null;
  unit_price: number;
  quantity: number;
  line_total: number;
  created_at: string;
}

export interface DatabaseReview {
  id: string;
  user_id: string;
  product_id: string;
  order_item_id: string | null;
  rating: number;
  title: string | null;
  body: string | null;
  approved: boolean;
  created_at: string;
  updated_at: string;
}

export interface DatabaseTables {
  profiles: DatabaseProfile;
  brands: DatabaseBrand;
  categories: DatabaseCategory;
  products: DatabaseProduct;
  product_images: DatabaseProductImage;
  inventory: DatabaseInventory;
  addresses: DatabaseAddress;
  orders: DatabaseOrder;
  order_items: DatabaseOrderItem;
  reviews: DatabaseReview;
}
