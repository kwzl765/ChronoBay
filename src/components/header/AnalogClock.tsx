import { useEffect, useState } from 'react';

function getMyanmarParts(): { h: number; m: number; s: number; ms: number } {
  const parts = new Intl.DateTimeFormat('en-GB', {
    timeZone: 'Asia/Yangon',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: false,
  }).formatToParts(new Date());

  const h = parseInt(parts.find((p) => p.type === 'hour')?.value ?? '0', 10) % 24;
  const m = parseInt(parts.find((p) => p.type === 'minute')?.value ?? '0', 10);
  const s = parseInt(parts.find((p) => p.type === 'second')?.value ?? '0', 10);
  const ms = new Date().getMilliseconds();
  return { h, m, s, ms };
}

export default function AnalogClock({ size = 44 }: { size?: number }) {
  const [parts, setParts] = useState<{ h: number; m: number; s: number; ms: number } | null>(null);

  useEffect(() => {
    setParts(getMyanmarParts());
    const id = setInterval(() => setParts(getMyanmarParts()), 1000);
    return () => clearInterval(id);
  }, []);

  const h = parts?.h ?? 0;
  const m = parts?.m ?? 0;
  const s = parts?.s ?? 0;
  const ms = parts?.ms ?? 0;

  const secAngle = (s + ms / 1000) * 6;
  const minAngle = m * 6 + s * 0.1;
  const hourAngle = (h % 12) * 30 + m * 0.5;

  const center = size / 2;
  const radius = size / 2 - 2;

  const hourLen = radius * 0.5;
  const minLen = radius * 0.72;
  const secLen = radius * 0.82;

  const hourEnd = {
    x: center + hourLen * Math.sin((hourAngle * Math.PI) / 180),
    y: center - hourLen * Math.cos((hourAngle * Math.PI) / 180),
  };
  const minEnd = {
    x: center + minLen * Math.sin((minAngle * Math.PI) / 180),
    y: center - minLen * Math.cos((minAngle * Math.PI) / 180),
  };
  const secEnd = {
    x: center + secLen * Math.sin((secAngle * Math.PI) / 180),
    y: center - secLen * Math.cos((secAngle * Math.PI) / 180),
  };

  const ticks = Array.from({ length: 12 }, (_, i) => i * 30);

  return (
    <svg
      width={size}
      height={size}
      viewBox={`0 0 ${size} ${size}`}
      aria-label="Analog clock showing Myanmar time"
      role="img"
    >
      <circle cx={center} cy={center} r={radius} fill="#1A1A1A" stroke="#F58220" strokeWidth={1.5} />
      {ticks.map((angle) => {
        const isMajor = angle % 90 === 0;
        const tickLen = isMajor ? 4 : 2.5;
        const x1 = center + (radius - 2) * Math.sin((angle * Math.PI) / 180);
        const y1 = center - (radius - 2) * Math.cos((angle * Math.PI) / 180);
        const x2 = center + (radius - 2 - tickLen) * Math.sin((angle * Math.PI) / 180);
        const y2 = center - (radius - 2 - tickLen) * Math.cos((angle * Math.PI) / 180);
        return (
          <line
            key={angle}
            x1={x1}
            y1={y1}
            x2={x2}
            y2={y2}
            stroke={isMajor ? '#F58220' : '#6B6B6B'}
            strokeWidth={isMajor ? 1.2 : 0.7}
          />
        );
      })}
      <line
        x1={center}
        y1={center}
        x2={hourEnd.x}
        y2={hourEnd.y}
        stroke="#FFFFFF"
        strokeWidth={2.2}
        strokeLinecap="round"
      />
      <line
        x1={center}
        y1={center}
        x2={minEnd.x}
        y2={minEnd.y}
        stroke="#FFFFFF"
        strokeWidth={1.5}
        strokeLinecap="round"
      />
      <line
        x1={center}
        y1={center}
        x2={secEnd.x}
        y2={secEnd.y}
        stroke="#F58220"
        strokeWidth={1}
        strokeLinecap="round"
      />
      <circle cx={center} cy={center} r={2} fill="#F58220" />
    </svg>
  );
}
