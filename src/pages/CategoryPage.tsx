import { useState } from 'react';
import { useParams, Link, Navigate } from 'react-router-dom';
import { ChevronRight } from 'lucide-react';
import Seo from '@/components/Seo';
import ProductCard from '@/components/ProductCard';
import QuickViewModal from '@/components/QuickViewModal';
import { ProductGridSkeleton } from '@/components/Skeletons';
import { useCategoryBySlug, useProductsByCategory } from '@/hooks/useCatalogue';
import type { Product } from '@/types';

export default function CategoryPage() {
  const { slug } = useParams<{ slug: string }>();
  const [quickViewProduct, setQuickViewProduct] = useState<Product | null>(null);

  const { data: category, loading: catLoading } = useCategoryBySlug(slug);
  const { data: productsData, loading: productsLoading } = useProductsByCategory(slug);

  if (catLoading && !category) {
    return (
      <div className="container-wide py-20">
        <div className="animate-pulse">
          <div className="h-8 w-48 rounded bg-gray-200" />
          <div className="mt-4 h-4 w-72 rounded bg-gray-200" />
        </div>
      </div>
    );
  }

  if (!category) return <Navigate to="/404" replace />;

  const categoryProducts = productsData ?? [];

  return (
    <>
      <Seo
        title={`${category.name} — ChronoBay`}
        description={category.description}
      />

      {/* Breadcrumb */}
      <div className="border-b border-gray-200 bg-gray-50">
        <div className="container-wide py-3">
          <nav className="flex items-center gap-2 text-xs text-gray-500" aria-label="Breadcrumb">
            <Link to="/" className="hover:text-accent">Home</Link>
            <ChevronRight className="h-3 w-3" aria-hidden="true" />
            <Link to="/shop" className="hover:text-accent">Shop</Link>
            <ChevronRight className="h-3 w-3" aria-hidden="true" />
            <span className="text-charcoal">{category.name}</span>
          </nav>
        </div>
      </div>

      {/* Hero banner */}
      <div className="relative h-[200px] overflow-hidden bg-navy-600 sm:h-[260px]">
        <img
          src={category.image}
          alt=""
          className="h-full w-full object-cover opacity-40"
          loading="eager"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-navy-600 via-navy-600/50 to-transparent" />
        <div className="container-wide relative flex h-full items-center">
          <div>
            <h1 className="text-3xl font-bold text-white sm:text-4xl">{category.name}</h1>
            <p className="mt-2 max-w-lg text-sm text-gray-200">{category.description}</p>
            <p className="mt-3 text-xs text-gray-300">
              {productsLoading ? 'Loading...' : `${categoryProducts.length} product${categoryProducts.length !== 1 ? 's' : ''}`}
            </p>
          </div>
        </div>
      </div>

      <div className="container-wide py-10 lg:py-14">
        {productsLoading ? (
          <ProductGridSkeleton count={8} />
        ) : categoryProducts.length === 0 ? (
          <p className="py-16 text-center text-gray-500">No products in this category yet.</p>
        ) : (
          <div className="grid grid-cols-2 gap-5 md:grid-cols-3 lg:grid-cols-4">
            {categoryProducts.map((product) => (
              <ProductCard
                key={product.id}
                product={product}
                onQuickView={setQuickViewProduct}
              />
            ))}
          </div>
        )}
      </div>

      <QuickViewModal product={quickViewProduct} onClose={() => setQuickViewProduct(null)} />
    </>
  );
}
