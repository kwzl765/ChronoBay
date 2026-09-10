import { Link } from 'react-router-dom';
import { Heart, Eye, ShoppingBag } from 'lucide-react';
import type { Product } from '@/types';
import { formatMMK, discountPercent } from '@/data/mockData';
import { useShop } from '@/context/ShopContext';
import Rating from '@/components/Rating';

interface ProductCardProps {
  product: Product;
  onQuickView?: (product: Product) => void;
}

export default function ProductCard({ product, onQuickView }: ProductCardProps) {
  const { addToCart, toggleWishlist, isInWishlist } = useShop();
  const discount = discountPercent(product);
  const inWishlist = isInWishlist(product.id);

  return (
    <div className="group flex flex-col bg-white transition-shadow duration-300 hover:shadow-card">
      {/* Image */}
      <div className="relative aspect-square overflow-hidden bg-gray-100">
        <Link to={`/product/${product.slug}`} aria-label={product.name}>
          <img
            src={product.image}
            alt={`${product.brand} ${product.name}`}
            loading="lazy"
            className="h-full w-full object-contain p-5 transition-transform duration-500 group-hover:scale-[1.04]"
          />
        </Link>

        {/* Badges */}
        <div className="absolute left-2.5 top-2.5 flex flex-col gap-1">
          {discount && (
            <span className="rounded bg-accent px-1.5 py-0.5 text-[10px] font-bold text-white">
              -{discount}%
            </span>
          )}
          {product.newArrival && (
            <span className="rounded bg-navy-600 px-1.5 py-0.5 text-[10px] font-bold text-white">
              NEW
            </span>
          )}
        </div>

        {/* Wishlist */}
        <button
          onClick={() => toggleWishlist(product)}
          className={`absolute right-2.5 top-2.5 flex h-8 w-8 items-center justify-center rounded-full transition-colors ${
            inWishlist
              ? 'bg-accent text-white'
              : 'bg-white/85 text-gray-500 hover:bg-accent hover:text-white'
          }`}
          aria-label={inWishlist ? 'Remove from wishlist' : 'Add to wishlist'}
        >
          <Heart className={`h-3.5 w-3.5 ${inWishlist ? 'fill-current' : ''}`} />
        </button>

        {/* Hover actions */}
        <div className="absolute bottom-2.5 left-2.5 right-2.5 flex gap-2 opacity-0 transition-opacity duration-200 group-hover:opacity-100">
          {onQuickView && (
            <button
              onClick={() => onQuickView(product)}
              className="flex h-9 flex-1 items-center justify-center gap-1.5 rounded bg-white/95 text-xs font-semibold text-charcoal shadow-sm transition-colors hover:bg-navy-600 hover:text-white"
              aria-label={`Quick view ${product.name}`}
            >
              <Eye className="h-3.5 w-3.5" />
              Quick View
            </button>
          )}
          <button
            onClick={() => addToCart(product)}
            className="flex h-9 w-9 items-center justify-center rounded bg-accent text-white shadow-sm transition-colors hover:bg-accent-600"
            aria-label={`Add ${product.name} to cart`}
          >
            <ShoppingBag className="h-3.5 w-3.5" />
          </button>
        </div>
      </div>

      {/* Info */}
      <div className="flex flex-1 flex-col px-1 py-3">
        <p className="text-[11px] font-medium uppercase tracking-wider text-gray-400">
          {product.brand}
        </p>
        <Link
          to={`/product/${product.slug}`}
          className="mt-1 line-clamp-2 text-sm font-semibold text-navy-600 transition-colors hover:text-accent"
        >
          {product.name}
        </Link>
        <div className="mt-1.5">
          <Rating rating={product.rating} reviewCount={product.reviewCount} />
        </div>
        <div className="mt-auto flex items-baseline gap-2 pt-3">
          <span className="text-base font-bold text-navy-600">
            {formatMMK(product.price)}
          </span>
          {product.originalPrice && (
            <span className="text-xs text-gray-400 line-through">
              {formatMMK(product.originalPrice)}
            </span>
          )}
        </div>
      </div>
    </div>
  );
}
