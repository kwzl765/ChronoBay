import { useState, useRef, useEffect, useMemo } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Search, ShoppingBag, Heart, User, Globe, Menu, LogOut } from 'lucide-react';
import Logo from '@/components/Logo';
import { useShop } from '@/context/ShopContext';
import { useAuth } from '@/context/AuthContext';
import { useSearchProducts, useBrands } from '@/hooks/useCatalogue';

interface MainHeaderProps {
  onOpenMobileNav: () => void;
}

export default function MainHeader({ onOpenMobileNav }: MainHeaderProps) {
  const { cartCount, wishlistCount } = useShop();
  const { user, signOut } = useAuth();
  const navigate = useNavigate();
  const [query, setQuery] = useState('');
  const [showSuggestions, setShowSuggestions] = useState(false);
  const [debouncedQuery, setDebouncedQuery] = useState('');
  const [showAccountMenu, setShowAccountMenu] = useState(false);
  const searchRef = useRef<HTMLDivElement>(null);
  const accountRef = useRef<HTMLDivElement>(null);

  const { data: searchResults } = useSearchProducts(debouncedQuery, 5);
  const { data: allBrands } = useBrands();

  useEffect(() => {
    const t = setTimeout(() => setDebouncedQuery(query.trim()), 300);
    return () => clearTimeout(t);
  }, [query]);

  const suggestions = searchResults ?? [];

  const brandSuggestions = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return [];
    return (allBrands ?? []).filter((b) => b.name.toLowerCase().includes(q)).slice(0, 3);
  }, [allBrands, query]);

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (searchRef.current && !searchRef.current.contains(e.target as Node)) {
        setShowSuggestions(false);
      }
      if (accountRef.current && !accountRef.current.contains(e.target as Node)) {
        setShowAccountMenu(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    if (query.trim()) {
      navigate(`/shop?q=${encodeURIComponent(query.trim())}`);
      setShowSuggestions(false);
    }
  };

  const handleSignOut = async () => {
    await signOut();
    setShowAccountMenu(false);
    navigate('/');
  };

  const userInitial = user?.email?.charAt(0).toUpperCase() ?? 'U';

  return (
    <div className="border-b border-gray-200 bg-white">
      <div className="container-wide flex items-center gap-2 py-3 sm:gap-4 lg:gap-6">
        {/* Mobile menu */}
        <button
          onClick={onOpenMobileNav}
          className="lg:hidden flex h-11 w-11 shrink-0 items-center justify-center rounded text-charcoal hover:bg-gray-100"
          aria-label="Open menu"
        >
          <Menu className="h-6 w-6" />
        </button>

        <Logo className="shrink-0" />

        {/* Search */}
        <div ref={searchRef} className="relative flex-1 max-w-3xl mx-auto hidden md:block">
          <form onSubmit={handleSearch} role="search">
            <div className="relative">
              <Search
                className="absolute left-3.5 top-1/2 -translate-y-1/2 h-5 w-5 text-gray-400"
                aria-hidden="true"
              />
              <input
                type="search"
                value={query}
                onChange={(e) => {
                  setQuery(e.target.value);
                  setShowSuggestions(true);
                }}
                onFocus={() => setShowSuggestions(true)}
                placeholder="Search for watches, brands, collections..."
                className="w-full rounded border border-gray-300 bg-gray-50 pl-11 pr-4 py-2.5 text-sm text-charcoal placeholder:text-gray-400 transition-colors focus:border-accent focus:bg-white focus:ring-1 focus:ring-accent/20"
                aria-label="Search products"
              />
            </div>
          </form>

          {/* Suggestions */}
          {showSuggestions && (suggestions.length > 0 || brandSuggestions.length > 0) && (
            <div className="absolute top-full left-0 right-0 z-50 mt-px rounded border border-gray-200 bg-white shadow-card-hover animate-fadeIn">
              {brandSuggestions.length > 0 && (
                <div className="border-b border-gray-100 p-2">
                  <p className="px-3 py-1 text-xs font-semibold uppercase text-gray-400">Brands</p>
                  {brandSuggestions.map((b) => (
                    <Link
                      key={b.slug}
                      to={`/brands/${b.slug}`}
                      onClick={() => setShowSuggestions(false)}
                      className="flex items-center gap-2 rounded px-3 py-2 text-sm text-charcoal hover:bg-gray-50"
                    >
                      <Globe className="h-4 w-4 text-accent" aria-hidden="true" />
                      {b.name}
                    </Link>
                  ))}
                </div>
              )}
              {suggestions.length > 0 && (
                <div className="p-2">
                  <p className="px-3 py-1 text-xs font-semibold uppercase text-gray-400">Products</p>
                  {suggestions.map((p) => (
                    <Link
                      key={p.id}
                      to={`/product/${p.slug}`}
                      onClick={() => setShowSuggestions(false)}
                      className="flex items-center gap-3 rounded px-3 py-2 hover:bg-gray-50"
                    >
                      <img
                        src={p.image}
                        alt=""
                        className="h-10 w-10 rounded object-cover"
                        loading="lazy"
                      />
                      <div className="min-w-0 flex-1">
                        <p className="truncate text-sm font-medium text-charcoal">{p.name}</p>
                        <p className="text-xs text-gray-400">{p.brand}</p>
                      </div>
                      <span className="text-sm font-semibold text-accent">
                        {new Intl.NumberFormat('en-US').format(p.price)} MMK
                      </span>
                    </Link>
                  ))}
                </div>
              )}
            </div>
          )}
        </div>

        {/* Icons */}
        <div className="flex items-center gap-0.5 sm:gap-1 ml-auto">
          <Link
            to="/wishlist"
            className="relative flex h-11 w-11 shrink-0 items-center justify-center rounded text-charcoal hover:bg-gray-100 transition-colors"
            aria-label={`Wishlist, ${wishlistCount} items`}
          >
            <Heart className="h-5 w-5" />
            {wishlistCount > 0 && (
              <span className="absolute -right-0.5 -top-0.5 flex h-5 min-w-[20px] items-center justify-center rounded-full bg-accent px-1 text-[10px] font-bold text-white">
                {wishlistCount}
              </span>
            )}
          </Link>
          <Link
            to="/cart"
            className="relative flex h-11 w-11 shrink-0 items-center justify-center rounded text-charcoal hover:bg-gray-100 transition-colors"
            aria-label={`Cart, ${cartCount} items`}
          >
            <ShoppingBag className="h-5 w-5" />
            {cartCount > 0 && (
              <span className="absolute -right-0.5 -top-0.5 flex h-5 min-w-[20px] items-center justify-center rounded-full bg-accent px-1 text-[10px] font-bold text-white">
                {cartCount}
              </span>
            )}
          </Link>

          {/* Account: logged-in shows dropdown, logged-out shows login link */}
          {user ? (
            <div ref={accountRef} className="relative hidden sm:block">
              <button
                onClick={() => setShowAccountMenu(!showAccountMenu)}
                className="flex h-11 w-11 shrink-0 items-center justify-center rounded text-charcoal hover:bg-gray-100 transition-colors"
                aria-label="Account menu"
                aria-expanded={showAccountMenu}
              >
                <span className="flex h-7 w-7 items-center justify-center rounded-full bg-accent text-xs font-bold text-white">
                  {userInitial}
                </span>
              </button>
              {showAccountMenu && (
                <div className="absolute right-0 top-full z-50 mt-px w-56 rounded border border-gray-200 bg-white shadow-card-hover animate-fadeIn">
                  <div className="border-b border-gray-100 px-4 py-3">
                    <p className="text-xs text-gray-400">Signed in as</p>
                    <p className="mt-0.5 truncate text-sm font-medium text-charcoal">{user.email}</p>
                  </div>
                  <button
                    onClick={handleSignOut}
                    className="flex w-full items-center gap-2 px-4 py-3 text-sm text-charcoal hover:bg-gray-50"
                  >
                    <LogOut className="h-4 w-4 text-gray-400" />
                    Sign Out
                  </button>
                </div>
              )}
            </div>
          ) : (
            <Link
              to="/login"
              className="hidden h-11 w-11 shrink-0 items-center justify-center rounded text-charcoal hover:bg-gray-100 transition-colors sm:flex"
              aria-label="Sign in"
            >
              <User className="h-5 w-5" />
            </Link>
          )}

          <button
            className="hidden lg:flex h-11 items-center gap-1.5 rounded px-2 text-sm text-charcoal hover:bg-gray-100 transition-colors"
            aria-label="Select language"
          >
            <Globe className="h-5 w-5" />
            <span className="font-medium">EN</span>
          </button>
        </div>
      </div>

      {/* Mobile search */}
      <div className="container-wide pb-3 md:hidden">
        <form onSubmit={handleSearch} role="search">
          <div className="relative">
            <Search
              className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-gray-400"
              aria-hidden="true"
            />
            <input
              type="search"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Search watches..."
              className="w-full rounded border border-gray-300 bg-gray-50 pl-10 pr-4 py-2.5 text-sm placeholder:text-gray-400 focus:border-accent focus:bg-white"
              aria-label="Search products"
            />
          </div>
        </form>
      </div>
    </div>
  );
}
