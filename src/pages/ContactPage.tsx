import { useState } from 'react';
import { Link } from 'react-router-dom';
import { Mail, Phone, MapPin, Clock, Send, CheckCircle2 } from 'lucide-react';
import Seo from '@/components/Seo';
import { useShop } from '@/context/ShopContext';

const contactInfo = [
  { icon: Mail, label: 'Email', value: 'support@chronobay.com', href: 'mailto:support@chronobay.com' },
  { icon: Phone, label: 'Phone', value: '+95 9 123 456 789', href: 'tel:+959123456789' },
  { icon: MapPin, label: 'Address', value: 'No. 42, Strand Road, Yangon, Myanmar', href: null },
  { icon: Clock, label: 'Hours', value: 'Mon–Sat: 9:00 AM – 6:00 PM', href: null },
];

export default function ContactPage() {
  const { showToast } = useShop();
  const [form, setForm] = useState({ name: '', email: '', subject: '', message: '' });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const newErrors: Record<string, string> = {};
    if (!form.name.trim()) newErrors.name = 'Name is required';
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) newErrors.email = 'Valid email required';
    if (!form.subject.trim()) newErrors.subject = 'Subject is required';
    if (form.message.trim().length < 10) newErrors.message = 'Message must be at least 10 characters';

    setErrors(newErrors);
    if (Object.keys(newErrors).length > 0) return;

    setSubmitted(true);
    showToast('success', 'Your message has been sent. We will get back to you soon.');
    setForm({ name: '', email: '', subject: '', message: '' });
    setTimeout(() => setSubmitted(false), 5000);
  };

  return (
    <>
      <Seo
        title="Contact Us — ChronoBay"
        description="Get in touch with the ChronoBay team. We are here to help with any questions about our watches, orders, or services."
      />

      <div className="border-b border-gray-200 bg-gray-50">
        <div className="container-wide py-3">
          <nav className="flex items-center gap-2 text-xs text-gray-500" aria-label="Breadcrumb">
            <Link to="/" className="hover:text-accent">Home</Link>
            <span aria-hidden="true">/</span>
            <span className="text-charcoal">Contact</span>
          </nav>
        </div>
      </div>

      <section className="bg-navy-600 py-12 lg:py-16">
        <div className="container-wide text-center">
          <h1 className="text-[26px] font-bold text-white sm:text-[32px]">Get in Touch</h1>
          <p className="mx-auto mt-3 max-w-xl text-sm text-gray-300">
            Questions about a watch, an order, or anything else? Our team is ready to help.
          </p>
        </div>
      </section>

      <div className="container-wide py-12 lg:py-16">
        <div className="grid gap-10 lg:grid-cols-3">
          {/* Contact info */}
          <div className="lg:col-span-1">
            <h2 className="text-lg font-bold text-navy-600">Contact Information</h2>
            <p className="mt-2 text-sm text-gray-500">
              Reach us through any of the channels below.
            </p>
            <div className="mt-8 space-y-6">
              {contactInfo.map((info) => (
                <div key={info.label} className="flex items-start gap-4">
                  <div className="flex h-11 w-11 shrink-0 items-center justify-center rounded bg-accent/10">
                    <info.icon className="h-5 w-5 text-accent" aria-hidden="true" />
                  </div>
                  <div>
                    <p className="text-xs font-semibold uppercase tracking-wider text-gray-400">
                      {info.label}
                    </p>
                    {info.href ? (
                      <a
                        href={info.href}
                        className="mt-1 block text-sm font-medium text-charcoal hover:text-accent transition-colors"
                      >
                        {info.value}
                      </a>
                    ) : (
                      <p className="mt-1 text-sm font-medium text-charcoal">{info.value}</p>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Form */}
          <div className="lg:col-span-2">
            <div className="rounded border border-gray-200 bg-white p-6 lg:p-8">
              <h2 className="text-lg font-bold text-navy-600">Send Us a Message</h2>
              <form onSubmit={handleSubmit} className="mt-6 space-y-5" noValidate>
                <div className="grid gap-5 sm:grid-cols-2">
                  <div>
                    <label htmlFor="contact-name" className="block text-sm font-medium text-charcoal mb-1.5">
                      Your Name
                    </label>
                    <input
                      id="contact-name"
                      type="text"
                      value={form.name}
                      onChange={(e) => setForm({ ...form, name: e.target.value })}
                      className="input-base"
                      placeholder="John Doe"
                      aria-invalid={!!errors.name}
                    />
                    {errors.name && <p className="mt-1 text-xs text-red-600">{errors.name}</p>}
                  </div>
                  <div>
                    <label htmlFor="contact-email" className="block text-sm font-medium text-charcoal mb-1.5">
                      Email Address
                    </label>
                    <input
                      id="contact-email"
                      type="email"
                      value={form.email}
                      onChange={(e) => setForm({ ...form, email: e.target.value })}
                      className="input-base"
                      placeholder="your@email.com"
                      aria-invalid={!!errors.email}
                    />
                    {errors.email && <p className="mt-1 text-xs text-red-600">{errors.email}</p>}
                  </div>
                </div>
                <div>
                  <label htmlFor="contact-subject" className="block text-sm font-medium text-charcoal mb-1.5">
                    Subject
                  </label>
                  <input
                    id="contact-subject"
                    type="text"
                    value={form.subject}
                    onChange={(e) => setForm({ ...form, subject: e.target.value })}
                    className="input-base"
                    placeholder="How can we help?"
                    aria-invalid={!!errors.subject}
                  />
                  {errors.subject && <p className="mt-1 text-xs text-red-600">{errors.subject}</p>}
                </div>
                <div>
                  <label htmlFor="contact-message" className="block text-sm font-medium text-charcoal mb-1.5">
                    Message
                  </label>
                  <textarea
                    id="contact-message"
                    rows={5}
                    value={form.message}
                    onChange={(e) => setForm({ ...form, message: e.target.value })}
                    className="input-base resize-none"
                    placeholder="Tell us more..."
                    aria-invalid={!!errors.message}
                  />
                  {errors.message && <p className="mt-1 text-xs text-red-600">{errors.message}</p>}
                </div>

                {submitted && (
                  <div
                    role="status"
                    className="flex items-center gap-2 rounded bg-green-50 px-4 py-3 text-sm text-green-700 animate-fadeIn"
                  >
                    <CheckCircle2 className="h-5 w-5 shrink-0" aria-hidden="true" />
                    Your message has been sent successfully.
                  </div>
                )}

                <button type="submit" className="btn-primary">
                  <Send className="h-4 w-4" />
                  Send Message
                </button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
