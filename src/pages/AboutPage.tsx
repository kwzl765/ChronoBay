import { Link } from 'react-router-dom';
import {
  BadgeCheck,
  ShieldCheck,
  Truck,
  Heart,
  Award,
  Users,
} from 'lucide-react';
import Seo from '@/components/Seo';

const values = [
  { icon: BadgeCheck, title: 'Authenticity First', desc: 'Every watch is verified genuine by our certified horologists before it reaches you.' },
  { icon: ShieldCheck, title: 'Official Warranty', desc: 'All timepieces come with manufacturer-backed warranty for complete peace of mind.' },
  { icon: Truck, title: 'Nationwide Delivery', desc: 'Free delivery on orders over 300,000 MMK to every corner of the country.' },
  { icon: Heart, title: 'Customer Care', desc: 'Our team is passionate about watches and dedicated to helping you find the perfect one.' },
];

const stats = [
  { value: '20+', label: 'Premium Brands' },
  { value: '500+', label: 'Authentic Watches' },
  { value: '10K+', label: 'Happy Customers' },
  { value: '5', label: 'Years of Trust' },
];

export default function AboutPage() {
  return (
    <>
      <Seo
        title="About Us — ChronoBay"
        description="ChronoBay is your official online destination for authentic premium timepieces. Learn about our story, values, and commitment to quality."
      />

      <div className="border-b border-gray-200 bg-gray-50">
        <div className="container-wide py-3">
          <nav className="flex items-center gap-2 text-xs text-gray-500" aria-label="Breadcrumb">
            <Link to="/" className="hover:text-accent">Home</Link>
            <span aria-hidden="true">/</span>
            <span className="text-charcoal">About</span>
          </nav>
        </div>
      </div>

      {/* Hero */}
      <section className="bg-navy-600 py-16 lg:py-24">
        <div className="container-wide">
          <div className="mx-auto max-w-3xl text-center">
            <span className="text-xs font-semibold uppercase tracking-[0.2em] text-accent">
              Our Story
            </span>
            <h1 className="mt-3 text-3xl font-bold text-white sm:text-4xl lg:text-5xl text-balance">
              Passion for Precision, Devotion to Design
            </h1>
            <p className="mt-5 text-base leading-relaxed text-gray-300">
              ChronoBay was founded with a singular mission: to make authentic, premium
              timepieces accessible to watch enthusiasts across the country. We partner
              directly with authorized distributors to bring you genuine watches backed
              by official warranty — delivered with care to your door.
            </p>
          </div>
        </div>
      </section>

      {/* Stats */}
      <section className="border-b border-gray-200 bg-white py-12">
        <div className="container-wide">
          <div className="grid grid-cols-2 gap-8 lg:grid-cols-4">
            {stats.map((s) => (
              <div key={s.label} className="text-center">
                <p className="text-3xl font-bold text-navy-600 sm:text-4xl">{s.value}</p>
                <p className="mt-1 text-sm text-gray-500">{s.label}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Values */}
      <section className="py-16 lg:py-24">
        <div className="container-wide">
          <div className="mx-auto max-w-2xl text-center">
            <span className="text-xs font-semibold uppercase tracking-[0.2em] text-accent">
              What We Stand For
            </span>
            <h2 className="mt-3 text-[26px] font-bold text-navy-600 sm:text-[32px]">
              Values That Define Us
            </h2>
          </div>
          <div className="mt-12 grid gap-8 sm:grid-cols-2 lg:grid-cols-4">
            {values.map((v) => (
              <div key={v.title} className="text-center">
                <div className="mx-auto flex h-14 w-14 items-center justify-center rounded bg-accent/10">
                  <v.icon className="h-7 w-7 text-accent" aria-hidden="true" />
                </div>
                <h3 className="mt-4 text-base font-semibold text-charcoal">{v.title}</h3>
                <p className="mt-2 text-sm leading-relaxed text-gray-500">{v.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Mission */}
      <section className="bg-gray-50 py-16 lg:py-24">
        <div className="container-wide">
          <div className="grid gap-12 lg:grid-cols-2 lg:items-center">
            <div>
              <span className="text-xs font-semibold uppercase tracking-[0.2em] text-accent">
                Our Mission
              </span>
              <h2 className="mt-3 text-[26px] font-bold text-navy-600 sm:text-[32px]">
                Making Luxury Accessible
              </h2>
              <p className="mt-4 text-sm leading-relaxed text-gray-600">
                We believe everyone deserves to own a timepiece they love. That's why we
                curate collections across price points — from rugged everyday watches to
                heirloom-grade automatics. Our transparent pricing, authentic products,
                and dedicated service make the experience as refined as the watches themselves.
              </p>
              <div className="mt-6 flex gap-3">
                <Link to="/shop" className="btn-primary">
                  Explore Watches
                </Link>
                <Link to="/contact" className="btn-secondary">
                  Contact Us
                </Link>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="flex flex-col items-center justify-center rounded bg-navy-600 p-8 text-center">
                <Award className="h-10 w-10 text-accent" aria-hidden="true" />
                <p className="mt-3 text-sm font-semibold text-white">Certified Authentic</p>
              </div>
              <div className="flex flex-col items-center justify-center rounded border border-gray-200 bg-white p-8 text-center">
                <Users className="h-10 w-10 text-navy-600" aria-hidden="true" />
                <p className="mt-3 text-sm font-semibold text-charcoal">Expert Team</p>
              </div>
              <div className="flex flex-col items-center justify-center rounded border border-gray-200 bg-white p-8 text-center">
                <ShieldCheck className="h-10 w-10 text-navy-600" aria-hidden="true" />
                <p className="mt-3 text-sm font-semibold text-charcoal">Warranty Backed</p>
              </div>
              <div className="flex flex-col items-center justify-center rounded bg-accent p-8 text-center">
                <Truck className="h-10 w-10 text-white" aria-hidden="true" />
                <p className="mt-3 text-sm font-semibold text-white">Fast Delivery</p>
              </div>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
