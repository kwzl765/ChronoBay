export interface Product {
  id: string;
  slug: string;
  name: string;
  brand: string;
  brandSlug: string;
  category: CategorySlug;
  gender: 'Men' | 'Women' | 'Unisex';
  movement: 'Automatic' | 'Quartz' | 'Solar' | 'Mechanical';
  price: number;
  originalPrice?: number;
  image: string;
  gallery: string[];
  description: string;
  specifications: Record<string, string>;
  rating: number;
  reviewCount: number;
  stock: number;
  featured: boolean;
  newArrival: boolean;
}

export type CategorySlug =
  | 'men'
  | 'women'
  | 'smart-watches'
  | 'clocks';

export interface Category {
  slug: CategorySlug;
  name: string;
  description: string;
  image: string;
}

export interface Brand {
  name: string;
  slug: string;
  description: string;
  logo: string;
  banner?: string;
  visualFamily?: string;
  featured?: boolean;
}

export interface CartItem {
  product: Product;
  quantity: number;
}

export interface ToastMessage {
  id: string;
  type: 'success' | 'error' | 'info';
  message: string;
}

export interface Filters {
  categories: CategorySlug[];
  brands: string[];
  genders: string[];
  movements: string[];
  minPrice: number | null;
  maxPrice: number | null;
  search: string;
  sort: 'newest' | 'price-asc' | 'price-desc' | 'popularity';
}
