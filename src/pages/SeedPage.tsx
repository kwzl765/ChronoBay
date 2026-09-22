import { useState } from 'react';
import { useAuth } from '@/context/AuthContext';
import { supabase } from '@/lib/supabase';
import { seedBrands, seedCategories, seedProducts } from '@/data/seed-data';
import { Database, CheckCircle, AlertCircle, Loader2, ArrowLeft } from 'lucide-react';
import { Link } from 'react-router-dom';

type StepStatus = 'idle' | 'loading' | 'done' | 'error';

interface StepState {
  status: StepStatus;
  message: string;
  count?: number;
}

const initialSteps: Record<string, StepState> = {
  brands: { status: 'idle', message: 'Pending' },
  categories: { status: 'idle', message: 'Pending' },
  products: { status: 'idle', message: 'Pending' },
  images: { status: 'idle', message: 'Pending' },
  inventory: { status: 'idle', message: 'Pending' },
};

export default function SeedPage() {
  const { user, loading: authLoading } = useAuth();
  const [steps, setSteps] = useState<Record<string, StepState>>(initialSteps);
  const [running, setRunning] = useState(false);
  const [complete, setComplete] = useState(false);

  const updateStep = (key: string, state: StepState) => {
    setSteps((prev) => ({ ...prev, [key]: state }));
  };

  async function runSeed() {
    setRunning(true);
    setComplete(false);
    setSteps(initialSteps);

    try {
      // 1. Upsert brands
      updateStep('brands', { status: 'loading', message: 'Inserting brands...' });
      const { error: brandError } = await supabase
        .from('brands')
        .upsert(seedBrands, { onConflict: 'slug' });
      if (brandError) throw new Error(`Brands: ${brandError.message}`);
      updateStep('brands', { status: 'done', message: `${seedBrands.length} brands inserted`, count: seedBrands.length });

      // 2. Upsert categories
      updateStep('categories', { status: 'loading', message: 'Inserting categories...' });
      const { error: catError } = await supabase
        .from('categories')
        .upsert(seedCategories, { onConflict: 'slug' });
      if (catError) throw new Error(`Categories: ${catError.message}`);
      updateStep('categories', { status: 'done', message: `${seedCategories.length} categories inserted`, count: seedCategories.length });

      // 3. Fetch brand and category IDs for FK mapping
      updateStep('products', { status: 'loading', message: 'Resolving brand/category IDs...' });
      const { data: brandRows } = await supabase.from('brands').select('id, slug');
      const { data: catRows } = await supabase.from('categories').select('id, slug');
      const brandMap = new Map((brandRows ?? []).map((b) => [b.slug, b.id]));
      const catMap = new Map((catRows ?? []).map((c) => [c.slug, c.id]));

      // 4. Upsert products in batches of 25
      const productRows = seedProducts.map((p) => ({
        brand_id: brandMap.get(p.brand_slug),
        category_id: catMap.get(p.category_slug),
        name: p.name,
        slug: p.slug,
        sku: p.sku,
        short_description: p.short_description,
        description: p.description,
        gender: p.gender,
        movement: p.movement,
        case_material: p.case_material || null,
        strap_material: p.strap_material || null,
        water_resistance: p.water_resistance || null,
        warranty_months: p.warranty_months,
        price: p.price,
        original_price: p.original_price,
        currency: p.currency,
        status: p.status,
        featured: p.featured,
        new_arrival: p.new_arrival,
        average_rating: p.average_rating,
        review_count: p.review_count,
      }));

      const batchSize = 25;
      let inserted = 0;
      for (let i = 0; i < productRows.length; i += batchSize) {
        const batch = productRows.slice(i, i + batchSize);
        const { error: prodError } = await supabase
          .from('products')
          .upsert(batch, { onConflict: 'slug' });
        if (prodError) throw new Error(`Products batch ${Math.floor(i / batchSize) + 1}: ${prodError.message}`);
        inserted += batch.length;
        updateStep('products', { status: 'loading', message: `Inserted ${inserted}/${productRows.length} products...` });
      }
      updateStep('products', { status: 'done', message: `${inserted} products inserted`, count: inserted });

      // 5. Fetch product IDs for images and inventory
      updateStep('images', { status: 'loading', message: 'Resolving product IDs...' });
      const { data: prodRows } = await supabase.from('products').select('id, slug');
      const prodMap = new Map((prodRows ?? []).map((p) => [p.slug, p.id]));

      // 6. Insert product images
      const imageRows = seedProducts.map((p) => ({
        product_id: prodMap.get(p.slug),
        storage_path: p.image_url,
        alt_text: p.name,
        sort_order: 0,
      }));

      const imgBatchSize = 50;
      let imgInserted = 0;
      for (let i = 0; i < imageRows.length; i += imgBatchSize) {
        const batch = imageRows.slice(i, i + imgBatchSize);
        const { error: imgError } = await supabase
          .from('product_images')
          .upsert(batch, { onConflict: 'product_id,sort_order' });
        if (imgError) {
          // Try insert without conflict target as fallback
          const { error: imgError2 } = await supabase.from('product_images').insert(batch);
          if (imgError2) throw new Error(`Images batch: ${imgError2.message}`);
        }
        imgInserted += batch.length;
        updateStep('images', { status: 'loading', message: `Inserted ${imgInserted}/${imageRows.length} images...` });
      }
      updateStep('images', { status: 'done', message: `${imgInserted} images inserted`, count: imgInserted });

      // 7. Insert inventory
      updateStep('inventory', { status: 'loading', message: 'Inserting inventory...' });
      const inventoryRows = seedProducts.map((p) => ({
        product_id: prodMap.get(p.slug),
        quantity: p.stock,
        reserved_quantity: 0,
        low_stock_threshold: 5,
      }));

      const invBatchSize = 50;
      let invInserted = 0;
      for (let i = 0; i < inventoryRows.length; i += invBatchSize) {
        const batch = inventoryRows.slice(i, i + invBatchSize);
        const { error: invError } = await supabase
          .from('inventory')
          .upsert(batch, { onConflict: 'product_id' });
        if (invError) throw new Error(`Inventory batch: ${invError.message}`);
        invInserted += batch.length;
        updateStep('inventory', { status: 'loading', message: `Inserted ${invInserted}/${inventoryRows.length} inventory records...` });
      }
      updateStep('inventory', { status: 'done', message: `${invInserted} inventory records inserted`, count: invInserted });

      setComplete(true);
    } catch (err) {
      const msg = err instanceof Error ? err.message : 'Unknown error';
      // Mark the current loading step as errored
      setSteps((prev) => {
        const next = { ...prev };
        for (const key of Object.keys(next)) {
          if (next[key].status === 'loading') {
            next[key] = { status: 'error', message: msg };
            break;
          }
        }
        return next;
      });
    } finally {
      setRunning(false);
    }
  }

  if (authLoading) {
    return (
      <div className="flex min-h-[60vh] items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-slate-400" />
      </div>
    );
  }

  if (!user) {
    return (
      <div className="mx-auto max-w-md px-4 py-20 text-center">
        <Database className="mx-auto mb-4 h-12 w-12 text-slate-300" />
        <h1 className="text-2xl font-bold text-slate-900">Admin Access Required</h1>
        <p className="mt-2 text-slate-600">
          You need to be signed in as an admin to import product data.
        </p>
        <Link
          to="/login"
          className="mt-6 inline-block rounded-lg bg-slate-900 px-6 py-3 text-sm font-medium text-white transition hover:bg-slate-800"
        >
          Sign In
        </Link>
      </div>
    );
  }

  const stepOrder = ['brands', 'categories', 'products', 'images', 'inventory'];
  const stepLabels: Record<string, string> = {
    brands: 'Brands',
    categories: 'Categories',
    products: 'Products',
    images: 'Product Images',
    inventory: 'Inventory',
  };

  return (
    <div className="mx-auto max-w-2xl px-4 py-12">
      <Link to="/" className="mb-6 inline-flex items-center gap-2 text-sm text-slate-500 transition hover:text-slate-900">
        <ArrowLeft className="h-4 w-4" /> Back to home
      </Link>

      <div className="rounded-2xl border border-slate-200 bg-white p-8 shadow-sm">
        <div className="mb-6 flex items-center gap-3">
          <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-slate-900">
            <Database className="h-6 w-6 text-white" />
          </div>
          <div>
            <h1 className="text-xl font-bold text-slate-900">Import Product Data</h1>
            <p className="text-sm text-slate-500">
              Seeds {seedBrands.length} brands, {seedCategories.length} categories, and {seedProducts.length} products from CSV files.
            </p>
          </div>
        </div>

        {complete && (
          <div className="mb-6 flex items-start gap-3 rounded-xl border border-emerald-200 bg-emerald-50 p-4">
            <CheckCircle className="mt-0.5 h-5 w-5 shrink-0 text-emerald-600" />
            <div>
              <p className="font-medium text-emerald-900">Import complete!</p>
              <p className="text-sm text-emerald-700">
                All product data has been inserted. Your store now has {seedProducts.length} products across {seedBrands.length} brands.
              </p>
            </div>
          </div>
        )}

        <div className="mb-6 space-y-3">
          {stepOrder.map((key) => {
            const step = steps[key];
            return (
              <div
                key={key}
                className="flex items-center justify-between rounded-lg border border-slate-200 px-4 py-3"
              >
                <div className="flex items-center gap-3">
                  {step.status === 'idle' && (
                    <div className="h-5 w-5 rounded-full border-2 border-slate-200" />
                  )}
                  {step.status === 'loading' && (
                    <Loader2 className="h-5 w-5 animate-spin text-blue-600" />
                  )}
                  {step.status === 'done' && (
                    <CheckCircle className="h-5 w-5 text-emerald-600" />
                  )}
                  {step.status === 'error' && (
                    <AlertCircle className="h-5 w-5 text-red-600" />
                  )}
                  <span className="text-sm font-medium text-slate-700">{stepLabels[key]}</span>
                </div>
                <span className={`text-xs ${
                  step.status === 'done' ? 'text-emerald-600' :
                  step.status === 'error' ? 'text-red-600' :
                  step.status === 'loading' ? 'text-blue-600' :
                  'text-slate-400'
                }`}>
                  {step.message}
                </span>
              </div>
            );
          })}
        </div>

        <button
          onClick={runSeed}
          disabled={running}
          className="w-full rounded-xl bg-slate-900 px-6 py-3.5 text-sm font-semibold text-white transition hover:bg-slate-800 disabled:cursor-not-allowed disabled:opacity-50"
        >
          {running ? 'Importing...' : complete ? 'Re-import Data' : 'Start Import'}
        </button>

        <p className="mt-4 text-center text-xs text-slate-400">
          This action is idempotent — running it multiple times will update existing records without creating duplicates.
        </p>
      </div>
    </div>
  );
}
