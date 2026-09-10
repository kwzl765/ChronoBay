export type VisualFamily = 'luxury' | 'fashion' | 'sport' | 'classic' | 'digital' | 'gift';

export interface BrandData {
  id: string;
  name: string;
  slug: string;
  logo: string;
  banner: string;
  visualFamily: VisualFamily;
  description: string;
  featured: boolean;
}

export const brandsData: BrandData[] = [
  {
    id: 'alexandre-christie',
    name: 'Alexandre Christie',
    slug: 'alexandre-christie',
    logo: '/brands/alexandre-christie/logo.svg',
    banner: '/brands/alexandre-christie/alexandre-christie-banner.jpg',
    visualFamily: 'fashion',
    description: 'Brazilian-inspired timepieces blending contemporary design with accessible luxury for the modern lifestyle.',
    featured: true,
  },
  {
    id: 'armani-exchange',
    name: 'Armani Exchange',
    slug: 'armani-exchange',
    logo: '/brands/armani-exchange/logo.svg',
    banner: '/brands/armani-exchange/armani-exchange-banner.jpg',
    visualFamily: 'fashion',
    description: 'Urban, youthful watches from the Armani Exchange line — bold aesthetics for a fashion-forward generation.',
    featured: false,
  },
  {
    id: 'baby-g',
    name: 'Baby-G',
    slug: 'baby-g',
    logo: '/brands/baby-g/logo.svg',
    banner: '/brands/baby-g/baby-g-banner.jpg',
    visualFamily: 'sport',
    description: 'Compact shock-resistant watches designed for active women. Tough protection meets playful styling.',
    featured: false,
  },
  {
    id: 'boss',
    name: 'BOSS',
    slug: 'boss',
    logo: '/brands/boss/logo.svg',
    banner: '/brands/boss/boss-banner.jpg',
    visualFamily: 'fashion',
    description: 'Precision-crafted watches from Hugo Boss — clean lines and refined materials for the modern professional.',
    featured: false,
  },
  {
    id: 'calvin-klein',
    name: 'Calvin Klein',
    slug: 'calvin-klein',
    logo: '/brands/calvin-klein/logo.svg',
    banner: '/brands/calvin-klein/banner.svg',
    visualFamily: 'fashion',
    description: 'Minimalist watches with a bold attitude. Calvin Klein timepieces embody modern American minimalism.',
    featured: false,
  },
  {
    id: 'casio',
    name: 'CASIO',
    slug: 'casio',
    logo: '/brands/casio/logo.svg',
    banner: '/brands/casio/banner.svg',
    visualFamily: 'digital',
    description: 'Innovative, reliable timepieces for every lifestyle. From classic digitals to advanced solar technology.',
    featured: true,
  },
  {
    id: 'dennis-martin',
    name: 'Dennis Martin',
    slug: 'dennis-martin',
    logo: '/brands/dennis-martin/logo.svg',
    banner: '/brands/dennis-martin/banner.svg',
    visualFamily: 'classic',
    description: 'Affordable elegance with European-inspired designs. Dennis Martin delivers quality craftsmanship at accessible prices.',
    featured: false,
  },
  {
    id: 'diesel',
    name: 'Diesel',
    slug: 'diesel',
    logo: '/brands/diesel/logo.svg',
    banner: '/brands/diesel/banner.svg',
    visualFamily: 'fashion',
    description: 'Bold, oversized watches with industrial attitude. Diesel makes statements that refuse to be ignored.',
    featured: false,
  },
  {
    id: 'edifice',
    name: 'Edifice',
    slug: 'edifice',
    logo: '/brands/edifice/logo.svg',
    banner: '/brands/edifice/banner.svg',
    visualFamily: 'classic',
    description: 'Sophisticated chronographs with stainless steel construction. Edifice pairs precision engineering with refined style.',
    featured: false,
  },
  {
    id: 'elle',
    name: 'Elle',
    slug: 'elle',
    logo: '/brands/elle/logo.svg',
    banner: '/brands/elle/banner.svg',
    visualFamily: 'fashion',
    description: 'Elegant watches inspired by the iconic fashion magazine. Elle timepieces celebrate feminine sophistication.',
    featured: false,
  },
  {
    id: 'emporio-armani',
    name: 'Emporio Armani',
    slug: 'emporio-armani',
    logo: '/brands/emporio-armani/logo.svg',
    banner: '/brands/emporio-armani/banner.svg',
    visualFamily: 'fashion',
    description: 'Timeless Italian design with contemporary appeal. Emporio Armani watches define understated luxury.',
    featured: true,
  },
  {
    id: 'fossil',
    name: 'Fossil',
    slug: 'fossil',
    logo: '/brands/fossil/logo.svg',
    banner: '/brands/fossil/banner.svg',
    visualFamily: 'classic',
    description: 'Vintage-inspired watches with modern functionality. Fossil blends authentic design with smart technology.',
    featured: true,
  },
  {
    id: 'fuji',
    name: 'Fuji',
    slug: 'fuji',
    logo: '/brands/fuji/logo.svg',
    banner: '/brands/fuji/banner.svg',
    visualFamily: 'classic',
    description: 'Reliable timepieces with clean aesthetics. Fuji watches offer everyday value without compromising on style.',
    featured: false,
  },
  {
    id: 'gift-card',
    name: 'Gift Card',
    slug: 'gift-card',
    logo: '/brands/gift-card/logo.svg',
    banner: '/brands/gift-card/banner.svg',
    visualFamily: 'gift',
    description: 'The perfect present for any occasion. ChronoBay gift cards let your loved ones choose their ideal timepiece.',
    featured: false,
  },
  {
    id: 'g-shock-myanmar',
    name: 'G-SHOCK Myanmar',
    slug: 'g-shock-myanmar',
    logo: '/brands/g-shock-myanmar/logo.svg',
    banner: '/brands/g-shock-myanmar/banner.svg',
    visualFamily: 'sport',
    description: 'The toughest watches on the planet, built to survive the most extreme conditions. Shock-resistant and uncompromising.',
    featured: true,
  },
  {
    id: 'guess',
    name: 'GUESS',
    slug: 'guess',
    logo: '/brands/guess/logo.svg',
    banner: '/brands/guess/banner.svg',
    visualFamily: 'fashion',
    description: 'Trendy, youthful watches with bold designs. GUESS brings runway-inspired style to your wrist.',
    featured: false,
  },
  {
    id: 'haofa',
    name: 'Haofa',
    slug: 'haofa',
    logo: '/brands/haofa/logo.svg',
    banner: '/brands/haofa/banner.svg',
    visualFamily: 'classic',
    description: 'Quality timepieces with a focus on durability and value. Haofa delivers dependable performance for daily wear.',
    featured: false,
  },
  {
    id: 'm-cavo',
    name: 'M.Cavo',
    slug: 'm-cavo',
    logo: '/brands/m-cavo/logo.svg',
    banner: '/brands/m-cavo/banner.svg',
    visualFamily: 'fashion',
    description: 'Contemporary designs with a distinctive European flair. M.Cavo creates watches for the style-conscious individual.',
    featured: false,
  },
  {
    id: 'michael-kors',
    name: 'Michael Kors',
    slug: 'michael-kors',
    logo: '/brands/michael-kors/logo.svg',
    banner: '/brands/michael-kors/banner.svg',
    visualFamily: 'fashion',
    description: 'Glamorous, jet-set inspired timepieces. Michael Kors watches bring luxury lifestyle appeal to every outfit.',
    featured: true,
  },
  {
    id: 'microwear',
    name: 'Microwear',
    slug: 'microwear',
    logo: '/brands/microwear/logo.svg',
    banner: '/brands/microwear/banner.svg',
    visualFamily: 'digital',
    description: 'Affordable smartwatches with fitness tracking and connected features. Microwear makes wearable tech accessible.',
    featured: false,
  },
  {
    id: 'microwear-strap',
    name: 'Microwear Strap',
    slug: 'microwear-strap',
    logo: '/brands/microwear-strap/logo.svg',
    banner: '/brands/microwear-strap/banner.svg',
    visualFamily: 'digital',
    description: 'Replacement straps and accessories for Microwear smartwatches. Customize your wearable to match your style.',
    featured: false,
  },
  {
    id: 'minber',
    name: 'Minber',
    slug: 'minber',
    logo: '/brands/minber/logo.svg',
    banner: '/brands/minber/banner.svg',
    visualFamily: 'classic',
    description: 'Crafted timepieces with attention to detail and quality materials. Minber offers enduring style at fair value.',
    featured: false,
  },
  {
    id: 'orient',
    name: 'Orient',
    slug: 'orient',
    logo: '/brands/orient/logo.svg',
    banner: '/brands/orient/banner.svg',
    visualFamily: 'classic',
    description: 'Japanese mechanical watchmaking since 1950. Orient delivers in-house automatic movements with exceptional value.',
    featured: true,
  },
  {
    id: 'rhythm',
    name: 'Rhythm',
    slug: 'rhythm',
    logo: '/brands/rhythm/logo.svg',
    banner: '/brands/rhythm/banner.svg',
    visualFamily: 'classic',
    description: 'Precision clocks and timepieces from Japan. Rhythm combines innovative movement technology with elegant design.',
    featured: false,
  },
  {
    id: 'romanson',
    name: 'Romanson',
    slug: 'romanson',
    logo: '/brands/romanson/logo.svg',
    banner: '/brands/romanson/banner.svg',
    visualFamily: 'classic',
    description: 'Korean watchmaking with a focus on elegant design and reliable movements. Romanson offers timeless appeal.',
    featured: false,
  },
  {
    id: 'seiko',
    name: 'Seiko',
    slug: 'seiko',
    logo: '/brands/seiko/logo.svg',
    banner: '/brands/seiko/banner.svg',
    visualFamily: 'luxury',
    description: 'A pioneer of Japanese watchmaking since 1881. Seiko crafts timepieces that blend innovation with century-old heritage.',
    featured: true,
  },
  {
    id: 'sheen',
    name: 'Sheen',
    slug: 'sheen',
    logo: '/brands/sheen/logo.svg',
    banner: '/brands/sheen/banner.svg',
    visualFamily: 'fashion',
    description: 'Radiant watches designed for women. Sheen combines crystal accents with refined dials for effortless elegance.',
    featured: false,
  },
  {
    id: 'skagen',
    name: 'SKAGEN',
    slug: 'skagen',
    logo: '/brands/skagen/logo.svg',
    banner: '/brands/skagen/banner.svg',
    visualFamily: 'fashion',
    description: 'Danish minimalist design at its finest. SKAGEN watches are slim, sleek, and inspired by the coastal town of Skagen.',
    featured: false,
  },
  {
    id: 'tommy-hilfiger',
    name: 'Tommy Hilfiger',
    slug: 'tommy-hilfiger',
    logo: '/brands/tommy-hilfiger/logo.svg',
    banner: '/brands/tommy-hilfiger/tommy-hilfiger-banner.jpg',
    visualFamily: 'fashion',
    description: 'Classic American cool with a preppy twist. Tommy Hilfiger watches bring iconic style to everyday wear.',
    featured: false,
  },
];

export const visualFamilyLabels: Record<VisualFamily, string> = {
  luxury: 'Luxury',
  fashion: 'Fashion',
  sport: 'Sport',
  classic: 'Classic',
  digital: 'Digital',
  gift: 'Gift',
};

export const visualFamilyOrder: VisualFamily[] = [
  'luxury',
  'fashion',
  'sport',
  'classic',
  'digital',
  'gift',
];

export const getBrandBySlug = (slug: string): BrandData | undefined =>
  brandsData.find((b) => b.slug === slug);

export const getFeaturedBrands = (): BrandData[] =>
  brandsData.filter((b) => b.featured);

export const getBrandsByFamily = (family: VisualFamily): BrandData[] =>
  brandsData.filter((b) => b.visualFamily === family);

export const getRelatedBrands = (brand: BrandData, limit = 4): BrandData[] =>
  brandsData
    .filter((b) => b.slug !== brand.slug && b.visualFamily === brand.visualFamily)
    .slice(0, limit);

export const popularNavBrands = [
  'casio',
  'g-shock-myanmar',
  'seiko',
  'orient',
  'fossil',
  'michael-kors',
  'alexandre-christie',
];

export const homepageFeaturedBrandSlugs = [
  'casio',
  'g-shock-myanmar',
  'seiko',
  'orient',
  'alexandre-christie',
  'fossil',
  'michael-kors',
  'emporio-armani',
];

export const getPopularNavBrands = (): BrandData[] =>
  popularNavBrands
    .map((slug) => getBrandBySlug(slug))
    .filter((b): b is BrandData => b !== undefined);

export const getHomepageFeaturedBrands = (): BrandData[] =>
  homepageFeaturedBrandSlugs
    .map((slug) => getBrandBySlug(slug))
    .filter((b): b is BrandData => b !== undefined);
