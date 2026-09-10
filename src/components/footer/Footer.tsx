import { useState } from 'react';
import { Link } from 'react-router-dom';
import {
  Mail,
  Phone,
  Facebook,
  Instagram,
  Twitter,
  Youtube,
  ChevronDown,
  Apple,
  Smartphone,
  CreditCard,
} from 'lucide-react';
import Logo from '@/components/Logo';

const footerSections = [
  {
    title: 'Information',
    links: [
      { label: 'About Us', to: '/about' },
      { label: 'Contact Us', to: '/contact' },
      { label: 'Blog', to: '/blog' },
      { label: 'Privacy Policy', to: '/about' },
      { label: 'Terms & Conditions', to: '/about' },
    ],
  },
  {
    title: 'Customer Service',
    links: [
      { label: 'My Account', to: '/login' },
      { label: 'Track Your Order', to: '/cart' },
      { label: 'Returns & Exchanges', to: '/about' },
      { label: 'Shipping Information', to: '/about' },
      { label: 'FAQ', to: '/contact' },
    ],
  },
];

const paymentMethods = ['Visa', 'Mastercard', 'JCB', ' MPU', 'Amex'];

export default function Footer() {
  const [openSection, setOpenSection] = useState<string | null>(null);

  return (
    <footer className="bg-[#121212] text-gray-400">
      {/* Top: brand + columns */}
      <div className="container-wide py-12 lg:py-16">
        <div className="grid gap-10 lg:grid-cols-5">
          {/* Brand intro */}
          <div className="lg:col-span-2">
            <Logo variant="light" />
            <p className="mt-4 max-w-sm text-sm leading-relaxed text-gray-400">
              ChronoBay is your official online destination for authentic, premium
              timepieces. Every watch we sell is guaranteed genuine and backed by
              official warranty — delivered nationwide.
            </p>
            <div className="mt-6 space-y-2">
              <a
                href="mailto:support@chronobay.com"
                className="flex items-center gap-2 text-sm hover:text-accent transition-colors"
              >
                <Mail className="h-4 w-4 text-accent" aria-hidden="true" />
                support@chronobay.com
              </a>
              <a
                href="tel:+959123456789"
                className="flex items-center gap-2 text-sm hover:text-accent transition-colors"
              >
                <Phone className="h-4 w-4 text-accent" aria-hidden="true" />
                +95 9 123 456 789
              </a>
            </div>
            {/* Social */}
            <div className="mt-6">
              <p className="text-xs font-semibold uppercase tracking-wider text-gray-500 mb-3">
                Follow Us
              </p>
              <div className="flex gap-2">
                {[
                  { Icon: Facebook, label: 'Facebook' },
                  { Icon: Instagram, label: 'Instagram' },
                  { Icon: Twitter, label: 'Twitter' },
                  { Icon: Youtube, label: 'YouTube' },
                ].map(({ Icon, label }) => (
                  <button
                    key={label}
                    type="button"
                    disabled
                    className="flex h-10 w-10 cursor-not-allowed items-center justify-center rounded bg-white/5 text-gray-500 opacity-60"
                    aria-label={`${label} (coming soon)`}
                    title="Coming soon"
                  >
                    <Icon className="h-5 w-5" />
                  </button>
                ))}
              </div>
            </div>
          </div>

          {/* Link columns — desktop */}
          {footerSections.map((section) => (
            <div key={section.title} className="hidden lg:block">
              <h3 className="text-sm font-semibold uppercase tracking-wider text-white mb-4">
                {section.title}
              </h3>
              <ul className="space-y-3">
                {section.links.map((link) => (
                  <li key={link.label}>
                    <Link
                      to={link.to}
                      className="text-sm text-gray-400 transition-colors hover:text-accent"
                    >
                      {link.label}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
          ))}

          {/* App download — desktop */}
          <div className="hidden lg:block">
            <h3 className="text-sm font-semibold uppercase tracking-wider text-white mb-4">
              Get the App
            </h3>
            <div className="space-y-3">
              <button
                type="button"
                disabled
                className="flex w-full cursor-not-allowed items-center gap-3 rounded bg-white/5 px-4 py-3 opacity-60"
                aria-label="App Store (coming soon)"
                title="Coming soon"
              >
                <Apple className="h-6 w-6 text-white" aria-hidden="true" />
                <span className="flex flex-col">
                  <span className="text-[10px] text-gray-500">Download on the</span>
                  <span className="text-sm font-semibold text-white">App Store</span>
                </span>
              </button>
              <button
                type="button"
                disabled
                className="flex w-full cursor-not-allowed items-center gap-3 rounded bg-white/5 px-4 py-3 opacity-60"
                aria-label="Google Play (coming soon)"
                title="Coming soon"
              >
                <Smartphone className="h-6 w-6 text-white" aria-hidden="true" />
                <span className="flex flex-col">
                  <span className="text-[10px] text-gray-500">Get it on</span>
                  <span className="text-sm font-semibold text-white">Google Play</span>
                </span>
              </button>
            </div>
          </div>
        </div>

        {/* Mobile accordions */}
        <div className="lg:hidden mt-8">
          {footerSections.map((section) => (
            <div key={section.title} className="border-t border-white/10">
              <button
                onClick={() =>
                  setOpenSection(openSection === section.title ? null : section.title)
                }
                className="flex w-full items-center justify-between py-4 text-left"
                aria-expanded={openSection === section.title}
              >
                <span className="text-sm font-semibold uppercase tracking-wider text-white">
                  {section.title}
                </span>
                <ChevronDown
                  className={`h-5 w-5 text-gray-500 transition-transform ${
                    openSection === section.title ? 'rotate-180' : ''
                  }`}
                  aria-hidden="true"
                />
              </button>
              {openSection === section.title && (
                <ul className="space-y-3 pb-4 animate-fadeIn">
                  {section.links.map((link) => (
                    <li key={link.label}>
                      <Link
                        to={link.to}
                        className="text-sm text-gray-400 transition-colors hover:text-accent"
                      >
                        {link.label}
                      </Link>
                    </li>
                  ))}
                </ul>
              )}
            </div>
          ))}
          {/* Mobile app buttons */}
          <div className="border-t border-white/10 pt-4">
            <div className="flex gap-3">
              <button
                type="button"
                disabled
                className="flex flex-1 cursor-not-allowed items-center gap-2 rounded bg-white/5 px-3 py-2.5 opacity-60"
                aria-label="App Store (coming soon)"
                title="Coming soon"
              >
                <Apple className="h-5 w-5 text-white" aria-hidden="true" />
                <span className="text-xs font-semibold text-white">App Store</span>
              </button>
              <button
                type="button"
                disabled
                className="flex flex-1 cursor-not-allowed items-center gap-2 rounded bg-white/5 px-3 py-2.5 opacity-60"
                aria-label="Google Play (coming soon)"
                title="Coming soon"
              >
                <Smartphone className="h-5 w-5 text-white" aria-hidden="true" />
                <span className="text-xs font-semibold text-white">Google Play</span>
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Payment methods + language */}
      <div className="border-t border-white/10">
        <div className="container-wide py-6">
          <div className="flex flex-col items-center justify-between gap-4 md:flex-row">
            <div className="flex items-center gap-2">
              <CreditCard className="h-5 w-5 text-gray-500" aria-hidden="true" />
              <span className="text-xs text-gray-500 mr-1">We Accept:</span>
              <div className="flex flex-wrap gap-2">
                {paymentMethods.map((method) => (
                  <span
                    key={method}
                    className="rounded border border-white/10 bg-white/5 px-2.5 py-1 text-[11px] font-medium text-gray-300"
                  >
                    {method}
                  </span>
                ))}
              </div>
            </div>
            <div className="flex items-center gap-2">
              <span className="text-xs text-gray-500">Language:</span>
              <select
                className="rounded border border-white/10 bg-white/5 px-3 py-1.5 text-xs text-gray-300 focus:border-accent focus:outline-none"
                aria-label="Select language"
              >
                <option>English</option>
                <option>မြန်မာ</option>
                <option>日本語</option>
              </select>
            </div>
          </div>
        </div>
      </div>

      {/* Copyright */}
      <div className="border-t border-white/10">
        <div className="container-wide py-4">
          <p className="text-center text-xs text-gray-500">
            © {new Date().getFullYear()} ChronoBay. All rights reserved. ChronoBay is a
            fictional brand created for demonstration purposes.
          </p>
        </div>
      </div>
    </footer>
  );
}
