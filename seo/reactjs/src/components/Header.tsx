"use client"

import { useState } from "react"
import { Link } from "react-router-dom"
import { Menu, X, Search } from "lucide-react"

const categories = [
  { name: "Politique", slug: "politique" },
  { name: "Économie", slug: "economie" },
  { name: "Science", slug: "science" },
  { name: "Culture", slug: "culture" },
  { name: "Sport", slug: "sport" },
]

export default function Header() {
  const [isMenuOpen, setIsMenuOpen] = useState(false)

  return (
    <header className="bg-slate-900 text-white shadow-md">
      <div className="container mx-auto px-4 py-4">
        <div className="flex justify-between items-center">
          <Link to="/" className="text-2xl font-bold">
            <span className="text-orange-500">Info</span>Flash
          </Link>

          <div className="hidden md:flex items-center space-x-6">
            {categories.map((category) => (
              <Link
                key={category.slug}
                to={`/category/${category.slug}`}
                className="hover:text-orange-400 transition-colors"
              >
                {category.name}
              </Link>
            ))}
          </div>

          <div className="flex items-center space-x-4">
            <div className="relative hidden md:block">
              <input
                type="text"
                placeholder="Rechercher..."
                className="bg-slate-800 text-white px-3 py-1 rounded-md text-sm focus:outline-none focus:ring-2 focus:ring-orange-500 w-40"
              />
              <Search className="absolute right-2 top-1/2 transform -translate-y-1/2 h-4 w-4 text-slate-400" />
            </div>

            <button className="md:hidden" onClick={() => setIsMenuOpen(!isMenuOpen)}>
              {isMenuOpen ? <X /> : <Menu />}
            </button>
          </div>
        </div>

        {isMenuOpen && (
          <nav className="mt-4 pb-4 md:hidden">
            <ul className="flex flex-col space-y-2">
              {categories.map((category) => (
                <li key={category.slug}>
                  <Link
                    to={`/category/${category.slug}`}
                    className="block hover:text-orange-400 transition-colors"
                    onClick={() => setIsMenuOpen(false)}
                  >
                    {category.name}
                  </Link>
                </li>
              ))}
              <li className="pt-2">
                <div className="relative">
                  <input
                    type="text"
                    placeholder="Rechercher..."
                    className="bg-slate-800 text-white px-3 py-1 rounded-md text-sm focus:outline-none focus:ring-2 focus:ring-orange-500 w-full"
                  />
                  <Search className="absolute right-2 top-1/2 transform -translate-y-1/2 h-4 w-4 text-slate-400" />
                </div>
              </li>
            </ul>
          </nav>
        )}
      </div>
    </header>
  )
}

