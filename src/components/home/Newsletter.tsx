import { useState } from 'react';
import { Mail, CheckCircle2, AlertCircle } from 'lucide-react';

export default function Newsletter() {
  const [email, setEmail] = useState('');
  const [status, setStatus] = useState<'idle' | 'success' | 'error'>('idle');
  const [message, setMessage] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      setStatus('error');
      setMessage('Please enter a valid email address.');
      return;
    }
    setStatus('success');
    setMessage('Thank you for subscribing! Check your inbox for confirmation.');
    setEmail('');
  };

  return (
    <section className="bg-navy-600 py-14 lg:py-20">
      <div className="container-wide">
        <div className="mx-auto flex max-w-2xl flex-col items-center text-center">
          <div className="flex h-14 w-14 items-center justify-center rounded bg-accent/20">
            <Mail className="h-7 w-7 text-accent" aria-hidden="true" />
          </div>
          <h2 className="mt-4 text-2xl font-bold text-white sm:text-3xl">
            Stay Ahead of Time
          </h2>
          <p className="mt-2 text-sm text-gray-300">
            Subscribe for exclusive offers, new arrivals, and watch enthusiasts\' insights.
          </p>

          <form onSubmit={handleSubmit} className="mt-6 w-full max-w-md" noValidate>
            <div className="flex flex-col gap-3 sm:flex-row">
              <label htmlFor="newsletter-email" className="sr-only">
                Email address
              </label>
              <input
                id="newsletter-email"
                type="email"
                value={email}
                onChange={(e) => {
                  setEmail(e.target.value);
                  setStatus('idle');
                }}
                placeholder="your@email.com"
                className="flex-1 rounded border border-white/20 bg-white/10 px-4 py-3 text-sm text-white placeholder:text-gray-400 focus:border-accent focus:bg-white/15 focus:outline-none focus:ring-1 focus:ring-accent/30"
                aria-invalid={status === 'error'}
                aria-describedby="newsletter-msg"
              />
              <button type="submit" className="btn-primary shrink-0">
                Subscribe
              </button>
            </div>

            {status !== 'idle' && (
              <div
                id="newsletter-msg"
                role={status === 'error' ? 'alert' : 'status'}
                className={`mt-3 flex items-center justify-center gap-2 rounded px-4 py-2.5 text-sm animate-fadeIn ${
                  status === 'success'
                    ? 'bg-green-500/15 text-green-300'
                    : 'bg-red-500/15 text-red-300'
                }`}
              >
                {status === 'success' ? (
                  <CheckCircle2 className="h-4 w-4 shrink-0" aria-hidden="true" />
                ) : (
                  <AlertCircle className="h-4 w-4 shrink-0" aria-hidden="true" />
                )}
                {message}
              </div>
            )}
          </form>
        </div>
      </div>
    </section>
  );
}
