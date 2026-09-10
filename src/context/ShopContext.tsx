import {
  createContext,
  useContext,
  useState,
  useEffect,
  useCallback,
  type ReactNode,
} from 'react';
import type { CartItem, Product, ToastMessage } from '@/types';

interface ShopContextValue {
  cart: CartItem[];
  wishlist: Product[];
  cartCount: number;
  wishlistCount: number;
  cartSubtotal: number;
  addToCart: (product: Product, quantity?: number) => void;
  removeFromCart: (productId: string) => void;
  updateQuantity: (productId: string, quantity: number) => void;
  clearCart: () => void;
  isInWishlist: (productId: string) => boolean;
  toggleWishlist: (product: Product) => void;
  removeFromWishlist: (productId: string) => void;
  toasts: ToastMessage[];
  showToast: (type: ToastMessage['type'], message: string) => void;
  dismissToast: (id: string) => void;
}

const ShopContext = createContext<ShopContextValue | undefined>(undefined);

const CART_KEY = 'chronobay_cart';
const WISHLIST_KEY = 'chronobay_wishlist';

function loadCart(): CartItem[] {
  try {
    const raw = localStorage.getItem(CART_KEY);
    return raw ? (JSON.parse(raw) as CartItem[]) : [];
  } catch {
    return [];
  }
}

function loadWishlist(): Product[] {
  try {
    const raw = localStorage.getItem(WISHLIST_KEY);
    return raw ? (JSON.parse(raw) as Product[]) : [];
  } catch {
    return [];
  }
}

let toastIdCounter = 0;

export function ShopProvider({ children }: { children: ReactNode }) {
  const [cart, setCart] = useState<CartItem[]>(loadCart);
  const [wishlist, setWishlist] = useState<Product[]>(loadWishlist);
  const [toasts, setToasts] = useState<ToastMessage[]>([]);

  useEffect(() => {
    localStorage.setItem(CART_KEY, JSON.stringify(cart));
  }, [cart]);

  useEffect(() => {
    localStorage.setItem(WISHLIST_KEY, JSON.stringify(wishlist));
  }, [wishlist]);

  const dismissToast = useCallback((id: string) => {
    setToasts((prev) => prev.filter((t) => t.id !== id));
  }, []);

  const showToast = useCallback(
    (type: ToastMessage['type'], message: string) => {
      const id = `toast-${++toastIdCounter}`;
      setToasts((prev) => [...prev, { id, type, message }]);
      setTimeout(() => {
        setToasts((prev) => prev.filter((t) => t.id !== id));
      }, 3500);
    },
    []
  );

  const addToCart = useCallback(
    (product: Product, quantity = 1) => {
      setCart((prev) => {
        const existing = prev.find((item) => item.product.id === product.id);
        if (existing) {
          return prev.map((item) =>
            item.product.id === product.id
              ? { ...item, quantity: item.quantity + quantity }
              : item
          );
        }
        return [...prev, { product, quantity }];
      });
      showToast('success', `${product.name} added to cart`);
    },
    [showToast]
  );

  const removeFromCart = useCallback((productId: string) => {
    setCart((prev) => prev.filter((item) => item.product.id !== productId));
  }, []);

  const updateQuantity = useCallback((productId: string, quantity: number) => {
    if (quantity < 1) return;
    setCart((prev) =>
      prev.map((item) =>
        item.product.id === productId ? { ...item, quantity } : item
      )
    );
  }, []);

  const clearCart = useCallback(() => setCart([]), []);

  const isInWishlist = useCallback(
    (productId: string) => wishlist.some((p) => p.id === productId),
    [wishlist]
  );

  const toggleWishlist = useCallback(
    (product: Product) => {
      setWishlist((prev) => {
        if (prev.some((p) => p.id === product.id)) {
          showToast('info', `${product.name} removed from wishlist`);
          return prev.filter((p) => p.id !== product.id);
        }
        showToast('success', `${product.name} added to wishlist`);
        return [...prev, product];
      });
    },
    [showToast]
  );

  const removeFromWishlist = useCallback(
    (productId: string) => {
      setWishlist((prev) => prev.filter((p) => p.id !== productId));
    },
    []
  );

  const cartCount = cart.reduce((sum, item) => sum + item.quantity, 0);
  const cartSubtotal = cart.reduce(
    (sum, item) => sum + item.product.price * item.quantity,
    0
  );

  const value: ShopContextValue = {
    cart,
    wishlist,
    cartCount,
    wishlistCount: wishlist.length,
    cartSubtotal,
    addToCart,
    removeFromCart,
    updateQuantity,
    clearCart,
    isInWishlist,
    toggleWishlist,
    removeFromWishlist,
    toasts,
    showToast,
    dismissToast,
  };

  return <ShopContext.Provider value={value}>{children}</ShopContext.Provider>;
}

// eslint-disable-next-line react-refresh/only-export-components
export function useShop() {
  const ctx = useContext(ShopContext);
  if (!ctx) throw new Error('useShop must be used within ShopProvider');
  return ctx;
}
