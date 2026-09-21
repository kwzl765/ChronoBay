import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { Flame, ArrowRight } from 'lucide-react';

const SALE_HOURS = 12;
const STORAGE_KEY = 'chronobay_sale_deadline';

function getDeadline(): number {
  const stored = typeof window !== 'undefined' ? localStorage.getItem(STORAGE_KEY) : null;
  if (stored) {
    const ts = parseInt(stored, 10);
    if (!Number.isNaN(ts) && ts > Date.now()) return ts;
  }
  const ts = Date.now() + SALE_HOURS * 60 * 60 * 1000;
  if (typeof window !== 'undefined') localStorage.setItem(STORAGE_KEY, String(ts));
  return ts;
}

function pad(n: number): string {
  return n < 10 ? `0${n}` : String(n);
}

interface TimeLeft {
  hours: number;
  minutes: number;
  seconds: number;
}

function calcTimeLeft(deadline: number): TimeLeft {
  const diff = Math.max(0, deadline - Date.now());
  const totalSec = Math.floor(diff / 1000);
  return {
    hours: Math.floor(totalSec / 3600),
    minutes: Math.floor((totalSec % 3600) / 60),
    seconds: totalSec % 60,
  };
}

export default function CountdownSale() {
  const [deadline] = useState(getDeadline);
  const [timeLeft, setTimeLeft] = useState<TimeLeft>(() => calcTimeLeft(deadline));
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    const id = setInterval(() => {
      const next = calcTimeLeft(deadline);
      setTimeLeft(next);
      if (next.hours === 0 && next.minutes === 0 && next.seconds === 0) {
        clearInterval(id);
      }
    }, 1000);
    return () => clearInterval(id);
  }, [deadline]);

  const segments = [
    { label: 'Hours', value: timeLeft.hours },
    { label: 'Mins', value: timeLeft.minutes },
    { label: 'Secs', value: timeLeft.seconds },
  ];

  return (
    <section className="bg-gradient-to-r from-accent-600 via-accent-500 to-accent-600" aria-label="Flash sale countdown">
      <div className="container-wide py-6 lg:py-8">
        <div className="flex flex-col items-center gap-6 lg:flex-row lg:items-center lg:justify-between">
          <div className="flex items-center gap-4">
            <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-full bg-white/25 animate-pulse">
              <Flame className="h-6 w-6 text-white" aria-hidden="true" />
            </div>
            <div className="text-center lg:text-left">
              <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-white/80">
                Flash Sale
              </p>
              <h2 className="mt-0.5 text-xl font-bold text-white sm:text-2xl">
                Up to 40% Off Selected Watches
              </h2>
              <p className="mt-0.5 text-sm text-white/80">
                Limited time only — ends in
              </p>
            </div>
          </div>

          <div className="flex items-center gap-2 sm:gap-3" aria-label="Time remaining">
            {segments.map((seg, i) => (
              <div key={seg.label} className="flex items-center gap-2 sm:gap-3">
                <div className="flex flex-col items-center">
                  <div className="flex h-14 w-14 items-center justify-center rounded-lg bg-white/20 backdrop-blur-sm border border-white/25 sm:h-16 sm:w-16">
                    <span className="text-2xl font-bold tabular-nums text-white sm:text-3xl" suppressHydrationWarning>
                      {mounted ? pad(seg.value) : '--'}
                    </span>
                  </div>
                  <span className="mt-1.5 text-[10px] font-medium uppercase tracking-wider text-white/70">
                    {seg.label}
                  </span>
                </div>
                {i < segments.length - 1 && (
                  <span className="text-2xl font-bold text-white/70 sm:text-3xl" aria-hidden="true">:</span>
                )}
              </div>
            ))}
          </div>

          <Link
            to="/shop?sort=popularity"
            className="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded bg-navy-600 px-6 py-3 text-sm font-semibold text-white transition-all hover:scale-[1.02] hover:bg-navy-700"
          >
            Shop the Sale
            <ArrowRight className="h-4 w-4" aria-hidden="true" />
          </Link>
        </div>
      </div>
    </section>
  );
}
