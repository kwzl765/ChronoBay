import { useState, useEffect, useCallback, useRef } from 'react';
import type { Product, Brand, Category } from '@/types';
import {
  fetchBrands,
  fetchBrandBySlug,
  fetchCategories,
  fetchCategoryBySlug,
  fetchProducts,
  fetchProductBySlug,
  fetchFeaturedProducts,
  fetchNewArrivals,
  fetchProductsByBrand,
  fetchProductsByCategory,
  searchProducts,
  fetchShopProducts,
  type ShopQuery,
  type ShopResult,
} from '@/lib/catalogue';

// Mock fallbacks — kept until all Supabase reads are verified
import {
  products as mockProducts,
  getProductBySlug as mockGetProductBySlug,
  getFeaturedProducts as mockGetFeatured,
  getNewArrivals as mockGetNewArrivals,
  getProductsByBrand as mockGetProductsByBrand,
  categories as mockCategories,
} from '@/data/mockData';
import {
  brandsData as mockBrands,
  getBrandBySlug as mockGetBrandBySlug,
} from '@/data/brands';

interface QueryState<T> {
  data: T | null;
  loading: boolean;
  error: string | null;
}

function useQuery<T>(
  fetcher: () => Promise<T>,
  deps: unknown[],
  fallback: T
): QueryState<T> & { retry: () => void } {
  const [state, setState] = useState<QueryState<T>>({
    data: null,
    loading: true,
    error: null,
  });
  const mountedRef = useRef(true);
  const [retryCount, setRetryCount] = useState(0);

  useEffect(() => {
    mountedRef.current = true;
    setState({ data: null, loading: true, error: null });

    fetcher()
      .then((result) => {
        if (mountedRef.current) {
          setState({ data: result, loading: false, error: null });
        }
      })
      .catch((err) => {
        if (mountedRef.current) {
          setState({
            data: fallback,
            loading: false,
            error: err instanceof Error ? err.message : 'Failed to load data',
          });
        }
      });

    return () => {
      mountedRef.current = false;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [...deps, retryCount]);

  const retry = useCallback(() => setRetryCount((n) => n + 1), []);

  return { ...state, retry };
}

// --- Brand hooks ---

export function useBrands() {
  return useQuery<Brand[]>(fetchBrands, [], mockBrands);
}

export function useBrandBySlug(slug: string | undefined) {
  return useQuery<Brand | null>(
    () => fetchBrandBySlug(slug ?? ''),
    [slug],
    slug ? mockGetBrandBySlug(slug) ?? null : null
  );
}

// --- Category hooks ---

export function useCategories() {
  return useQuery<Category[]>(fetchCategories, [], mockCategories);
}

export function useCategoryBySlug(slug: string | undefined) {
  return useQuery<Category | null>(
    () => fetchCategoryBySlug(slug ?? ''),
    [slug],
    slug ? mockCategories.find((c) => c.slug === slug) ?? null : null
  );
}

// --- Product hooks ---

export function useProducts() {
  return useQuery<Product[]>(fetchProducts, [], mockProducts);
}

export function useProductBySlug(slug: string | undefined) {
  return useQuery<Product | null>(
    () => fetchProductBySlug(slug ?? ''),
    [slug],
    slug ? mockGetProductBySlug(slug) ?? null : null
  );
}

export function useFeaturedProducts(limit = 8) {
  return useQuery<Product[]>(
    () => fetchFeaturedProducts(limit),
    [limit],
    mockGetFeatured().slice(0, limit)
  );
}

export function useNewArrivals(limit = 8) {
  return useQuery<Product[]>(
    () => fetchNewArrivals(limit),
    [limit],
    mockGetNewArrivals().slice(0, limit)
  );
}

export function useProductsByBrand(brandSlug: string | undefined) {
  return useQuery<Product[]>(
    () => fetchProductsByBrand(brandSlug ?? ''),
    [brandSlug],
    brandSlug ? mockGetProductsByBrand(brandSlug) : []
  );
}

export function useProductsByCategory(categorySlug: string | undefined) {
  return useQuery<Product[]>(
    () => fetchProductsByCategory(categorySlug ?? ''),
    [categorySlug],
    categorySlug ? mockProducts.filter((p) => p.category === categorySlug) : []
  );
}

export function useSearchProducts(query: string, limit = 5) {
  return useQuery<Product[]>(
    () => searchProducts(query, limit),
    [query, limit],
    []
  );
}

// --- Shop page hook with server-side filtering ---

export function useShopProducts(query: ShopQuery) {
  const [state, setState] = useState<{
    data: ShopResult | null;
    loading: boolean;
    error: string | null;
  }>({ data: null, loading: true, error: null });
  const mountedRef = useRef(true);
  const [retryCount, setRetryCount] = useState(0);

  const queryKey = JSON.stringify(query);

  useEffect(() => {
    mountedRef.current = true;
    setState({ data: null, loading: true, error: null });

    fetchShopProducts(query)
      .then((result) => {
        if (mountedRef.current) {
          setState({ data: result, loading: false, error: null });
        }
      })
      .catch(() => {
        if (mountedRef.current) {
          // Fallback to mock filtering
          let result = [...mockProducts];
          if (query.categories.length)
            result = result.filter((p) => query.categories.includes(p.category));
          if (query.brands.length)
            result = result.filter((p) => query.brands.includes(p.brandSlug));
          if (query.genders.length)
            result = result.filter((p) => query.genders.includes(p.gender));
          if (query.movements.length)
            result = result.filter((p) => query.movements.includes(p.movement));
          if (query.minPrice !== null)
            result = result.filter((p) => p.price >= query.minPrice!);
          if (query.maxPrice !== null)
            result = result.filter((p) => p.price <= query.maxPrice!);
          if (query.search) {
            const q = query.search.toLowerCase();
            result = result.filter(
              (p) =>
                p.name.toLowerCase().includes(q) ||
                p.brand.toLowerCase().includes(q)
            );
          }
          switch (query.sort) {
            case 'price-asc':
              result.sort((a, b) => a.price - b.price);
              break;
            case 'price-desc':
              result.sort((a, b) => b.price - a.price);
              break;
            case 'popularity':
              result.sort((a, b) => b.reviewCount - a.reviewCount);
              break;
            default:
              result.sort((a, b) => Number(b.newArrival) - Number(a.newArrival));
          }
          const from = (query.page - 1) * query.perPage;
          const paged = result.slice(from, from + query.perPage);
          const totalPages = Math.ceil(result.length / query.perPage);
          setState({
            data: { products: paged, total: result.length, totalPages },
            loading: false,
            error: 'Using offline data — some features may be limited',
          });
        }
      });

    return () => {
      mountedRef.current = false;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [queryKey, retryCount]);

  const retry = useCallback(() => setRetryCount((n) => n + 1), []);

  return { ...state, retry };
}
