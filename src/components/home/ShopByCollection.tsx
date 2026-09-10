import { Link } from 'react-router-dom';
import { ArrowRight } from 'lucide-react';
import { categories, collectionImages } from '@/data/mockData';
import SectionTitle from '@/components/SectionTitle';

export default function ShopByCollection() {
  const featured = [
    { ...categories[0], image: collectionImages.men },
    { ...categories[1], image: collectionImages.women },
    { ...categories[2], image: collectionImages['smart-watches'] },
  ];

  return (
    <section className="container-wide py-12 lg:py-16">
      <SectionTitle eyebrow="Collections" title="Shop by Collection" centered />
      <div className="mt-10 grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
        {featured.map((col) => (
          <Link
            key={col.slug}
            to={`/category/${col.slug}`}
            className="group relative flex min-h-[340px] items-end overflow-hidden rounded"
          >
            <img
              src={col.image}
              alt={col.name}
              loading="lazy"
              className="absolute inset-0 h-full w-full object-cover transition-transform duration-700 group-hover:scale-[1.05]"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-navy-600/90 via-navy-600/30 to-transparent" />
            <div className="relative p-7">
              <h3 className="text-xl font-bold text-white">{col.name}</h3>
              <p className="mt-1.5 max-w-xs text-sm leading-relaxed text-gray-300">{col.description}</p>
              <span className="mt-4 inline-flex items-center gap-1.5 text-sm font-medium text-accent">
                Explore
                <ArrowRight
                  className="h-4 w-4 transition-transform group-hover:translate-x-1"
                  aria-hidden="true"
                />
              </span>
            </div>
          </Link>
        ))}
      </div>
    </section>
  );
}
