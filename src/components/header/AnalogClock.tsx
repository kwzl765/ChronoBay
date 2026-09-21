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

const GOLD = '#C5A35E';
const GOLD_DARK = '#A68B3F';
const GOLD_LIGHT = '#E6CD8A';

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

  const vb = 100;
  const center = vb / 2;
  const bezelR = 48;
  const flutedR = 46;
  const dialR = 42;
  const crownW = 5;
  const crownH = 11;

  const hourLen = dialR * 0.45;
  const minLen = dialR * 0.70;
  const secLen = dialR * 0.76;

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
  const secTail = {
    x: center - (dialR * 0.2) * Math.sin((secAngle * Math.PI) / 180),
    y: center + (dialR * 0.2) * Math.cos((secAngle * Math.PI) / 180),
  };

  const hourMarkers = Array.from({ length: 12 }, (_, i) => i * 30);
  const minuteMarks = Array.from({ length: 60 }, (_, i) => i * 6).filter((a) => a % 30 !== 0);

  const flutes = Array.from({ length: 60 }, (_, i) => i * 6);

  return (
    <svg
      width={size}
      height={size}
      viewBox={`0 0 ${vb + crownW} ${vb}`}
      aria-label="Orient Star luxury watch clock showing Myanmar time"
      role="img"
    >
      <defs>
        <radialGradient id="lux-dial" cx="50%" cy="30%" r="80%">
          <stop offset="0%" stopColor="#1E3A6E" />
          <stop offset="40%" stopColor="#142A52" />
          <stop offset="80%" stopColor="#0C1E40" />
          <stop offset="100%" stopColor="#081530" />
        </radialGradient>
        <linearGradient id="lux-gold-bezel" x1="0%" y1="0%" x2="0%" y2="100%">
          <stop offset="0%" stopColor={GOLD_LIGHT} />
          <stop offset="30%" stopColor={GOLD} />
          <stop offset="70%" stopColor={GOLD_DARK} />
          <stop offset="100%" stopColor={GOLD} />
        </linearGradient>
        <linearGradient id="lux-gold-crown" x1="0%" y1="0%" x2="100%" y2="0%">
          <stop offset="0%" stopColor={GOLD_DARK} />
          <stop offset="50%" stopColor={GOLD_LIGHT} />
          <stop offset="100%" stopColor={GOLD_DARK} />
        </linearGradient>
        <radialGradient id="lux-subdial" cx="50%" cy="35%" r="65%">
          <stop offset="0%" stopColor="#0C1E40" />
          <stop offset="100%" stopColor="#060F25" />
        </radialGradient>
      </defs>

      {/* Crown at 3 o'clock with fluted texture */}
      <rect
        x={vb - 1}
        y={center - crownH / 2}
        width={crownW + 1}
        height={crownH}
        rx={1.5}
        fill="url(#lux-gold-crown)"
      />
      {[-3, -1, 1, 3].map((dy) => (
        <line
          key={`crown-${dy}`}
          x1={vb}
          y1={center + dy}
          x2={vb + crownW}
          y2={center + dy}
          stroke={GOLD_DARK}
          strokeWidth={0.3}
          opacity={0.5}
        />
      ))}

      {/* Gold bezel ring */}
      <circle cx={center} cy={center} r={bezelR} fill="url(#lux-gold-bezel)" />

      {/* Fluted bezel pattern */}
      {flutes.map((angle) => {
        const r1 = flutedR;
        const r2 = bezelR - 0.5;
        const x1 = center + r1 * Math.sin((angle * Math.PI) / 180);
        const y1 = center - r1 * Math.cos((angle * Math.PI) / 180);
        const x2 = center + r2 * Math.sin((angle * Math.PI) / 180);
        const y2 = center - r2 * Math.cos((angle * Math.PI) / 180);
        return (
          <line
            key={`flute-${angle}`}
            x1={x1}
            y1={y1}
            x2={x2}
            y2={y2}
            stroke={GOLD_DARK}
            strokeWidth={0.35}
            opacity={0.4}
          />
        );
      })}

      {/* Inner bezel edge */}
      <circle cx={center} cy={center} r={flutedR} fill="none" stroke={GOLD_LIGHT} strokeWidth={0.5} />

      {/* Dial face - sunburst midnight blue */}
      <circle cx={center} cy={center} r={dialR} fill="url(#lux-dial)" />

      {/* Sunburst rays effect */}
      {Array.from({ length: 120 }, (_, i) => i * 3).map((angle) => {
        const x = center + dialR * Math.sin((angle * Math.PI) / 180);
        const y = center - dialR * Math.cos((angle * Math.PI) / 180);
        return (
          <line
            key={`ray-${angle}`}
            x1={center}
            y1={center}
            x2={x}
            y2={y}
            stroke="#2A4A80"
            strokeWidth={0.15}
            opacity={0.3}
          />
        );
      })}

      {/* Outer dial chapter ring */}
      <circle
        cx={center}
        cy={center}
        r={dialR - 1}
        fill="none"
        stroke={GOLD}
        strokeWidth={0.3}
        opacity={0.4}
      />

      {/* Minute marks - gold fine ticks */}
      {minuteMarks.map((angle) => {
        const r1 = dialR - 2;
        const r2 = dialR - 3.5;
        const x1 = center + r1 * Math.sin((angle * Math.PI) / 180);
        const y1 = center - r1 * Math.cos((angle * Math.PI) / 180);
        const x2 = center + r2 * Math.sin((angle * Math.PI) / 180);
        const y2 = center - r2 * Math.cos((angle * Math.PI) / 180);
        return (
          <line
            key={`m-${angle}`}
            x1={x1}
            y1={y1}
            x2={x2}
            y2={y2}
            stroke={GOLD}
            strokeWidth={0.35}
            opacity={0.6}
          />
        );
      })}

      {/* Hour markers - applied gold batons with faceted look */}
      {hourMarkers.map((angle) => {
        const r1 = dialR - 2;
        const r2 = dialR - 7;
        const midX = center + ((r1 + r2) / 2) * Math.sin((angle * Math.PI) / 180);
        const midY = center - ((r1 + r2) / 2) * Math.cos((angle * Math.PI) / 180);
        return (
          <g key={`h-${angle}`}>
            <rect
              x={midX - 1.2}
              y={midY - 2.5}
              width={2.4}
              height={5}
              rx={0.3}
              fill="url(#lux-gold-bezel)"
              transform={`rotate(${angle} ${midX} ${midY})`}
            />
            <rect
              x={midX - 0.4}
              y={midY - 2.5}
              width={0.8}
              height={5}
              rx={0.2}
              fill={GOLD_LIGHT}
              opacity={0.5}
              transform={`rotate(${angle} ${midX} ${midY})`}
            />
          </g>
        );
      })}

      {/* Power reserve subdial at 6 o'clock position */}
      <circle
        cx={center}
        cy={center + dialR * 0.42}
        r={dialR * 0.16}
        fill="url(#lux-subdial)"
        stroke={GOLD}
        strokeWidth={0.3}
        opacity={0.7}
      />
      {/* Power reserve arc */}
      {Array.from({ length: 7 }, (_, i) => -60 + i * 20).map((a) => {
        const subCx = center;
        const subCy = center + dialR * 0.42;
        const subR = dialR * 0.12;
        const x1 = subCx + subR * Math.sin((a * Math.PI) / 180);
        const y1 = subCy - subR * Math.cos((a * Math.PI) / 180);
        const x2 = subCx + (subR - 1.5) * Math.sin((a * Math.PI) / 180);
        const y2 = subCy - (subR - 1.5) * Math.cos((a * Math.PI) / 180);
        return (
          <line
            key={`pr-${a}`}
            x1={x1}
            y1={y1}
            x2={x2}
            y2={y2}
            stroke={GOLD}
            strokeWidth={0.3}
            opacity={0.5}
          />
        );
      })}
      {/* Power reserve hand - static at ~70% */}
      <line
        x1={center}
        y1={center + dialR * 0.42}
        x2={center + dialR * 0.1 * Math.sin((40 * Math.PI) / 180)}
        y2={center + dialR * 0.42 - dialR * 0.1 * Math.cos((40 * Math.PI) / 180)}
        stroke={GOLD_LIGHT}
        strokeWidth={0.5}
        strokeLinecap="round"
      />
      <circle cx={center} cy={center + dialR * 0.42} r={0.5} fill={GOLD} />

      {/* ORIENT STAR brand text */}
      <text
        x={center}
        y={center - dialR * 0.32}
        textAnchor="middle"
        fontFamily="'Times New Roman', serif"
        fontSize={5.5}
        fontWeight={700}
        fill={GOLD_LIGHT}
        letterSpacing={1.5}
      >
        ORIENT
      </text>
      {/* Star above ORIENT */}
      <text
        x={center}
        y={center - dialR * 0.42}
        textAnchor="middle"
        fontFamily="serif"
        fontSize={3.5}
        fill={GOLD_LIGHT}
      >
        ★
      </text>

      {/* "MYANMAR" text below subdial */}
      <text
        x={center}
        y={center + dialR * 0.62}
        textAnchor="middle"
        fontFamily="Inter, sans-serif"
        fontSize={2.5}
        fontWeight={400}
        fill={GOLD}
        letterSpacing={1}
        opacity={0.7}
      >
        MYANMAR
      </text>

      {/* Hour hand - gold dauphine */}
      <polygon
        points={`${center},${center + 3} ${center - 1.2},${center} ${center},${hourEnd.y - 1} ${center + 1.2},${center}`}
        fill={GOLD}
        transform={`rotate(${hourAngle} ${center} ${center})`}
      />
      <polygon
        points={`${center},${center + 3} ${center - 0.5},${center} ${center},${hourEnd.y - 1} ${center + 0.5},${center}`}
        fill={GOLD_LIGHT}
        transform={`rotate(${hourAngle} ${center} ${center})`}
        opacity={0.6}
      />

      {/* Minute hand - gold dauphine */}
      <polygon
        points={`${center},${center + 4} ${center - 1},${center} ${center},${minEnd.y - 1} ${center + 1},${center}`}
        fill={GOLD}
        transform={`rotate(${minAngle} ${center} ${center})`}
      />
      <polygon
        points={`${center},${center + 4} ${center - 0.4},${center} ${center},${minEnd.y - 1} ${center + 0.4},${center}`}
        fill={GOLD_LIGHT}
        transform={`rotate(${minAngle} ${center} ${center})`}
        opacity={0.6}
      />

      {/* Second hand - thin gold with counterweight */}
      <line
        x1={secTail.x}
        y1={secTail.y}
        x2={secEnd.x}
        y2={secEnd.y}
        stroke={GOLD_LIGHT}
        strokeWidth={0.6}
        strokeLinecap="round"
      />
      <circle cx={secTail.x} cy={secTail.y} r={1.5} fill="none" stroke={GOLD_LIGHT} strokeWidth={0.5} />

      {/* Center cap - gold with inner detail */}
      <circle cx={center} cy={center} r={2.5} fill={GOLD_DARK} />
      <circle cx={center} cy={center} r={1.8} fill={GOLD} />
      <circle cx={center} cy={center} r={0.7} fill={GOLD_LIGHT} />
    </svg>
  );
}
