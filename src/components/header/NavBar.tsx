import { useState, useRef, useEffect } from 'react';
import { Link, NavLink } from 'react-router-dom';
import { ChevronDown, X, Home, Watch, Sparkles, Clock, Building2, BookOpen, MoreHorizontal } from 'lucide-react';
import { getPopularNavBrands } from '@/data/brands';
import { useCategories } from '@/hooks/useCatalogue';
import { useAuth } from '@/context/AuthContext';

interface NavBarProps {
  open: boolean;
  onClose: () => void;
}

interface DropdownItem {
  label: string;
  to: string;
  description?: string;
}

const menDropdown: DropdownItem[] = [
  { label: 'All Men\'s Watches', to: '/category/men', description: 'Browse every men\'s timepiece' },
  { label: 'Automatic', to: '/shop?genders=Men&movements=Automatic' },
  { label: 'Chronograph', to: '/shop?genders=Men' },
  { label: 'Diver', to: '/shop?genders=Men' },
];

const womenDropdown: DropdownItem[] = [
  { label: 'All Women\'s Watches', to: '/category/women', description: 'Browse every women\'s timepiece' },
  { label: 'Automatic', to: '/shop?genders=Women&movements=Automatic' },
  { label: 'Diamond Accent', to: '/shop?genders=Women' },
  { label: 'Slim & Minimal', to: '/shop?genders=Women' },
];

export default function NavBar({ open, onClose }: NavBarProps) {
  const [openDropdown, setOpenDropdown] = useState<string | null>(null);
  const navRef = useRef<HTMLDivElement>(null);
  const { data: dbCategories } = useCategories();
  const categories = dbCategories ?? [];
  const { user, signOut } = useAuth();

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (navRef.current && !navRef.current.contains(e.target as Node)) {
        setOpenDropdown(null);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  useEffect(() => {
    document.body.style.overflow = open ? 'hidden' : '';
    return () => {
      document.body.style.overflow = '';
    };
  }, [open]);

  const brandDropdown: DropdownItem[] = [
    ...getPopularNavBrands().map((b) => ({
      label: b.name,
      to: `/brands/${b.slug}`,
      description: b.description,
    })),
    { label: 'View All Brands', to: '/brands', description: 'Browse all 29 brands' },
  ];

  const handleSignOut = async () => {
    await signOut();
    onClose();
  };

  const moreDropdown: DropdownItem[] = user
    ? [
        { label: 'About Us', to: '/about', description: 'Our story and mission' },
        { label: 'Contact', to: '/contact', description: 'Get in touch with our team' },
        { label: 'Blog', to: '/blog', description: 'Watch guides and news' },
        { label: 'Sign Out', to: '#signout', description: user.email ?? '' },
      ]
    : [
        { label: 'About Us', to: '/about', description: 'Our story and mission' },
        { label: 'Contact', to: '/contact', description: 'Get in touch with our team' },
        { label: 'Blog', to: '/blog', description: 'Watch guides and news' },
        { label: 'Login', to: '/login', description: 'Sign in to your account' },
      ];

  const navItems: {
    label: string;
    to: string;
    dropdown?: DropdownItem[];
    icon: typeof Home;
  }[] = [
    { label: 'Home', to: '/', icon: Home },
    { label: 'Men', to: '/category/men', dropdown: menDropdown, icon: Watch },
    { label: 'Women', to: '/category/women', dropdown: womenDropdown, icon: Watch },
    { label: 'Smart Watches', to: '/category/smart-watches', icon: Sparkles },
    { label: 'Clocks', to: '/category/clocks', icon: Clock },
    { label: 'Brands', to: '/brands', dropdown: brandDropdown, icon: Building2 },
    { label: 'Blog', to: '/blog', icon: BookOpen },
    { label: 'More', to: '/about', dropdown: moreDropdown, icon: MoreHorizontal },
  ];

  return (
    <>
      <nav
        ref={navRef}
        className="hidden lg:block border-b border-gray-200 bg-white sticky top-0 z-40"
        aria-label="Main navigation"
      >
        <div className="container-wide">
          <ul className="flex items-center justify-center">
            {navItems.map((item, idx) => (
              <li
                key={item.label}
                className={`relative ${idx > 0 ? 'border-l border-gray-200' : ''}`}
                onMouseEnter={() => item.dropdown && setOpenDropdown(item.label)}
                onMouseLeave={() => setOpenDropdown(null)}
              >
                <NavLink
                  to={item.to}
                  className={({ isActive }) =>
                    `flex items-center gap-1 px-5 py-3.5 text-sm font-medium transition-colors ${
                      isActive ? 'text-accent' : 'text-charcoal hover:text-accent'
                    }`
                  }
                  aria-expanded={item.dropdown ? openDropdown === item.label : undefined}
                  aria-haspopup={item.dropdown ? 'true' : undefined}
                >
                  {item.label}
                  {item.dropdown && (
                    <ChevronDown
                      className={`h-4 w-4 transition-transform ${
                        openDropdown === item.label ? 'rotate-180' : ''
                      }`}
                      aria-hidden="true"
                    />
                  )}
                </NavLink>

                {item.dropdown && openDropdown === item.label && (
                  <div className="absolute left-0 top-full z-50 min-w-[280px] rounded border border-gray-200 bg-white shadow-card-hover animate-fadeIn">
                    <ul className="p-1.5">
                      {item.dropdown.map((drop) => (
                        <li key={drop.to}>
                          <Link
                            to={drop.to}
                            onClick={(e) => {
                              if (drop.to === '#signout') {
                                e.preventDefault();
                                handleSignOut();
                              } else {
                                setOpenDropdown(null);
                              }
                            }}
                            className="block rounded px-3 py-2.5 hover:bg-gray-50"
                          >
                            <span className="block text-sm font-medium text-charcoal">
                              {drop.label}
                            </span>
                            {drop.description && (
                              <span className="block text-xs text-gray-400 mt-0.5">
                                {drop.description}
                              </span>
                            )}
                          </Link>
                        </li>
                      ))}
                    </ul>
                  </div>
                )}
              </li>
            ))}
          </ul>
        </div>
      </nav>

      {/* Mobile drawer */}
      {open && (
        <div className="lg:hidden fixed inset-0 z-50">
          <div
            className="absolute inset-0 bg-navy-600/50 animate-fadeIn"
            onClick={onClose}
            aria-hidden="true"
          />
          <div className="absolute left-0 top-0 h-full w-[85%] max-w-sm bg-white shadow-2xl animate-slideIn overflow-y-auto">
            <div className="flex items-center justify-between border-b border-gray-200 px-4 py-4">
              <span className="text-lg font-bold text-navy-600">Menu</span>
              <button
                onClick={onClose}
                className="flex h-11 w-11 items-center justify-center rounded text-charcoal hover:bg-gray-100"
                aria-label="Close menu"
              >
                <X className="h-6 w-6" />
              </button>
            </div>
            <ul className="p-2">
              {navItems.map((item) => (
                <li key={item.label} className="border-b border-gray-100 last:border-0">
                  {item.dropdown ? (
                    <MobileDropdownItem item={item} onClose={onClose} onSignOut={handleSignOut} />
                  ) : (
                    <Link
                      to={item.to}
                      onClick={onClose}
                      className="flex items-center gap-3 px-3 py-3.5 text-sm font-medium text-charcoal hover:bg-gray-50"
                    >
                      <item.icon className="h-5 w-5 text-accent" aria-hidden="true" />
                      {item.label}
                    </Link>
                  )}
                </li>
              ))}
            </ul>
            <div className="p-4 border-t border-gray-200">
              <p className="text-xs font-semibold uppercase tracking-wider text-gray-400 mb-3">
                Popular Categories
              </p>
              <div className="flex flex-wrap gap-2">
                {categories.map((c) => (
                  <Link
                    key={c.slug}
                    to={`/category/${c.slug}`}
                    onClick={onClose}
                    className="rounded bg-gray-100 px-3 py-1.5 text-xs font-medium text-charcoal hover:bg-accent hover:text-white"
                  >
                    {c.name}
                  </Link>
                ))}
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
}

function MobileDropdownItem({
  item,
  onClose,
  onSignOut,
}: {
  item: { label: string; to: string; dropdown?: DropdownItem[]; icon: typeof Home };
  onClose: () => void;
  onSignOut: () => void;
}) {
  const [expanded, setExpanded] = useState(false);

  return (
    <>
      <button
        onClick={() => setExpanded(!expanded)}
        className="flex w-full items-center justify-between px-3 py-3.5 text-sm font-medium text-charcoal hover:bg-gray-50"
        aria-expanded={expanded}
      >
        <span className="flex items-center gap-3">
          <item.icon className="h-5 w-5 text-accent" aria-hidden="true" />
          {item.label}
        </span>
        <ChevronDown
          className={`h-4 w-4 transition-transform ${expanded ? 'rotate-180' : ''}`}
          aria-hidden="true"
        />
      </button>
      {expanded && item.dropdown && (
        <ul className="pb-2 pl-11">
          {item.dropdown.map((drop) => (
            <li key={drop.to}>
              <Link
                to={drop.to}
                onClick={(e) => {
                  if (drop.to === '#signout') {
                    e.preventDefault();
                    onSignOut();
                  } else {
                    onClose();
                  }
                }}
                className="block px-3 py-2.5 text-sm text-gray-600 hover:text-accent"
              >
                {drop.label}
              </Link>
            </li>
          ))}
        </ul>
      )}
    </>
  );
}
