"use client"

import {useParams} from "react-router-dom"
import {useEffect, useState} from "react"
import {articles} from "../data/articles"
import type {Article} from "../data/articles"
import NewsCard from "../components/NewsCard"

export default function CategoryPage() {
    const {category} = useParams<{ category: string }>()
    const [categoryArticles, setCategoryArticles] = useState<Article[]>([])

    useEffect(() => {
        if (category) {
            const filtered = articles.filter((a) => a.category.toLowerCase() === category.toLowerCase())
            setCategoryArticles(filtered)
        }
    }, [category])

    const categoryTitle = category ? category.charAt(0).toUpperCase() + category.slice(1) : ""

    return (
        <>
            <title>{categoryTitle} | InfoFlash</title>
            <meta
                name="description"
                content={`Découvrez toutes les actualités de la catégorie ${categoryTitle} sur InfoFlash`}
            />
            <link rel="canonical" href={`https://infoflash.example.com/category/${category}`}/>

            <section>
                <h1 className="text-3xl font-bold mb-8 pb-2 border-b border-slate-200">Catégorie : {categoryTitle}</h1>

                {categoryArticles.length > 0 ? (
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        {categoryArticles.map((article) => (
                            <NewsCard key={article.id} article={article}/>
                        ))}
                    </div>
                ) : (
                    <div className="text-center py-12 text-slate-600">Aucun article trouvé dans cette catégorie</div>
                )}
            </section>
        </>
    )
}
