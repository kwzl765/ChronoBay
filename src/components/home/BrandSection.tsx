import { useState } from 'react';
import { Link } from 'react-router-dom';
import { ArrowRight } from 'lucide-react';
import type { Product } from '@/types';
import { useProductsByBrand } from '@/hooks/useCatalogue';
import { getBrandBySlug } from '@/data/brands';
import ProductCard from '@/components/ProductCard';
import QuickViewModal from '@/components/QuickViewModal';
import { ProductGridSkeleton } from '@/components/Skeletons';

interface BrandSectionProps {
  brand: string;
  alt?: boolean;
  slug: string;
}

export default function BrandSection({ alt = false, slug }: BrandSectionProps) {
  const { data, loading } = useProductsByBrand(slug);
  const [quickViewProduct, setQuickViewProduct] = useState<Product | null>(null);

  const brandProducts = (data ?? []).slice(0, 4);
  const brandInfo = getBrandBySlug(slug);

  if (loading) {
    return (
      <section className={`${alt ? 'bg-gray-50' : 'bg-white'} py-12 lg:py-16`}>
        <div className="container-wide">
          <div className="mb-10">
            <span className="text-[11px] font-semibold uppercase tracking-[0.2em] text-accent">
              Featured Brand
            </span>
            <h2 className="mt-2 text-[26px] font-bold text-navy-600 sm:text-[32px]">
              {brandInfo?.name ?? slug}
            </h2>
          </div>
          <ProductGridSkeleton count={4} />
        </div>
      </section>
    );
  }

  if (brandProducts.length === 0) return null;

  return (
    <section className={`${alt ? 'bg-gray-50' : 'bg-white'} py-12 lg:py-16`}>
      <div className="container-wide">
        <div className="flex items-end justify-between gap-4">
          <div>
            <span className="text-[11px] font-semibold uppercase tracking-[0.2em] text-accent">
              Featured Brand
            </span>
            <h2 className="mt-2 text-[26px] font-bold text-navy-600 sm:text-[32px]">
              {brandInfo?.name ?? slug}
            </h2>
          </div>
          <Link
            to={`/brands/${slug}`}
            className="group flex shrink-0 items-center gap-1 text-sm font-medium text-charcoal hover:text-accent transition-colors"
          >
            View All
            <ArrowRight
              className="h-4 w-4 transition-transform group-hover:translate-x-1"
              aria-hidden="true"
            />
          </Link>
        </div>
        <div className="mt-10 grid grid-cols-2 gap-5 md:grid-cols-3 lg:grid-cols-4">
          {brandProducts.map((product) => (
            <ProductCard
              key={product.id}
              product={product}
              onQuickView={setQuickViewProduct}
            />
          ))}
        </div>
      </div>
      <QuickViewModal
        product={quickViewProduct}
        onClose={() => setQuickViewProduct(null)}
      />
    </section>
  );
}
