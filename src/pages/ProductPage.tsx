import { useState } from 'react';
import { useParams, Link, Navigate } from 'react-router-dom';
import {
  Heart,
  ShoppingBag,
  Minus,
  Plus,
  ChevronRight,
  Shield,
  Truck,
  RefreshCw,
  Check,
  ChevronLeft,
  AlertCircle,
} from 'lucide-react';
import Seo from '@/components/Seo';
import Rating from '@/components/Rating';
import ProductCard from '@/components/ProductCard';
import { useProductBySlug, useProducts } from '@/hooks/useCatalogue';
import { useShop } from '@/context/ShopContext';
import { formatMMK, discountPercent } from '@/data/mockData';

export default function ProductPage() {
  const { slug } = useParams<{ slug: string }>();
  const { data: product, loading, error, retry } = useProductBySlug(slug);
  const { data: allProducts } = useProducts();
  const { addToCart, toggleWishlist, isInWishlist } = useShop();

  const [selectedImage, setSelectedImage] = useState(0);
  const [quantity, setQuantity] = useState(1);
  const [activeTab, setActiveTab] = useState<'description' | 'specifications'>('description');

  if (loading) {
    return (
      <div className="container-wide py-20">
        <div className="grid gap-10 lg:grid-cols-2 lg:gap-14">
          <div className="aspect-square animate-pulse rounded bg-gray-200" />
          <div className="space-y-4">
            <div className="h-4 w-24 animate-pulse rounded bg-gray-200" />
            <div className="h-8 w-64 animate-pulse rounded bg-gray-200" />
            <div className="h-4 w-32 animate-pulse rounded bg-gray-200" />
            <div className="h-8 w-40 animate-pulse rounded bg-gray-200" />
            <div className="h-32 w-full animate-pulse rounded bg-gray-200" />
          </div>
        </div>
      </div>
    );
  }

  if (error && !product) {
    return (
      <div className="container-wide py-20 text-center">
        <AlertCircle className="mx-auto h-12 w-12 text-amber-400" />
        <h1 className="mt-4 text-xl font-bold text-navy-600">Unable to load product</h1>
        <p className="mt-2 text-sm text-gray-500">{error}</p>
        <button onClick={retry} className="btn-primary mt-6">Retry</button>
      </div>
    );
  }

  if (!product) return <Navigate to="/404" replace />;

  const discount = discountPercent(product);
  const inWishlist = isInWishlist(product.id);

  // Related products from the same category or brand
  const related = (allProducts ?? [])
    .filter(
      (p) =>
        p.id !== product.id &&
        (p.category === product.category || p.brandSlug === product.brandSlug)
    )
    .slice(0, 4);

  const gallery = product.gallery.length > 0 ? product.gallery : [product.image];

  return (
    <>
      <Seo
        title={`${product.name} — ${product.brand} | ChronoBay`}
        description={product.description.slice(0, 160)}
      />

      {/* Breadcrumb */}
      <div className="border-b border-gray-200 bg-gray-50">
        <div className="container-wide py-3">
          <nav className="flex items-center gap-2 text-xs text-gray-500" aria-label="Breadcrumb">
            <Link to="/" className="hover:text-accent">Home</Link>
            <ChevronRight className="h-3 w-3" aria-hidden="true" />
            <Link to="/shop" className="hover:text-accent">Shop</Link>
            <ChevronRight className="h-3 w-3" aria-hidden="true" />
            <Link to={`/category/${product.category}`} className="hover:text-accent capitalize">
              {product.category.replace('-', ' ')}
            </Link>
            <ChevronRight className="h-3 w-3" aria-hidden="true" />
            <span className="truncate text-charcoal">{product.name}</span>
          </nav>
        </div>
      </div>

      <div className="container-wide py-10 lg:py-14">
        <div className="grid gap-10 lg:grid-cols-2 lg:gap-14">
          {/* Gallery */}
          <div className="flex flex-col gap-4">
            <div className="relative aspect-square overflow-hidden rounded border border-gray-200 bg-gray-100">
              <img
                src={gallery[selectedImage]}
                alt={`${product.brand} ${product.name}`}
                className="h-full w-full object-contain p-8"
              />
              {discount && (
                <span className="absolute left-4 top-4 rounded bg-accent px-3 py-1 text-sm font-bold text-white">
                  -{discount}%
                </span>
              )}
            </div>
            {gallery.length > 1 && (
              <div className="flex gap-2 overflow-x-auto no-scrollbar">
                {gallery.map((img, i) => (
                  <button
                    key={i}
                    onClick={() => setSelectedImage(i)}
                    className={`relative h-20 w-20 shrink-0 overflow-hidden rounded border-2 bg-gray-100 transition-colors ${
                      selectedImage === i ? 'border-accent' : 'border-gray-200 hover:border-gray-300'
                    }`}
                    aria-label={`View image ${i + 1}`}
                    aria-current={selectedImage === i}
                  >
                    <img
                      src={img}
                      alt=""
                      className="h-full w-full object-contain p-2"
                      loading="lazy"
                    />
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* Info */}
          <div className="flex flex-col">
            <p className="text-[11px] font-medium uppercase tracking-wider text-gray-400">
              {product.brand}
            </p>
            <h1 className="mt-1.5 text-[26px] font-bold text-navy-600 sm:text-[32px]">
              {product.name}
            </h1>
            <div className="mt-3 flex items-center gap-3">
              <Rating rating={product.rating} reviewCount={product.reviewCount} size="md" />
              <span className="text-sm text-gray-400">
                {product.rating} / 5
              </span>
            </div>

            {/* Price */}
            <div className="mt-5 flex items-baseline gap-3">
              <span className="text-3xl font-bold text-navy-600">
                {formatMMK(product.price)}
              </span>
              {product.originalPrice && (
                <span className="text-lg text-gray-400 line-through">
                  {formatMMK(product.originalPrice)}
                </span>
              )}
              {discount && (
                <span className="rounded bg-accent/10 px-2 py-0.5 text-sm font-bold text-accent">
                  Save {discount}%
                </span>
              )}
            </div>

            {/* Stock & SKU */}
            <div className="mt-4 flex flex-wrap gap-4 text-sm">
              <span className="flex items-center gap-1.5">
                <Check
                  className={`h-4 w-4 ${product.stock > 0 ? 'text-green-600' : 'text-red-600'}`}
                  aria-hidden="true"
                />
                {product.stock > 0 ? (
                  <span className="text-green-600">In Stock ({product.stock} available)</span>
                ) : (
                  <span className="text-red-600">Out of Stock</span>
                )}
              </span>
              <span className="text-gray-400">SKU: {product.id.toUpperCase()}</span>
            </div>

            {/* Quantity + actions */}
            <div className="mt-6 flex flex-wrap items-center gap-3">
              <div className="flex items-center rounded border border-gray-300">
                <button
                  onClick={() => setQuantity((q) => Math.max(1, q - 1))}
                  className="flex h-11 w-11 items-center justify-center text-charcoal hover:bg-gray-50"
                  aria-label="Decrease quantity"
                >
                  <Minus className="h-4 w-4" />
                </button>
                <span
                  className="w-12 text-center text-sm font-semibold"
                  aria-live="polite"
                  aria-label={`Quantity: ${quantity}`}
                >
                  {quantity}
                </span>
                <button
                  onClick={() => setQuantity((q) => Math.min(product.stock, q + 1))}
                  className="flex h-11 w-11 items-center justify-center text-charcoal hover:bg-gray-50"
                  aria-label="Increase quantity"
                >
                  <Plus className="h-4 w-4" />
                </button>
              </div>

              <button
                onClick={() => addToCart(product, quantity)}
                disabled={product.stock === 0}
                className="btn-primary flex-1 sm:flex-none"
              >
                <ShoppingBag className="h-5 w-5" />
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

            {/* Assurance icons */}
            <div className="mt-8 grid grid-cols-1 gap-3 sm:grid-cols-3">
              <div className="flex items-center gap-2 rounded border border-gray-200 p-3">
                <Shield className="h-5 w-5 shrink-0 text-accent" aria-hidden="true" />
                <div>
                  <p className="text-xs font-semibold text-charcoal">Warranty</p>
                  <p className="text-xs text-gray-400">2 Years</p>
                </div>
              </div>
              <div className="flex items-center gap-2 rounded border border-gray-200 p-3">
                <Truck className="h-5 w-5 shrink-0 text-accent" aria-hidden="true" />
                <div>
                  <p className="text-xs font-semibold text-charcoal">Delivery</p>
                  <p className="text-xs text-gray-400">2-5 business days</p>
                </div>
              </div>
              <div className="flex items-center gap-2 rounded border border-gray-200 p-3">
                <RefreshCw className="h-5 w-5 shrink-0 text-accent" aria-hidden="true" />
                <div>
                  <p className="text-xs font-semibold text-charcoal">Returns</p>
                  <p className="text-xs text-gray-400">7-day return</p>
                </div>
              </div>
            </div>

            {/* Tabs */}
            <div className="mt-8">
              <div className="flex border-b border-gray-200" role="tablist">
                <button
                  onClick={() => setActiveTab('description')}
                  className={`px-4 py-3 text-sm font-medium transition-colors ${
                    activeTab === 'description'
                      ? 'border-b-2 border-accent text-accent'
                      : 'text-gray-500 hover:text-charcoal'
                  }`}
                  role="tab"
                  aria-selected={activeTab === 'description'}
                >
                  Description
                </button>
                <button
                  onClick={() => setActiveTab('specifications')}
                  className={`px-4 py-3 text-sm font-medium transition-colors ${
                    activeTab === 'specifications'
                      ? 'border-b-2 border-accent text-accent'
                      : 'text-gray-500 hover:text-charcoal'
                  }`}
                  role="tab"
                  aria-selected={activeTab === 'specifications'}
                >
                  Specifications
                </button>
              </div>
              <div className="pt-5">
                {activeTab === 'description' ? (
                  <p className="text-sm leading-relaxed text-gray-600">
                    {product.description}
                  </p>
                ) : (
                  <p className="text-sm text-gray-500">
                    Detailed specifications for this product will be available soon.
                  </p>
                )}
              </div>
            </div>
          </div>
        </div>

        {/* Related products */}
        {related.length > 0 && (
          <section className="mt-16">
            <h2 className="text-xl font-bold text-navy-600 sm:text-2xl">Related Products</h2>
            <div className="mt-8 grid grid-cols-2 gap-5 md:grid-cols-4">
              {related.map((p) => (
                <ProductCard key={p.id} product={p} />
              ))}
            </div>
            <div className="mt-8 text-center">
              <Link
                to="/shop"
                className="inline-flex items-center gap-1 text-sm font-medium text-accent hover:underline"
              >
                <ChevronLeft className="h-4 w-4" />
                Back to Shop
              </Link>
            </div>
          </section>
        )}
      </div>
    </>
  );
}
