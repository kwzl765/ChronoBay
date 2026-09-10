/*
# Revoke unnecessary anon privileges

Supabase's default grants give the anon role full CRUD on all public tables.
With RLS enabled this isn't a direct data leak, but it violates least-privilege
principles. This migration revokes all write privileges from anon and limits
anon to SELECT only on public catalogue tables that have public read policies.

Authenticated users retain only the privileges matching their RLS policies.
*/

-- Anon: SELECT only on public catalogue tables
REVOKE ALL ON public.profiles FROM anon;
REVOKE ALL ON public.user_roles FROM anon;
REVOKE ALL ON public.brands FROM anon;
REVOKE ALL ON public.categories FROM anon;
REVOKE ALL ON public.products FROM anon;
REVOKE ALL ON public.product_images FROM anon;
REVOKE ALL ON public.inventory FROM anon;
REVOKE ALL ON public.addresses FROM anon;
REVOKE ALL ON public.carts FROM anon;
REVOKE ALL ON public.cart_items FROM anon;
REVOKE ALL ON public.wishlist_items FROM anon;
REVOKE ALL ON public.orders FROM anon;
REVOKE ALL ON public.order_items FROM anon;
REVOKE ALL ON public.reviews FROM anon;

GRANT SELECT ON public.brands TO anon;
GRANT SELECT ON public.categories TO anon;
GRANT SELECT ON public.products TO anon;
GRANT SELECT ON public.product_images TO anon;
GRANT SELECT ON public.inventory TO anon;
GRANT SELECT ON public.reviews TO anon;

-- Authenticated: keep only what they need
REVOKE ALL ON public.profiles FROM authenticated;
REVOKE ALL ON public.user_roles FROM authenticated;
REVOKE ALL ON public.brands FROM authenticated;
REVOKE ALL ON public.categories FROM authenticated;
REVOKE ALL ON public.products FROM authenticated;
REVOKE ALL ON public.product_images FROM authenticated;
REVOKE ALL ON public.inventory FROM authenticated;
REVOKE ALL ON public.addresses FROM authenticated;
REVOKE ALL ON public.carts FROM authenticated;
REVOKE ALL ON public.cart_items FROM authenticated;
REVOKE ALL ON public.wishlist_items FROM authenticated;
REVOKE ALL ON public.orders FROM authenticated;
REVOKE ALL ON public.order_items FROM authenticated;
REVOKE ALL ON public.reviews FROM authenticated;

-- Catalogue reads
GRANT SELECT ON public.brands TO authenticated;
GRANT SELECT ON public.categories TO authenticated;
GRANT SELECT ON public.products TO authenticated;
GRANT SELECT ON public.product_images TO authenticated;
GRANT SELECT ON public.inventory TO authenticated;
GRANT SELECT ON public.reviews TO authenticated;

-- Profile
GRANT SELECT, UPDATE ON public.profiles TO authenticated;

-- Role lookup
GRANT SELECT ON public.user_roles TO authenticated;

-- Addresses: full CRUD
GRANT SELECT, INSERT, UPDATE, DELETE ON public.addresses TO authenticated;

-- Cart + cart items: full CRUD
GRANT SELECT, INSERT, UPDATE, DELETE ON public.carts TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.cart_items TO authenticated;

-- Wishlist: read, add, remove
GRANT SELECT, INSERT, DELETE ON public.wishlist_items TO authenticated;

-- Orders: create + read own
GRANT SELECT, INSERT ON public.orders TO authenticated;

-- Order items: read own
GRANT SELECT ON public.order_items TO authenticated;

-- Reviews: create + read, update/delete own
GRANT SELECT, INSERT ON public.reviews TO authenticated;
GRANT UPDATE, DELETE ON public.reviews TO authenticated;
