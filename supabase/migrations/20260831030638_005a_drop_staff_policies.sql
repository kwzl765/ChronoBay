/*
# Step 1: Drop all policies that depend on public.has_role

We need to move has_role to the private schema, but PostgreSQL won't let us
drop the function while policies depend on it. So we first drop all the
staff/admin policies, then in the next migration we'll recreate the function
in private and recreate all policies referencing it.
*/

-- Drop all staff policies on public tables
DROP POLICY IF EXISTS "brands_insert_staff" ON public.brands;
DROP POLICY IF EXISTS "brands_update_staff" ON public.brands;
DROP POLICY IF EXISTS "brands_delete_staff" ON public.brands;

DROP POLICY IF EXISTS "categories_insert_staff" ON public.categories;
DROP POLICY IF EXISTS "categories_update_staff" ON public.categories;
DROP POLICY IF EXISTS "categories_delete_staff" ON public.categories;

DROP POLICY IF EXISTS "products_insert_staff" ON public.products;
DROP POLICY IF EXISTS "products_update_staff" ON public.products;
DROP POLICY IF EXISTS "products_delete_staff" ON public.products;

DROP POLICY IF EXISTS "product_images_insert_staff" ON public.product_images;
DROP POLICY IF EXISTS "product_images_update_staff" ON public.product_images;
DROP POLICY IF EXISTS "product_images_delete_staff" ON public.product_images;

DROP POLICY IF EXISTS "inventory_insert_staff" ON public.inventory;
DROP POLICY IF EXISTS "inventory_update_staff" ON public.inventory;
DROP POLICY IF EXISTS "inventory_delete_staff" ON public.inventory;

DROP POLICY IF EXISTS "orders_select_staff" ON public.orders;
DROP POLICY IF EXISTS "orders_update_staff" ON public.orders;

DROP POLICY IF EXISTS "order_items_select_staff" ON public.order_items;

DROP POLICY IF EXISTS "reviews_update_staff" ON public.reviews;
DROP POLICY IF EXISTS "reviews_delete_staff" ON public.reviews;

-- Drop storage policies that depend on has_role
DROP POLICY IF EXISTS "brand_assets_insert_staff" ON storage.objects;
DROP POLICY IF EXISTS "brand_assets_update_staff" ON storage.objects;
DROP POLICY IF EXISTS "brand_assets_delete_staff" ON storage.objects;

DROP POLICY IF EXISTS "product_images_insert_staff" ON storage.objects;
DROP POLICY IF EXISTS "product_images_update_staff" ON storage.objects;
DROP POLICY IF EXISTS "product_images_delete_staff" ON storage.objects;
