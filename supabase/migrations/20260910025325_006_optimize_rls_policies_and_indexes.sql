-- 006: Optimize RLS policies to use (select auth.uid()) for init plan caching
-- and add missing index on wishlist_items.product_id

-- ============================================================
-- Index: wishlist_items.product_id (was missing, flagged by advisor)
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_wishlist_items_product_id
  ON public.wishlist_items(product_id);

-- ============================================================
-- Recreate RLS policies with (select auth.uid()) for performance
-- ============================================================

-- profiles
DROP POLICY IF EXISTS profiles_select_own ON public.profiles;
DROP POLICY IF EXISTS profiles_update_own ON public.profiles;

CREATE POLICY profiles_select_own ON public.profiles
  FOR SELECT TO authenticated
  USING ((select auth.uid()) = id);

CREATE POLICY profiles_update_own ON public.profiles
  FOR UPDATE TO authenticated
  USING ((select auth.uid()) = id)
  WITH CHECK ((select auth.uid()) = id);

-- user_roles
DROP POLICY IF EXISTS user_roles_select_own ON public.user_roles;

CREATE POLICY user_roles_select_own ON public.user_roles
  FOR SELECT TO authenticated
  USING ((select auth.uid()) = user_id);

-- addresses
DROP POLICY IF EXISTS addresses_select_own ON public.addresses;
DROP POLICY IF EXISTS addresses_insert_own ON public.addresses;
DROP POLICY IF EXISTS addresses_update_own ON public.addresses;
DROP POLICY IF EXISTS addresses_delete_own ON public.addresses;

CREATE POLICY addresses_select_own ON public.addresses
  FOR SELECT TO authenticated
  USING ((select auth.uid()) = user_id);

CREATE POLICY addresses_insert_own ON public.addresses
  FOR INSERT TO authenticated
  WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY addresses_update_own ON public.addresses
  FOR UPDATE TO authenticated
  USING ((select auth.uid()) = user_id)
  WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY addresses_delete_own ON public.addresses
  FOR DELETE TO authenticated
  USING ((select auth.uid()) = user_id);

-- carts
DROP POLICY IF EXISTS carts_select_own ON public.carts;
DROP POLICY IF EXISTS carts_insert_own ON public.carts;
DROP POLICY IF EXISTS carts_update_own ON public.carts;
DROP POLICY IF EXISTS carts_delete_own ON public.carts;

CREATE POLICY carts_select_own ON public.carts
  FOR SELECT TO authenticated
  USING ((select auth.uid()) = user_id);

CREATE POLICY carts_insert_own ON public.carts
  FOR INSERT TO authenticated
  WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY carts_update_own ON public.carts
  FOR UPDATE TO authenticated
  USING ((select auth.uid()) = user_id)
  WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY carts_delete_own ON public.carts
  FOR DELETE TO authenticated
  USING ((select auth.uid()) = user_id);

-- cart_items
DROP POLICY IF EXISTS cart_items_select_own ON public.cart_items;
DROP POLICY IF EXISTS cart_items_insert_own ON public.cart_items;
DROP POLICY IF EXISTS cart_items_update_own ON public.cart_items;
DROP POLICY IF EXISTS cart_items_delete_own ON public.cart_items;

CREATE POLICY cart_items_select_own ON public.cart_items
  FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM carts
    WHERE carts.id = cart_items.cart_id
      AND carts.user_id = (select auth.uid())
  ));

CREATE POLICY cart_items_insert_own ON public.cart_items
  FOR INSERT TO authenticated
  WITH CHECK (EXISTS (
    SELECT 1 FROM carts
    WHERE carts.id = cart_items.cart_id
      AND carts.user_id = (select auth.uid())
  ));

CREATE POLICY cart_items_update_own ON public.cart_items
  FOR UPDATE TO authenticated
  USING (EXISTS (
    SELECT 1 FROM carts
    WHERE carts.id = cart_items.cart_id
      AND carts.user_id = (select auth.uid())
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM carts
    WHERE carts.id = cart_items.cart_id
      AND carts.user_id = (select auth.uid())
  ));

CREATE POLICY cart_items_delete_own ON public.cart_items
  FOR DELETE TO authenticated
  USING (EXISTS (
    SELECT 1 FROM carts
    WHERE carts.id = cart_items.cart_id
      AND carts.user_id = (select auth.uid())
  ));

-- wishlist_items
DROP POLICY IF EXISTS wishlist_select_own ON public.wishlist_items;
DROP POLICY IF EXISTS wishlist_insert_own ON public.wishlist_items;
DROP POLICY IF EXISTS wishlist_delete_own ON public.wishlist_items;

CREATE POLICY wishlist_select_own ON public.wishlist_items
  FOR SELECT TO authenticated
  USING ((select auth.uid()) = user_id);

CREATE POLICY wishlist_insert_own ON public.wishlist_items
  FOR INSERT TO authenticated
  WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY wishlist_delete_own ON public.wishlist_items
  FOR DELETE TO authenticated
  USING ((select auth.uid()) = user_id);

-- orders
DROP POLICY IF EXISTS orders_select_own ON public.orders;
DROP POLICY IF EXISTS orders_insert_own ON public.orders;

CREATE POLICY orders_select_own ON public.orders
  FOR SELECT TO authenticated
  USING ((select auth.uid()) = user_id);

CREATE POLICY orders_insert_own ON public.orders
  FOR INSERT TO authenticated
  WITH CHECK ((select auth.uid()) = user_id);

-- order_items
DROP POLICY IF EXISTS order_items_select_own ON public.order_items;

CREATE POLICY order_items_select_own ON public.order_items
  FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM orders
    WHERE orders.id = order_items.order_id
      AND orders.user_id = (select auth.uid())
  ));

-- reviews
DROP POLICY IF EXISTS reviews_insert_own ON public.reviews;
DROP POLICY IF EXISTS reviews_update_own_unapproved ON public.reviews;
DROP POLICY IF EXISTS reviews_delete_own_unapproved ON public.reviews;

CREATE POLICY reviews_insert_own ON public.reviews
  FOR INSERT TO authenticated
  WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY reviews_update_own_unapproved ON public.reviews
  FOR UPDATE TO authenticated
  USING (((select auth.uid()) = user_id) AND (approved = false))
  WITH CHECK (((select auth.uid()) = user_id) AND (approved = false));

CREATE POLICY reviews_delete_own_unapproved ON public.reviews
  FOR DELETE TO authenticated
  USING (((select auth.uid()) = user_id) AND (approved = false));
