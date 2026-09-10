import { useState, useMemo } from 'react';
import { Link } from 'react-router-dom';
import { Search, PackageSearch } from 'lucide-react';
import Seo from '@/components/Seo';
import {
  visualFamilyLabels,
  type VisualFamily,
} from '@/data/brands';
import { useBrands, useProducts } from '@/hooks/useCatalogue';

type FilterKey = 'all' | VisualFamily;

const filterButtons: { key: FilterKey; label: string }[] = [
  { key: 'all', label: 'All' },
  { key: 'luxury', label: 'Luxury' },
  { key: 'fashion', label: 'Fashion' },
  { key: 'sport', label: 'Sport' },
  { key: 'classic', label: 'Classic' },
  { key: 'digital', label: 'Digital' },
  { key: 'gift', label: 'Gift' },
];

export default function BrandsPage() {
  const [search, setSearch] = useState('');
  const [filter, setFilter] = useState<FilterKey>('all');

  const { data: brands } = useBrands();
  const { data: products } = useProducts();

  const allBrands = brands ?? [];
  const allProducts = products ?? [];

  const productCountBySlug = useMemo(() => {
    const map = new Map<string, number>();
    for (const p of allProducts) {
      map.set(p.brandSlug, (map.get(p.brandSlug) ?? 0) + 1);
    }
    return map;
  }, [allProducts]);

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    return allBrands.filter((b) => {
      const matchesFilter = filter === 'all' || b.visualFamily === filter;
      const matchesSearch =
        !q ||
        b.name.toLowerCase().includes(q) ||
        b.description.toLowerCase().includes(q);
      return matchesFilter && matchesSearch;
    });
  }, [allBrands, search, filter]);

  return (
    <>
      <Seo
        title="All Brands — ChronoBay"
        description="Explore our complete directory of premium watch brands — from CASIO and Seiko to Emporio Armani and Michael Kors."
      />

      {/* Breadcrumb */}
      <div className="border-b border-gray-200 bg-gray-50">
        <div className="container-wide py-3">
          <nav className="flex items-center gap-2 text-xs text-gray-500" aria-label="Breadcrumb">
            <Link to="/" className="hover:text-accent">Home</Link>
            <span aria-hidden="true">/</span>
            <span className="text-charcoal">Brands</span>
          </nav>
        </div>
      </div>

      <div className="container-wide py-10 lg:py-14">
        <h1 className="text-[26px] font-bold text-navy-600 sm:text-[32px]">Explore Our Brands</h1>
        <p className="mt-2 max-w-2xl text-sm text-gray-500">
          Discover authentic timepieces from 29 world-renowned watchmakers. Each brand brings
          its own legacy of craftsmanship, innovation, and design excellence.
        </p>

        {/* Search */}
        <div className="mt-8 max-w-md">
          <label htmlFor="brand-search" className="sr-only">
            Search brands
          </label>
          <div className="relative">
            <Search
              className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-gray-400"
              aria-hidden="true"
            />
            <input
              id="brand-search"
              type="search"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search brands..."
              className="w-full rounded border border-gray-300 bg-gray-50 pl-10 pr-4 py-2.5 text-sm text-charcoal placeholder:text-gray-400 transition-colors focus:border-accent focus:bg-white focus:ring-1 focus:ring-accent/20"
              aria-label="Search brands"
            />
          </div>
        </div>

        {/* Filter buttons */}
        <div className="mt-5 flex flex-wrap gap-2">
          {filterButtons.map((btn) => (
            <button
              key={btn.key}
              onClick={() => setFilter(btn.key)}
              className={`rounded border px-4 py-2 text-sm font-medium transition-colors ${
                filter === btn.key
                  ? 'border-accent bg-accent text-white'
                  : 'border-gray-300 text-charcoal hover:bg-gray-50'
              }`}
              aria-pressed={filter === btn.key}
            >
              {btn.label}
            </button>
          ))}
        </div>

        {/* Brand grid */}
        {filtered.length === 0 ? (
          <div className="mt-10 flex flex-col items-center justify-center rounded border border-dashed border-gray-300 bg-gray-50 px-6 py-16 text-center">
            <div className="flex h-16 w-16 items-center justify-center rounded bg-gray-200 text-gray-400">
              <PackageSearch className="h-8 w-8" />
            </div>
            <h2 className="mt-4 text-lg font-semibold text-charcoal">No brands found</h2>
            <p className="mt-1 max-w-sm text-sm text-gray-500">
              No brands match your search. Try a different keyword or filter.
            </p>
            <button
              onClick={() => {
                setSearch('');
                setFilter('all');
              }}
              className="btn-primary mt-6"
            >
              Clear Filters
            </button>
          </div>
        ) : (
          <div className="mt-10 grid grid-cols-2 gap-4 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5">
            {filtered.map((brand) => {
              const count = productCountBySlug.get(brand.slug) ?? 0;
              return (
                <Link
                  key={brand.slug}
                  to={`/brands/${brand.slug}`}
                  className="group flex flex-col items-center"
                  aria-label={`View ${brand.name}`}
                >
                  <div className="flex aspect-[4/3] w-full items-center justify-center rounded border border-gray-200 bg-white p-5 transition-shadow duration-300 hover:shadow-card">
                    <img
                      src={brand.logo}
                      alt={`${brand.name} logo`}
                      loading="lazy"
                      className="h-full w-full object-contain"
                    />
                  </div>
                  <h2 className="mt-3 text-center text-sm font-semibold text-navy-600 group-hover:text-accent transition-colors">
                    {brand.name}
                  </h2>
                  <p className="mt-0.5 text-center text-xs text-gray-400">
                    {count > 0
                      ? `${count} product${count !== 1 ? 's' : ''}`
                      : brand.visualFamily
                        ? visualFamilyLabels[brand.visualFamily as keyof typeof visualFamilyLabels]
                        : ''}
                  </p>
                </Link>
              );
            })}
          </div>
        )}
      </div>
    </>
  );
}
