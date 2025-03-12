import { Link } from "react-router-dom"

export default function Footer() {
  return (
    <footer className="bg-slate-900 text-white py-8">
      <div className="container mx-auto px-4">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div>
            <h3 className="text-xl font-bold mb-4">
              <span className="text-orange-500">Info</span>Flash
            </h3>
            <p className="text-slate-300">
              Votre portail d'information pour rester informé des dernières actualités et tendances.
            </p>
          </div>

          <div>
            <h4 className="text-lg font-semibold mb-4">Catégories</h4>
            <ul className="space-y-2">
              <li>
                <Link to="/category/politique" className="text-slate-300 hover:text-orange-400">
                  Politique
                </Link>
              </li>
              <li>
                <Link to="/category/economie" className="text-slate-300 hover:text-orange-400">
                  Économie
                </Link>
              </li>
              <li>
                <Link to="/category/science" className="text-slate-300 hover:text-orange-400">
                  Science
                </Link>
              </li>
              <li>
                <Link to="/category/culture" className="text-slate-300 hover:text-orange-400">
                  Culture
                </Link>
              </li>
              <li>
                <Link to="/category/sport" className="text-slate-300 hover:text-orange-400">
                  Sport
                </Link>
              </li>
            </ul>
          </div>

          <div>
            <h4 className="text-lg font-semibold mb-4">À propos</h4>
            <ul className="space-y-2">
              <li>
                <Link to="/about" className="text-slate-300 hover:text-orange-400">
                  Notre équipe
                </Link>
              </li>
              <li>
                <Link to="/ethics" className="text-slate-300 hover:text-orange-400">
                  Charte éditoriale
                </Link>
              </li>
              <li>
                <Link to="/contact" className="text-slate-300 hover:text-orange-400">
                  Contact
                </Link>
              </li>
            </ul>
          </div>

          <div>
            <h4 className="text-lg font-semibold mb-4">Légal</h4>
            <ul className="space-y-2">
              <li>
                <Link to="/terms" className="text-slate-300 hover:text-orange-400">
                  Conditions d'utilisation
                </Link>
              </li>
              <li>
                <Link to="/privacy" className="text-slate-300 hover:text-orange-400">
                  Politique de confidentialité
                </Link>
              </li>
              <li>
                <Link to="/cookies" className="text-slate-300 hover:text-orange-400">
                  Gestion des cookies
                </Link>
              </li>
            </ul>
          </div>
        </div>

        <div className="border-t border-slate-700 mt-8 pt-6 text-center text-slate-400">
          <p>© {new Date().getFullYear()} InfoFlash. Tous droits réservés.</p>
          <p className="mt-2 text-xs">Contenu fictif - Créé à des fins de démonstration</p>
        </div>
      </div>
    </footer>
  )
}

