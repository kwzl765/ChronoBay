import { useState } from 'react';
import { Link } from 'react-router-dom';
import { ArrowRight, PackageSearch, AlertCircle } from 'lucide-react';
import ProductCard from '@/components/ProductCard';
import QuickViewModal from '@/components/QuickViewModal';
import SectionTitle from '@/components/SectionTitle';
import { ProductGridSkeleton } from '@/components/Skeletons';
import EmptyState from '@/components/EmptyState';
import { useFeaturedProducts } from '@/hooks/useCatalogue';
import type { Product } from '@/types';

export default function PopularCollection() {
  const { data: featured, loading, error, retry } = useFeaturedProducts(8);
  const [quickViewProduct, setQuickViewProduct] = useState<Product | null>(null);

  const products = featured ?? [];

  return (
    <section className="container-wide py-12 lg:py-16">
      <SectionTitle
        eyebrow="Popular"
        title="Popular Collection"
        link={{ label: 'View All', to: '/shop?sort=popularity' }}
      />
      <div className="mt-10">
        {loading ? (
          <ProductGridSkeleton count={8} />
        ) : products.length === 0 ? (
          <EmptyState
            icon={<PackageSearch className="h-8 w-8" />}
            title="No products found"
            description="We couldn't find any products in this collection right now."
            actionLabel="Browse All Products"
            actionTo="/shop"
          />
        ) : (
          <>
            {error && (
              <div className="mb-4 flex items-center gap-2 rounded border border-amber-200 bg-amber-50 px-4 py-2 text-xs text-amber-700">
                <AlertCircle className="h-4 w-4 shrink-0" />
                <span>{error}</span>
                <button onClick={retry} className="ml-auto font-medium underline">Retry</button>
              </div>
            )}
            <div className="grid grid-cols-2 gap-5 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4">
              {products.map((product) => (
                <ProductCard
                  key={product.id}
                  product={product}
                  onQuickView={setQuickViewProduct}
                />
              ))}
            </div>
          </>
        )}
      </div>
      <div className="mt-10 text-center">
        <Link to="/shop" className="btn-secondary">
          View All Products
          <ArrowRight className="h-4 w-4" />
        </Link>
      </div>
      <QuickViewModal
        product={quickViewProduct}
        onClose={() => setQuickViewProduct(null)}
      />
    </section>
  );
}
