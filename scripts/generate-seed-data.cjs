const fs = require('fs');
const path = require('path');
const csv = require('csv-parser');

const DATA_DIR = path.join(__dirname, '..', 'public', 'data', 'product-specs');

const csvFiles = [
  { file: 'casio/(_Casio_)_Product_Specification_for_website_upgrade_(1.Sep.2026).csv', brandSlug: 'casio' },
  { file: 'baby-g/(_Baby-G)_Product_Specification_for_website_upgrade_(1.Sep.2026).csv', brandSlug: 'baby-g' },
  { file: 'alexandre-christie/(AC)_Product_Specification_for_website_upgrade_(1.Sep.2026).csv', brandSlug: 'alexandre-christie' },
  { file: 'mw-brand/(_MW_Brand_)Product_Specification_for_website_upgrade_(1.Sep.2026).csv', brandSlug: 'microwear' },
];

const brandDefs = [
  { slug: 'alexandre-christie', name: 'Alexandre Christie', logo: '/brands/alexandre-christie/logo.svg', banner: '/brands/alexandre-christie/alexandre-christie-banner.jpg', visualFamily: 'fashion', description: 'Brazilian-inspired timepieces blending contemporary design with accessible luxury for the modern lifestyle.', featured: true, sortOrder: 1 },
  { slug: 'baby-g', name: 'Baby-G', logo: '/brands/baby-g/logo.svg', banner: '/brands/baby-g/baby-g-banner.jpg', visualFamily: 'sport', description: 'Compact shock-resistant watches designed for active women. Tough protection meets playful styling.', featured: false, sortOrder: 2 },
  { slug: 'casio', name: 'CASIO', logo: '/brands/casio/logo.svg', banner: '/brands/casio/banner.svg', visualFamily: 'digital', description: 'Innovative, reliable timepieces for every lifestyle. From classic digitals to advanced solar technology.', featured: true, sortOrder: 3 },
  { slug: 'microwear', name: 'Microwear', logo: '/brands/microwear/logo.svg', banner: '/brands/microwear/banner.svg', visualFamily: 'digital', description: 'Affordable smartwatches with fitness tracking and connected features. Microwear makes wearable tech accessible.', featured: false, sortOrder: 4 },
];

const categoryDefs = [
  { slug: 'men', name: 'Men', description: 'Precision-engineered timepieces crafted for the modern gentleman.', image: 'https://images.pexels.com/photos/12835320/pexels-photo-12835320.jpeg?auto=compress&cs=tinysrgb&w=900', sortOrder: 1 },
  { slug: 'women', name: 'Women', description: 'Elegant watches that blend sophistication with timeless design.', image: 'https://images.pexels.com/photos/15210883/pexels-photo-15210883.jpeg?auto=compress&cs=tinysrgb&w=900', sortOrder: 2 },
  { slug: 'smart-watches', name: 'Smart Watches', description: 'Connected wearables that keep you in sync with every moment.', image: 'https://images.pexels.com/photos/18662969/pexels-photo-18662969.jpeg?auto=compress&cs=tinysrgb&w=900', sortOrder: 3 },
  { slug: 'clocks', name: 'Clocks', description: 'Statement wall clocks for homes and offices that command attention.', image: 'https://images.pexels.com/photos/14976142/pexels-photo-14976142.jpeg?auto=compress&cs=tinysrgb&w=900', sortOrder: 4 },
];

const brandImageMap = {
  'casio': [
    'https://images.pexels.com/photos/8839887/pexels-photo-8839887.jpeg?auto=compress&cs=tinysrgb&w=900',
    'https://images.pexels.com/photos/16958879/pexels-photo-16958879.jpeg?auto=compress&cs=tinysrgb&w=900',
    'https://images.pexels.com/photos/12835320/pexels-photo-12835320.jpeg?auto=compress&cs=tinysrgb&w=900',
    'https://images.pexels.com/photos/267391/pexels-photo-267391.jpeg?auto=compress&cs=tinysrgb&w=900',
  ],
  'baby-g': [
    'https://images.pexels.com/photos/9561297/pexels-photo-9561297.jpeg?auto=compress&cs=tinysrgb&w=900',
    'https://images.pexels.com/photos/9561299/pexels-photo-9561299.jpeg?auto=compress&cs=tinysrgb&w=900',
    'https://images.pexels.com/photos/15210883/pexels-photo-15210883.jpeg?auto=compress&cs=tinysrgb&w=900',
  ],
  'alexandre-christie': [
    'https://images.pexels.com/photos/6157408/pexels-photo-6157408.jpeg?auto=compress&cs=tinysrgb&w=900',
    'https://images.pexels.com/photos/14312717/pexels-photo-14312717.jpeg?auto=compress&cs=tinysrgb&w=900',
    'https://images.pexels.com/photos/9561299/pexels-photo-9561299.jpeg?auto=compress&cs=tinysrgb&w=900',
    'https://images.pexels.com/photos/9261531/pexels-photo-9261531.jpeg?auto=compress&cs=tinysrgb&w=900',
  ],
  'microwear': [
    'https://images.pexels.com/photos/267391/pexels-photo-267391.jpeg?auto=compress&cs=tinysrgb&w=900',
    'https://images.pexels.com/photos/374673/pexels-photo-374673.jpeg?auto=compress&cs=tinysrgb&w=900',
    'https://images.pexels.com/photos/18662969/pexels-photo-18662969.jpeg?auto=compress&cs=tinysrgb&w=900',
    'https://images.pexels.com/photos/374619/pexels-photo-374619.jpeg?auto=compress&cs=tinysrgb&w=900',
    'https://images.pexels.com/photos/1080745/pexels-photo-1080745.jpeg?auto=compress&cs=tinysrgb&w=900',
  ],
};

const brandPriceRanges = {
  'casio': { min: 75000, max: 320000 },
  'baby-g': { min: 120000, max: 280000 },
  'alexandre-christie': { min: 85000, max: 350000 },
  'microwear': { min: 95000, max: 250000 },
};

function cleanStr(str) {
  if (!str) return '';
  return str.toString().trim().replace(/\s+/g, ' ');
}

function slugify(str) {
  return str.toString().toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .replace(/-+/g, '-');
}

function normalizeGender(gender) {
  const g = cleanStr(gender).toLowerCase();
  if (g === 'men' || g === 'men/women' || g === 'unisex') return 'Unisex';
  if (g === 'women') return 'Women';
  return 'Men';
}

function normalizeMovement(movement, category) {
  const m = cleanStr(movement).toLowerCase();
  if (m.includes('solar')) return 'Solar';
  if (m.includes('automatic') || m.includes('mechanical')) return 'Automatic';
  return 'Quartz';
}

function getCategory(gender, category) {
  const cat = cleanStr(category).toLowerCase();
  if (cat.includes('smart')) return 'smart-watches';
  if (cat.includes('clock')) return 'clocks';
  const g = cleanStr(gender).toLowerCase();
  if (g === 'women') return 'women';
  return 'men';
}

function pseudoRandom(seed) {
  let h = 2166136261;
  for (let i = 0; i < seed.length; i++) {
    h = Math.imul(h ^ seed.charCodeAt(i), 16777619);
  }
  return ((h >>> 0) % 10000) / 10000;
}

function generatePrice(brandSlug, sku) {
  const range = brandPriceRanges[brandSlug] || { min: 80000, max: 300000 };
  const r = pseudoRandom(sku);
  return Math.round((range.min + r * (range.max - range.min)) / 1000) * 1000;
}

function generateOriginalPrice(price, sku) {
  const r = pseudoRandom(sku + 'orig');
  if (r < 0.3) return null;
  return Math.round((price * (1.1 + r * 0.2)) / 1000) * 1000;
}

function generateRating(sku) {
  const r = pseudoRandom(sku + 'rating');
  return Math.round((3.8 + r * 1.1) * 10) / 10;
}

function generateReviewCount(sku) {
  const r = pseudoRandom(sku + 'reviews');
  return Math.floor(r * 200) + 5;
}

function generateStock(sku) {
  const r = pseudoRandom(sku + 'stock');
  return Math.floor(r * 30) + 3;
}

function parseCsv(filePath) {
  return new Promise((resolve) => {
    const results = [];
    if (!fs.existsSync(filePath)) { resolve(results); return; }
    const stat = fs.statSync(filePath);
    if (stat.size === 0) { resolve(results); return; }
    fs.createReadStream(filePath)
      .pipe(csv())
      .on('data', (data) => results.push(data))
      .on('end', () => resolve(results))
      .on('error', () => resolve(results));
  });
}

async function main() {
  const allProducts = [];
  const seenSkus = new Set();

  for (const cfg of csvFiles) {
    const fullPath = path.join(DATA_DIR, cfg.file);
    const rows = await parseCsv(fullPath);
    for (const row of rows) {
      const sku = cleanStr(row.Product || row.product);
      if (!sku || seenSkus.has(sku)) continue;
      seenSkus.add(sku);

      const brand = cleanStr(row.Brand);
      const gender = cleanStr(row.Gender);
      const category = cleanStr(row.Category);
      const movement = cleanStr(row['Movement Type'] || row.Movement || '');
      const caseMaterial = cleanStr(row['Case Material'] || '');
      const caseSize = cleanStr(row['Case Size'] || row.Size || '');
      const caseThickness = cleanStr(row['Case Thickness'] || '');
      const dialColor = cleanStr(row['Dial Color'] || row.Color || '');
      const glass = cleanStr(row.Glass || '');
      const bandMaterial = cleanStr(row['Band Material'] || '');
      const bandColor = cleanStr(row['Band Color'] || '');
      const buckle = cleanStr(row.Buckle || '');
      const waterResistance = cleanStr(row['Water Resistance'] || '');
      const batteryLife = cleanStr(row['Battery Life'] || row.Battery || row['Battery Life '] || '');
      const otherSpecs = cleanStr(row['Other Specs'] || row['Designation'] || '');
      const display = cleanStr(row.Display || '');
      const phoneCall = cleanStr(row['Phone Call & Received'] || '');
      const notifications = cleanStr(row.Notifications || '');
      const heartRate = cleanStr(row['Heart Rate'] || '');
      const bloodPressure = cleanStr(row['Blood Pressure'] || '');
      const bloodOxygen = cleanStr(row['Blood Oxygen'] || '');
      const bluetooth = cleanStr(row.Bluetooth || '');

      const brandSlug = cfg.brandSlug;
      const catSlug = getCategory(gender, category);
      const normGender = normalizeGender(gender);
      const normMovement = normalizeMovement(movement, category);

      const descParts = [];
      descParts.push(`The ${sku} by ${brand} is a ${normGender.toLowerCase()}'s ${cleanStr(category).toLowerCase()}.`);
      if (caseMaterial) descParts.push(`Featuring a ${caseMaterial.toLowerCase()} case with a ${dialColor.toLowerCase()} dial.`);
      if (glass) descParts.push(`Protected by ${glass.toLowerCase()}.`);
      if (bandMaterial) descParts.push(`Finished with a ${bandMaterial.toLowerCase()} band in ${bandColor.toLowerCase()}.`);
      if (waterResistance) descParts.push(`Water resistance: ${waterResistance}.`);
      if (batteryLife) descParts.push(`${batteryLife}.`);
      const description = descParts.join(' ');

      const specs = {};
      if (caseMaterial) specs['Case Material'] = caseMaterial;
      if (caseSize) specs['Case Size'] = caseSize;
      if (caseThickness) specs['Case Thickness'] = caseThickness;
      if (dialColor) specs['Dial Color'] = dialColor;
      if (glass) specs['Glass'] = glass;
      if (bandMaterial) specs['Band Material'] = bandMaterial;
      if (bandColor) specs['Band Color'] = bandColor;
      if (buckle) specs['Buckle'] = buckle;
      if (waterResistance) specs['Water Resistance'] = waterResistance;
      if (batteryLife) specs['Battery'] = batteryLife;
      if (movement) specs['Movement'] = movement;
      if (display) specs['Display'] = display;
      if (phoneCall) specs['Phone Call'] = phoneCall;
      if (notifications) specs['Notifications'] = notifications;
      if (heartRate) specs['Heart Rate'] = heartRate;
      if (bloodPressure) specs['Blood Pressure'] = bloodPressure;
      if (bloodOxygen) specs['Blood Oxygen'] = bloodOxygen;
      if (bluetooth) specs['Bluetooth'] = bluetooth;
      if (otherSpecs) specs['Other'] = otherSpecs;

      const price = generatePrice(brandSlug, sku);
      const originalPrice = generateOriginalPrice(price, sku);
      const rating = generateRating(sku);
      const reviewCount = generateReviewCount(sku);
      const stock = generateStock(sku);
      const name = `${brand} ${sku}`;
      const slug = slugify(`${brand}-${sku}`);
      const imgPool = brandImageMap[brandSlug];
      const imgIndex = Math.floor(pseudoRandom(sku + 'img') * imgPool.length);
      const mainImage = imgPool[imgIndex];

      allProducts.push({
        sku, brandSlug, brandName: brand, name, slug,
        catSlug, gender: normGender, movement: normMovement,
        description, specs,
        price, originalPrice, rating, reviewCount, stock,
        mainImage,
        caseMaterial, bandMaterial, waterResistance,
      });
    }
  }

  allProducts.sort((a, b) => {
    const brandOrder = { 'alexandre-christie': 0, 'casio': 1, 'baby-g': 2, 'microwear': 3 };
    return (brandOrder[a.brandSlug] || 99) - (brandOrder[b.brandSlug] || 99);
  });

  allProducts.forEach((p, i) => {
    p.featured = i < 4;
    p.newArrival = i >= allProducts.length - Math.ceil(allProducts.length * 0.3);
  });

  // Generate TypeScript file
  const ts = `// Auto-generated from CSV product specification files.
// Do not edit manually — regenerate with: node scripts/generate-seed-data.cjs

export interface SeedBrand {
  name: string;
  slug: string;
  description: string;
  logo_url: string;
  banner_url: string;
  visual_family: string;
  featured: boolean;
  active: boolean;
  sort_order: number;
}

export interface SeedCategory {
  name: string;
  slug: string;
  description: string;
  image_url: string;
  active: boolean;
  sort_order: number;
}

export interface SeedProduct {
  brand_slug: string;
  category_slug: string;
  name: string;
  slug: string;
  sku: string;
  short_description: string;
  description: string;
  gender: string;
  movement: string;
  case_material: string;
  strap_material: string;
  water_resistance: string;
  warranty_months: number;
  price: number;
  original_price: number | null;
  currency: string;
  status: string;
  featured: boolean;
  new_arrival: boolean;
  average_rating: number;
  review_count: number;
  image_url: string;
  stock: number;
}

export const seedBrands: SeedBrand[] = ${JSON.stringify(brandDefs.map(b => ({
  name: b.name, slug: b.slug, description: b.description,
  logo_url: b.logo, banner_url: b.banner, visual_family: b.visualFamily,
  featured: b.featured, active: true, sort_order: b.sortOrder,
})), null, 2)};

export const seedCategories: SeedCategory[] = ${JSON.stringify(categoryDefs.map(c => ({
  name: c.name, slug: c.slug, description: c.description,
  image_url: c.image, active: true, sort_order: c.sortOrder,
})), null, 2)};

export const seedProducts: SeedProduct[] = ${JSON.stringify(allProducts.map(p => ({
  brand_slug: p.brandSlug, category_slug: p.catSlug,
  name: p.name, slug: p.slug, sku: p.sku,
  short_description: p.description.substring(0, 150),
  description: p.description,
  gender: p.gender, movement: p.movement,
  case_material: p.caseMaterial, strap_material: p.bandMaterial,
  water_resistance: p.waterResistance, warranty_months: 12,
  price: p.price, original_price: p.originalPrice, currency: 'MMK',
  status: 'active', featured: p.featured, new_arrival: p.newArrival,
  average_rating: p.rating, review_count: p.reviewCount,
  image_url: p.mainImage, stock: p.stock,
})), null, 2)};
`;

  const outPath = path.join(__dirname, '..', 'src', 'data', 'seed-data.ts');
  fs.writeFileSync(outPath, ts);
  console.log(`Generated TypeScript seed data at ${outPath}`);
  console.log(`Total products: ${allProducts.length}`);
  console.log(`  Casio: ${allProducts.filter(p => p.brandSlug === 'casio').length}`);
  console.log(`  Baby-G: ${allProducts.filter(p => p.brandSlug === 'baby-g').length}`);
  console.log(`  Alexandre Christie: ${allProducts.filter(p => p.brandSlug === 'alexandre-christie').length}`);
  console.log(`  Microwear: ${allProducts.filter(p => p.brandSlug === 'microwear').length}`);
}

main().catch(err => { console.error('Error:', err); process.exit(1); });
