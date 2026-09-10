import { Link } from 'react-router-dom';
import { ArrowRight } from 'lucide-react';
import { promoImages } from '@/data/mockData';

const cards = [
  {
    title: 'Just In',
    subtitle: 'New Arrivals',
    description: 'Be the first to own the latest timepieces',
    image: promoImages.newArrivals,
    to: '/shop?sort=newest',
  },
  {
    title: 'Best Sellers',
    subtitle: 'Most Loved Watches',
    description: 'Our community\'s top-rated picks',
    image: promoImages.bestSellers,
    to: '/shop?sort=popularity',
  },
];

export default function PromoCards() {
  return (
    <section className="container-wide py-12 lg:py-16">
      <div className="grid gap-5 sm:grid-cols-2">
        {cards.map((card) => (
          <Link
            key={card.title}
            to={card.to}
            className="group relative flex min-h-[300px] items-end overflow-hidden rounded"
          >
            <img
              src={card.image}
              alt={card.subtitle}
              loading="lazy"
              className="absolute inset-0 h-full w-full object-cover transition-transform duration-700 group-hover:scale-[1.03]"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-navy-600/95 via-navy-600/40 to-transparent" />
            <div className="relative p-7 lg:p-9">
              <p className="text-[11px] font-semibold uppercase tracking-[0.15em] text-accent">
                {card.title}
              </p>
              <h3 className="mt-2 text-2xl font-bold leading-tight text-white">
                {card.subtitle}
              </h3>
              <p className="mt-2 text-sm text-gray-300">{card.description}</p>
              <span className="mt-4 inline-flex items-center gap-1.5 text-sm font-medium text-white">
                Discover
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
