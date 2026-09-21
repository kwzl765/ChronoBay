import { useEffect, useState } from 'react';
import { Clock } from 'lucide-react';

const messages = [
  'Official Online Watch Store',
  'Free Delivery on Orders Over 300,000 MMK',
  'Authentic Watches with Warranty',
];

function getMyanmarTime(): string {
  return new Intl.DateTimeFormat('en-GB', {
    timeZone: 'Asia/Yangon',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: false,
  }).format(new Date());
}

export default function AnnouncementBar() {
  const prefersReducedMotion =
    typeof window !== 'undefined' &&
    window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  const [time, setTime] = useState<string>('');

  useEffect(() => {
    setTime(getMyanmarTime());
    const id = setInterval(() => setTime(getMyanmarTime()), 1000);
    return () => clearInterval(id);
  }, []);

  const repeated = [...messages, ...messages, ...messages, ...messages];

  return (
    <div
      className="relative flex items-stretch bg-charcoal text-white"
      style={{ overflowX: 'clip' }}
      aria-label="Promotional announcements"
    >
      <div className="relative z-10 flex shrink-0 items-center gap-2 bg-charcoal px-4 py-1.5">
        <Clock className="h-3.5 w-3.5 text-accent" aria-hidden="true" />
        <span className="text-[11px] font-semibold uppercase tracking-wider text-gray-200">
          Myanmar
        </span>
        <span className="text-[11px] font-semibold tabular-nums text-accent" suppressHydrationWarning>
          {time || '--:--:--'}
        </span>
      </div>

      <div className="relative flex-1 overflow-hidden">
        <div
          className={`flex whitespace-nowrap py-1.5 ${prefersReducedMotion ? '' : 'animate-marquee'}`}
          style={{ width: 'max-content' }}
        >
          {repeated.map((msg, i) => (
            <span
              key={i}
              className="flex items-center gap-2 px-6 text-[11px] font-medium uppercase tracking-wider"
            >
              <span className="text-accent" aria-hidden="true">
                ◆
              </span>
              <span className="text-gray-200">{msg}</span>
              <span className="text-gray-600" aria-hidden="true">
                ·
              </span>
            </span>
          ))}
        </div>
      </div>
    </div>
  );
}
