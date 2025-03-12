const Footer = () => {
  const currentYear = new Date().getFullYear()

  return (
    <footer className="bg-white border-t border-gray-200 py-4">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col md:flex-row md:items-center md:justify-between">
          <div className="flex items-center">
            <p className="text-gray-500 text-sm">&copy; {currentYear} Gestion de Tâches Collaboratives</p>
          </div>

          <nav className="mt-4 md:mt-0" aria-label="Liens du pied de page">
            <ul className="flex space-x-6">
              <li>
                <a
                  href="#privacy"
                  className="text-sm text-gray-500 hover:text-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500 rounded-md"
                >
                  Confidentialité
                </a>
              </li>
              <li>
                <a
                  href="#terms"
                  className="text-sm text-gray-500 hover:text-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500 rounded-md"
                >
                  Conditions d'utilisation
                </a>
              </li>
              <li>
                <a
                  href="#contact"
                  className="text-sm text-gray-500 hover:text-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500 rounded-md"
                >
                  Contact
                </a>
              </li>
            </ul>
          </nav>
        </div>
      </div>
    </footer>
  )
}

export default Footer

