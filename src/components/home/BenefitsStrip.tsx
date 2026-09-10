import { BadgeCheck, ShieldCheck, Lock, Truck, RefreshCw } from 'lucide-react';

const benefits = [
  { icon: BadgeCheck, title: 'Authentic Products', desc: '100% genuine watches' },
  { icon: ShieldCheck, title: 'Official Warranty', desc: 'Manufacturer backed' },
  { icon: Lock, title: 'Secure Payments', desc: 'Encrypted checkout' },
  { icon: Truck, title: 'Nationwide Delivery', desc: 'Across the country' },
  { icon: RefreshCw, title: 'Easy Returns', desc: '7-day return policy' },
];

export default function BenefitsStrip() {
  return (
    <section className="border-y border-gray-200 bg-white py-8">
      <div className="container-wide">
        <div className="grid grid-cols-2 gap-6 sm:grid-cols-3 lg:grid-cols-5">
          {benefits.map((b) => (
            <div
              key={b.title}
              className="flex flex-col items-center text-center gap-2"
            >
              <div className="flex h-12 w-12 items-center justify-center rounded bg-accent/10 text-accent">
                <b.icon className="h-6 w-6" aria-hidden="true" />
              </div>
              <h3 className="text-sm font-semibold text-charcoal">{b.title}</h3>
              <p className="text-xs text-gray-400">{b.desc}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
