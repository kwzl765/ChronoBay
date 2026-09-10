/*
# Step 2: Recreate has_role in private schema + all staff policies + indexes

1. Drops the public.has_role function (now safe — no dependents)
2. Creates private.has_role as SECURITY DEFINER, not exposed via Data API
3. Recreates all staff/admin RLS policies referencing private.has_role
4. Recreates storage policies for brand-assets and product-images
5. Adds missing FK indexes flagged by performance advisor
*/

-- Drop old function and create in private schema
DROP FUNCTION IF EXISTS public.has_role(user_role);

CREATE OR REPLACE FUNCTION private.has_role(required_role user_role)
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

REVOKE EXECUTE ON FUNCTION private.has_role(user_role) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION private.has_role(user_role) TO authenticated;

-- ============================================================
-- STAFF RLS POLICIES (using private.has_role)
-- ============================================================

-- Brands
CREATE POLICY "brands_insert_staff"
  ON public.brands FOR INSERT
  TO authenticated
  WITH CHECK (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

CREATE POLICY "brands_update_staff"
  ON public.brands FOR UPDATE
  TO authenticated
  USING (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role))
  WITH CHECK (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

CREATE POLICY "brands_delete_staff"
  ON public.brands FOR DELETE
  TO authenticated
  USING (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

-- Categories
CREATE POLICY "categories_insert_staff"
  ON public.categories FOR INSERT
  TO authenticated
  WITH CHECK (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

CREATE POLICY "categories_update_staff"
  ON public.categories FOR UPDATE
  TO authenticated
  USING (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role))
  WITH CHECK (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

CREATE POLICY "categories_delete_staff"
  ON public.categories FOR DELETE
  TO authenticated
  USING (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

-- Products
CREATE POLICY "products_insert_staff"
  ON public.products FOR INSERT
  TO authenticated
  WITH CHECK (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

CREATE POLICY "products_update_staff"
  ON public.products FOR UPDATE
  TO authenticated
  USING (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role))
  WITH CHECK (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

CREATE POLICY "products_delete_staff"
  ON public.products FOR DELETE
  TO authenticated
  USING (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

-- Product images
CREATE POLICY "product_images_insert_staff"
  ON public.product_images FOR INSERT
  TO authenticated
  WITH CHECK (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

CREATE POLICY "product_images_update_staff"
  ON public.product_images FOR UPDATE
  TO authenticated
  USING (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role))
  WITH CHECK (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

CREATE POLICY "product_images_delete_staff"
  ON public.product_images FOR DELETE
  TO authenticated
  USING (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

-- Inventory
CREATE POLICY "inventory_insert_staff"
  ON public.inventory FOR INSERT
  TO authenticated
  WITH CHECK (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

CREATE POLICY "inventory_update_staff"
  ON public.inventory FOR UPDATE
  TO authenticated
  USING (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role))
  WITH CHECK (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

CREATE POLICY "inventory_delete_staff"
  ON public.inventory FOR DELETE
  TO authenticated
  USING (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

-- Orders
CREATE POLICY "orders_select_staff"
  ON public.orders FOR SELECT
  TO authenticated
  USING (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

CREATE POLICY "orders_update_staff"
  ON public.orders FOR UPDATE
  TO authenticated
  USING (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role))
  WITH CHECK (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

-- Order items
CREATE POLICY "order_items_select_staff"
  ON public.order_items FOR SELECT
  TO authenticated
  USING (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

-- Reviews
CREATE POLICY "reviews_update_staff"
  ON public.reviews FOR UPDATE
  TO authenticated
  USING (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role))
  WITH CHECK (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

CREATE POLICY "reviews_delete_staff"
  ON public.reviews FOR DELETE
  TO authenticated
  USING (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role));

-- ============================================================
-- STORAGE POLICIES (using private.has_role)
-- ============================================================

CREATE POLICY "brand_assets_insert_staff"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'brand-assets'
    AND (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role))
  );

CREATE POLICY "brand_assets_update_staff"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'brand-assets'
    AND (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role))
  )
  WITH CHECK (
    bucket_id = 'brand-assets'
    AND (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role))
  );

CREATE POLICY "brand_assets_delete_staff"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'brand-assets'
    AND (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role))
  );

CREATE POLICY "product_images_insert_staff"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'product-images'
    AND (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role))
  );

CREATE POLICY "product_images_update_staff"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'product-images'
    AND (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role))
  )
  WITH CHECK (
    bucket_id = 'product-images'
    AND (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role))
  );

CREATE POLICY "product_images_delete_staff"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'product-images'
    AND (private.has_role('admin'::user_role) OR private.has_role('staff'::user_role))
  );

-- ============================================================
-- MISSING FK INDEXES (from performance advisor)
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_addresses_user_id ON public.addresses(user_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_product_id ON public.cart_items(product_id);
CREATE INDEX IF NOT EXISTS idx_categories_parent_id ON public.categories(parent_id);
CREATE INDEX IF NOT EXISTS idx_carts_user_id ON public.carts(user_id);
CREATE INDEX IF NOT EXISTS idx_carts_session_id ON public.carts(session_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON public.order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON public.order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_product_images_product_id ON public.product_images(product_id);
CREATE INDEX IF NOT EXISTS idx_reviews_user_id ON public.reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_order_item_id ON public.reviews(order_item_id);
