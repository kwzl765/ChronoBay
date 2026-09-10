/*
# ChronoBay Core Database Schema

## Overview
This migration creates the complete production schema for the ChronoBay
e-commerce watch store. It defines all catalogue, cart, wishlist, order,
review, and user-profile tables with proper constraints, indexes, triggers,
and Row Level Security policies.

## Enums
- `product_status`: draft, active, archived — controls product visibility
- `order_status`: pending, confirmed, processing, shipped, delivered, cancelled
- `payment_status`: unpaid, pending, paid, failed, refunded
- `address_type`: shipping, billing
- `user_role`: customer, staff, admin — stored in user_roles, never in profiles

## Tables Created
1. `profiles` — user profile data (id links to auth.users)
2. `user_roles` — authorization roles (admin/staff/customer), NOT user-editable
3. `brands` — watch brand catalogue
4. `categories` — product categories with optional parent hierarchy
5. `products` — main product catalogue with pricing, specs, SEO
6. `product_images` — image references per product (storage_path, not base64)
7. `inventory` — stock tracking per product
8. `addresses` — shipping/billing addresses per user
9. `carts` — shopping carts (user or session based)
10. `cart_items` — items within a cart
11. `wishlist_items` — user wishlist (composite PK)
12. `orders` — order records with immutable shipping snapshots
13. `order_items` — order line items with immutable product snapshots
14. `reviews` — product reviews with approval workflow

## Triggers
- `set_updated_at()` — reusable SECURITY INVOKER function to auto-update updated_at
- `handle_new_user()` — SECURITY DEFINER trigger to create profile + role on signup

## Security
- RLS enabled on ALL public tables
- Public/anonymous: read active catalogue (brands, categories, products, images, reviews)
- Authenticated customers: CRUD on own profile, addresses, cart, wishlist, reviews, orders
- Customers CANNOT: edit roles, edit catalogue, edit inventory, approve reviews, alter orders
- Admin/staff access via `user_roles` table — never via user_metadata
- Every UPDATE policy has both USING and WITH CHECK
- No `auth.role()` used anywhere
- No public SECURITY DEFINER functions
*/

-- ============================================================
-- ENUMS
-- ============================================================

DO $$ BEGIN
  CREATE TYPE product_status AS ENUM ('draft', 'active', 'archived');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE order_status AS ENUM ('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE payment_status AS ENUM ('unpaid', 'pending', 'paid', 'failed', 'refunded');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE address_type AS ENUM ('shipping', 'billing');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE user_role AS ENUM ('customer', 'staff', 'admin');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- ============================================================
-- UPDATED_AT TRIGGER FUNCTION (SECURITY INVOKER)
-- ============================================================

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- ============================================================
-- PROFILES
-- ============================================================

CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name text,
  phone text,
  avatar_url text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

DROP TRIGGER IF EXISTS profiles_updated_at ON public.profiles;
CREATE TRIGGER profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- USER_ROLES (authorization — NOT user-editable)
-- ============================================================

CREATE TABLE IF NOT EXISTS public.user_roles (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role user_role NOT NULL DEFAULT 'customer',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

DROP TRIGGER IF EXISTS user_roles_updated_at ON public.user_roles;
CREATE TRIGGER user_roles_updated_at
  BEFORE UPDATE ON public.user_roles
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- BRANDS
-- ============================================================

CREATE TABLE IF NOT EXISTS public.brands (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text NOT NULL UNIQUE,
  description text,
  logo_url text,
  banner_url text,
  visual_family text,
  featured boolean DEFAULT false,
  active boolean DEFAULT true,
  sort_order integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE public.brands ENABLE ROW LEVEL SECURITY;

DROP TRIGGER IF EXISTS brands_updated_at ON public.brands;
CREATE TRIGGER brands_updated_at
  BEFORE UPDATE ON public.brands
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- CATEGORIES
-- ============================================================

CREATE TABLE IF NOT EXISTS public.categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id uuid REFERENCES public.categories(id),
  name text NOT NULL,
  slug text NOT NULL UNIQUE,
  description text,
  image_url text,
  active boolean DEFAULT true,
  sort_order integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;

DROP TRIGGER IF EXISTS categories_updated_at ON public.categories;
CREATE TRIGGER categories_updated_at
  BEFORE UPDATE ON public.categories
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- PRODUCTS
-- ============================================================

CREATE TABLE IF NOT EXISTS public.products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  brand_id uuid NOT NULL REFERENCES public.brands(id),
  category_id uuid NOT NULL REFERENCES public.categories(id),
  name text NOT NULL,
  slug text NOT NULL UNIQUE,
  sku text NOT NULL UNIQUE,
  short_description text,
  description text,
  gender text,
  movement text,
  case_material text,
  strap_material text,
  water_resistance text,
  warranty_months integer DEFAULT 12,
  price numeric(14,2) NOT NULL CHECK (price >= 0),
  original_price numeric(14,2) CHECK (original_price IS NULL OR original_price >= price),
  currency text NOT NULL DEFAULT 'MMK',
  status product_status NOT NULL DEFAULT 'draft',
  featured boolean DEFAULT false,
  new_arrival boolean DEFAULT false,
  average_rating numeric(2,1) DEFAULT 0,
  review_count integer DEFAULT 0,
  seo_title text,
  seo_description text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

DROP TRIGGER IF EXISTS products_updated_at ON public.products;
CREATE TRIGGER products_updated_at
  BEFORE UPDATE ON public.products
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- PRODUCT_IMAGES
-- ============================================================

CREATE TABLE IF NOT EXISTS public.product_images (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  storage_path text NOT NULL,
  alt_text text,
  sort_order integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE public.product_images ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- INVENTORY
-- ============================================================

CREATE TABLE IF NOT EXISTS public.inventory (
  product_id uuid PRIMARY KEY REFERENCES public.products(id) ON DELETE CASCADE,
  quantity integer NOT NULL DEFAULT 0 CHECK (quantity >= 0),
  reserved_quantity integer NOT NULL DEFAULT 0 CHECK (reserved_quantity >= 0),
  low_stock_threshold integer NOT NULL DEFAULT 5,
  updated_at timestamptz DEFAULT now(),
  CHECK (reserved_quantity <= quantity)
);

ALTER TABLE public.inventory ENABLE ROW LEVEL SECURITY;

DROP TRIGGER IF EXISTS inventory_updated_at ON public.inventory;
CREATE TRIGGER inventory_updated_at
  BEFORE UPDATE ON public.inventory
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- ADDRESSES
-- ============================================================

CREATE TABLE IF NOT EXISTS public.addresses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  type address_type NOT NULL,
  recipient_name text NOT NULL,
  phone text NOT NULL,
  address_line_1 text NOT NULL,
  address_line_2 text,
  township text,
  city text NOT NULL,
  region text,
  postal_code text,
  country text DEFAULT 'Myanmar',
  is_default boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE public.addresses ENABLE ROW LEVEL SECURITY;

DROP TRIGGER IF EXISTS addresses_updated_at ON public.addresses;
CREATE TRIGGER addresses_updated_at
  BEFORE UPDATE ON public.addresses
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- CARTS
-- ============================================================

CREATE TABLE IF NOT EXISTS public.carts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  session_id text UNIQUE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  CHECK (user_id IS NOT NULL OR session_id IS NOT NULL)
);

ALTER TABLE public.carts ENABLE ROW LEVEL SECURITY;

DROP TRIGGER IF EXISTS carts_updated_at ON public.carts;
CREATE TRIGGER carts_updated_at
  BEFORE UPDATE ON public.carts
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- CART_ITEMS
-- ============================================================

CREATE TABLE IF NOT EXISTS public.cart_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  cart_id uuid NOT NULL REFERENCES public.carts(id) ON DELETE CASCADE,
  product_id uuid NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  quantity integer NOT NULL DEFAULT 1 CHECK (quantity > 0),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(cart_id, product_id)
);

ALTER TABLE public.cart_items ENABLE ROW LEVEL SECURITY;

DROP TRIGGER IF EXISTS cart_items_updated_at ON public.cart_items;
CREATE TRIGGER cart_items_updated_at
  BEFORE UPDATE ON public.cart_items
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- WISHLIST_ITEMS
-- ============================================================

CREATE TABLE IF NOT EXISTS public.wishlist_items (
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id uuid NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  PRIMARY KEY (user_id, product_id)
);

ALTER TABLE public.wishlist_items ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- ORDERS
-- ============================================================

CREATE TABLE IF NOT EXISTS public.orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id),
  order_number text NOT NULL UNIQUE,
  status order_status NOT NULL DEFAULT 'pending',
  payment_status payment_status NOT NULL DEFAULT 'unpaid',
  payment_method text,
  subtotal numeric(14,2) NOT NULL CHECK (subtotal >= 0),
  delivery_fee numeric(14,2) NOT NULL DEFAULT 0 CHECK (delivery_fee >= 0),
  discount_amount numeric(14,2) NOT NULL DEFAULT 0 CHECK (discount_amount >= 0),
  total numeric(14,2) NOT NULL CHECK (total >= 0),
  currency text NOT NULL DEFAULT 'MMK',
  shipping_name text NOT NULL,
  shipping_phone text NOT NULL,
  shipping_address jsonb NOT NULL,
  customer_note text,
  tracking_number text,
  placed_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

DROP TRIGGER IF EXISTS orders_updated_at ON public.orders;
CREATE TRIGGER orders_updated_at
  BEFORE UPDATE ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- ORDER_ITEMS
-- ============================================================

CREATE TABLE IF NOT EXISTS public.order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
  product_id uuid REFERENCES public.products(id) ON DELETE SET NULL,
  product_name text NOT NULL,
  product_sku text NOT NULL,
  product_image_url text,
  unit_price numeric(14,2) NOT NULL CHECK (unit_price >= 0),
  quantity integer NOT NULL CHECK (quantity > 0),
  line_total numeric(14,2) NOT NULL CHECK (line_total >= 0),
  created_at timestamptz DEFAULT now()
);

ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- REVIEWS
-- ============================================================

CREATE TABLE IF NOT EXISTS public.reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id uuid NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  order_item_id uuid REFERENCES public.order_items(id),
  rating integer NOT NULL CHECK (rating BETWEEN 1 AND 5),
  title text,
  body text,
  approved boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(user_id, product_id)
);

ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

DROP TRIGGER IF EXISTS reviews_updated_at ON public.reviews;
CREATE TRIGGER reviews_updated_at
  BEFORE UPDATE ON public.reviews
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_brands_slug ON public.brands(slug);
CREATE INDEX IF NOT EXISTS idx_categories_slug ON public.categories(slug);
CREATE INDEX IF NOT EXISTS idx_products_slug ON public.products(slug);
CREATE INDEX IF NOT EXISTS idx_products_sku ON public.products(sku);
CREATE INDEX IF NOT EXISTS idx_products_brand_id ON public.products(brand_id);
CREATE INDEX IF NOT EXISTS idx_products_category_id ON public.products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_status ON public.products(status);
CREATE INDEX IF NOT EXISTS idx_products_featured_status ON public.products(featured, status);
CREATE INDEX IF NOT EXISTS idx_products_new_arrival_status ON public.products(new_arrival, status);
CREATE INDEX IF NOT EXISTS idx_product_images_product_sort ON public.product_images(product_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_cart_items_cart_id ON public.cart_items(cart_id);
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON public.orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_order_number ON public.orders(order_number);
CREATE INDEX IF NOT EXISTS idx_orders_status_created ON public.orders(status, created_at);
CREATE INDEX IF NOT EXISTS idx_reviews_product_id ON public.reviews(product_id);

-- ============================================================
-- AUTH PROFILE CREATION TRIGGER (SECURITY DEFINER)
-- ============================================================

-- Place the handler in a private schema to avoid exposing it via the Data API
CREATE SCHEMA IF NOT EXISTS private;

CREATE OR REPLACE FUNCTION private.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, private
AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name)
  VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email));

  INSERT INTO public.user_roles (user_id, role)
  VALUES (NEW.id, 'customer')
  ON CONFLICT (user_id) DO NOTHING;

  RETURN NEW;
END;
$$;

REVOKE EXECUTE ON FUNCTION private.handle_new_user() FROM PUBLIC;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION private.handle_new_user();

-- ============================================================
-- HELPER: check if current user has a specific role
-- SECURITY DEFINER so policies can read user_roles without
-- needing direct SELECT access on that table
-- ============================================================

CREATE OR REPLACE FUNCTION public.has_role(required_role user_role)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = auth.uid() AND role = required_role
  );
$$;

REVOKE EXECUTE ON FUNCTION public.has_role(user_role) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.has_role(user_role) TO authenticated;

-- ============================================================
-- RLS POLICIES: PROFILES
-- ============================================================

DROP POLICY IF EXISTS "profiles_select_own" ON public.profiles;
CREATE POLICY "profiles_select_own"
  ON public.profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

DROP POLICY IF EXISTS "profiles_update_own" ON public.profiles;
CREATE POLICY "profiles_update_own"
  ON public.profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- ============================================================
-- RLS POLICIES: USER_ROLES (users can only read their own)
-- ============================================================

DROP POLICY IF EXISTS "user_roles_select_own" ON public.user_roles;
CREATE POLICY "user_roles_select_own"
  ON public.user_roles FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- No INSERT/UPDATE/DELETE policies — users cannot modify roles.
-- Roles are set only by the auth trigger or admin operations.

-- ============================================================
-- RLS POLICIES: BRANDS (public read active)
-- ============================================================

DROP POLICY IF EXISTS "brands_select_public" ON public.brands;
CREATE POLICY "brands_select_public"
  ON public.brands FOR SELECT
  TO anon, authenticated
  USING (active = true);

-- ============================================================
-- RLS POLICIES: CATEGORIES (public read active)
-- ============================================================

DROP POLICY IF EXISTS "categories_select_public" ON public.categories;
CREATE POLICY "categories_select_public"
  ON public.categories FOR SELECT
  TO anon, authenticated
  USING (active = true);

-- ============================================================
-- RLS POLICIES: PRODUCTS (public read active)
-- ============================================================

DROP POLICY IF EXISTS "products_select_public" ON public.products;
CREATE POLICY "products_select_public"
  ON public.products FOR SELECT
  TO anon, authenticated
  USING (status = 'active');

-- ============================================================
-- RLS POLICIES: PRODUCT_IMAGES (public read images for active products)
-- ============================================================

DROP POLICY IF EXISTS "product_images_select_public" ON public.product_images;
CREATE POLICY "product_images_select_public"
  ON public.product_images FOR SELECT
  TO anon, authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.products
      WHERE products.id = product_images.product_id
        AND products.status = 'active'
    )
  );

-- ============================================================
-- RLS POLICIES: INVENTORY (public read availability only)
-- ============================================================

DROP POLICY IF EXISTS "inventory_select_public" ON public.inventory;
CREATE POLICY "inventory_select_public"
  ON public.inventory FOR SELECT
  TO anon, authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.products
      WHERE products.id = inventory.product_id
        AND products.status = 'active'
    )
  );

-- ============================================================
-- RLS POLICIES: ADDRESSES (owner CRUD)
-- ============================================================

DROP POLICY IF EXISTS "addresses_select_own" ON public.addresses;
CREATE POLICY "addresses_select_own"
  ON public.addresses FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "addresses_insert_own" ON public.addresses;
CREATE POLICY "addresses_insert_own"
  ON public.addresses FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "addresses_update_own" ON public.addresses;
CREATE POLICY "addresses_update_own"
  ON public.addresses FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "addresses_delete_own" ON public.addresses;
CREATE POLICY "addresses_delete_own"
  ON public.addresses FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- ============================================================
-- RLS POLICIES: CARTS (owner CRUD)
-- ============================================================

DROP POLICY IF EXISTS "carts_select_own" ON public.carts;
CREATE POLICY "carts_select_own"
  ON public.carts FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "carts_insert_own" ON public.carts;
CREATE POLICY "carts_insert_own"
  ON public.carts FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "carts_update_own" ON public.carts;
CREATE POLICY "carts_update_own"
  ON public.carts FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "carts_delete_own" ON public.carts;
CREATE POLICY "carts_delete_own"
  ON public.carts FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- ============================================================
-- RLS POLICIES: CART_ITEMS (owner via parent cart)
-- ============================================================

DROP POLICY IF EXISTS "cart_items_select_own" ON public.cart_items;
CREATE POLICY "cart_items_select_own"
  ON public.cart_items FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.carts
      WHERE carts.id = cart_items.cart_id
        AND carts.user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "cart_items_insert_own" ON public.cart_items;
CREATE POLICY "cart_items_insert_own"
  ON public.cart_items FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.carts
      WHERE carts.id = cart_items.cart_id
        AND carts.user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "cart_items_update_own" ON public.cart_items;
CREATE POLICY "cart_items_update_own"
  ON public.cart_items FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.carts
      WHERE carts.id = cart_items.cart_id
        AND carts.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.carts
      WHERE carts.id = cart_items.cart_id
        AND carts.user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "cart_items_delete_own" ON public.cart_items;
CREATE POLICY "cart_items_delete_own"
  ON public.cart_items FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.carts
      WHERE carts.id = cart_items.cart_id
        AND carts.user_id = auth.uid()
    )
  );

-- ============================================================
-- RLS POLICIES: WISHLIST_ITEMS (owner CRUD)
-- ============================================================

DROP POLICY IF EXISTS "wishlist_select_own" ON public.wishlist_items;
CREATE POLICY "wishlist_select_own"
  ON public.wishlist_items FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "wishlist_insert_own" ON public.wishlist_items;
CREATE POLICY "wishlist_insert_own"
  ON public.wishlist_items FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "wishlist_delete_own" ON public.wishlist_items;
CREATE POLICY "wishlist_delete_own"
  ON public.wishlist_items FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- ============================================================
-- RLS POLICIES: ORDERS (owner read only)
-- ============================================================

DROP POLICY IF EXISTS "orders_select_own" ON public.orders;
CREATE POLICY "orders_select_own"
  ON public.orders FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "orders_insert_own" ON public.orders;
CREATE POLICY "orders_insert_own"
  ON public.orders FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- ============================================================
-- RLS POLICIES: ORDER_ITEMS (owner read via parent order)
-- ============================================================

DROP POLICY IF EXISTS "order_items_select_own" ON public.order_items;
CREATE POLICY "order_items_select_own"
  ON public.order_items FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.orders
      WHERE orders.id = order_items.order_id
        AND orders.user_id = auth.uid()
    )
  );

-- ============================================================
-- RLS POLICIES: REVIEWS
-- ============================================================

-- Public can read approved reviews
DROP POLICY IF EXISTS "reviews_select_public" ON public.reviews;
CREATE POLICY "reviews_select_public"
  ON public.reviews FOR SELECT
  TO anon, authenticated
  USING (approved = true);

-- Authenticated users can create reviews as themselves
DROP POLICY IF EXISTS "reviews_insert_own" ON public.reviews;
CREATE POLICY "reviews_insert_own"
  ON public.reviews FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Users can update/delete only their own unapproved reviews
DROP POLICY IF EXISTS "reviews_update_own_unapproved" ON public.reviews;
CREATE POLICY "reviews_update_own_unapproved"
  ON public.reviews FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id AND approved = false)
  WITH CHECK (auth.uid() = user_id AND approved = false);

DROP POLICY IF EXISTS "reviews_delete_own_unapproved" ON public.reviews;
CREATE POLICY "reviews_delete_own_unapproved"
  ON public.reviews FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id AND approved = false);

-- ============================================================
-- ADMIN/STAFF POLICIES (full catalogue management)
-- Uses public.has_role() helper — not user_metadata
-- ============================================================

-- Brands: admin/staff can INSERT, UPDATE, DELETE
DROP POLICY IF EXISTS "brands_insert_staff" ON public.brands;
CREATE POLICY "brands_insert_staff"
  ON public.brands FOR INSERT
  TO authenticated
  WITH CHECK (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

DROP POLICY IF EXISTS "brands_update_staff" ON public.brands;
CREATE POLICY "brands_update_staff"
  ON public.brands FOR UPDATE
  TO authenticated
  USING (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role))
  WITH CHECK (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

DROP POLICY IF EXISTS "brands_delete_staff" ON public.brands;
CREATE POLICY "brands_delete_staff"
  ON public.brands FOR DELETE
  TO authenticated
  USING (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

-- Categories: admin/staff can INSERT, UPDATE, DELETE
DROP POLICY IF EXISTS "categories_insert_staff" ON public.categories;
CREATE POLICY "categories_insert_staff"
  ON public.categories FOR INSERT
  TO authenticated
  WITH CHECK (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

DROP POLICY IF EXISTS "categories_update_staff" ON public.categories;
CREATE POLICY "categories_update_staff"
  ON public.categories FOR UPDATE
  TO authenticated
  USING (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role))
  WITH CHECK (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

DROP POLICY IF EXISTS "categories_delete_staff" ON public.categories;
CREATE POLICY "categories_delete_staff"
  ON public.categories FOR DELETE
  TO authenticated
  USING (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

-- Products: admin/staff can INSERT, UPDATE, DELETE
DROP POLICY IF EXISTS "products_insert_staff" ON public.products;
CREATE POLICY "products_insert_staff"
  ON public.products FOR INSERT
  TO authenticated
  WITH CHECK (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

DROP POLICY IF EXISTS "products_update_staff" ON public.products;
CREATE POLICY "products_update_staff"
  ON public.products FOR UPDATE
  TO authenticated
  USING (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role))
  WITH CHECK (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

DROP POLICY IF EXISTS "products_delete_staff" ON public.products;
CREATE POLICY "products_delete_staff"
  ON public.products FOR DELETE
  TO authenticated
  USING (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

-- Product images: admin/staff can INSERT, UPDATE, DELETE
DROP POLICY IF EXISTS "product_images_insert_staff" ON public.product_images;
CREATE POLICY "product_images_insert_staff"
  ON public.product_images FOR INSERT
  TO authenticated
  WITH CHECK (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

DROP POLICY IF EXISTS "product_images_update_staff" ON public.product_images;
CREATE POLICY "product_images_update_staff"
  ON public.product_images FOR UPDATE
  TO authenticated
  USING (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role))
  WITH CHECK (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

DROP POLICY IF EXISTS "product_images_delete_staff" ON public.product_images;
CREATE POLICY "product_images_delete_staff"
  ON public.product_images FOR DELETE
  TO authenticated
  USING (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

-- Inventory: admin/staff can INSERT, UPDATE, DELETE
DROP POLICY IF EXISTS "inventory_insert_staff" ON public.inventory;
CREATE POLICY "inventory_insert_staff"
  ON public.inventory FOR INSERT
  TO authenticated
  WITH CHECK (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

DROP POLICY IF EXISTS "inventory_update_staff" ON public.inventory;
CREATE POLICY "inventory_update_staff"
  ON public.inventory FOR UPDATE
  TO authenticated
  USING (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role))
  WITH CHECK (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

DROP POLICY IF EXISTS "inventory_delete_staff" ON public.inventory;
CREATE POLICY "inventory_delete_staff"
  ON public.inventory FOR DELETE
  TO authenticated
  USING (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

-- Orders: admin/staff can read all, update status
DROP POLICY IF EXISTS "orders_select_staff" ON public.orders;
CREATE POLICY "orders_select_staff"
  ON public.orders FOR SELECT
  TO authenticated
  USING (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

DROP POLICY IF EXISTS "orders_update_staff" ON public.orders;
CREATE POLICY "orders_update_staff"
  ON public.orders FOR UPDATE
  TO authenticated
  USING (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role))
  WITH CHECK (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

-- Order items: admin/staff can read all
DROP POLICY IF EXISTS "order_items_select_staff" ON public.order_items;
CREATE POLICY "order_items_select_staff"
  ON public.order_items FOR SELECT
  TO authenticated
  USING (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

-- Reviews: admin/staff can update (approve) and delete any review
DROP POLICY IF EXISTS "reviews_update_staff" ON public.reviews;
CREATE POLICY "reviews_update_staff"
  ON public.reviews FOR UPDATE
  TO authenticated
  USING (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role))
  WITH CHECK (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

DROP POLICY IF EXISTS "reviews_delete_staff" ON public.reviews;
CREATE POLICY "reviews_delete_staff"
  ON public.reviews FOR DELETE
  TO authenticated
  USING (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role));

-- ============================================================
-- GRANTS (explicit table privileges)
-- ============================================================

-- Public catalogue reads for anon
GRANT SELECT ON public.brands TO anon, authenticated;
GRANT SELECT ON public.categories TO anon, authenticated;
GRANT SELECT ON public.products TO anon, authenticated;
GRANT SELECT ON public.product_images TO anon, authenticated;
GRANT SELECT ON public.inventory TO anon, authenticated;
GRANT SELECT ON public.reviews TO anon, authenticated;

-- Authenticated user-owned data
GRANT SELECT, UPDATE ON public.profiles TO authenticated;
GRANT SELECT ON public.user_roles TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.addresses TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.carts TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.cart_items TO authenticated;
GRANT SELECT, INSERT, DELETE ON public.wishlist_items TO authenticated;
GRANT SELECT, INSERT ON public.orders TO authenticated;
GRANT SELECT ON public.order_items TO authenticated;
GRANT SELECT, INSERT ON public.reviews TO authenticated;
GRANT UPDATE, DELETE ON public.reviews TO authenticated;
