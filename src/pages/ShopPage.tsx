import { useState, useMemo, useCallback } from 'react';
import { useSearchParams, Link } from 'react-router-dom';
import { SlidersHorizontal, X, ChevronLeft, ChevronRight, Filter, AlertCircle, RefreshCw } from 'lucide-react';
import Seo from '@/components/Seo';
import ProductCard from '@/components/ProductCard';
import QuickViewModal from '@/components/QuickViewModal';
import EmptyState from '@/components/EmptyState';
import { ProductGridSkeleton } from '@/components/Skeletons';
import type { Product, CategorySlug, Filters } from '@/types';
import { categories as mockCategories } from '@/data/mockData';
import { brandsData } from '@/data/brands';
import { useShopProducts, useCategories, useBrands } from '@/hooks/useCatalogue';

const PER_PAGE = 9;
const allGenders = ['Men', 'Women', 'Unisex'];
const allMovements = ['Automatic', 'Quartz', 'Solar', 'Mechanical'];

export default function ShopPage() {
  const [searchParams, setSearchParams] = useSearchParams();
  const [quickViewProduct, setQuickViewProduct] = useState<Product | null>(null);
  const [mobileFiltersOpen, setMobileFiltersOpen] = useState(false);
  const [showAllBrands, setShowAllBrands] = useState(false);

  const { data: dbBrands } = useBrands();
  const { data: dbCategories } = useCategories();

  const allBrands = dbBrands ?? brandsData;
  const allCategories = dbCategories ?? mockCategories;

  const brandsWithProducts = useMemo(
    () => allBrands.filter((b) => b.slug === 'casio' || b.slug === 'g-shock-myanmar' || b.slug === 'seiko'),
    [allBrands]
  );
  const visibleBrands = showAllBrands ? allBrands : allBrands;

  // Parse filters from URL
  const filters: Filters = useMemo(() => {
    const cats = searchParams.get('categories')?.split(',').filter(Boolean) as CategorySlug[] ?? [];
    const brnds = searchParams.get('brands')?.split(',').filter(Boolean) ?? [];
    const gndrs = searchParams.get('genders')?.split(',').filter(Boolean) ?? [];
    const mvmnts = searchParams.get('movements')?.split(',').filter(Boolean) ?? [];
    const minPrice = searchParams.get('minPrice') ? Number(searchParams.get('minPrice')) : null;
    const maxPrice = searchParams.get('maxPrice') ? Number(searchParams.get('maxPrice')) : null;
    const search = searchParams.get('q') ?? '';
    const sort = (searchParams.get('sort') as Filters['sort']) ?? 'newest';
    return {
      categories: cats,
      brands: brnds,
      genders: gndrs,
      movements: mvmnts,
      minPrice,
      maxPrice,
      search,
      sort,
    };
  }, [searchParams]);

  const page = parseInt(searchParams.get('page') ?? '1', 10);

  const updateFilters = useCallback(
    (updates: Partial<Filters>) => {
      const newParams = new URLSearchParams(searchParams);
      const merged = { ...filters, ...updates };

      const setOrDelete = (key: string, value: string | null) => {
        if (value) newParams.set(key, value);
        else newParams.delete(key);
      };

      setOrDelete('categories', merged.categories.length ? merged.categories.join(',') : null);
      setOrDelete('brands', merged.brands.length ? merged.brands.join(',') : null);
      setOrDelete('genders', merged.genders.length ? merged.genders.join(',') : null);
      setOrDelete('movements', merged.movements.length ? merged.movements.join(',') : null);
      setOrDelete('minPrice', merged.minPrice?.toString() ?? null);
      setOrDelete('maxPrice', merged.maxPrice?.toString() ?? null);
      setOrDelete('q', merged.search || null);
      setOrDelete('sort', merged.sort !== 'newest' ? merged.sort : null);

      if (updates.sort === undefined) newParams.delete('page');

      setSearchParams(newParams);
    },
    [filters, searchParams, setSearchParams]
  );

  const clearAll = () => {
    setSearchParams(new URLSearchParams());
  };

  const setPage = (newPage: number) => {
    const newParams = new URLSearchParams(searchParams);
    if (newPage > 1) newParams.set('page', String(newPage));
    else newParams.delete('page');
    setSearchParams(newParams);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  // Server-side query
  const { data: shopResult, loading, error, retry } = useShopProducts({
    categories: filters.categories,
    brands: filters.brands,
    genders: filters.genders,
    movements: filters.movements,
    minPrice: filters.minPrice,
    maxPrice: filters.maxPrice,
    search: filters.search,
    sort: filters.sort,
    page,
    perPage: PER_PAGE,
  });

  const pagedProducts = shopResult?.products ?? [];
  const totalProducts = shopResult?.total ?? 0;
  const totalPages = shopResult?.totalPages ?? 0;

  const hasActiveFilters =
    filters.categories.length > 0 ||
    filters.brands.length > 0 ||
    filters.genders.length > 0 ||
    filters.movements.length > 0 ||
    filters.minPrice !== null ||
    filters.maxPrice !== null ||
    filters.search !== '';

  const toggleArrayFilter = <K extends keyof Filters>(key: K, value: string) => {
    const current = filters[key] as string[];
    const updated = current.includes(value)
      ? current.filter((v) => v !== value)
      : [...current, value];
    updateFilters({ [key]: updated } as Partial<Filters>);
  };

  const FilterContent = () => (
    <div className="space-y-6">
      {/* Categories */}
      <FilterGroup title="Category">
        {allCategories.map((cat) => (
          <CheckboxItem
            key={cat.slug}
            label={cat.name}
            checked={filters.categories.includes(cat.slug)}
            onChange={() => toggleArrayFilter('categories', cat.slug)}
          />
        ))}
      </FilterGroup>

      {/* Brands */}
      <FilterGroup title="Brand">
        {visibleBrands.map((brand) => (
          <CheckboxItem
            key={brand.slug}
            label={brand.name}
            checked={filters.brands.includes(brand.slug)}
            onChange={() => toggleArrayFilter('brands', brand.slug)}
          />
        ))}
        {!showAllBrands && allBrands.length > brandsWithProducts.length && (
          <button
            onClick={() => setShowAllBrands(true)}
            className="mt-2 text-xs font-medium text-accent hover:underline"
          >
            Show all brands ({allBrands.length})
          </button>
        )}
        {showAllBrands && (
          <button
            onClick={() => setShowAllBrands(false)}
            className="mt-2 text-xs font-medium text-accent hover:underline"
          >
            Show brands with products only
          </button>
        )}
      </FilterGroup>

      {/* Gender */}
      <FilterGroup title="Gender">
        {allGenders.map((gender) => (
          <CheckboxItem
            key={gender}
            label={gender}
            checked={filters.genders.includes(gender)}
            onChange={() => toggleArrayFilter('genders', gender)}
          />
        ))}
      </FilterGroup>

      {/* Movement */}
      <FilterGroup title="Movement">
        {allMovements.map((movement) => (
          <CheckboxItem
            key={movement}
            label={movement}
            checked={filters.movements.includes(movement)}
            onChange={() => toggleArrayFilter('movements', movement)}
          />
        ))}
      </FilterGroup>

      {/* Price */}
      <FilterGroup title="Price Range (MMK)">
        <div className="flex items-center gap-2">
          <input
            type="number"
            placeholder="Min"
            value={filters.minPrice ?? ''}
            onChange={(e) =>
              updateFilters({ minPrice: e.target.value ? Number(e.target.value) : null })
            }
            className="input-base text-xs"
            aria-label="Minimum price"
          />
          <span className="text-gray-400">—</span>
          <input
            type="number"
            placeholder="Max"
            value={filters.maxPrice ?? ''}
            onChange={(e) =>
              updateFilters({ maxPrice: e.target.value ? Number(e.target.value) : null })
            }
            className="input-base text-xs"
            aria-label="Maximum price"
          />
        </div>
      </FilterGroup>

      {hasActiveFilters && (
        <button
          onClick={clearAll}
          className="flex w-full items-center justify-center gap-2 rounded border border-gray-300 py-2.5 text-sm font-medium text-charcoal hover:bg-gray-50"
        >
          <X className="h-4 w-4" />
          Clear All Filters
        </button>
      )}
    </div>
  );

  return (
    <>
      <Seo
        title="Shop All Watches — ChronoBay"
        description="Browse our full collection of authentic premium watches. Filter by brand, category, gender, movement, and price."
      />

      {/* Breadcrumb */}
      <div className="border-b border-gray-200 bg-gray-50">
        <div className="container-wide py-3">
          <nav className="flex items-center gap-2 text-xs text-gray-500" aria-label="Breadcrumb">
            <Link to="/" className="hover:text-accent">Home</Link>
            <span aria-hidden="true">/</span>
            <span className="text-charcoal">Shop</span>
          </nav>
        </div>
      </div>

      <div className="container-wide py-10 lg:py-14">
        {/* Header */}
        <div className="mb-8 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <h1 className="text-[26px] font-bold text-navy-600 sm:text-[32px]">All Watches</h1>
            <p className="mt-1 text-sm text-gray-500">
              {loading ? 'Loading products...' : `${totalProducts} product${totalProducts !== 1 ? 's' : ''} found`}
            </p>
          </div>

          <div className="flex items-center gap-3">
            <button
              onClick={() => setMobileFiltersOpen(true)}
              className="flex items-center gap-2 rounded border border-gray-300 px-4 py-2.5 text-sm font-medium text-charcoal hover:bg-gray-50 lg:hidden"
              aria-label="Open filters"
            >
              <Filter className="h-4 w-4" />
              Filters
            </button>

            <label className="flex items-center gap-2 text-sm">
              <span className="hidden text-gray-500 sm:inline">Sort:</span>
              <select
                value={filters.sort}
                onChange={(e) => updateFilters({ sort: e.target.value as Filters['sort'] })}
                className="rounded border border-gray-300 bg-white px-3 py-2.5 text-sm text-charcoal focus:border-accent focus:outline-none"
                aria-label="Sort products"
              >
                <option value="newest">Newest</option>
                <option value="price-asc">Price: Low to High</option>
                <option value="price-desc">Price: High to Low</option>
                <option value="popularity">Popularity</option>
              </select>
            </label>
          </div>
        </div>

        {error && !loading && (
          <div className="mb-6 flex items-center gap-2 rounded border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-700">
            <AlertCircle className="h-5 w-5 shrink-0" />
            <span>{error}</span>
            <button onClick={retry} className="ml-auto flex items-center gap-1 font-medium underline">
              <RefreshCw className="h-4 w-4" /> Retry
            </button>
          </div>
        )}

        <div className="flex gap-10">
          {/* Desktop sidebar */}
          <aside className="hidden w-64 shrink-0 lg:block">
            <div className="sticky top-44">
              <div className="mb-4 flex items-center gap-2">
                <SlidersHorizontal className="h-5 w-5 text-accent" aria-hidden="true" />
                <h2 className="text-sm font-semibold uppercase tracking-wider text-charcoal">
                  Filters
                </h2>
              </div>
              <FilterContent />
            </div>
          </aside>

          {/* Products */}
          <div className="flex-1 min-w-0">
            {loading ? (
              <ProductGridSkeleton count={9} />
            ) : pagedProducts.length === 0 ? (
              <EmptyState
                icon={<Filter className="h-8 w-8" />}
                title="No products match your filters"
                description="Try adjusting or clearing some filters to see more results."
                actionLabel="Clear All Filters"
                actionTo="/shop"
              />
            ) : (
              <>
                <div className="grid grid-cols-2 gap-5 md:grid-cols-3">
                  {pagedProducts.map((product) => (
                    <ProductCard
                      key={product.id}
                      product={product}
                      onQuickView={setQuickViewProduct}
                    />
                  ))}
                </div>

                {totalPages > 1 && (
                  <nav
                    className="mt-10 flex items-center justify-center gap-2"
                    aria-label="Pagination"
                  >
                    <button
                      onClick={() => setPage(page - 1)}
                      disabled={page === 1}
                      className="flex h-10 w-10 items-center justify-center rounded border border-gray-300 text-charcoal hover:bg-gray-50 disabled:opacity-40 disabled:cursor-not-allowed"
                      aria-label="Previous page"
                    >
                      <ChevronLeft className="h-5 w-5" />
                    </button>
                    {Array.from({ length: totalPages }).map((_, i) => (
                      <button
                        key={i}
                        onClick={() => setPage(i + 1)}
                        className={`flex h-10 min-w-[40px] items-center justify-center rounded border px-3 text-sm font-medium transition-colors ${
                          page === i + 1
                            ? 'border-accent bg-accent text-white'
                            : 'border-gray-300 text-charcoal hover:bg-gray-50'
                        }`}
                        aria-current={page === i + 1}
                        aria-label={`Page ${i + 1}`}
                      >
                        {i + 1}
                      </button>
                    ))}
                    <button
                      onClick={() => setPage(page + 1)}
                      disabled={page === totalPages}
                      className="flex h-10 w-10 items-center justify-center rounded border border-gray-300 text-charcoal hover:bg-gray-50 disabled:opacity-40 disabled:cursor-not-allowed"
                      aria-label="Next page"
                    >
                      <ChevronRight className="h-5 w-5" />
                    </button>
                  </nav>
                )}
              </>
            )}
          </div>
        </div>
      </div>

      {/* Mobile filter drawer */}
      {mobileFiltersOpen && (
        <div className="fixed inset-0 z-50 lg:hidden">
          <div
            className="absolute inset-0 bg-navy-600/50 animate-fadeIn"
            onClick={() => setMobileFiltersOpen(false)}
            aria-hidden="true"
          />
          <div className="absolute right-0 top-0 h-full w-[85%] max-w-sm bg-white shadow-2xl animate-slideIn overflow-y-auto">
            <div className="flex items-center justify-between border-b border-gray-200 px-4 py-4">
              <span className="flex items-center gap-2 text-lg font-bold text-navy-600">
                <SlidersHorizontal className="h-5 w-5 text-accent" />
                Filters
              </span>
              <button
                onClick={() => setMobileFiltersOpen(false)}
                className="flex h-11 w-11 items-center justify-center rounded text-charcoal hover:bg-gray-100"
                aria-label="Close filters"
              >
                <X className="h-6 w-6" />
              </button>
            </div>
            <div className="p-4">
              <FilterContent />
            </div>
            <div className="sticky bottom-0 border-t border-gray-200 bg-white p-4">
              <button
                onClick={() => setMobileFiltersOpen(false)}
                className="btn-primary w-full"
              >
                Show {totalProducts} Results
              </button>
            </div>
          </div>
        </div>
      )}

      <QuickViewModal
        product={quickViewProduct}
        onClose={() => setQuickViewProduct(null)}
      />
    </>
  );
}

function FilterGroup({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div className="border-b border-gray-100 pb-4 last:border-0">
      <h3 className="mb-3 text-sm font-semibold text-charcoal">{title}</h3>
      <div className="space-y-2">{children}</div>
    </div>
  );
}

function CheckboxItem({
  label,
  checked,
  onChange,
}: {
  label: string;
  checked: boolean;
  onChange: () => void;
}) {
  return (
    <label className="flex cursor-pointer items-center gap-2.5 text-sm text-charcoal hover:text-accent transition-colors">
      <input
        type="checkbox"
        checked={checked}
        onChange={onChange}
        className="h-4 w-4 rounded border-gray-300 text-accent focus:ring-accent"
      />
      {label}
    </label>
  );
}
