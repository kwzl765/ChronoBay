import { Link } from 'react-router-dom';
import { Minus, Plus, Trash2, ShoppingBag, ArrowRight, Truck } from 'lucide-react';
import Seo from '@/components/Seo';
import EmptyState from '@/components/EmptyState';
import { useShop } from '@/context/ShopContext';
import { formatMMK } from '@/data/mockData';

const DELIVERY_THRESHOLD = 300000;
const DELIVERY_FEE = 15000;

export default function CartPage() {
  const { cart, updateQuantity, removeFromCart, cartSubtotal, clearCart } = useShop();

  const deliveryFee = cartSubtotal >= DELIVERY_THRESHOLD || cartSubtotal === 0 ? 0 : DELIVERY_FEE;
  const total = cartSubtotal + deliveryFee;
  const freeDeliveryRemaining = Math.max(0, DELIVERY_THRESHOLD - cartSubtotal);

  if (cart.length === 0) {
    return (
      <>
        <Seo title="Your Cart — ChronoBay" description="Your shopping cart is currently empty." />
        <div className="container-wide py-16">
          <EmptyState
            icon={<ShoppingBag className="h-8 w-8" />}
            title="Your cart is empty"
            description="Looks like you haven't added any watches yet. Explore our collection and find your perfect timepiece."
            actionLabel="Start Shopping"
            actionTo="/shop"
          />
        </div>
      </>
    );
  }

  return (
    <>
      <Seo title="Your Cart — ChronoBay" description="Review your selected watches and proceed to checkout." />
      <div className="container-wide py-10 lg:py-14">
        <h1 className="text-[26px] font-bold text-navy-600 sm:text-[32px]">Shopping Cart</h1>
        <p className="mt-1 text-sm text-gray-500">{cart.length} item{cart.length !== 1 ? 's' : ''} in your cart</p>

        <div className="mt-10 grid gap-10 lg:grid-cols-3">
          {/* Items */}
          <div className="lg:col-span-2">
            <div className="divide-y divide-gray-200 rounded border border-gray-200">
              {cart.map((item) => (
                <div key={item.product.id} className="flex gap-4 p-4">
                  <Link
                    to={`/product/${item.product.slug}`}
                    className="shrink-0"
                  >
                    <div className="h-24 w-24 overflow-hidden rounded border border-gray-200 bg-gray-100">
                      <img
                        src={item.product.image}
                        alt={item.product.name}
                        className="h-full w-full object-contain p-2"
                        loading="lazy"
                      />
                    </div>
                  </Link>
                  <div className="flex flex-1 flex-col gap-2 min-w-0">
                    <div className="flex items-start justify-between gap-2">
                      <div className="min-w-0">
                        <p className="text-[11px] font-medium uppercase tracking-wider text-gray-400">
                          {item.product.brand}
                        </p>
                        <Link
                          to={`/product/${item.product.slug}`}
                          className="block truncate text-sm font-semibold text-navy-600 hover:text-accent"
                        >
                          {item.product.name}
                        </Link>
                        <p className="mt-0.5 text-xs text-gray-400">
                          {item.product.movement} · {item.product.gender}
                        </p>
                      </div>
                      <button
                        onClick={() => removeFromCart(item.product.id)}
                        className="shrink-0 rounded p-1.5 text-gray-400 hover:bg-red-50 hover:text-red-600"
                        aria-label={`Remove ${item.product.name} from cart`}
                      >
                        <Trash2 className="h-4 w-4" />
                      </button>
                    </div>
                    <div className="flex items-end justify-between">
                      <div className="flex items-center rounded border border-gray-300">
                        <button
                          onClick={() => updateQuantity(item.product.id, item.quantity - 1)}
                          className="flex h-9 w-9 items-center justify-center text-charcoal hover:bg-gray-50"
                          aria-label="Decrease quantity"
                        >
                          <Minus className="h-3.5 w-3.5" />
                        </button>
                        <span className="w-10 text-center text-sm font-semibold" aria-live="polite">
                          {item.quantity}
                        </span>
                        <button
                          onClick={() => updateQuantity(item.product.id, item.quantity + 1)}
                          className="flex h-9 w-9 items-center justify-center text-charcoal hover:bg-gray-50"
                          aria-label="Increase quantity"
                        >
                          <Plus className="h-3.5 w-3.5" />
                        </button>
                      </div>
                      <span className="text-base font-bold text-navy-600">
                        {formatMMK(item.product.price * item.quantity)}
                      </span>
                    </div>
                  </div>
                </div>
              ))}
            </div>
            <div className="mt-4 flex justify-between">
              <Link to="/shop" className="btn-ghost">
                ← Continue Shopping
              </Link>
              <button
                onClick={clearCart}
                className="text-sm font-medium text-gray-500 hover:text-red-600"
              >
                Clear Cart
              </button>
            </div>
          </div>

          {/* Summary */}
          <div className="lg:col-span-1">
            <div className="sticky top-44 rounded border border-gray-200 bg-gray-50 p-6">
              <h2 className="text-lg font-bold text-navy-600">Order Summary</h2>

              {freeDeliveryRemaining > 0 && (
                <div className="mt-4 rounded bg-accent/10 p-3">
                  <p className="flex items-center gap-2 text-xs text-accent-700">
                    <Truck className="h-4 w-4 shrink-0" />
                    Add {formatMMK(freeDeliveryRemaining)} more for free delivery!
                  </p>
                </div>
              )}

              <dl className="mt-4 space-y-3">
                <div className="flex justify-between text-sm">
                  <dt className="text-gray-500">Subtotal</dt>
                  <dd className="font-medium text-charcoal">{formatMMK(cartSubtotal)}</dd>
                </div>
                <div className="flex justify-between text-sm">
                  <dt className="text-gray-500">Estimated Delivery</dt>
                  <dd className="font-medium text-charcoal">
                    {deliveryFee === 0 ? (
                      <span className="text-green-600">Free</span>
                    ) : (
                      formatMMK(deliveryFee)
                    )}
                  </dd>
                </div>
                <div className="border-t border-gray-200 pt-3" />
                <div className="flex justify-between">
                  <dt className="font-semibold text-charcoal">Total</dt>
                  <dd className="text-lg font-bold text-navy-600">{formatMMK(total)}</dd>
                </div>
              </dl>

              <button className="btn-primary mt-6 w-full">
                Proceed to Checkout
                <ArrowRight className="h-4 w-4" />
              </button>
              <p className="mt-3 text-center text-xs text-gray-400">
                Secure checkout · Free returns within 7 days
              </p>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
