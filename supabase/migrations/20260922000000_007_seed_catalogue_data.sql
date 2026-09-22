/*
# Seed Catalogue Data from CSV Product Specifications

## Overview
This migration populates the database with real product data from the brand CSV files.
It inserts brands, categories, products, product images, and inventory records.

## Data Sources
- Casio: 22 products
- Baby-G: 2 products
- Alexandre Christie: 62 products
- Microwear: 27 products
- Total: 113 products

## Tables Populated
1. brands — 4 brand records with logos, banners, descriptions
2. categories — 4 category records (men, women, smart-watches, clocks)
3. products — 113 product records with full specs and pricing
4. product_images — 1 image per product (stock photo placeholders)
5. inventory — stock quantities per product

## Notes
- Prices are generated in MMK based on brand-specific ranges
- Ratings and review counts are seeded with deterministic pseudo-random values
- Images use Pexels stock photos as placeholders until brand product photos are uploaded
- All products are set to 'active' status for immediate visibility
- This migration is idempotent: uses ON CONFLICT DO NOTHING for brands/categories,
  and ON CONFLICT DO UPDATE for products (upsert by slug)
*/

-- Use upserts for idempotency

-- ============================================================
-- BRANDS
-- ============================================================
INSERT INTO public.brands (name, slug, description, logo_url, banner_url, visual_family, featured, active, sort_order)
VALUES ('Alexandre Christie', 'alexandre-christie', 'Brazilian-inspired timepieces blending contemporary design with accessible luxury for the modern lifestyle.', '/brands/alexandre-christie/logo.svg', '/brands/alexandre-christie/alexandre-christie-banner.jpg', 'fashion', true, true, 1)
ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description, logo_url = EXCLUDED.logo_url, banner_url = EXCLUDED.banner_url, visual_family = EXCLUDED.visual_family, featured = EXCLUDED.featured, sort_order = EXCLUDED.sort_order;
INSERT INTO public.brands (name, slug, description, logo_url, banner_url, visual_family, featured, active, sort_order)
VALUES ('Baby-G', 'baby-g', 'Compact shock-resistant watches designed for active women. Tough protection meets playful styling.', '/brands/baby-g/logo.svg', '/brands/baby-g/baby-g-banner.jpg', 'sport', false, true, 2)
ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description, logo_url = EXCLUDED.logo_url, banner_url = EXCLUDED.banner_url, visual_family = EXCLUDED.visual_family, featured = EXCLUDED.featured, sort_order = EXCLUDED.sort_order;
INSERT INTO public.brands (name, slug, description, logo_url, banner_url, visual_family, featured, active, sort_order)
VALUES ('CASIO', 'casio', 'Innovative, reliable timepieces for every lifestyle. From classic digitals to advanced solar technology.', '/brands/casio/logo.svg', '/brands/casio/banner.svg', 'digital', true, true, 3)
ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description, logo_url = EXCLUDED.logo_url, banner_url = EXCLUDED.banner_url, visual_family = EXCLUDED.visual_family, featured = EXCLUDED.featured, sort_order = EXCLUDED.sort_order;
INSERT INTO public.brands (name, slug, description, logo_url, banner_url, visual_family, featured, active, sort_order)
VALUES ('Microwear', 'microwear', 'Affordable smartwatches with fitness tracking and connected features. Microwear makes wearable tech accessible.', '/brands/microwear/logo.svg', '/brands/microwear/banner.svg', 'digital', false, true, 4)
ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description, logo_url = EXCLUDED.logo_url, banner_url = EXCLUDED.banner_url, visual_family = EXCLUDED.visual_family, featured = EXCLUDED.featured, sort_order = EXCLUDED.sort_order;

-- ============================================================
-- CATEGORIES
-- ============================================================
INSERT INTO public.categories (name, slug, description, image_url, active, sort_order)
VALUES ('Men', 'men', 'Precision-engineered timepieces crafted for the modern gentleman.', 'https://images.pexels.com/photos/12835320/pexels-photo-12835320.jpeg?auto=compress&cs=tinysrgb&w=900', true, 1)
ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description, image_url = EXCLUDED.image_url, sort_order = EXCLUDED.sort_order;
INSERT INTO public.categories (name, slug, description, image_url, active, sort_order)
VALUES ('Women', 'women', 'Elegant watches that blend sophistication with timeless design.', 'https://images.pexels.com/photos/15210883/pexels-photo-15210883.jpeg?auto=compress&cs=tinysrgb&w=900', true, 2)
ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description, image_url = EXCLUDED.image_url, sort_order = EXCLUDED.sort_order;
INSERT INTO public.categories (name, slug, description, image_url, active, sort_order)
VALUES ('Smart Watches', 'smart-watches', 'Connected wearables that keep you in sync with every moment.', 'https://images.pexels.com/photos/18662969/pexels-photo-18662969.jpeg?auto=compress&cs=tinysrgb&w=900', true, 3)
ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description, image_url = EXCLUDED.image_url, sort_order = EXCLUDED.sort_order;
INSERT INTO public.categories (name, slug, description, image_url, active, sort_order)
VALUES ('Clocks', 'clocks', 'Statement wall clocks for homes and offices that command attention.', 'https://images.pexels.com/photos/14976142/pexels-photo-14976142.jpeg?auto=compress&cs=tinysrgb&w=900', true, 4)
ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description, image_url = EXCLUDED.image_url, sort_order = EXCLUDED.sort_order;

-- ============================================================
-- PRODUCTS
-- ============================================================
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CA158WA-1D', 'casio-ca158wa-1d', 'CA158WA-1D', 'The CA158WA-1D by Casio is a unisex''s digital watch. Featuring a stainless steel case with a black dial. Protected by resin. Finished with a stainless', 'The CA158WA-1D by Casio is a unisex''s digital watch. Featuring a stainless steel case with a black dial. Protected by resin. Finished with a stainless steel band in silver. Water resistance: Water-Resistant. Approx. battery life: 7 years on CR2016.', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', 'Water-Resistant', 12, 239000, 305000, 'MMK', 'active', true, false, 3.9, 24
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CAE-1000W-8A', 'casio-cae-1000w-8a', 'CAE-1000W-8A', 'The CAE-1000W-8A by Casio is a unisex''s digital watch. Featuring a resin case with a gray dial. Protected by resin glass. Finished with a resin band i', 'The CAE-1000W-8A by Casio is a unisex''s digital watch. Featuring a resin case with a gray dial. Protected by resin glass. Finished with a resin band in gray. Water resistance: 100 meters. Approx. 10 years on a CR2025 battery.', 'Unisex', 'Quartz', 'Resin', 'Resin', '100 meters', 12, 134000, 174000, 'MMK', 'active', true, false, 4, 80
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CAE-1200WHD-1A', 'casio-cae-1200whd-1a', 'CAE-1200WHD-1A', 'The CAE-1200WHD-1A by Casio is a unisex''s digital watch. Featuring a stainless steel case with a gray and black dial. Protected by resin glass. Finish', 'The CAE-1200WHD-1A by Casio is a unisex''s digital watch. Featuring a stainless steel case with a gray and black dial. Protected by resin glass. Finished with a stainless steel band in gray. Water resistance: 100 Metres. Approx. battery life: 10 years on CR2025.', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '100 Metres', 12, 188000, 225000, 'MMK', 'active', true, false, 4.7, 151
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CAE-1600H-5A', 'casio-cae-1600h-5a', 'CAE-1600H-5A', 'The CAE-1600H-5A by Casio is a unisex''s digital watch. Featuring a resin case with a gray dial. Protected by resin glass. Finished with a resin band i', 'The CAE-1600H-5A by Casio is a unisex''s digital watch. Featuring a resin case with a gray dial. Protected by resin glass. Finished with a resin band in beige. Water resistance: 100-meter. Approx. battery life: 10 years on CR2032.', 'Unisex', 'Quartz', 'Resin', 'Resin', '100-meter', 12, 285000, NULL, 'MMK', 'active', true, false, 4.4, 56
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CB640WB-1A', 'casio-cb640wb-1a', 'CB640WB-1A', 'The CB640WB-1A by Casio is a unisex''s digital watch. Featuring a resin case with a black dial. Protected by resin glass. Finished with a stainless ste', 'The CB640WB-1A by Casio is a unisex''s digital watch. Featuring a resin case with a black dial. Protected by resin glass. Finished with a stainless steel band in black. Water resistance: 50-meter. Approx. battery life: 3 years on CR2016.', 'Unisex', 'Quartz', 'Resin', 'Stainless Steel', '50-meter', 12, 275000, 346000, 'MMK', 'active', false, false, 3.9, 130
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CA130WEG-9A', 'casio-ca130weg-9a', 'CA130WEG-9A', 'The CA130WEG-9A by Casio is a unisex''s digital watch. Featuring a resin case with a gold dial. Protected by resin glass. Finished with a stainless ste', 'The CA130WEG-9A by Casio is a unisex''s digital watch. Featuring a resin case with a gold dial. Protected by resin glass. Finished with a stainless steel band in gold. Water resistance: 10 meter. Approx. battery life: 3 years on CR1616.', 'Unisex', 'Quartz', 'Resin', 'Stainless Steel', '10 meter', 12, 228000, 273000, 'MMK', 'active', false, false, 4, 54
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CA168WEMB-1B', 'casio-ca168wemb-1b', 'CA168WEMB-1B', 'The CA168WEMB-1B by Casio is a unisex''s digital watch. Featuring a stainless steel case with a black dial. Protected by resin glass. Finished with a s', 'The CA168WEMB-1B by Casio is a unisex''s digital watch. Featuring a stainless steel case with a black dial. Protected by resin glass. Finished with a stainless steel band in black. Water resistance: 30 meter. Approx. battery life: 7 years on CR2016.', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless steel', '30 meter', 12, 226000, 288000, 'MMK', 'active', false, false, 4.7, 108
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CAE-1500WHC-1A', 'casio-cae-1500whc-1a', 'CAE-1500WHC-1A', 'The CAE-1500WHC-1A by Casio is a unisex''s digital watch. Featuring a resin case with a green dial. Protected by resin glass. Finished with a resin ban', 'The CAE-1500WHC-1A by Casio is a unisex''s digital watch. Featuring a resin case with a green dial. Protected by resin glass. Finished with a resin band in black. Water resistance: 100 Meter. Approx. battery life: 10 years on CR2032.', 'Unisex', 'Quartz', 'Resin', 'Resin', '100 Meter', 12, 125000, NULL, 'MMK', 'active', false, false, 4.6, 171
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CAE-1500WHC-8A', 'casio-cae-1500whc-8a', 'CAE-1500WHC-8A', 'The CAE-1500WHC-8A by Casio is a unisex''s digital watch. Featuring a resin case with a orange, black dial. Protected by resin glass. Finished with a r', 'The CAE-1500WHC-8A by Casio is a unisex''s digital watch. Featuring a resin case with a orange, black dial. Protected by resin glass. Finished with a resin band band in grey. Water resistance: 100-meter. Approx. battery life: 10 years on CR2032.', 'Unisex', 'Quartz', 'Resin', 'Resin Band', '100-meter', 12, 229000, 285000, 'MMK', 'active', false, false, 4, 171
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CAE-1700H-1A', 'casio-cae-1700h-1a', 'CAE-1700H-1A', 'The CAE-1700H-1A by Casio is a unisex''s digital watch. Featuring a resin and aluminum case with a gray/liquid crystal dial. Protected by resin glass. ', 'The CAE-1700H-1A by Casio is a unisex''s digital watch. Featuring a resin and aluminum case with a gray/liquid crystal dial. Protected by resin glass. Finished with a resin band in black. Water resistance: 100-meter. Approx. battery life: 10 years on CR2032.', 'Unisex', 'Quartz', 'Resin And Aluminum', 'Resin', '100-meter', 12, 117000, 148000, 'MMK', 'active', false, false, 4.2, 185
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CAE-1700H-1A2', 'casio-cae-1700h-1a2', 'CAE-1700H-1A2', 'The CAE-1700H-1A2 by Casio is a unisex''s digital watch. Featuring a resin case with a gray dial. Protected by resin glass. Finished with a resin band ', 'The CAE-1700H-1A2 by Casio is a unisex''s digital watch. Featuring a resin case with a gray dial. Protected by resin glass. Finished with a resin band in black. Water resistance: 100-meter. Approx. battery life: 10 years on CR2032.', 'Unisex', 'Quartz', 'Resin', 'Resin', '100-meter', 12, 89000, 110000, 'MMK', 'active', false, false, 4.4, 130
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CW-221H-8A', 'casio-cw-221h-8a', 'CW-221H-8A', 'The CW-221H-8A by Casio is a unisex''s digital watch. Featuring a resin case with a ream/beige and grey dial. Protected by resin glass. Finished with a', 'The CW-221H-8A by Casio is a unisex''s digital watch. Featuring a resin case with a ream/beige and grey dial. Protected by resin glass. Finished with a resin band in beige. Water resistance: 50-meter. Approx. battery life: 10 years on CR2032.', 'Unisex', 'Quartz', 'Resin', 'Resin', '50-meter', 12, 276000, NULL, 'MMK', 'active', false, false, 4.1, 164
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CMTP-V004D-7B2', 'casio-cmtp-v004d-7b2', 'CMTP-V004D-7B2', 'The CMTP-V004D-7B2 by Casio is a unisex''s digital watch. Featuring a stainless steel case with a silver dial. Protected by mineral glass. Finished wit', 'The CMTP-V004D-7B2 by Casio is a unisex''s digital watch. Featuring a stainless steel case with a silver dial. Protected by mineral glass. Finished with a stainless steel band in silver. Water resistance: 30 meter. Approx. battery life: 3 years on SR626SW.', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '30 meter', 12, 108000, 128000, 'MMK', 'active', false, false, 4.1, 73
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CMQ-24DA-2A', 'casio-cmq-24da-2a', 'CMQ-24DA-2A', 'The CMQ-24DA-2A by Casio is a unisex''s digital watch. Featuring a resin case with a blue dial. Protected by resin glass. Finished with a stainless ste', 'The CMQ-24DA-2A by Casio is a unisex''s digital watch. Featuring a resin case with a blue dial. Protected by resin glass. Finished with a stainless steel band in silver. Water resistance: 30 meter. Approx. battery life: 3 years on SR626SW.', 'Unisex', 'Quartz', 'Resin', 'Stainless steel', '30 meter', 12, 159000, 205000, 'MMK', 'active', false, false, 4.3, 141
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CLWS-2200H-1A', 'casio-clws-2200h-1a', 'CLWS-2200H-1A', 'The CLWS-2200H-1A by Casio is a unisex''s digital watch. Featuring a resin case with a black dial. Protected by resin glass. Finished with a resin band', 'The CLWS-2200H-1A by Casio is a unisex''s digital watch. Featuring a resin case with a black dial. Protected by resin glass. Finished with a resin band in black. Water resistance: 100-meter. Approx. battery life: 2 years on CR1620.', 'Unisex', 'Quartz', 'Resin', 'Resin', '100-meter', 12, 217000, 281000, 'MMK', 'active', false, false, 4.8, 166
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CLW-204-9A', 'casio-clw-204-9a', 'CLW-204-9A', 'The CLW-204-9A by Casio is a women''s digital watch. Featuring a resin case with a cream / gold dial. Protected by resin glass. Finished with a resin b', 'The CLW-204-9A by Casio is a women''s digital watch. Featuring a resin case with a cream / gold dial. Protected by resin glass. Finished with a resin band in cream. Water resistance: 50-meter. Approx. battery life: 3 years on CR2016.', 'Women', 'Quartz', 'Resin', 'Resin', '50-meter', 12, 112000, 136000, 'MMK', 'active', false, false, 3.8, 46
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CAE-1700H-1B', 'casio-cae-1700h-1b', 'CAE-1700H-1B', 'The CAE-1700H-1B by Casio is a unisex''s digital watch. Featuring a resin case with a black dial. Protected by resin glass. Finished with a aluminum ba', 'The CAE-1700H-1B by Casio is a unisex''s digital watch. Featuring a resin case with a black dial. Protected by resin glass. Finished with a aluminum band in black. Water resistance: 100-meter. Approx. battery life: 10 years on CR2032.', 'Unisex', 'Quartz', 'Resin', 'Aluminum', '100-meter', 12, 176000, 211000, 'MMK', 'active', false, false, 4.4, 15
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CDW-291H-1A', 'casio-cdw-291h-1a', 'CDW-291H-1A', 'The CDW-291H-1A by Casio is a unisex''s digital watch. Featuring a resin case with a gold dial. Protected by mineral glass. Finished with a resin band ', 'The CDW-291H-1A by Casio is a unisex''s digital watch. Featuring a resin case with a gold dial. Protected by mineral glass. Finished with a resin band in black. Water resistance: 200-meter. Approx. battery life: 10 years on CR2025.', 'Unisex', 'Quartz', 'Resin', 'resin', '200-meter', 12, 87000, NULL, 'MMK', 'active', false, false, 4.5, 183
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CDW-291HX-1A', 'casio-cdw-291hx-1a', 'CDW-291HX-1A', 'The CDW-291HX-1A by Casio is a unisex''s digital watch. Featuring a resin case with a black dial. Protected by mineral glass. Finished with a resin ban', 'The CDW-291HX-1A by Casio is a unisex''s digital watch. Featuring a resin case with a black dial. Protected by mineral glass. Finished with a resin band in black. Water resistance: 200-meter. Approx. battery life: 10 years on CR2025.', 'Unisex', 'Quartz', 'Resin', 'Resin', '200-meter', 12, 282000, 350000, 'MMK', 'active', false, false, 4.1, 46
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CLTP-1183A-7A', 'casio-cltp-1183a-7a', 'CLTP-1183A-7A', 'The CLTP-1183A-7A by Casio is a women''s digital watch. Featuring a stainless steel case with a silver dial. Protected by mineral glass. Finished with ', 'The CLTP-1183A-7A by Casio is a women''s digital watch. Featuring a stainless steel case with a silver dial. Protected by mineral glass. Finished with a stainless steel band in silver. Water resistance: 30 meters. Approx. battery life: 3 years on SR621SW.', 'Women', 'Quartz', 'Stainless Steel', 'Stainless Steel', '30 meters', 12, 284000, NULL, 'MMK', 'active', false, false, 4.7, 174
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CLTP-V006L-7B', 'casio-cltp-v006l-7b', 'CLTP-V006L-7B', 'The CLTP-V006L-7B by Casio is a women''s digital watch. Featuring a stainless steel case with a white. dial. Protected by mineral glass. Finished with ', 'The CLTP-V006L-7B by Casio is a women''s digital watch. Featuring a stainless steel case with a white. dial. Protected by mineral glass. Finished with a leather band in black. Water resistance: 30 meters. Approx. battery life: 3 years on SR626SW.', 'Women', 'Quartz', 'Stainless Steel', 'Leather', '30 meters', 12, 179000, NULL, 'MMK', 'active', false, false, 4.7, 125
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Casio CLW-204-7A', 'casio-clw-204-7a', 'CLW-204-7A', 'The CLW-204-7A by Casio is a unisex''s digital watch. Featuring a resin case with a white dial. Protected by resin glass. Finished with a resin band in', 'The CLW-204-7A by Casio is a unisex''s digital watch. Featuring a resin case with a white dial. Protected by resin glass. Finished with a resin band in gray. Water resistance: 50-meter. Approx. battery life: 3 years on CR2016.', 'Unisex', 'Quartz', 'Resin', 'Resin', '50-meter', 12, 141000, 171000, 'MMK', 'active', false, false, 4.5, 161
FROM public.brands b, public.categories c
WHERE b.slug = 'casio' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Baby-G CBG-169U-4B', 'baby-g-cbg-169u-4b', 'CBG-169U-4B', 'The CBG-169U-4B by Baby-G is a women''s digital watch. Featuring a resin case with a pink dial. Protected by mineral. Finished with a resin band band i', 'The CBG-169U-4B by Baby-G is a women''s digital watch. Featuring a resin case with a pink dial. Protected by mineral. Finished with a resin band band in pink. Water resistance: 20 ATM.', 'Women', 'Quartz', 'Resin', 'Resin Band', '20 ATM', 12, 248000, 303000, 'MMK', 'active', false, false, 4.1, 96
FROM public.brands b, public.categories c
WHERE b.slug = 'baby-g' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Baby-G CBA-110XBE-7A', 'baby-g-cba-110xbe-7a', 'CBA-110XBE-7A', 'The CBA-110XBE-7A by Baby-G is a women''s digital watch. Featuring a resin case with a blue dial. Protected by mineral. Finished with a resin band band', 'The CBA-110XBE-7A by Baby-G is a women''s digital watch. Featuring a resin case with a blue dial. Protected by mineral. Finished with a resin band band in white. Water resistance: 100M.', 'Women', 'Quartz', 'Resin', 'Resin Band', '100M', 12, 227000, NULL, 'MMK', 'active', false, false, 4.3, 173
FROM public.brands b, public.categories c
WHERE b.slug = 'baby-g' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear MA27(Black)', 'microwear-ma27-black', 'MA27(Black)', 'The MA27(Black) by Microwear is a unisex''s smart watch. 430MAH Lithium ion polymer battery.', 'The MA27(Black) by Microwear is a unisex''s smart watch. 430MAH Lithium ion polymer battery.', 'Unisex', 'Quartz', '', '', '', 12, 214000, NULL, 'MMK', 'active', false, false, 4, 62
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear MA27(Titanium)', 'microwear-ma27-titanium', 'MA27(Titanium)', 'The MA27(Titanium) by Microwear is a unisex''s smart watch. 430MAH Lithium ion polymer battery.', 'The MA27(Titanium) by Microwear is a unisex''s smart watch. 430MAH Lithium ion polymer battery.', 'Unisex', 'Quartz', '', '', '', 12, 133000, 160000, 'MMK', 'active', false, false, 4.3, 14
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear MA31(Silver)', 'microwear-ma31-silver', 'MA31(Silver)', 'The MA31(Silver) by Microwear is a unisex''s smart watch. 380MAH Lithium ion polymer battery.', 'The MA31(Silver) by Microwear is a unisex''s smart watch. 380MAH Lithium ion polymer battery.', 'Unisex', 'Quartz', '', '', '', 12, 113000, 142000, 'MMK', 'active', false, false, 4, 152
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear MA35(Black)', 'microwear-ma35-black', 'MA35(Black)', 'The MA35(Black) by Microwear is a unisex''s smart watch. 350mAh large capacity polymer battery.', 'The MA35(Black) by Microwear is a unisex''s smart watch. 350mAh large capacity polymer battery.', 'Unisex', 'Quartz', '', '', '', 12, 125000, 155000, 'MMK', 'active', false, false, 4.4, 202
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear MA35(Pink)', 'microwear-ma35-pink', 'MA35(Pink)', 'The MA35(Pink) by Microwear is a unisex''s smart watch. 350mAh large capacity polymer battery.', 'The MA35(Pink) by Microwear is a unisex''s smart watch. 350mAh large capacity polymer battery.', 'Unisex', 'Quartz', '', '', '', 12, 167000, NULL, 'MMK', 'active', false, false, 3.9, 17
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear MA35(Silver)', 'microwear-ma35-silver', 'MA35(Silver)', 'The MA35(Silver) by Microwear is a unisex''s smart watch. 350mAh large capacity polymer battery.', 'The MA35(Silver) by Microwear is a unisex''s smart watch. 350mAh large capacity polymer battery.', 'Unisex', 'Quartz', '', '', '', 12, 191000, 236000, 'MMK', 'active', false, false, 4.3, 157
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear U5plus(Black)', 'microwear-u5plus-black', 'U5plus(Black)', 'The U5plus(Black) by Microwear is a unisex''s smart watch. 350 MAH Lithium ion polymer battery, wireless charger, 150mins to full charge.', 'The U5plus(Black) by Microwear is a unisex''s smart watch. 350 MAH Lithium ion polymer battery, wireless charger, 150mins to full charge.', 'Unisex', 'Quartz', '', '', '', 12, 238000, 290000, 'MMK', 'active', false, false, 4, 28
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear U5plus(Silver)', 'microwear-u5plus-silver', 'U5plus(Silver)', 'The U5plus(Silver) by Microwear is a unisex''s smart watch. 350 MAH Lithium ion polymer battery, wireless charger, 150mins to full charge.', 'The U5plus(Silver) by Microwear is a unisex''s smart watch. 350 MAH Lithium ion polymer battery, wireless charger, 150mins to full charge.', 'Unisex', 'Quartz', '', '', '', 12, 123000, 143000, 'MMK', 'active', false, false, 4.5, 5
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear Ultra3Mini(S.Black)', 'microwear-ultra3mini-s-black', 'Ultra3Mini(S.Black)', 'The Ultra3Mini(S.Black) by Microwear is a women''s smart watch. 350MAH Lithium ion polymer battery.', 'The Ultra3Mini(S.Black) by Microwear is a women''s smart watch. 350MAH Lithium ion polymer battery.', 'Women', 'Quartz', '', '', '', 12, 239000, 303000, 'MMK', 'active', false, false, 4.9, 130
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear W10P(Black)', 'microwear-w10p-black', 'W10P(Black)', 'The W10P(Black) by Microwear is a unisex''s smart watch. 375 MAH Lithium ion polymer battery.', 'The W10P(Black) by Microwear is a unisex''s smart watch. 375 MAH Lithium ion polymer battery.', 'Unisex', 'Quartz', '', '', '', 12, 171000, NULL, 'MMK', 'active', false, false, 4, 158
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear W10PMini(Black)', 'microwear-w10pmini-black', 'W10PMini(Black)', 'The W10PMini(Black) by Microwear is a women''s smart watch. 190MAH Lithium ion polymer battery.', 'The W10PMini(Black) by Microwear is a women''s smart watch. 190MAH Lithium ion polymer battery.', 'Women', 'Quartz', '', '', '', 12, 225000, 287000, 'MMK', 'active', false, false, 4, 175
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear W10PMini(Rose Gold)', 'microwear-w10pmini-rose-gold', 'W10PMini(Rose Gold)', 'The W10PMini(Rose Gold) by Microwear is a women''s smart watch. 190MAH Lithium ion polymer battery.', 'The W10PMini(Rose Gold) by Microwear is a women''s smart watch. 190MAH Lithium ion polymer battery.', 'Women', 'Quartz', '', '', '', 12, 149000, NULL, 'MMK', 'active', false, false, 4.6, 169
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear W10PMini(Silver)', 'microwear-w10pmini-silver', 'W10PMini(Silver)', 'The W10PMini(Silver) by Microwear is a women''s smart watch. 190MAH Lithium ion polymer battery.', 'The W10PMini(Silver) by Microwear is a women''s smart watch. 190MAH Lithium ion polymer battery.', 'Women', 'Quartz', '', '', '', 12, 127000, 149000, 'MMK', 'active', false, false, 4.4, 30
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear W11A(Black)', 'microwear-w11a-black', 'W11A(Black)', 'The W11A(Black) by Microwear is a unisex''s smart watch. 800mAh.', 'The W11A(Black) by Microwear is a unisex''s smart watch. 800mAh.', 'Unisex', 'Quartz', '', '', '', 12, 209000, 258000, 'MMK', 'active', false, false, 4.6, 163
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear W11G(Black)', 'microwear-w11g-black', 'W11G(Black)', 'The W11G(Black) by Microwear is a unisex''s smart watch. 400MAH Lithium ion polymer battery.', 'The W11G(Black) by Microwear is a unisex''s smart watch. 400MAH Lithium ion polymer battery.', 'Unisex', 'Quartz', '', '', '', 12, 165000, NULL, 'MMK', 'active', false, false, 4, 88
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear W11P(Black)', 'microwear-w11p-black', 'W11P(Black)', 'The W11P(Black) by Microwear is a unisex''s smart watch. 375 MAH Lithium ion polymer battery.', 'The W11P(Black) by Microwear is a unisex''s smart watch. 375 MAH Lithium ion polymer battery.', 'Unisex', 'Quartz', '', '', '', 12, 104000, 129000, 'MMK', 'active', false, false, 4.3, 91
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear W11P(Orange)', 'microwear-w11p-orange', 'W11P(Orange)', 'The W11P(Orange) by Microwear is a unisex''s smart watch. 375 MAH Lithium ion polymer battery.', 'The W11P(Orange) by Microwear is a unisex''s smart watch. 375 MAH Lithium ion polymer battery.', 'Unisex', 'Quartz', '', '', '', 12, 119000, 143000, 'MMK', 'active', false, false, 4.2, 192
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear W11P(Silver)', 'microwear-w11p-silver', 'W11P(Silver)', 'The W11P(Silver) by Microwear is a unisex''s smart watch. 375 MAH Lithium ion polymer battery.', 'The W11P(Silver) by Microwear is a unisex''s smart watch. 375 MAH Lithium ion polymer battery.', 'Unisex', 'Quartz', '', '', '', 12, 97000, NULL, 'MMK', 'active', false, false, 4, 196
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear W11PMini(Black)', 'microwear-w11pmini-black', 'W11PMini(Black)', 'The W11PMini(Black) by Microwear is a women''s smart watch. 190MAH Lithium ion polymer battery.', 'The W11PMini(Black) by Microwear is a women''s smart watch. 190MAH Lithium ion polymer battery.', 'Women', 'Quartz', '', '', '', 12, 181000, 229000, 'MMK', 'active', false, false, 4.5, 63
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear W11PMini(Orange)', 'microwear-w11pmini-orange', 'W11PMini(Orange)', 'The W11PMini(Orange) by Microwear is a women''s smart watch. 190MAH Lithium ion polymer battery.', 'The W11PMini(Orange) by Microwear is a women''s smart watch. 190MAH Lithium ion polymer battery.', 'Women', 'Quartz', '', '', '', 12, 198000, 257000, 'MMK', 'active', false, false, 4.3, 89
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear W11PMini(Rose Gold)', 'microwear-w11pmini-rose-gold', 'W11PMini(Rose Gold)', 'The W11PMini(Rose Gold) by Microwear is a women''s smart watch. 190MAH Lithium ion polymer battery.', 'The W11PMini(Rose Gold) by Microwear is a women''s smart watch. 190MAH Lithium ion polymer battery.', 'Women', 'Quartz', '', '', '', 12, 182000, 214000, 'MMK', 'active', false, false, 4.7, 159
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear W11PMini(Silver)', 'microwear-w11pmini-silver', 'W11PMini(Silver)', 'The W11PMini(Silver) by Microwear is a women''s smart watch. 190MAH Lithium ion polymer battery.', 'The W11PMini(Silver) by Microwear is a women''s smart watch. 190MAH Lithium ion polymer battery.', 'Women', 'Quartz', '', '', '', 12, 163000, NULL, 'MMK', 'active', false, false, 3.9, 123
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear W11X(Black)', 'microwear-w11x-black', 'W11X(Black)', 'The W11X(Black) by Microwear is a unisex''s smart watch. 190MAH Lithium ion polymer battery.', 'The W11X(Black) by Microwear is a unisex''s smart watch. 190MAH Lithium ion polymer battery.', 'Unisex', 'Quartz', '', '', '', 12, 229000, NULL, 'MMK', 'active', false, false, 4.2, 81
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear W11X(Silver)', 'microwear-w11x-silver', 'W11X(Silver)', 'The W11X(Silver) by Microwear is a unisex''s smart watch. 190MAH Lithium ion polymer battery.', 'The W11X(Silver) by Microwear is a unisex''s smart watch. 190MAH Lithium ion polymer battery.', 'Unisex', 'Quartz', '', '', '', 12, 151000, NULL, 'MMK', 'active', false, false, 4.7, 37
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear WXMini(S.Black)', 'microwear-wxmini-s-black', 'WXMini(S.Black)', 'The WXMini(S.Black) by Microwear is a women''s smart watch. 350MAH Lithium ion polymer battery.', 'The WXMini(S.Black) by Microwear is a women''s smart watch. 350MAH Lithium ion polymer battery.', 'Women', 'Quartz', '', '', '', 12, 153000, 187000, 'MMK', 'active', false, false, 4.7, 150
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear Z403(Black)', 'microwear-z403-black', 'Z403(Black)', 'The Z403(Black) by Microwear is a unisex''s smart watch. 410mAh large capacity polymer battery.', 'The Z403(Black) by Microwear is a unisex''s smart watch. 410mAh large capacity polymer battery.', 'Unisex', 'Quartz', '', '', '', 12, 243000, 309000, 'MMK', 'active', false, false, 4.7, 136
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Microwear Z403(Orange)', 'microwear-z403-orange', 'Z403(Orange)', 'The Z403(Orange) by Microwear is a unisex''s smart watch. 410mAh large capacity polymer battery.', 'The Z403(Orange) by Microwear is a unisex''s smart watch. 410mAh large capacity polymer battery.', 'Unisex', 'Quartz', '', '', '', 12, 116000, NULL, 'MMK', 'active', false, false, 4.2, 107
FROM public.brands b, public.categories c
WHERE b.slug = 'microwear' AND c.slug = 'smart-watches'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC1007MDLIPBARG', 'alexandre-christie-ac1007mdlipbarg', 'AC1007MDLIPBARG', 'The AC1007MDLIPBARG by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal', 'The AC1007MDLIPBARG by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a leather band in black. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Leather', '3 ATM (30 Meters)', 12, 289000, 357000, 'MMK', 'active', false, false, 4.1, 148
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC1008MDBBRBA', 'alexandre-christie-ac1008mdbbrba', 'AC1008MDBBRBA', 'The AC1008MDBBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. ', 'The AC1008MDBBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a stainless steel band in black. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 111000, NULL, 'MMK', 'active', false, false, 4.5, 111
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC1008MDBSSSL', 'alexandre-christie-ac1008mdbsssl', 'AC1008MDBSSSL', 'The AC1008MDBSSSL by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a white dial. Protected by mineral crystal. ', 'The AC1008MDBSSSL by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a white dial. Protected by mineral crystal. Finished with a stainless steel band in silver. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 278000, NULL, 'MMK', 'active', false, false, 4.3, 146
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC1031LDBSSSL', 'alexandre-christie-ac1031ldbsssl', 'AC1031LDBSSSL', 'The AC1031LDBSSSL by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a silver dial. Protected by mineral crystal. ', 'The AC1031LDBSSSL by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a silver dial. Protected by mineral crystal. Finished with a stainless steel band in silver. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 201000, NULL, 'MMK', 'active', false, false, 4.1, 119
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC2977BFBRGSL', 'alexandre-christie-ac2977bfbrgsl', 'AC2977BFBRGSL', 'The AC2977BFBRGSL by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a silver dial. Protected by mineral crystal. ', 'The AC2977BFBRGSL by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a silver dial. Protected by mineral crystal. Finished with a stainless steel band in rose gold. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 303000, 352000, 'MMK', 'active', false, false, 3.9, 111
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC2977BFBURBU', 'alexandre-christie-ac2977bfburbu', 'AC2977BFBURBU', 'The AC2977BFBURBU by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a dark blue dial. Protected by mineral crysta', 'The AC2977BFBURBU by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a dark blue dial. Protected by mineral crystal. Finished with a stainless steel band in dark blue. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 305000, 368000, 'MMK', 'active', false, false, 4, 97
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC2A42BFBRGPU', 'alexandre-christie-ac2a42bfbrgpu', 'AC2A42BFBRGPU', 'The AC2A42BFBRGPU by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a purple dial. Protected by mineral crystal. ', 'The AC2A42BFBRGPU by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a purple dial. Protected by mineral crystal. Finished with a stainless steel band in rose gold. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 313000, 380000, 'MMK', 'active', false, false, 3.9, 187
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC2B36LHBRGSL', 'alexandre-christie-ac2b36lhbrgsl', 'AC2B36LHBRGSL', 'The AC2B36LHBRGSL by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a silver dial. Protected by sapphire crystal.', 'The AC2B36LHBRGSL by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a silver dial. Protected by sapphire crystal. Finished with a stainless steel (mesh strap) band in rose gold. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Stainless Steel (Mesh Strap)', '3 ATM (30 Meters)', 12, 129000, NULL, 'MMK', 'active', false, false, 4.4, 62
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC2B36LHBURBU', 'alexandre-christie-ac2b36lhburbu', 'AC2B36LHBURBU', 'The AC2B36LHBURBU by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a blue / rose gold dial. Protected by sapphir', 'The AC2B36LHBURBU by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a blue / rose gold dial. Protected by sapphire crystal. Finished with a stainless steel (mesh strap) band in blue. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Stainless Steel (Mesh Strap)', '3 ATM (30 Meters)', 12, 181000, 223000, 'MMK', 'active', false, false, 4.6, 48
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC2B52LHBRGPN', 'alexandre-christie-ac2b52lhbrgpn', 'AC2B52LHBRGPN', 'The AC2B52LHBRGPN by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a pink dial. Protected by mineral crystal. Fi', 'The AC2B52LHBRGPN by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a pink dial. Protected by mineral crystal. Finished with a stainless steel with acetate band in pink. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Stainless Steel With Acetate', '3 ATM (30 Meters)', 12, 288000, 346000, 'MMK', 'active', false, false, 4.5, 94
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC2B77LHRRGBO', 'alexandre-christie-ac2b77lhrrgbo', 'AC2B77LHRRGBO', 'The AC2B77LHRRGBO by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a brown dial. Protected by mineral crystal. F', 'The AC2B77LHRRGBO by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a brown dial. Protected by mineral crystal. Finished with a rubber / silicon band in brown. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Rubber / Silicon', '3 ATM (30 Meters)', 12, 345000, 427000, 'MMK', 'active', false, false, 3.9, 70
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC2C10LHBBRBA', 'alexandre-christie-ac2c10lhbbrba', 'AC2C10LHBBRBA', 'The AC2C10LHBBRBA by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. F', 'The AC2C10LHBBRBA by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a stainless steel band in black. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 185000, 234000, 'MMK', 'active', false, false, 4, 63
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC2C10LHBRGSL', 'alexandre-christie-ac2c10lhbrgsl', 'AC2C10LHBRGSL', 'The AC2C10LHBRGSL by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a silver dial. Protected by mineral crystal. ', 'The AC2C10LHBRGSL by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a silver dial. Protected by mineral crystal. Finished with a stainless steel band in rose gold. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 155000, 181000, 'MMK', 'active', false, false, 4.2, 72
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC2C13BFFBRBA', 'alexandre-christie-ac2c13bffbrba', 'AC2C13BFFBRBA', 'The AC2C13BFFBRBA by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. F', 'The AC2C13BFFBRBA by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a stainless steel band in black. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 280000, 333000, 'MMK', 'active', false, false, 4, 168
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC2C13BFFRGGR', 'alexandre-christie-ac2c13bffrggr', 'AC2C13BFFRGGR', 'The AC2C13BFFRGGR by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a grey dial. Protected by mineral crystal. Fi', 'The AC2C13BFFRGGR by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a grey dial. Protected by mineral crystal. Finished with a stainless steel band in rose gold. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 272000, 328000, 'MMK', 'active', false, false, 4.7, 134
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC3030MCLBRBA', 'alexandre-christie-ac3030mclbrba', 'AC3030MCLBRBA', 'The AC3030MCLBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. ', 'The AC3030MCLBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a leather band in brown. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Leather', '3 ATM (30 Meters)', 12, 243000, 307000, 'MMK', 'active', false, false, 4.4, 46
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC3030MCLCABA', 'alexandre-christie-ac3030mclcaba', 'AC3030MCLCABA', 'The AC3030MCLCABA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. ', 'The AC3030MCLCABA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a leather band in black. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Leather', '3 ATM (30 Meters)', 12, 279000, 341000, 'MMK', 'active', false, false, 4.4, 34
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC3030MCLTUBA', 'alexandre-christie-ac3030mcltuba', 'AC3030MCLTUBA', 'The AC3030MCLTUBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. ', 'The AC3030MCLTUBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a leather band in black. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Leather', '3 ATM (30 Meters)', 12, 210000, NULL, 'MMK', 'active', false, false, 4.6, 52
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC3039MCLBRBA', 'alexandre-christie-ac3039mclbrba', 'AC3039MCLBRBA', 'The AC3039MCLBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel with pvd coating case with a black dial. Protected by ', 'The AC3039MCLBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel with pvd coating case with a black dial. Protected by mineral crystal. Finished with a leather band in brown. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel with PVD Coating', 'Leather', '3 ATM (30 Meters)', 12, 161000, 207000, 'MMK', 'active', false, false, 4.3, 166
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC3039MCLRGBA', 'alexandre-christie-ac3039mclrgba', 'AC3039MCLRGBA', 'The AC3039MCLRGBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel with pvd coating case with a black dial. Protected by ', 'The AC3039MCLRGBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel with pvd coating case with a black dial. Protected by mineral crystal. Finished with a leather band in black. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel with PVD Coating', 'Leather', '3 ATM (30 Meters)', 12, 253000, NULL, 'MMK', 'active', false, false, 4.4, 111
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC3039MCLURBU', 'alexandre-christie-ac3039mclurbu', 'AC3039MCLURBU', 'The AC3039MCLURBU by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel with pvd coating case with a blue dial. Protected by m', 'The AC3039MCLURBU by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel with pvd coating case with a blue dial. Protected by mineral crystal. Finished with a leather band in black. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel with PVD Coating', 'Leather', '3 ATM (30 Meters)', 12, 276000, NULL, 'MMK', 'active', false, false, 4.3, 133
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC5002MDBGPGN', 'alexandre-christie-ac5002mdbgpgn', 'AC5002MDBGPGN', 'The AC5002MDBGPGN by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a green dial. Protected by mineral crystal. ', 'The AC5002MDBGPGN by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a green dial. Protected by mineral crystal. Finished with a stainless steel band in gold. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 300000, 361000, 'MMK', 'active', false, false, 4.6, 60
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC5002MDBTRSL', 'alexandre-christie-ac5002mdbtrsl', 'AC5002MDBTRSL', 'The AC5002MDBTRSL by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a silver dial. Protected by mineral crystal.', 'The AC5002MDBTRSL by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a silver dial. Protected by mineral crystal. Finished with a stainless steel band in rose gold /silver. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 266000, 309000, 'MMK', 'active', false, false, 4.9, 161
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC5013MDBRGBO3', 'alexandre-christie-ac5013mdbrgbo3', 'AC5013MDBRGBO3', 'The AC5013MDBRGBO3 by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a brown dial. Protected by sapphire crystal', 'The AC5013MDBRGBO3 by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a brown dial. Protected by sapphire crystal. Finished with a stainless steel band in rose gold. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 296000, 384000, 'MMK', 'active', false, false, 4.8, 92
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC5013MDBTRGR3', 'alexandre-christie-ac5013mdbtrgr3', 'AC5013MDBTRGR3', 'The AC5013MDBTRGR3 by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a gray dial. Protected by sapphire crystal.', 'The AC5013MDBTRGR3 by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a gray dial. Protected by sapphire crystal. Finished with a stainless steel band in rose gold/silver. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 314000, 407000, 'MMK', 'active', false, false, 3.9, 15
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC5013MDBTRSL3', 'alexandre-christie-ac5013mdbtrsl3', 'AC5013MDBTRSL3', 'The AC5013MDBTRSL3 by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a silver dial. Protected by sapphire crysta', 'The AC5013MDBTRSL3 by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a silver dial. Protected by sapphire crystal. Finished with a stainless steel band in rose gold/silver. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 314000, 390000, 'MMK', 'active', false, false, 4.1, 75
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6141MCBBRBA', 'alexandre-christie-ac6141mcbbrba', 'AC6141MCBBRBA', 'The AC6141MCBBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. ', 'The AC6141MCBBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a stainless steel band in black/rose gold. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 255000, NULL, 'MMK', 'active', false, false, 4.5, 91
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6141MCBROBO', 'alexandre-christie-ac6141mcbrobo', 'AC6141MCBROBO', 'The AC6141MCBROBO by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a brown dial. Protected by mineral crystal. ', 'The AC6141MCBROBO by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a brown dial. Protected by mineral crystal. Finished with a stainless steel band in brown. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 306000, 389000, 'MMK', 'active', false, false, 4.2, 120
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6141MCBTBSL', 'alexandre-christie-ac6141mcbtbsl', 'AC6141MCBTBSL', 'The AC6141MCBTBSL by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a white dial. Protected by mineral crystal. ', 'The AC6141MCBTBSL by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a white dial. Protected by mineral crystal. Finished with a stainless steel band in silver. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 338000, 419000, 'MMK', 'active', false, true, 4.3, 121
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6141MCBURBU', 'alexandre-christie-ac6141mcburbu', 'AC6141MCBURBU', 'The AC6141MCBURBU by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a blue dial. Protected by mineral crystal. F', 'The AC6141MCBURBU by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a blue dial. Protected by mineral crystal. Finished with a stainless steel band in blue. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 189000, 240000, 'MMK', 'active', false, true, 3.9, 135
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6295MCLBRBA', 'alexandre-christie-ac6295mclbrba', 'AC6295MCLBRBA', 'The AC6295MCLBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. ', 'The AC6295MCLBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a leather band in brown. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Leather', '5 ATM (50 Meters)', 12, 196000, 231000, 'MMK', 'active', false, true, 4.3, 84
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6295MCLIPBAIVBA', 'alexandre-christie-ac6295mclipbaivba', 'AC6295MCLIPBAIVBA', 'The AC6295MCLIPBAIVBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral cryst', 'The AC6295MCLIPBAIVBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a leather band in black. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Leather', '5 ATM (50 Meters)', 12, 163000, NULL, 'MMK', 'active', false, true, 4.4, 101
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6295MCLURBU', 'alexandre-christie-ac6295mclurbu', 'AC6295MCLURBU', 'The AC6295MCLURBU by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a blue dial. Protected by mineral crystal. F', 'The AC6295MCLURBU by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a blue dial. Protected by mineral crystal. Finished with a leather band in brown. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Leather', '5 ATM (50 Meters)', 12, 326000, 416000, 'MMK', 'active', false, true, 4.5, 77
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6323MCBBRBA', 'alexandre-christie-ac6323mcbbrba', 'AC6323MCBBRBA', 'The AC6323MCBBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. ', 'The AC6323MCBBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a stainless steel band in black. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '5 ATM (50 Meters)', 12, 340000, 418000, 'MMK', 'active', false, true, 3.9, 150
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6350MCBEPBA', 'alexandre-christie-ac6350mcbepba', 'AC6350MCBEPBA', 'The AC6350MCBEPBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. ', 'The AC6350MCBEPBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a stainless steel band in black. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '5 ATM (50 Meters)', 12, 288000, 340000, 'MMK', 'active', false, true, 4.9, 9
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6564BFBRGSL', 'alexandre-christie-ac6564bfbrgsl', 'AC6564BFBRGSL', 'The AC6564BFBRGSL by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a blue dial. Protected by mineral crystal. F', 'The AC6564BFBRGSL by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a blue dial. Protected by mineral crystal. Finished with a leather band in brown. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Leather', '5 ATM (50 Meters)', 12, 283000, 342000, 'MMK', 'active', false, true, 4, 202
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6564MCLBRBA', 'alexandre-christie-ac6564mclbrba', 'AC6564MCLBRBA', 'The AC6564MCLBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. ', 'The AC6564MCLBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a leather band in brown. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Leather', '5 ATM (50 Meters)', 12, 184000, 223000, 'MMK', 'active', false, true, 3.8, 177
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6564MCLURBU', 'alexandre-christie-ac6564mclurbu', 'AC6564MCLURBU', 'The AC6564MCLURBU by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a blue dial. Protected by mineral crystal. F', 'The AC6564MCLURBU by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a blue dial. Protected by mineral crystal. Finished with a leather band in brown. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Leather', '5 ATM (50 Meters)', 12, 163000, 203000, 'MMK', 'active', false, true, 3.9, 99
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6565MCREPBA', 'alexandre-christie-ac6565mcrepba', 'AC6565MCREPBA', 'The AC6565MCREPBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. ', 'The AC6565MCREPBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a rubber band in black. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Rubber', '5 ATM (50 Meters)', 12, 311000, NULL, 'MMK', 'active', false, true, 4.5, 34
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6565MCREPBARE', 'alexandre-christie-ac6565mcrepbare', 'AC6565MCREPBARE', 'The AC6565MCREPBARE by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal', 'The AC6565MCREPBARE by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a rubber band in red. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Rubber', '5 ATM (50 Meters)', 12, 341000, 430000, 'MMK', 'active', false, true, 4.4, 183
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6565MCRTBBA', 'alexandre-christie-ac6565mcrtbba', 'AC6565MCRTBBA', 'The AC6565MCRTBBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. ', 'The AC6565MCRTBBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a rubber band in black. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Rubber', '5 ATM (50 Meters)', 12, 131000, 167000, 'MMK', 'active', false, true, 4.2, 185
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6627MCRIPBAYL', 'alexandre-christie-ac6627mcripbayl', 'AC6627MCRIPBAYL', 'The AC6627MCRIPBAYL by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal', 'The AC6627MCRIPBAYL by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a leather band in black. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Leather', '5 ATM (50 Meters)', 12, 311000, 366000, 'MMK', 'active', false, true, 4.5, 179
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6688MCRIPBAYL', 'alexandre-christie-ac6688mcripbayl', 'AC6688MCRIPBAYL', 'The AC6688MCRIPBAYL by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal', 'The AC6688MCRIPBAYL by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a rubber band in black. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Rubber', '5 ATM (50 Meters)', 12, 337000, 413000, 'MMK', 'active', false, true, 3.9, 75
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6695MCFBRBA', 'alexandre-christie-ac6695mcfbrba', 'AC6695MCFBRBA', 'The AC6695MCFBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. ', 'The AC6695MCFBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a stainless steel band in black/rose gold. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '5 ATM (50 Meters)', 12, 156000, NULL, 'MMK', 'active', false, true, 4.5, 159
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6695MCFEPBA', 'alexandre-christie-ac6695mcfepba', 'AC6695MCFEPBA', 'The AC6695MCFEPBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. ', 'The AC6695MCFEPBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a stainless steel band in black. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '5 ATM (50 Meters)', 12, 255000, 308000, 'MMK', 'active', false, true, 3.8, 128
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6695MCFEPBARG', 'alexandre-christie-ac6695mcfepbarg', 'AC6695MCFEPBARG', 'The AC6695MCFEPBARG by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal', 'The AC6695MCFEPBARG by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a stainless steel band in black. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '5 ATM (50 Meters)', 12, 148000, NULL, 'MMK', 'active', false, true, 4.2, 83
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC6695MCFTBBA', 'alexandre-christie-ac6695mcftbba', 'AC6695MCFTBBA', 'The AC6695MCFTBBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. ', 'The AC6695MCFTBBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a stainless steel band in silver. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '5 ATM (50 Meters)', 12, 336000, 416000, 'MMK', 'active', false, true, 4.8, 99
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC8694LDLIPBA', 'alexandre-christie-ac8694ldlipba', 'AC8694LDLIPBA', 'The AC8694LDLIPBA by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. F', 'The AC8694LDLIPBA by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a leather band in black. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Leather', '3 ATM (30 Meters)', 12, 254000, 314000, 'MMK', 'active', false, true, 4.3, 137
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC8697LDBBRBA', 'alexandre-christie-ac8697ldbbrba', 'AC8697LDBBRBA', 'The AC8697LDBBRBA by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a black dial. Protected by sapphire crystal. ', 'The AC8697LDBBRBA by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a black dial. Protected by sapphire crystal. Finished with a stainless steel band in black/rose gold. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 339000, 434000, 'MMK', 'active', false, true, 4, 120
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC8697LDBIPBA', 'alexandre-christie-ac8697ldbipba', 'AC8697LDBIPBA', 'The AC8697LDBIPBA by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a black dial. Protected by sapphire crystal. ', 'The AC8697LDBIPBA by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a black dial. Protected by sapphire crystal. Finished with a stainless steel band in black. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 348000, 407000, 'MMK', 'active', false, true, 4.2, 43
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC8697LDBRGLN', 'alexandre-christie-ac8697ldbrgln', 'AC8697LDBRGLN', 'The AC8697LDBRGLN by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a rose gold dial. Protected by sapphire cryst', 'The AC8697LDBRGLN by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a rose gold dial. Protected by sapphire crystal. Finished with a stainless steel band in rose gold. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 312000, NULL, 'MMK', 'active', false, true, 4.1, 18
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC8697LDBTEGR', 'alexandre-christie-ac8697ldbtegr', 'AC8697LDBTEGR', 'The AC8697LDBTEGR by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a grey dial. Protected by sapphire crystal. F', 'The AC8697LDBTEGR by Alexandre Christie is a women''s quartz watch. Featuring a stainless steel case with a grey dial. Protected by sapphire crystal. Finished with a stainless steel band in silver. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 248000, NULL, 'MMK', 'active', false, true, 4.3, 63
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC8697MCBBRBA', 'alexandre-christie-ac8697mcbbrba', 'AC8697MCBBRBA', 'The AC8697MCBBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by sapphire crystal.', 'The AC8697MCBBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by sapphire crystal. Finished with a stainless steel band in black/rose gold. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '5 ATM (50 Meters)', 12, 325000, NULL, 'MMK', 'active', false, true, 4.2, 173
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC8697MCBIPBA', 'alexandre-christie-ac8697mcbipba', 'AC8697MCBIPBA', 'The AC8697MCBIPBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by sapphire crystal.', 'The AC8697MCBIPBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by sapphire crystal. Finished with a stainless steel band in black. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '5 ATM (50 Meters)', 12, 152000, NULL, 'MMK', 'active', false, true, 3.9, 16
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC8697MCBSSSLRG', 'alexandre-christie-ac8697mcbssslrg', 'AC8697MCBSSSLRG', 'The AC8697MCBSSSLRG by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a silver dial. Protected by sapphire cryst', 'The AC8697MCBSSSLRG by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a silver dial. Protected by sapphire crystal. Finished with a stainless steel band in silver. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '5 ATM (50 Meters)', 12, 276000, NULL, 'MMK', 'active', false, true, 4.2, 124
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC8697MCBTBBA', 'alexandre-christie-ac8697mcbtbba', 'AC8697MCBTBBA', 'The AC8697MCBTBBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by sapphire crystal.', 'The AC8697MCBTBBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by sapphire crystal. Finished with a stainless steel band in silver. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '5 ATM (50 Meters)', 12, 347000, 407000, 'MMK', 'active', false, true, 4.1, 119
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC8697MCBTEGR', 'alexandre-christie-ac8697mcbtegr', 'AC8697MCBTEGR', 'The AC8697MCBTEGR by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a grey dial. Protected by sapphire crystal. ', 'The AC8697MCBTEGR by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a grey dial. Protected by sapphire crystal. Finished with a stainless steel band in silver. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '5 ATM (50 Meters)', 12, 223000, 259000, 'MMK', 'active', false, true, 4.5, 48
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC8711MDBBRDGSG', 'alexandre-christie-ac8711mdbbrdgsg', 'AC8711MDBBRDGSG', 'The AC8711MDBBRDGSG by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by sapphire crysta', 'The AC8711MDBBRDGSG by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by sapphire crystal. Finished with a stainless steel band in black/rose gold. Water resistance: 3 ATM (30 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '3 ATM (30 Meters)', 12, 185000, 227000, 'MMK', 'active', false, true, 4.4, 174
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC8715MDFTBBA', 'alexandre-christie-ac8715mdftbba', 'AC8715MDFTBBA', 'The AC8715MDFTBBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. ', 'The AC8715MDFTBBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a stainless steel band in silver. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '5 ATM (50 Meters)', 12, 328000, 412000, 'MMK', 'active', false, true, 3.9, 57
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC9205MCBBRBA', 'alexandre-christie-ac9205mcbbrba', 'AC9205MCBBRBA', 'The AC9205MCBBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. ', 'The AC9205MCBBRBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a stainless steel band in black. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '5 ATM (50 Meters)', 12, 220000, NULL, 'MMK', 'active', false, true, 4.5, 168
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC9205MCBEPBA', 'alexandre-christie-ac9205mcbepba', 'AC9205MCBEPBA', 'The AC9205MCBEPBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. ', 'The AC9205MCBEPBA by Alexandre Christie is a unisex''s quartz watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a stainless steel band in black. Water resistance: 5 ATM (50 Meters).', 'Unisex', 'Quartz', 'Stainless Steel', 'Stainless Steel', '5 ATM (50 Meters)', 12, 296000, 354000, 'MMK', 'active', false, true, 4.2, 177
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'men'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;
INSERT INTO public.products (brand_id, category_id, name, slug, sku, short_description, description, gender, movement, case_material, strap_material, water_resistance, warranty_months, price, original_price, currency, status, featured, new_arrival, average_rating, review_count)
SELECT b.id, c.id, 'Alexandre Christie AC9381LHBRGBA-SET', 'alexandre-christie-ac9381lhbrgba-set', 'AC9381LHBRGBA-SET', 'The AC9381LHBRGBA-SET by Alexandre Christie is a women''s digital watch. Featuring a stainless steel case with a black dial. Protected by mineral cryst', 'The AC9381LHBRGBA-SET by Alexandre Christie is a women''s digital watch. Featuring a stainless steel case with a black dial. Protected by mineral crystal. Finished with a stainless steel strap + extra strap band in rose gold. Water resistance: 3 ATM (30 Meters).', 'Women', 'Quartz', 'Stainless Steel', 'Stainless Steel Strap + Extra Strap', '3 ATM (30 Meters)', 12, 221000, 284000, 'MMK', 'active', false, true, 4.2, 203
FROM public.brands b, public.categories c
WHERE b.slug = 'alexandre-christie' AND c.slug = 'women'
ON CONFLICT (slug) DO UPDATE SET
  brand_id = EXCLUDED.brand_id,
  category_id = EXCLUDED.category_id,
  name = EXCLUDED.name,
  sku = EXCLUDED.sku,
  short_description = EXCLUDED.short_description,
  description = EXCLUDED.description,
  gender = EXCLUDED.gender,
  movement = EXCLUDED.movement,
  case_material = EXCLUDED.case_material,
  strap_material = EXCLUDED.strap_material,
  water_resistance = EXCLUDED.water_resistance,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  status = EXCLUDED.status,
  featured = EXCLUDED.featured,
  new_arrival = EXCLUDED.new_arrival,
  average_rating = EXCLUDED.average_rating,
  review_count = EXCLUDED.review_count;

-- ============================================================
-- PRODUCT_IMAGES (one placeholder image per product)
-- ============================================================
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/16958879/pexels-photo-16958879.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CA158WA-1D', 0
FROM public.products p
WHERE p.slug = 'casio-ca158wa-1d'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/16958879/pexels-photo-16958879.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CAE-1000W-8A', 0
FROM public.products p
WHERE p.slug = 'casio-cae-1000w-8a'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/267391/pexels-photo-267391.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CAE-1200WHD-1A', 0
FROM public.products p
WHERE p.slug = 'casio-cae-1200whd-1a'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/12835320/pexels-photo-12835320.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CAE-1600H-5A', 0
FROM public.products p
WHERE p.slug = 'casio-cae-1600h-5a'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/267391/pexels-photo-267391.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CB640WB-1A', 0
FROM public.products p
WHERE p.slug = 'casio-cb640wb-1a'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/12835320/pexels-photo-12835320.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CA130WEG-9A', 0
FROM public.products p
WHERE p.slug = 'casio-ca130weg-9a'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/12835320/pexels-photo-12835320.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CA168WEMB-1B', 0
FROM public.products p
WHERE p.slug = 'casio-ca168wemb-1b'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/8839887/pexels-photo-8839887.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CAE-1500WHC-1A', 0
FROM public.products p
WHERE p.slug = 'casio-cae-1500whc-1a'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/12835320/pexels-photo-12835320.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CAE-1500WHC-8A', 0
FROM public.products p
WHERE p.slug = 'casio-cae-1500whc-8a'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/12835320/pexels-photo-12835320.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CAE-1700H-1A', 0
FROM public.products p
WHERE p.slug = 'casio-cae-1700h-1a'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/12835320/pexels-photo-12835320.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CAE-1700H-1A2', 0
FROM public.products p
WHERE p.slug = 'casio-cae-1700h-1a2'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/8839887/pexels-photo-8839887.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CW-221H-8A', 0
FROM public.products p
WHERE p.slug = 'casio-cw-221h-8a'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/16958879/pexels-photo-16958879.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CMTP-V004D-7B2', 0
FROM public.products p
WHERE p.slug = 'casio-cmtp-v004d-7b2'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/8839887/pexels-photo-8839887.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CMQ-24DA-2A', 0
FROM public.products p
WHERE p.slug = 'casio-cmq-24da-2a'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/16958879/pexels-photo-16958879.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CLWS-2200H-1A', 0
FROM public.products p
WHERE p.slug = 'casio-clws-2200h-1a'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/12835320/pexels-photo-12835320.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CLW-204-9A', 0
FROM public.products p
WHERE p.slug = 'casio-clw-204-9a'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/16958879/pexels-photo-16958879.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CAE-1700H-1B', 0
FROM public.products p
WHERE p.slug = 'casio-cae-1700h-1b'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/267391/pexels-photo-267391.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CDW-291H-1A', 0
FROM public.products p
WHERE p.slug = 'casio-cdw-291h-1a'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/16958879/pexels-photo-16958879.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CDW-291HX-1A', 0
FROM public.products p
WHERE p.slug = 'casio-cdw-291hx-1a'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/16958879/pexels-photo-16958879.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CLTP-1183A-7A', 0
FROM public.products p
WHERE p.slug = 'casio-cltp-1183a-7a'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/8839887/pexels-photo-8839887.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CLTP-V006L-7B', 0
FROM public.products p
WHERE p.slug = 'casio-cltp-v006l-7b'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/12835320/pexels-photo-12835320.jpeg?auto=compress&cs=tinysrgb&w=900', 'Casio CLW-204-7A', 0
FROM public.products p
WHERE p.slug = 'casio-clw-204-7a'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9561299/pexels-photo-9561299.jpeg?auto=compress&cs=tinysrgb&w=900', 'Baby-G CBG-169U-4B', 0
FROM public.products p
WHERE p.slug = 'baby-g-cbg-169u-4b'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9561297/pexels-photo-9561297.jpeg?auto=compress&cs=tinysrgb&w=900', 'Baby-G CBA-110XBE-7A', 0
FROM public.products p
WHERE p.slug = 'baby-g-cba-110xbe-7a'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/374619/pexels-photo-374619.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear MA27(Black)', 0
FROM public.products p
WHERE p.slug = 'microwear-ma27-black'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/18662969/pexels-photo-18662969.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear MA27(Titanium)', 0
FROM public.products p
WHERE p.slug = 'microwear-ma27-titanium'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/374619/pexels-photo-374619.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear MA31(Silver)', 0
FROM public.products p
WHERE p.slug = 'microwear-ma31-silver'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/267391/pexels-photo-267391.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear MA35(Black)', 0
FROM public.products p
WHERE p.slug = 'microwear-ma35-black'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/374619/pexels-photo-374619.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear MA35(Pink)', 0
FROM public.products p
WHERE p.slug = 'microwear-ma35-pink'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/18662969/pexels-photo-18662969.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear MA35(Silver)', 0
FROM public.products p
WHERE p.slug = 'microwear-ma35-silver'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/374619/pexels-photo-374619.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear U5plus(Black)', 0
FROM public.products p
WHERE p.slug = 'microwear-u5plus-black'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/374673/pexels-photo-374673.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear U5plus(Silver)', 0
FROM public.products p
WHERE p.slug = 'microwear-u5plus-silver'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/18662969/pexels-photo-18662969.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear Ultra3Mini(S.Black)', 0
FROM public.products p
WHERE p.slug = 'microwear-ultra3mini-s-black'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/374619/pexels-photo-374619.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear W10P(Black)', 0
FROM public.products p
WHERE p.slug = 'microwear-w10p-black'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/374673/pexels-photo-374673.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear W10PMini(Black)', 0
FROM public.products p
WHERE p.slug = 'microwear-w10pmini-black'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/374619/pexels-photo-374619.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear W10PMini(Rose Gold)', 0
FROM public.products p
WHERE p.slug = 'microwear-w10pmini-rose-gold'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/374673/pexels-photo-374673.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear W10PMini(Silver)', 0
FROM public.products p
WHERE p.slug = 'microwear-w10pmini-silver'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/1080745/pexels-photo-1080745.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear W11A(Black)', 0
FROM public.products p
WHERE p.slug = 'microwear-w11a-black'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/374673/pexels-photo-374673.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear W11G(Black)', 0
FROM public.products p
WHERE p.slug = 'microwear-w11g-black'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/374673/pexels-photo-374673.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear W11P(Black)', 0
FROM public.products p
WHERE p.slug = 'microwear-w11p-black'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/267391/pexels-photo-267391.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear W11P(Orange)', 0
FROM public.products p
WHERE p.slug = 'microwear-w11p-orange'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/374619/pexels-photo-374619.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear W11P(Silver)', 0
FROM public.products p
WHERE p.slug = 'microwear-w11p-silver'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/374673/pexels-photo-374673.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear W11PMini(Black)', 0
FROM public.products p
WHERE p.slug = 'microwear-w11pmini-black'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/374673/pexels-photo-374673.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear W11PMini(Orange)', 0
FROM public.products p
WHERE p.slug = 'microwear-w11pmini-orange'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/267391/pexels-photo-267391.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear W11PMini(Rose Gold)', 0
FROM public.products p
WHERE p.slug = 'microwear-w11pmini-rose-gold'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/18662969/pexels-photo-18662969.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear W11PMini(Silver)', 0
FROM public.products p
WHERE p.slug = 'microwear-w11pmini-silver'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/267391/pexels-photo-267391.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear W11X(Black)', 0
FROM public.products p
WHERE p.slug = 'microwear-w11x-black'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/374619/pexels-photo-374619.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear W11X(Silver)', 0
FROM public.products p
WHERE p.slug = 'microwear-w11x-silver'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/267391/pexels-photo-267391.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear WXMini(S.Black)', 0
FROM public.products p
WHERE p.slug = 'microwear-wxmini-s-black'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/374673/pexels-photo-374673.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear Z403(Black)', 0
FROM public.products p
WHERE p.slug = 'microwear-z403-black'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/1080745/pexels-photo-1080745.jpeg?auto=compress&cs=tinysrgb&w=900', 'Microwear Z403(Orange)', 0
FROM public.products p
WHERE p.slug = 'microwear-z403-orange'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/14312717/pexels-photo-14312717.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC1007MDLIPBARG', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac1007mdlipbarg'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/6157408/pexels-photo-6157408.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC1008MDBBRBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac1008mdbbrba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/14312717/pexels-photo-14312717.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC1008MDBSSSL', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac1008mdbsssl'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/14312717/pexels-photo-14312717.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC1031LDBSSSL', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac1031ldbsssl'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/6157408/pexels-photo-6157408.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC2977BFBRGSL', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2977bfbrgsl'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/14312717/pexels-photo-14312717.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC2977BFBURBU', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2977bfburbu'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/6157408/pexels-photo-6157408.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC2A42BFBRGPU', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2a42bfbrgpu'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC2B36LHBRGSL', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2b36lhbrgsl'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9561299/pexels-photo-9561299.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC2B36LHBURBU', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2b36lhburbu'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC2B52LHBRGPN', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2b52lhbrgpn'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC2B77LHRRGBO', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2b77lhrrgbo'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/6157408/pexels-photo-6157408.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC2C10LHBBRBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2c10lhbbrba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9561299/pexels-photo-9561299.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC2C10LHBRGSL', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2c10lhbrgsl'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/14312717/pexels-photo-14312717.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC2C13BFFBRBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2c13bffbrba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC2C13BFFRGGR', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2c13bffrggr'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/14312717/pexels-photo-14312717.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC3030MCLBRBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac3030mclbrba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC3030MCLCABA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac3030mclcaba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/6157408/pexels-photo-6157408.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC3030MCLTUBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac3030mcltuba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/14312717/pexels-photo-14312717.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC3039MCLBRBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac3039mclbrba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/14312717/pexels-photo-14312717.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC3039MCLRGBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac3039mclrgba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/14312717/pexels-photo-14312717.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC3039MCLURBU', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac3039mclurbu'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/6157408/pexels-photo-6157408.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC5002MDBGPGN', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac5002mdbgpgn'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9561299/pexels-photo-9561299.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC5002MDBTRSL', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac5002mdbtrsl'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC5013MDBRGBO3', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac5013mdbrgbo3'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/14312717/pexels-photo-14312717.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC5013MDBTRGR3', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac5013mdbtrgr3'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9561299/pexels-photo-9561299.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC5013MDBTRSL3', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac5013mdbtrsl3'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/14312717/pexels-photo-14312717.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6141MCBBRBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6141mcbbrba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/6157408/pexels-photo-6157408.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6141MCBROBO', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6141mcbrobo'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6141MCBTBSL', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6141mcbtbsl'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6141MCBURBU', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6141mcburbu'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6295MCLBRBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6295mclbrba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/6157408/pexels-photo-6157408.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6295MCLIPBAIVBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6295mclipbaivba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/6157408/pexels-photo-6157408.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6295MCLURBU', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6295mclurbu'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9561299/pexels-photo-9561299.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6323MCBBRBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6323mcbbrba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/6157408/pexels-photo-6157408.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6350MCBEPBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6350mcbepba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6564BFBRGSL', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6564bfbrgsl'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6564MCLBRBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6564mclbrba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9561299/pexels-photo-9561299.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6564MCLURBU', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6564mclurbu'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/6157408/pexels-photo-6157408.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6565MCREPBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6565mcrepba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9561299/pexels-photo-9561299.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6565MCREPBARE', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6565mcrepbare'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/6157408/pexels-photo-6157408.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6565MCRTBBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6565mcrtbba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6627MCRIPBAYL', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6627mcripbayl'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/6157408/pexels-photo-6157408.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6688MCRIPBAYL', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6688mcripbayl'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6695MCFBRBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6695mcfbrba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6695MCFEPBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6695mcfepba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/14312717/pexels-photo-14312717.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6695MCFEPBARG', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6695mcfepbarg'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/14312717/pexels-photo-14312717.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC6695MCFTBBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6695mcftbba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC8694LDLIPBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8694ldlipba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9561299/pexels-photo-9561299.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC8697LDBBRBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697ldbbrba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/6157408/pexels-photo-6157408.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC8697LDBIPBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697ldbipba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9561299/pexels-photo-9561299.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC8697LDBRGLN', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697ldbrgln'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/6157408/pexels-photo-6157408.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC8697LDBTEGR', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697ldbtegr'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9561299/pexels-photo-9561299.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC8697MCBBRBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697mcbbrba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9561299/pexels-photo-9561299.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC8697MCBIPBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697mcbipba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9561299/pexels-photo-9561299.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC8697MCBSSSLRG', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697mcbssslrg'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/14312717/pexels-photo-14312717.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC8697MCBTBBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697mcbtbba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/6157408/pexels-photo-6157408.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC8697MCBTEGR', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697mcbtegr'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9561299/pexels-photo-9561299.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC8711MDBBRDGSG', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8711mdbbrdgsg'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC8715MDFTBBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8715mdftbba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC9205MCBBRBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac9205mcbbrba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9561299/pexels-photo-9561299.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC9205MCBEPBA', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac9205mcbepba'
ON CONFLICT DO NOTHING;
INSERT INTO public.product_images (product_id, storage_path, alt_text, sort_order)
SELECT p.id, 'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900', 'Alexandre Christie AC9381LHBRGBA-SET', 0
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac9381lhbrgba-set'
ON CONFLICT DO NOTHING;

-- ============================================================
-- INVENTORY
-- ============================================================
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 16, 0, 5
FROM public.products p
WHERE p.slug = 'casio-ca158wa-1d'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 14, 0, 5
FROM public.products p
WHERE p.slug = 'casio-cae-1000w-8a'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 3, 0, 5
FROM public.products p
WHERE p.slug = 'casio-cae-1200whd-1a'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 20, 0, 5
FROM public.products p
WHERE p.slug = 'casio-cae-1600h-5a'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 25, 0, 5
FROM public.products p
WHERE p.slug = 'casio-cb640wb-1a'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 22, 0, 5
FROM public.products p
WHERE p.slug = 'casio-ca130weg-9a'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 12, 0, 5
FROM public.products p
WHERE p.slug = 'casio-ca168wemb-1b'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 13, 0, 5
FROM public.products p
WHERE p.slug = 'casio-cae-1500whc-1a'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 25, 0, 5
FROM public.products p
WHERE p.slug = 'casio-cae-1500whc-8a'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 17, 0, 5
FROM public.products p
WHERE p.slug = 'casio-cae-1700h-1a'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 27, 0, 5
FROM public.products p
WHERE p.slug = 'casio-cae-1700h-1a2'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 27, 0, 5
FROM public.products p
WHERE p.slug = 'casio-cw-221h-8a'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 23, 0, 5
FROM public.products p
WHERE p.slug = 'casio-cmtp-v004d-7b2'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 9, 0, 5
FROM public.products p
WHERE p.slug = 'casio-cmq-24da-2a'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 10, 0, 5
FROM public.products p
WHERE p.slug = 'casio-clws-2200h-1a'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 18, 0, 5
FROM public.products p
WHERE p.slug = 'casio-clw-204-9a'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 31, 0, 5
FROM public.products p
WHERE p.slug = 'casio-cae-1700h-1b'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 28, 0, 5
FROM public.products p
WHERE p.slug = 'casio-cdw-291h-1a'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 20, 0, 5
FROM public.products p
WHERE p.slug = 'casio-cdw-291hx-1a'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 28, 0, 5
FROM public.products p
WHERE p.slug = 'casio-cltp-1183a-7a'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 20, 0, 5
FROM public.products p
WHERE p.slug = 'casio-cltp-v006l-7b'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 31, 0, 5
FROM public.products p
WHERE p.slug = 'casio-clw-204-7a'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 3, 0, 5
FROM public.products p
WHERE p.slug = 'baby-g-cbg-169u-4b'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 23, 0, 5
FROM public.products p
WHERE p.slug = 'baby-g-cba-110xbe-7a'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 12, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-ma27-black'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 23, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-ma27-titanium'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 19, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-ma31-silver'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 3, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-ma35-black'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 14, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-ma35-pink'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 8, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-ma35-silver'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 31, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-u5plus-black'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 19, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-u5plus-silver'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 22, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-ultra3mini-s-black'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 9, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-w10p-black'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 32, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-w10pmini-black'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 9, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-w10pmini-rose-gold'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 30, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-w10pmini-silver'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 7, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-w11a-black'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 9, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-w11g-black'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 32, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-w11p-black'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 18, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-w11p-orange'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 28, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-w11p-silver'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 25, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-w11pmini-black'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 11, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-w11pmini-orange'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 4, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-w11pmini-rose-gold'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 9, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-w11pmini-silver'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 19, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-w11x-black'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 14, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-w11x-silver'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 32, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-wxmini-s-black'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 32, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-z403-black'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 28, 0, 5
FROM public.products p
WHERE p.slug = 'microwear-z403-orange'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 30, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac1007mdlipbarg'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 30, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac1008mdbbrba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 25, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac1008mdbsssl'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 30, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac1031ldbsssl'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 16, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2977bfbrgsl'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 3, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2977bfburbu'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 26, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2a42bfbrgpu'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 29, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2b36lhbrgsl'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 24, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2b36lhburbu'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 9, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2b52lhbrgpn'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 26, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2b77lhrrgbo'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 3, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2c10lhbbrba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 23, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2c10lhbrgsl'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 25, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2c13bffbrba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 5, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac2c13bffrggr'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 20, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac3030mclbrba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 17, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac3030mclcaba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 29, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac3030mcltuba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 17, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac3039mclbrba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 20, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac3039mclrgba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 20, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac3039mclurbu'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 18, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac5002mdbgpgn'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 32, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac5002mdbtrsl'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 26, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac5013mdbrgbo3'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 32, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac5013mdbtrgr3'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 32, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac5013mdbtrsl3'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 4, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6141mcbbrba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 27, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6141mcbrobo'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 4, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6141mcbtbsl'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 29, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6141mcburbu'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 24, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6295mclbrba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 23, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6295mclipbaivba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 23, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6295mclurbu'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 23, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6323mcbbrba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 16, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6350mcbepba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 10, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6564bfbrgsl'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 4, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6564mclbrba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 25, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6564mclurbu'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 6, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6565mcrepba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 30, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6565mcrepbare'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 30, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6565mcrtbba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 6, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6627mcripbayl'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 32, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6688mcripbayl'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 31, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6695mcfbrba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 32, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6695mcfepba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 5, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6695mcfepbarg'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 10, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac6695mcftbba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 4, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8694ldlipba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 12, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697ldbbrba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 12, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697ldbipba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 11, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697ldbrgln'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 11, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697ldbtegr'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 3, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697mcbbrba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 21, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697mcbipba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 24, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697mcbssslrg'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 6, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697mcbtbba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 22, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8697mcbtegr'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 31, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8711mdbbrdgsg'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 11, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac8715mdftbba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 7, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac9205mcbbrba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 31, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac9205mcbepba'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
INSERT INTO public.inventory (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT p.id, 23, 0, 5
FROM public.products p
WHERE p.slug = 'alexandre-christie-ac9381lhbrgba-set'
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, reserved_quantity = EXCLUDED.reserved_quantity, low_stock_threshold = EXCLUDED.low_stock_threshold;
