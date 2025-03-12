import NewsCard from "../components/NewsCard"
import {articles} from "../data/articles"

export default function HomePage() {
    const featuredArticle = articles[0]
    const recentArticles = articles.slice(1)

    return (
        <>
            <title>InfoFlash - L'actualité qui fait réfléchir</title>
            <meta
                name="description"
                content="Découvrez les dernières actualités et tendances avec InfoFlash, votre portail d'information de référence."
            />
            <link rel="canonical" href="https://infoflash.example.com"/>

            <section className="mb-10">
                <h1 className="text-3xl font-bold mb-6 pb-2 border-b border-slate-200">À la une</h1>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                    <NewsCard article={featuredArticle} featured={true}/>
                </div>
            </section>

            <section>
                <h2 className="text-2xl font-bold mb-6 pb-2 border-b border-slate-200">Actualités récentes</h2>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    {recentArticles.map((article) => (
                        <NewsCard key={article.id} article={article}/>
                    ))}
                </div>
            </section>
        </>
    )
}
