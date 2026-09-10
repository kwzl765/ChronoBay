import { supabase } from '@/lib/supabase';
import type {
  DatabaseBrand,
  DatabaseCategory,
  DatabaseProduct,
  DatabaseProductImage,
  DatabaseInventory,
} from '@/lib/supabase';
import type { Product, Brand, Category, CategorySlug } from '@/types';

// --- DB row → frontend type mappers ---

function mapBrand(row: DatabaseBrand): Brand {
  return {
    name: row.name,
    slug: row.slug,
    description: row.description ?? '',
    logo: row.logo_url ?? '',
    banner: row.banner_url ?? undefined,
    visualFamily: row.visual_family ?? undefined,
    featured: row.featured,
  };
}

function mapCategory(row: DatabaseCategory): Category {
  return {
    slug: row.slug as CategorySlug,
    name: row.name,
    description: row.description ?? '',
    image: row.image_url ?? '',
  };
}

interface ProductWithRelations extends DatabaseProduct {
  brands?: DatabaseBrand | null;
  categories?: DatabaseCategory | null;
  product_images?: DatabaseProductImage[];
  inventory?: DatabaseInventory | null;
}

function mapProduct(row: ProductWithRelations): Product {
  const images = (row.product_images ?? []).sort((a, b) => a.sort_order - b.sort_order);
  const storagePaths = images.map((img) => img.storage_path);

  return {
    id: row.id,
    slug: row.slug,
    name: row.name,
    brand: row.brands?.name ?? '',
    brandSlug: row.brands?.slug ?? '',
    category: (row.categories?.slug ?? 'men') as CategorySlug,
    gender: (row.gender as Product['gender']) ?? 'Unisex',
    movement: (row.movement as Product['movement']) ?? 'Quartz',
    price: Number(row.price),
    originalPrice: row.original_price ? Number(row.original_price) : undefined,
    image: storagePaths[0] ?? '',
    gallery: storagePaths.length > 0 ? storagePaths : [''],
    description: row.description ?? '',
    specifications: {},
    rating: Number(row.average_rating),
    reviewCount: row.review_count,
    stock: row.inventory?.quantity ?? 0,
    featured: row.featured,
    newArrival: row.new_arrival,
  };
}

// --- Query functions ---

export async function fetchBrands(): Promise<Brand[]> {
  const { data, error } = await supabase
    .from('brands')
    .select('*')
    .eq('active', true)
    .order('sort_order')
    .order('name');

  if (error) throw error;
  return (data as DatabaseBrand[]).map(mapBrand);
}

export async function fetchBrandBySlug(slug: string): Promise<Brand | null> {
  const { data, error } = await supabase
    .from('brands')
    .select('*')
    .eq('slug', slug)
    .eq('active', true)
    .maybeSingle();

  if (error) throw error;
  if (!data) return null;
  return mapBrand(data as DatabaseBrand);
}

export async function fetchCategories(): Promise<Category[]> {
  const { data, error } = await supabase
    .from('categories')
    .select('*')
    .eq('active', true)
    .order('sort_order');

  if (error) throw error;
  return (data as DatabaseCategory[]).map(mapCategory);
}

export async function fetchCategoryBySlug(slug: string): Promise<Category | null> {
  const { data, error } = await supabase
    .from('categories')
    .select('*')
    .eq('slug', slug)
    .eq('active', true)
    .maybeSingle();

  if (error) throw error;
  if (!data) return null;
  return mapCategory(data as DatabaseCategory);
}

const productSelect = `
  *,
  brands!inner ( id, name, slug ),
  categories!inner ( id, slug, name ),
  product_images ( id, storage_path, alt_text, sort_order ),
  inventory ( product_id, quantity, reserved_quantity, low_stock_threshold )
`;

export async function fetchProducts(): Promise<Product[]> {
  const { data, error } = await supabase
    .from('products')
    .select(productSelect)
    .eq('status', 'active')
    .order('new_arrival', { ascending: false })
    .order('created_at', { ascending: false });

  if (error) throw error;
  return (data as ProductWithRelations[]).map(mapProduct);
}

export async function fetchProductBySlug(slug: string): Promise<Product | null> {
  const { data, error } = await supabase
    .from('products')
    .select(productSelect)
    .eq('slug', slug)
    .eq('status', 'active')
    .maybeSingle();

  if (error) throw error;
  if (!data) return null;
  return mapProduct(data as ProductWithRelations);
}

export async function fetchFeaturedProducts(limit = 8): Promise<Product[]> {
  const { data, error } = await supabase
    .from('products')
    .select(productSelect)
    .eq('status', 'active')
    .eq('featured', true)
    .order('review_count', { ascending: false })
    .limit(limit);

  if (error) throw error;
  return (data as ProductWithRelations[]).map(mapProduct);
}

export async function fetchNewArrivals(limit = 8): Promise<Product[]> {
  const { data, error } = await supabase
    .from('products')
    .select(productSelect)
    .eq('status', 'active')
    .eq('new_arrival', true)
    .order('created_at', { ascending: false })
    .limit(limit);

  if (error) throw error;
  return (data as ProductWithRelations[]).map(mapProduct);
}

export async function fetchProductsByBrand(brandSlug: string): Promise<Product[]> {
  const { data: brandData } = await supabase
    .from('brands')
    .select('id')
    .eq('slug', brandSlug)
    .maybeSingle();

  if (!brandData) return [];

  const { data, error } = await supabase
    .from('products')
    .select(productSelect)
    .eq('status', 'active')
    .eq('brand_id', brandData.id)
    .order('new_arrival', { ascending: false })
    .order('created_at', { ascending: false });

  if (error) throw error;
  return (data as ProductWithRelations[]).map(mapProduct);
}

export async function fetchProductsByCategory(categorySlug: string): Promise<Product[]> {
  const { data: catData } = await supabase
    .from('categories')
    .select('id')
    .eq('slug', categorySlug)
    .maybeSingle();

  if (!catData) return [];

  const { data, error } = await supabase
    .from('products')
    .select(productSelect)
    .eq('status', 'active')
    .eq('category_id', catData.id)
    .order('new_arrival', { ascending: false })
    .order('created_at', { ascending: false });

  if (error) throw error;
  return (data as ProductWithRelations[]).map(mapProduct);
}

export async function searchProducts(query: string, limit = 5): Promise<Product[]> {
  const q = query.trim();
  if (!q) return [];

  const { data, error } = await supabase
    .from('products')
    .select(productSelect)
    .eq('status', 'active')
    .or(`name.ilike.%${q}%,description.ilike.%${q}%`)
    .limit(limit);

  if (error) throw error;
  return (data as ProductWithRelations[]).map(mapProduct);
}

// --- Shop page filtering with server-side pagination ---

export interface ShopQuery {
  categories: string[];
  brands: string[];
  genders: string[];
  movements: string[];
  minPrice: number | null;
  maxPrice: number | null;
  search: string;
  sort: 'newest' | 'price-asc' | 'price-desc' | 'popularity';
  page: number;
  perPage: number;
}

export interface ShopResult {
  products: Product[];
  total: number;
  totalPages: number;
}

export async function fetchShopProducts(query: ShopQuery): Promise<ShopResult> {
  let dbQuery = supabase
    .from('products')
    .select(productSelect, { count: 'exact' })
    .eq('status', 'active');

  // Category filter — resolve slugs to IDs first
  if (query.categories.length > 0) {
    const { data: cats } = await supabase
      .from('categories')
      .select('id')
      .in('slug', query.categories);
    if (cats && cats.length > 0) {
      dbQuery = dbQuery.in('category_id', cats.map((c) => c.id));
    }
  }

  // Brand filter — resolve slugs to IDs
  if (query.brands.length > 0) {
    const { data: brands } = await supabase
      .from('brands')
      .select('id')
      .in('slug', query.brands);
    if (brands && brands.length > 0) {
      dbQuery = dbQuery.in('brand_id', brands.map((b) => b.id));
    }
  }

  // Gender filter
  if (query.genders.length > 0) {
    dbQuery = dbQuery.in('gender', query.genders);
  }

  // Movement filter
  if (query.movements.length > 0) {
    dbQuery = dbQuery.in('movement', query.movements);
  }

  // Price filters
  if (query.minPrice !== null) {
    dbQuery = dbQuery.gte('price', query.minPrice);
  }
  if (query.maxPrice !== null) {
    dbQuery = dbQuery.lte('price', query.maxPrice);
  }

  // Search — name or description
  if (query.search) {
    dbQuery = dbQuery.or(`name.ilike.%${query.search}%,description.ilike.%${query.search}%`);
  }

  // Sort
  switch (query.sort) {
    case 'price-asc':
      dbQuery = dbQuery.order('price', { ascending: true });
      break;
    case 'price-desc':
      dbQuery = dbQuery.order('price', { ascending: false });
      break;
    case 'popularity':
      dbQuery = dbQuery.order('review_count', { ascending: false });
      break;
    default:
      dbQuery = dbQuery.order('new_arrival', { ascending: false }).order('created_at', { ascending: false });
  }

  // Pagination
  const from = (query.page - 1) * query.perPage;
  const to = from + query.perPage - 1;
  dbQuery = dbQuery.range(from, to);

  const { data, error, count } = await dbQuery;

  if (error) throw error;

  const products = (data as ProductWithRelations[]).map(mapProduct);
  const total = count ?? 0;
  const totalPages = Math.ceil(total / query.perPage);

  return { products, total, totalPages };
}
