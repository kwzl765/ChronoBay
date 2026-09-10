import { Link } from 'react-router-dom';
import SectionTitle from '@/components/SectionTitle';
import { getHomepageFeaturedBrands } from '@/data/brands';

export default function ShopByBrand() {
  const featuredBrands = getHomepageFeaturedBrands();

  return (
    <section className="container-wide py-12 lg:py-16">
      <SectionTitle
        eyebrow="Brands"
        title="Shop by Brand"
        link={{ label: 'View All Brands', to: '/brands' }}
      />
      <div className="mt-10 grid grid-cols-2 gap-4 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-8">
        {featuredBrands.map((brand) => (
          <Link
            key={brand.id}
            to={`/brands/${brand.slug}`}
            className="group flex flex-col items-center"
            aria-label={`Shop ${brand.name}`}
          >
            <div className="flex aspect-square w-full items-center justify-center rounded border border-gray-200 bg-white p-4 transition-shadow duration-300 hover:shadow-card">
              <img
                src={brand.logo}
                alt={`${brand.name} logo`}
                loading="lazy"
                className="h-full w-full object-contain"
              />
            </div>
            <p className="mt-2 text-center text-xs font-medium text-charcoal group-hover:text-accent transition-colors">
              {brand.name}
            </p>
          </Link>
        ))}
      </div>
    </section>
  );
}
