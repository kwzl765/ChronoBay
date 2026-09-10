import { Link } from 'react-router-dom';
import { X, ShoppingBag, Heart } from 'lucide-react';
import type { Product } from '@/types';
import { formatMMK, discountPercent } from '@/data/mockData';
import { useShop } from '@/context/ShopContext';
import Rating from '@/components/Rating';
import { useEffect } from 'react';

interface QuickViewModalProps {
  product: Product | null;
  onClose: () => void;
}

export default function QuickViewModal({ product, onClose }: QuickViewModalProps) {
  const { addToCart, toggleWishlist, isInWishlist } = useShop();

  useEffect(() => {
    if (product) {
      document.body.style.overflow = 'hidden';
      const onKey = (e: KeyboardEvent) => e.key === 'Escape' && onClose();
      document.addEventListener('keydown', onKey);
      return () => {
        document.body.style.overflow = '';
        document.removeEventListener('keydown', onKey);
      };
    }
  }, [product, onClose]);

  if (!product) return null;

  const discount = discountPercent(product);
  const inWishlist = isInWishlist(product.id);

  return (
    <div className="fixed inset-0 z-[90] flex items-center justify-center p-4">
      <div
        className="absolute inset-0 bg-navy-600/60 animate-fadeIn"
        onClick={onClose}
        aria-hidden="true"
      />
      <div
        className="relative z-10 w-full max-w-3xl rounded bg-white shadow-2xl animate-scaleIn max-h-[90vh] overflow-y-auto"
        role="dialog"
        aria-modal="true"
        aria-label={`Quick view: ${product.name}`}
      >
        <button
          onClick={onClose}
          className="absolute right-3 top-3 z-20 flex h-10 w-10 items-center justify-center rounded bg-white/80 text-charcoal hover:bg-gray-100"
          aria-label="Close quick view"
        >
          <X className="h-5 w-5" />
        </button>
        <div className="grid gap-0 md:grid-cols-2">
          {/* Image */}
          <div className="relative aspect-square bg-gray-100">
            <img
              src={product.image}
              alt={`${product.brand} ${product.name}`}
              className="h-full w-full object-contain p-6"
            />
            {discount && (
              <span className="absolute left-3 top-3 rounded bg-accent px-2 py-0.5 text-xs font-bold text-white">
                -{discount}%
              </span>
            )}
          </div>
          {/* Info */}
          <div className="flex flex-col p-6">
            <p className="text-[11px] font-medium uppercase tracking-wider text-gray-400">
              {product.brand}
            </p>
            <h3 className="mt-1 text-lg font-bold text-navy-600">{product.name}</h3>
            <div className="mt-2">
              <Rating rating={product.rating} reviewCount={product.reviewCount} size="md" />
            </div>
            <div className="mt-4 flex items-baseline gap-2">
              <span className="text-2xl font-bold text-navy-600">
                {formatMMK(product.price)}
              </span>
              {product.originalPrice && (
                <span className="text-sm text-gray-400 line-through">
                  {formatMMK(product.originalPrice)}
                </span>
              )}
            </div>
            <p className="mt-2 text-sm text-gray-500">
              {product.stock > 0 ? (
                <span className="text-green-600">In Stock ({product.stock} available)</span>
              ) : (
                <span className="text-red-600">Out of Stock</span>
              )}
            </p>
            <p className="mt-4 line-clamp-4 text-sm leading-relaxed text-gray-600">
              {product.description}
            </p>
            <div className="mt-auto flex gap-3 pt-6">
              <button
                onClick={() => {
                  addToCart(product);
                  onClose();
                }}
                className="btn-primary flex-1"
              >
                <ShoppingBag className="h-4 w-4" />
                Add to Cart
              </button>
              <button
                onClick={() => toggleWishlist(product)}
                className={`flex h-12 w-12 items-center justify-center rounded border transition-colors ${
                  inWishlist
                    ? 'border-accent bg-accent text-white'
                    : 'border-gray-300 text-charcoal hover:border-accent hover:text-accent'
                }`}
                aria-label={inWishlist ? 'Remove from wishlist' : 'Add to wishlist'}
              >
                <Heart className={`h-5 w-5 ${inWishlist ? 'fill-current' : ''}`} />
              </button>
            </div>
            <Link
              to={`/product/${product.slug}`}
              onClick={onClose}
              className="mt-3 text-center text-sm font-medium text-accent hover:underline"
            >
              View full details →
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
