"use client"

import {useParams} from "react-router-dom"
import {useEffect, useState} from "react"
import {articles} from "../data/articles"
import type {Article} from "../data/articles"
import {formatDistanceToNow} from "date-fns"
import {fr} from "date-fns/locale"
import NewsCard from "../components/NewsCard"

export default function ArticlePage() {
    const {id} = useParams<{ id: string }>()
    const [article, setArticle] = useState<Article | null>(null)
    const [relatedArticles, setRelatedArticles] = useState<Article[]>([])

    useEffect(() => {
        if (id) {
            const currentArticle = articles.find((a) => a.id === id) || null
            setArticle(currentArticle)

            if (currentArticle) {
                const related = articles.filter((a) => a.category === currentArticle.category && a.id !== id).slice(0, 3)
                setRelatedArticles(related)
            }
        }
    }, [id])

    if (!article) {
        return <div className="text-center py-12">Article non trouvé</div>
    }

    const formattedDate = formatDistanceToNow(new Date(article.publishedAt), {
        addSuffix: true,
        locale: fr,
    })

    return (
        <>
            <title>{article.title} | InfoFlash</title>
            <meta name="description" content={article.excerpt}/>
            <meta property="og:title" content={article.title}/>
            <meta property="og:description" content={article.excerpt}/>
            <meta property="og:image" content={article.image}/>
            <meta property="og:type" content="article"/>
            <meta property="og:url" content={`https://infoflash.example.com/article/${article.id}`}/>
            <link rel="canonical" href={`https://infoflash.example.com/article/${article.id}`}/>

            <article className="max-w-4xl mx-auto">
                <header className="mb-8">
          <span
              className="inline-block bg-orange-100 text-orange-600 text-sm font-semibold px-3 py-1 rounded-md uppercase mb-4">
            {article.category}
          </span>
                    <h1 className="text-4xl font-bold mb-4">{article.title}</h1>
                    <p className="text-xl text-slate-600 mb-6">{article.excerpt}</p>
                    <div className="flex items-center justify-between border-b border-slate-200 pb-4">
                        <div className="flex items-center">
                            <img
                                src={`/placeholder.svg?height=40&width=40`}
                                alt={article.author}
                                className="w-10 h-10 rounded-full mr-3"
                            />
                            <span className="font-medium">{article.author}</span>
                        </div>
                        <time dateTime={article.publishedAt} className="text-slate-500">
                            {formattedDate}
                        </time>
                    </div>
                </header>

                <img
                    src={article.image || "/placeholder.svg"}
                    alt={article.title}
                    className="w-full h-[400px] object-cover rounded-lg mb-8"
                />

                <div className="prose prose-slate max-w-none mb-12"
                     dangerouslySetInnerHTML={{__html: article.content}}/>

                {relatedArticles.length > 0 && (
                    <section className="mt-12 pt-8 border-t border-slate-200">
                        <h2 className="text-2xl font-bold mb-6">Articles connexes</h2>
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                            {relatedArticles.map((relatedArticle) => (
                                <NewsCard key={relatedArticle.id} article={relatedArticle}/>
                            ))}
                        </div>
                    </section>
                )}
            </article>
        </>
    )
}
