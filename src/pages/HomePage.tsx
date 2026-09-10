import Seo from '@/components/Seo';
import HeroCarousel from '@/components/home/HeroCarousel';
import PromoCards from '@/components/home/PromoCards';
import ShopByCollection from '@/components/home/ShopByCollection';
import PopularCollection from '@/components/home/PopularCollection';
import BrandSection from '@/components/home/BrandSection';
import ShopByBrand from '@/components/home/ShopByBrand';
import BenefitsStrip from '@/components/home/BenefitsStrip';
import Newsletter from '@/components/home/Newsletter';

export default function HomePage() {
  return (
    <>
      <Seo
        title="ChronoBay — Premium Watches & Official Online Watch Store"
        description="Shop authentic premium watches from Casio, G-Shock, Seiko and more. Free delivery over 300,000 MMK. Official warranty, nationwide delivery."
      />
      <HeroCarousel />
      <PromoCards />
      <ShopByCollection />
      <PopularCollection />
      <BrandSection brand="CASIO" slug="casio" alt={false} />
      <BrandSection brand="G-SHOCK Myanmar" slug="g-shock-myanmar" alt />
      <BrandSection brand="Seiko" slug="seiko" alt={false} />
      <ShopByBrand />
      <BenefitsStrip />
      <Newsletter />
    </>
  );
}
