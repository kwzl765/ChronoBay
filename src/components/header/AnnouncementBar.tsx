const messages = [
  'Official Online Watch Store',
  'Free Delivery on Orders Over 300,000 MMK',
  'Authentic Watches with Warranty',
];

export default function AnnouncementBar() {
  const prefersReducedMotion =
    typeof window !== 'undefined' &&
    window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  const repeated = [...messages, ...messages, ...messages, ...messages];

  return (
    <div
      className="relative overflow-hidden bg-charcoal text-white"
      style={{ overflowX: 'clip' }}
      aria-label="Promotional announcements"
    >
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
  );
}
