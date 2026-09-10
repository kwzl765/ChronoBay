import { useState } from 'react';
import { Link } from 'react-router-dom';
import { Heart, Trash2, ShoppingBag } from 'lucide-react';
import Seo from '@/components/Seo';
import EmptyState from '@/components/EmptyState';
import ProductCard from '@/components/ProductCard';
import QuickViewModal from '@/components/QuickViewModal';
import { useShop } from '@/context/ShopContext';
import { formatMMK } from '@/data/mockData';
import type { Product } from '@/types';

export default function WishlistPage() {
  const { wishlist, removeFromWishlist, addToCart } = useShop();
  const [quickViewProduct, setQuickViewProduct] = useState<Product | null>(null);

  if (wishlist.length === 0) {
    return (
      <>
        <Seo title="Your Wishlist — ChronoBay" description="Your saved watches will appear here." />
        <div className="container-wide py-16">
          <h1 className="sr-only">My Wishlist</h1>
          <EmptyState
            icon={<Heart className="h-8 w-8" />}
            title="Your wishlist is empty"
            description="Save watches you love by tapping the heart icon. They'll appear here so you can find them easily later."
            actionLabel="Discover Watches"
            actionTo="/shop"
          />
        </div>
      </>
    );
  }

  return (
    <>
      <Seo title="Your Wishlist — ChronoBay" description="Your saved watches and favorite timepieces." />
      <div className="container-wide py-10 lg:py-14">
        <h1 className="text-[26px] font-bold text-navy-600 sm:text-[32px]">My Wishlist</h1>
        <p className="mt-1 text-sm text-gray-500">
          {wishlist.length} saved item{wishlist.length !== 1 ? 's' : ''}
        </p>

        {/* List view with actions */}
        <div className="mt-10 space-y-3">
          {wishlist.map((product) => (
            <div
              key={product.id}
              className="flex flex-col gap-4 rounded border border-gray-200 p-4 sm:flex-row sm:items-center"
            >
              <Link to={`/product/${product.slug}`} className="shrink-0">
                <div className="h-24 w-24 overflow-hidden rounded border border-gray-200 bg-gray-100">
                  <img
                    src={product.image}
                    alt={product.name}
                    className="h-full w-full object-contain p-2"
                    loading="lazy"
                  />
                </div>
              </Link>
              <div className="flex-1 min-w-0">
                <p className="text-[11px] font-medium uppercase tracking-wider text-gray-400">
                  {product.brand}
                </p>
                <Link
                  to={`/product/${product.slug}`}
                  className="block truncate text-sm font-semibold text-navy-600 hover:text-accent"
                >
                  {product.name}
                </Link>
                <p className="mt-1 text-lg font-bold text-navy-600">
                  {formatMMK(product.price)}
                </p>
              </div>
              <div className="flex gap-2">
                <button
                  onClick={() => addToCart(product)}
                  className="flex items-center gap-2 rounded bg-accent px-4 py-2.5 text-sm font-semibold text-white transition-colors hover:bg-accent-600"
                >
                  <ShoppingBag className="h-4 w-4" />
                  Add to Cart
                </button>
                <button
                  onClick={() => removeFromWishlist(product.id)}
                  className="flex h-11 w-11 items-center justify-center rounded border border-gray-300 text-gray-400 hover:border-red-300 hover:bg-red-50 hover:text-red-600"
                  aria-label={`Remove ${product.name} from wishlist`}
                >
                  <Trash2 className="h-4 w-4" />
                </button>
              </div>
            </div>
          ))}
        </div>

        {/* Grid view */}
        <div className="mt-12">
          <h2 className="text-lg font-bold text-navy-600">Quick Browse</h2>
          <div className="mt-8 grid grid-cols-2 gap-5 md:grid-cols-3 lg:grid-cols-4">
            {wishlist.map((product) => (
              <ProductCard
                key={product.id}
                product={product}
                onQuickView={setQuickViewProduct}
              />
            ))}
          </div>
        </div>
      </div>

      <QuickViewModal product={quickViewProduct} onClose={() => setQuickViewProduct(null)} />
    </>
  );
}
