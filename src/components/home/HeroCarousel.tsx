import { useState, useEffect, useCallback, useRef } from 'react';
import { Link } from 'react-router-dom';
import { ChevronLeft, ChevronRight, ArrowRight } from 'lucide-react';
import { heroImages } from '@/data/mockData';

const slides = [
  {
    image: heroImages.slide1,
    eyebrow: 'LIMITED COLLECTION',
    heading: 'Timeless Style, Made for Every Moment',
    copy: 'Discover authenticated premium timepieces from the world\'s finest brands. Each watch is backed by official warranty and delivered to your door.',
    primary: { label: 'Shop Now', to: '/shop' },
    secondary: { label: 'Explore Collection', to: '/category/men' },
  },
  {
    image: heroImages.slide2,
    eyebrow: 'NEW ARRIVALS',
    heading: 'Heritage Craftsmanship, Reimagined',
    copy: 'From Japanese automatic movements to Swiss-made precision — explore the latest additions to our curated collection of exceptional watches.',
    primary: { label: 'Shop New Arrivals', to: '/shop?sort=newest' },
    secondary: { label: 'View All Brands', to: '/brands' },
  },
  {
    image: heroImages.slide3,
    eyebrow: 'GIFT CARDS',
    heading: 'Give the Gift of Time',
    copy: 'Perfect for any occasion. ChronoBay gift cards let your loved ones choose the watch that matches their style — delivered instantly.',
    primary: { label: 'Shop Gift Cards', to: '/shop' },
    secondary: { label: 'Learn More', to: '/about' },
  },
];

export default function HeroCarousel() {
  const [current, setCurrent] = useState(0);
  const [paused, setPaused] = useState(false);
  const touchStartX = useRef<number | null>(null);
  const sectionRef = useRef<HTMLElement>(null);

  const prefersReducedMotion =
    typeof window !== 'undefined' &&
    window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  const next = useCallback(() => setCurrent((c) => (c + 1) % slides.length), []);
  const prev = useCallback(() => setCurrent((c) => (c - 1 + slides.length) % slides.length), []);

  useEffect(() => {
    if (paused || prefersReducedMotion) return;
    const timer = setInterval(next, 5000);
    return () => clearInterval(timer);
  }, [next, paused, prefersReducedMotion]);

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (e.key === 'ArrowRight') next();
      if (e.key === 'ArrowLeft') prev();
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [next, prev]);

  // Pause when keyboard focus enters the carousel
  useEffect(() => {
    const section = sectionRef.current;
    if (!section) return;
    const onFocusIn = () => setPaused(true);
    const onFocusOut = (e: FocusEvent) => {
      if (!section.contains(e.relatedTarget as Node)) setPaused(false);
    };
    section.addEventListener('focusin', onFocusIn);
    section.addEventListener('focusout', onFocusOut);
    return () => {
      section.removeEventListener('focusin', onFocusIn);
      section.removeEventListener('focusout', onFocusOut);
    };
  }, []);

  const handleTouchStart = (e: React.TouchEvent) => {
    touchStartX.current = e.touches[0].clientX;
  };

  const handleTouchEnd = (e: React.TouchEvent) => {
    if (touchStartX.current === null) return;
    const diff = touchStartX.current - e.changedTouches[0].clientX;
    if (Math.abs(diff) > 50) {
      if (diff > 0) next(); else prev();
    }
    touchStartX.current = null;
  };

  return (
    <section
      ref={sectionRef}
      className="relative overflow-hidden bg-navy-600"
      aria-roledescription="carousel"
      aria-label="Featured promotions from ChronoBay"
      onMouseEnter={() => setPaused(true)}
      onMouseLeave={() => setPaused(false)}
      onTouchStart={handleTouchStart}
      onTouchEnd={handleTouchEnd}
    >
      <div className="relative h-[480px] sm:h-[540px] lg:h-[600px]">
        {slides.map((slide, i) => {
          const isActive = i === current;
          return (
            <div
              key={i}
              className={`absolute inset-0 transition-opacity duration-700 ${
                isActive ? 'opacity-100' : 'opacity-0 pointer-events-none'
              }`}
              aria-hidden={!isActive}
              aria-roledescription="slide"
              aria-label={`${i + 1} of ${slides.length}`}
              tabIndex={isActive ? 0 : -1}
            >
              {/* Background */}
              <div className="absolute inset-0">
                <img
                  src={slide.image}
                  alt=""
                  className="h-full w-full object-cover"
                  loading={i === 0 ? 'eager' : 'lazy'}
                  fetchPriority={i === 0 ? 'high' : 'low'}
                />
                <div className="absolute inset-0 bg-gradient-to-r from-navy-600/95 via-navy-600/75 to-navy-600/50" />
              </div>

              {/* Content */}
              <div className="container-wide relative flex h-full items-center">
                <div className="max-w-xl py-12">
                  <span className="text-sm font-semibold uppercase tracking-[0.2em] text-accent">
                    {slide.eyebrow}
                  </span>
                  {isActive ? (
                    <h1 className="mt-3 text-3xl font-extrabold leading-tight text-white sm:text-4xl lg:text-5xl text-balance">
                      {slide.heading}
                    </h1>
                  ) : (
                    <h2 className="mt-3 text-3xl font-extrabold leading-tight text-white sm:text-4xl lg:text-5xl text-balance" aria-hidden="true">
                      {slide.heading}
                    </h2>
                  )}
                  <p className="mt-4 max-w-lg text-base leading-relaxed text-gray-200">
                    {slide.copy}
                  </p>
                  <div className="mt-8 flex flex-wrap gap-4">
                    <Link
                      to={slide.primary.to}
                      className="btn-primary"
                      tabIndex={isActive ? undefined : -1}
                    >
                      {slide.primary.label}
                      <ArrowRight className="h-4 w-4" />
                    </Link>
                    <Link
                      to={slide.secondary.to}
                      className="inline-flex items-center justify-center gap-2 rounded border border-white/30 px-6 py-3 text-sm font-semibold text-white transition-colors hover:bg-white/10"
                      tabIndex={isActive ? undefined : -1}
                    >
                      {slide.secondary.label}
                    </Link>
                  </div>
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {/* Arrows */}
      <button
        onClick={prev}
        className="absolute left-2 top-1/2 z-10 flex h-11 w-11 -translate-y-1/2 items-center justify-center rounded-full bg-white/10 text-white backdrop-blur-sm transition-colors hover:bg-accent"
        aria-label="Previous slide"
      >
        <ChevronLeft className="h-6 w-6" />
      </button>
      <button
        onClick={next}
        className="absolute right-2 top-1/2 z-10 flex h-11 w-11 -translate-y-1/2 items-center justify-center rounded-full bg-white/10 text-white backdrop-blur-sm transition-colors hover:bg-accent"
        aria-label="Next slide"
      >
        <ChevronRight className="h-6 w-6" />
      </button>

      {/* Dots */}
      <div className="absolute bottom-4 left-1/2 z-10 flex -translate-x-1/2 gap-2">
        {slides.map((_, i) => (
          <button
            key={i}
            onClick={() => setCurrent(i)}
            className={`h-2 rounded-full transition-all ${
              i === current ? 'w-8 bg-accent' : 'w-2 bg-white/40 hover:bg-white/70'
            }`}
            aria-label={`Go to slide ${i + 1}`}
            aria-current={i === current}
          />
        ))}
      </div>
    </section>
  );
}
