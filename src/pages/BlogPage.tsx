import { Link } from 'react-router-dom';
import { ArrowRight, Calendar, Clock } from 'lucide-react';
import Seo from '@/components/Seo';

const posts = [
  {
    title: 'Automatic vs Quartz: Which Movement Is Right for You?',
    excerpt: 'Understanding the difference between automatic and quartz movements helps you choose a watch that fits your lifestyle and values.',
    category: 'Guides',
    date: 'Aug 15, 2026',
    readTime: '5 min read',
    image: 'https://images.pexels.com/photos/12835320/pexels-photo-12835320.jpeg?auto=compress&cs=tinysrgb&w=800',
  },
  {
    title: 'How to Care for Your Mechanical Watch',
    excerpt: 'A well-maintained mechanical watch can last generations. Here are our expert tips for keeping your timepiece in pristine condition.',
    category: 'Care Tips',
    date: 'Aug 10, 2026',
    readTime: '7 min read',
    image: 'https://images.pexels.com/photos/28977357/pexels-photo-28977357.jpeg?auto=compress&cs=tinysrgb&w=800',
  },
  {
    title: 'The History of Japanese Watchmaking',
    excerpt: 'From Seiko\'s pioneering quartz revolution to Grand Seiko\'s artisanal craftsmanship, Japan has shaped modern horology.',
    category: 'History',
    date: 'Aug 5, 2026',
    readTime: '10 min read',
    image: 'https://images.pexels.com/photos/13548995/pexels-photo-13548995.jpeg?auto=compress&cs=tinysrgb&w=800',
  },
  {
    title: 'Choosing Your First Luxury Watch',
    excerpt: 'A first luxury watch is a milestone. We break down what to look for in terms of brand, movement, materials, and value.',
    category: 'Buying Guides',
    date: 'Jul 28, 2026',
    readTime: '6 min read',
    image: 'https://images.pexels.com/photos/16958879/pexels-photo-16958879.jpeg?auto=compress&cs=tinysrgb&w=800',
  },
  {
    title: 'Understanding Water Resistance Ratings',
    excerpt: 'What does 30m, 50m, or 200m water resistance actually mean? We demystify the specs so you can wear your watch with confidence.',
    category: 'Guides',
    date: 'Jul 20, 2026',
    readTime: '4 min read',
    image: 'https://images.pexels.com/photos/6157411/pexels-photo-6157411.jpeg?auto=compress&cs=tinysrgb&w=800',
  },
  {
    title: 'The Rise of Smart Hybrid Watches',
    excerpt: 'Hybrid smartwatches blend classic analog design with connected features. Here are the best options worth your attention.',
    category: 'Smart Watches',
    date: 'Jul 15, 2026',
    readTime: '5 min read',
    image: 'https://images.pexels.com/photos/18662969/pexels-photo-18662969.jpeg?auto=compress&cs=tinysrgb&w=800',
  },
];

export default function BlogPage() {
  return (
    <>
      <Seo
        title="Blog — ChronoBay"
        description="Watch guides, buying tips, and horological insights from the ChronoBay team."
      />

      <div className="border-b border-gray-200 bg-gray-50">
        <div className="container-wide py-3">
          <nav className="flex items-center gap-2 text-xs text-gray-500" aria-label="Breadcrumb">
            <Link to="/" className="hover:text-accent">Home</Link>
            <span aria-hidden="true">/</span>
            <span className="text-charcoal">Blog</span>
          </nav>
        </div>
      </div>

      <section className="bg-navy-600 py-12 lg:py-16">
        <div className="container-wide text-center">
          <span className="text-xs font-semibold uppercase tracking-[0.2em] text-accent">
            ChronoBay Journal
          </span>
          <h1 className="mt-3 text-[26px] font-bold text-white sm:text-[32px]">
            Watch Guides & Insights
          </h1>
          <p className="mx-auto mt-3 max-w-xl text-sm text-gray-300">
            Expert advice, brand histories, and care tips to help you get the most from your timepiece.
          </p>
        </div>
      </section>

      <div className="container-wide py-10 lg:py-16">
        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {posts.map((post) => (
            <article
              key={post.title}
              className="group flex flex-col overflow-hidden rounded border border-gray-200 bg-white transition-shadow hover:shadow-card"
            >
              <div className="relative aspect-[16/10] overflow-hidden bg-gray-100">
                <img
                  src={post.image}
                  alt={post.title}
                  loading="lazy"
                  className="h-full w-full object-cover transition-transform duration-500 group-hover:scale-105"
                />
                <span className="absolute left-3 top-3 rounded bg-accent px-2.5 py-1 text-xs font-semibold text-white">
                  {post.category}
                </span>
              </div>
              <div className="flex flex-1 flex-col p-5">
                <div className="flex items-center gap-3 text-xs text-gray-400">
                  <span className="flex items-center gap-1">
                    <Calendar className="h-3.5 w-3.5" aria-hidden="true" />
                    {post.date}
                  </span>
                  <span className="flex items-center gap-1">
                    <Clock className="h-3.5 w-3.5" aria-hidden="true" />
                    {post.readTime}
                  </span>
                </div>
                <h2 className="mt-3 text-base font-bold leading-snug text-charcoal group-hover:text-accent transition-colors">
                  {post.title}
                </h2>
                <p className="mt-2 flex-1 text-sm leading-relaxed text-gray-500">
                  {post.excerpt}
                </p>
                <Link
                  to="/blog"
                  className="mt-4 inline-flex items-center gap-1 text-sm font-medium text-accent hover:gap-2 transition-all"
                >
                  Read More
                  <ArrowRight className="h-4 w-4" aria-hidden="true" />
                </Link>
              </div>
            </article>
          ))}
        </div>
      </div>
    </>
  );
}
