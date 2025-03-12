"use client"

import { useState } from "react"

interface HeaderProps {
  onMenuToggle: () => void
}

const Header = ({ onMenuToggle }: HeaderProps) => {
  const [userMenuOpen, setUserMenuOpen] = useState(false)

  return (
    <header className="bg-white border-b border-gray-200 shadow-sm">
      <div className="px-4 py-3 flex items-center justify-between">
        <div className="flex items-center">
          <button
            type="button"
            className="p-2 rounded-md text-gray-600 hover:text-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500"
            onClick={onMenuToggle}
            aria-label="Menu de navigation"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-6 w-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
            </svg>
          </button>

          <h1 className="ml-4 text-xl font-semibold text-gray-800">Gestion de Tâches Collaboratives</h1>
        </div>

        <div className="relative">
          <button
            type="button"
            className="flex items-center space-x-2 p-2 rounded-full hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
            onClick={() => setUserMenuOpen(!userMenuOpen)}
            aria-expanded={userMenuOpen}
            aria-haspopup="true"
            aria-label="Menu utilisateur"
          >
            <div className="w-8 h-8 rounded-full bg-blue-500 flex items-center justify-center text-white">
              <span aria-hidden="true">U</span>
            </div>
            <span className="hidden md:inline-block">Utilisateur</span>
          </button>

          {userMenuOpen && (
            <div
              className="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-10 border border-gray-200"
              role="menu"
              aria-orientation="vertical"
              aria-labelledby="user-menu"
            >
              <a
                href="#profile"
                className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 focus:outline-none focus:bg-gray-100"
                role="menuitem"
              >
                Profil
              </a>
              <a
                href="#settings"
                className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 focus:outline-none focus:bg-gray-100"
                role="menuitem"
              >
                Paramètres
              </a>
              <a
                href="#logout"
                className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 focus:outline-none focus:bg-gray-100"
                role="menuitem"
              >
                Déconnexion
              </a>
            </div>
          )}
        </div>
      </div>
    </header>
  )
}

export default Header

