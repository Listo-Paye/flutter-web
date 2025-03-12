import { Link } from "react-router-dom"
import { formatDistanceToNow } from "date-fns"
import { fr } from "date-fns/locale"
import type { Article } from "../data/articles"

interface NewsCardProps {
  article: Article
  featured?: boolean
}

export default function NewsCard({ article, featured = false }: NewsCardProps) {
  const formattedDate = formatDistanceToNow(new Date(article.publishedAt), {
    addSuffix: true,
    locale: fr,
  })

  if (featured) {
    return (
      <article className="col-span-full md:col-span-2 bg-white rounded-lg overflow-hidden shadow-lg hover:shadow-xl transition-shadow">
        <Link to={`/article/${article.id}`} className="block">
          <img src={article.image || "/placeholder.svg"} alt={article.title} className="w-full h-64 object-cover" />
          <div className="p-6">
            <span className="inline-block bg-orange-100 text-orange-600 text-xs font-semibold px-2 py-1 rounded-md uppercase mb-2">
              {article.category}
            </span>
            <h2 className="text-2xl font-bold mb-3">{article.title}</h2>
            <p className="text-slate-600 mb-4 line-clamp-3">{article.excerpt}</p>
            <div className="flex justify-between items-center text-sm text-slate-500">
              <span>{article.author}</span>
              <time dateTime={article.publishedAt}>{formattedDate}</time>
            </div>
          </div>
        </Link>
      </article>
    )
  }

  return (
    <article className="bg-white rounded-lg overflow-hidden shadow hover:shadow-md transition-shadow">
      <Link to={`/article/${article.id}`} className="block">
        <img src={article.image || "/placeholder.svg"} alt={article.title} className="w-full h-48 object-cover" />
        <div className="p-4">
          <span className="inline-block bg-orange-100 text-orange-600 text-xs font-semibold px-2 py-1 rounded-md uppercase mb-2">
            {article.category}
          </span>
          <h3 className="text-xl font-bold mb-2">{article.title}</h3>
          <p className="text-slate-600 mb-3 line-clamp-2">{article.excerpt}</p>
          <div className="flex justify-between items-center text-xs text-slate-500">
            <span>{article.author}</span>
            <time dateTime={article.publishedAt}>{formattedDate}</time>
          </div>
        </div>
      </Link>
    </article>
  )
}

