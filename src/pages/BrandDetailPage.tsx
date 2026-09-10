import { useState, useMemo } from 'react';
import { useParams, Link, Navigate } from 'react-router-dom';
import { ChevronRight, ShoppingBag, ArrowRight, PackageSearch, AlertCircle, RefreshCw } from 'lucide-react';
import Seo from '@/components/Seo';
import ProductCard from '@/components/ProductCard';
import QuickViewModal from '@/components/QuickViewModal';
import EmptyState from '@/components/EmptyState';
import { ProductGridSkeleton } from '@/components/Skeletons';
import { getRelatedBrands, visualFamilyLabels, getBrandBySlug as getMockBrandBySlug } from '@/data/brands';
import { useBrandBySlug, useProductsByBrand } from '@/hooks/useCatalogue';
import type { Product } from '@/types';

type SortOption = 'newest' | 'price-asc' | 'price-desc' | 'popularity';

export default function BrandDetailPage() {
  const { slug } = useParams<{ slug: string }>();
  const [quickViewProduct, setQuickViewProduct] = useState<Product | null>(null);
  const [sort, setSort] = useState<SortOption>('newest');

  const { data: brand, loading: brandLoading } = useBrandBySlug(slug);
  const { data: productsData, loading: productsLoading, error, retry } = useProductsByBrand(slug);

  const brandProducts = useMemo(() => {
    let result = [...(productsData ?? [])];
    switch (sort) {
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
    return result;
  }, [productsData, sort]);

  if (brandLoading && !brand) {
    return (
      <div className="container-wide py-20">
        <div className="animate-pulse">
          <div className="h-8 w-64 rounded bg-gray-200" />
          <div className="mt-4 h-4 w-96 rounded bg-gray-200" />
        </div>
      </div>
    );
  }

  if (!brand) return <Navigate to="/404" replace />;

  const mockBrand = getMockBrandBySlug(brand.slug);
  const relatedBrands = mockBrand ? getRelatedBrands(mockBrand, 4) : [];

  return (
    <>
      <Seo
        title={`${brand.name} Watches — ChronoBay`}
        description={brand.description}
      />

      {/* Breadcrumb */}
      <div className="border-b border-gray-200 bg-gray-50">
        <div className="container-wide py-3">
          <nav className="flex items-center gap-2 text-xs text-gray-500" aria-label="Breadcrumb">
            <Link to="/" className="hover:text-accent">Home</Link>
            <ChevronRight className="h-3 w-3" aria-hidden="true" />
            <Link to="/brands" className="hover:text-accent">Brands</Link>
            <ChevronRight className="h-3 w-3" aria-hidden="true" />
            <span className="text-charcoal">{brand.name}</span>
          </nav>
        </div>
      </div>

      {/* Brand banner */}
      <div className="relative aspect-[16/6] min-h-[200px] overflow-hidden bg-navy-600 sm:min-h-[280px] lg:min-h-[340px]">
        <img
          src={brand.banner}
          alt={`${brand.name} collection banner`}
          className="h-full w-full object-cover object-center"
          loading="eager"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-navy-600/90 via-navy-600/60 to-navy-600/30" />
        <div className="container-wide relative flex h-full items-end pb-8 lg:pb-12">
          <div className="flex items-end gap-5">
            <div className="flex h-20 w-20 shrink-0 items-center justify-center rounded border border-white/20 bg-white/95 p-3 lg:h-24 lg:w-24">
              <img
                src={brand.logo}
                alt={`${brand.name} logo`}
                className="h-full w-full object-contain"
              />
            </div>
            <div>
              {brand.visualFamily && (
                <span className="text-xs font-semibold uppercase tracking-[0.2em] text-accent">
                  {visualFamilyLabels[brand.visualFamily as keyof typeof visualFamilyLabels]}
                </span>
              )}
              <h1 className="mt-1 text-2xl font-bold text-white sm:text-3xl lg:text-4xl">
                {brand.name}
              </h1>
              <p className="mt-2 max-w-xl text-sm text-gray-200">{brand.description}</p>
            </div>
          </div>
        </div>
      </div>

      <div className="container-wide py-10 lg:py-14">
        {/* Actions bar */}
        <div className="mb-8 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <p className="text-sm text-gray-500">
              {productsLoading ? 'Loading...' : `${brandProducts.length} product${brandProducts.length !== 1 ? 's' : ''}`}
            </p>
          </div>
          <div className="flex items-center gap-3">
            <Link to={`/shop?brands=${brand.slug}`} className="btn-secondary">
              <ShoppingBag className="h-4 w-4" />
              Shop This Brand
            </Link>
            {brandProducts.length > 0 && (
              <label className="flex items-center gap-2 text-sm">
                <span className="hidden text-gray-500 sm:inline">Sort:</span>
                <select
                  value={sort}
                  onChange={(e) => setSort(e.target.value as SortOption)}
                  className="rounded border border-gray-300 bg-white px-3 py-2.5 text-sm text-charcoal focus:border-accent focus:outline-none"
                  aria-label="Sort products"
                >
                  <option value="newest">Newest</option>
                  <option value="price-asc">Price: Low to High</option>
                  <option value="price-desc">Price: High to Low</option>
                  <option value="popularity">Popularity</option>
                </select>
              </label>
            )}
          </div>
        </div>

        {error && !productsLoading && (
          <div className="mb-6 flex items-center gap-2 rounded border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-700">
            <AlertCircle className="h-5 w-5 shrink-0" />
            <span>{error}</span>
            <button onClick={retry} className="ml-auto flex items-center gap-1 font-medium underline">
              <RefreshCw className="h-4 w-4" /> Retry
            </button>
          </div>
        )}

        {/* Products or loading or empty state */}
        {productsLoading ? (
          <ProductGridSkeleton count={8} />
        ) : brandProducts.length === 0 ? (
          <EmptyState
            icon={<PackageSearch className="h-8 w-8" />}
            title={`Products from ${brand.name} are coming soon.`}
            description="We're curating the finest timepieces from this brand. Check back shortly or explore our other collections."
            actionLabel="Browse All Products"
            actionTo="/shop"
          />
        ) : (
          <div className="grid grid-cols-2 gap-5 md:grid-cols-3 lg:grid-cols-4">
            {brandProducts.map((product) => (
              <ProductCard
                key={product.id}
                product={product}
                onQuickView={setQuickViewProduct}
              />
            ))}
          </div>
        )}

        {/* Related brands */}
        {relatedBrands.length > 0 && (
          <div className="mt-16">
            <h2 className="text-lg font-bold text-navy-600">Related Brands</h2>
            <div className="mt-6 grid grid-cols-2 gap-4 sm:grid-cols-3 md:grid-cols-4">
              {relatedBrands.map((rb) => (
                <Link
                  key={rb.id}
                  to={`/brands/${rb.slug}`}
                  className="group flex flex-col items-center"
                  aria-label={`View ${rb.name}`}
                >
                  <div className="flex aspect-[4/3] w-full items-center justify-center rounded border border-gray-200 bg-white p-5 transition-shadow duration-300 hover:shadow-card">
                    <img
                      src={rb.logo}
                      alt={`${rb.name} logo`}
                      loading="lazy"
                      className="h-full w-full object-contain"
                    />
                  </div>
                  <p className="mt-2 text-center text-xs font-medium text-charcoal group-hover:text-accent transition-colors">
                    {rb.name}
                  </p>
                </Link>
              ))}
            </div>
          </div>
        )}

        {/* Back to brands link */}
        <div className="mt-10 text-center">
          <Link
            to="/brands"
            className="group inline-flex items-center gap-1 text-sm font-medium text-charcoal hover:text-accent transition-colors"
          >
            <ArrowRight className="h-4 w-4 rotate-180 transition-transform group-hover:-translate-x-1" aria-hidden="true" />
            View All Brands
          </Link>
        </div>
      </div>

      <QuickViewModal product={quickViewProduct} onClose={() => setQuickViewProduct(null)} />
    </>
  );
}
