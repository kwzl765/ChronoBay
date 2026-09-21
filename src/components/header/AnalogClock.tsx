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

  const vb = 100;
  const center = vb / 2;
  const bezelR = 48;
  const dialR = 43;
  const crownW = 5;
  const crownH = 12;

  const hourLen = dialR * 0.52;
  const minLen = dialR * 0.74;
  const secLen = dialR * 0.82;

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

  const hourMarkers = Array.from({ length: 12 }, (_, i) => i * 30);

  return (
    <svg
      width={size}
      height={size}
      viewBox={`0 0 ${vb + crownW} ${vb}`}
      aria-label="Orient-style analog clock showing Myanmar time"
      role="img"
    >
      <defs>
        <radialGradient id="orient-dial" cx="50%" cy="38%" r="62%">
          <stop offset="0%" stopColor="#FFFFFF" />
          <stop offset="55%" stopColor="#F5F3EF" />
          <stop offset="100%" stopColor="#E8E4DC" />
        </radialGradient>
        <linearGradient id="orient-bezel" x1="0%" y1="0%" x2="0%" y2="100%">
          <stop offset="0%" stopColor="#1B2A5C" />
          <stop offset="50%" stopColor="#0B1235" />
          <stop offset="100%" stopColor="#080E2A" />
        </linearGradient>
      </defs>

      {/* Crown at 3 o'clock */}
      <rect
        x={vb - 2}
        y={center - crownH / 2}
        width={crownW + 2}
        height={crownH}
        rx={1.5}
        fill="url(#orient-bezel)"
      />
      <line
        x1={vb + 1}
        y1={center - crownH / 2 + 2}
        x2={vb + 1}
        y2={center + crownH / 2 - 2}
        stroke="#F58220"
        strokeWidth={0.6}
        opacity={0.6}
      />

      {/* Outer bezel ring */}
      <circle cx={center} cy={center} r={bezelR} fill="url(#orient-bezel)" />

      {/* Dial face */}
      <circle cx={center} cy={center} r={dialR} fill="url(#orient-dial)" />

      {/* Inner dial ring line */}
      <circle cx={center} cy={center} r={dialR - 1.5} fill="none" stroke="#D0CCC4" strokeWidth={0.4} />

      {/* Hour markers - Orient style applied baton markers */}
      {hourMarkers.map((angle) => {
        const isMajor = angle % 90 === 0;
        const markerLen = isMajor ? 6 : 4.5;
        const markerW = isMajor ? 2.8 : 1.8;
        const r1 = dialR - 3;
        const r2 = dialR - 3 - markerLen;
        const midX = center + ((r1 + r2) / 2) * Math.sin((angle * Math.PI) / 180);
        const midY = center - ((r1 + r2) / 2) * Math.cos((angle * Math.PI) / 180);

        return (
          <rect
            key={angle}
            x={midX - markerW / 2}
            y={midY - markerLen / 2}
            width={markerW}
            height={markerLen}
            rx={0.5}
            fill="#0B1235"
            transform={`rotate(${angle} ${midX} ${midY})`}
          />
        );
      })}

      {/* ORIENT text at 12 position */}
      <text
        x={center}
        y={center - dialR * 0.42}
        textAnchor="middle"
        fontFamily="Inter, sans-serif"
        fontSize={5.5}
        fontWeight={700}
        fill="#0B1235"
        letterSpacing={0.8}
      >
        ORIENT
      </text>

      {/* "MYANMAR" small text below center */}
      <text
        x={center}
        y={center + dialR * 0.35}
        textAnchor="middle"
        fontFamily="Inter, sans-serif"
        fontSize={3.2}
        fontWeight={500}
        fill="#6B6B6B"
        letterSpacing={0.5}
      >
        MYANMAR
      </text>

      {/* Hour hand - sword style */}
      <line
        x1={center}
        y1={center + 3}
        x2={hourEnd.x}
        y2={hourEnd.y}
        stroke="#0B1235"
        strokeWidth={2.8}
        strokeLinecap="round"
      />
      {/* Minute hand - sword style */}
      <line
        x1={center}
        y1={center + 4}
        x2={minEnd.x}
        y2={minEnd.y}
        stroke="#0B1235"
        strokeWidth={2}
        strokeLinecap="round"
      />
      {/* Second hand - orange thin */}
      <line
        x1={center}
        y1={center + 6}
        x2={secEnd.x}
        y2={secEnd.y}
        stroke="#F58220"
        strokeWidth={0.9}
        strokeLinecap="round"
      />

      {/* Center cap */}
      <circle cx={center} cy={center} r={2.5} fill="#0B1235" />
      <circle cx={center} cy={center} r={1} fill="#F58220" />
    </svg>
  );
}
