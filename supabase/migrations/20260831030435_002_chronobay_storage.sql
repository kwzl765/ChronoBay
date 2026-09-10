/*
# ChronoBay Storage Buckets and Policies

## Overview
Creates three storage buckets for the ChronoBay store:
- `brand-assets`: brand logos and banners (public read, staff write)
- `product-images`: product photos (public read, staff write)
- `avatars`: user profile pictures (public read, user writes only own folder)

## Security
- No anonymous uploads allowed on any bucket
- Brand assets & product images: admin/staff write only (via has_role check)
- Avatars: users can write only inside a folder named after their auth.uid()
- All buckets allow public read
*/

INSERT INTO storage.buckets (id, name, public)
VALUES ('brand-assets', 'brand-assets', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.buckets (id, name, public)
VALUES ('product-images', 'product-images', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- BRAND-ASSETS POLICIES
-- ============================================================

DROP POLICY IF EXISTS "brand_assets_read_public" ON storage.objects;
CREATE POLICY "brand_assets_read_public"
  ON storage.objects FOR SELECT
  TO anon, authenticated
  USING (bucket_id = 'brand-assets');

DROP POLICY IF EXISTS "brand_assets_insert_staff" ON storage.objects;
CREATE POLICY "brand_assets_insert_staff"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'brand-assets'
    AND (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role))
  );

DROP POLICY IF EXISTS "brand_assets_update_staff" ON storage.objects;
CREATE POLICY "brand_assets_update_staff"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'brand-assets'
    AND (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role))
  )
  WITH CHECK (
    bucket_id = 'brand-assets'
    AND (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role))
  );

DROP POLICY IF EXISTS "brand_assets_delete_staff" ON storage.objects;
CREATE POLICY "brand_assets_delete_staff"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'brand-assets'
    AND (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role))
  );

-- ============================================================
-- PRODUCT-IMAGES POLICIES
-- ============================================================

DROP POLICY IF EXISTS "product_images_read_public" ON storage.objects;
CREATE POLICY "product_images_read_public"
  ON storage.objects FOR SELECT
  TO anon, authenticated
  USING (bucket_id = 'product-images');

DROP POLICY IF EXISTS "product_images_insert_staff" ON storage.objects;
CREATE POLICY "product_images_insert_staff"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'product-images'
    AND (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role))
  );

DROP POLICY IF EXISTS "product_images_update_staff" ON storage.objects;
CREATE POLICY "product_images_update_staff"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'product-images'
    AND (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role))
  )
  WITH CHECK (
    bucket_id = 'product-images'
    AND (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role))
  );

DROP POLICY IF EXISTS "product_images_delete_staff" ON storage.objects;
CREATE POLICY "product_images_delete_staff"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'product-images'
    AND (public.has_role('admin'::user_role) OR public.has_role('staff'::user_role))
  );

-- ============================================================
-- AVATARS POLICIES
-- ============================================================

DROP POLICY IF EXISTS "avatars_read_public" ON storage.objects;
CREATE POLICY "avatars_read_public"
  ON storage.objects FOR SELECT
  TO anon, authenticated
  USING (bucket_id = 'avatars');

DROP POLICY IF EXISTS "avatars_insert_own" ON storage.objects;
CREATE POLICY "avatars_insert_own"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

DROP POLICY IF EXISTS "avatars_update_own" ON storage.objects;
CREATE POLICY "avatars_update_own"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  )
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

DROP POLICY IF EXISTS "avatars_delete_own" ON storage.objects;
CREATE POLICY "avatars_delete_own"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );
