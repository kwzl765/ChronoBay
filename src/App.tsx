import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { AuthProvider } from '@/context/AuthContext';
import { ShopProvider } from '@/context/ShopContext';
import Header from '@/components/header/Header';
import Footer from '@/components/footer/Footer';
import ToastContainer from '@/components/ToastContainer';
import ScrollToTop from '@/components/ScrollToTop';
import HomePage from '@/pages/HomePage';
import ShopPage from '@/pages/ShopPage';
import CategoryPage from '@/pages/CategoryPage';
import ProductPage from '@/pages/ProductPage';
import BrandsPage from '@/pages/BrandsPage';
import BrandDetailPage from '@/pages/BrandDetailPage';
import CartPage from '@/pages/CartPage';
import WishlistPage from '@/pages/WishlistPage';
import LoginPage from '@/pages/LoginPage';
import AboutPage from '@/pages/AboutPage';
import ContactPage from '@/pages/ContactPage';
import BlogPage from '@/pages/BlogPage';
import NotFoundPage from '@/pages/NotFoundPage';

function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
      <ShopProvider>
        <ScrollToTop />
        <div className="flex min-h-screen flex-col bg-white">
          <Header />
          <main className="flex-1">
            <Routes>
              <Route path="/" element={<HomePage />} />
              <Route path="/shop" element={<ShopPage />} />
              <Route path="/category/:slug" element={<CategoryPage />} />
              <Route path="/product/:slug" element={<ProductPage />} />
              <Route path="/brands" element={<BrandsPage />} />
              <Route path="/brands/:slug" element={<BrandDetailPage />} />
              <Route path="/cart" element={<CartPage />} />
              <Route path="/wishlist" element={<WishlistPage />} />
              <Route path="/login" element={<LoginPage />} />
              <Route path="/about" element={<AboutPage />} />
              <Route path="/contact" element={<ContactPage />} />
              <Route path="/blog" element={<BlogPage />} />
              <Route path="*" element={<NotFoundPage />} />
            </Routes>
          </main>
          <Footer />
        </div>
        <ToastContainer />
      </ShopProvider>
      </AuthProvider>
    </BrowserRouter>
  );
}

export default App;
