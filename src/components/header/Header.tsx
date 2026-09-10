import { useState, useEffect } from 'react';
import AnnouncementBar from '@/components/header/AnnouncementBar';
import MainHeader from '@/components/header/MainHeader';
import NavBar from '@/components/header/NavBar';

export default function Header() {
  const [mobileNavOpen, setMobileNavOpen] = useState(false);

  useEffect(() => {
    return () => {
      document.body.style.overflow = '';
    };
  }, []);

  return (
    <header className="sticky top-0 z-40">
      <AnnouncementBar />
      <MainHeader onOpenMobileNav={() => setMobileNavOpen(true)} />
      <NavBar open={mobileNavOpen} onClose={() => setMobileNavOpen(false)} />
    </header>
  );
}
