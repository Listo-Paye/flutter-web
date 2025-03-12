import {BrowserRouter as Router, Routes, Route} from "react-router-dom"
import Header from "./components/Header"
import Footer from "./components/Footer"
import HomePage from "./pages/HomePage"
import ArticlePage from "./pages/ArticlePage"
import CategoryPage from "./pages/CategoryPage"

function App() {
    return (
        <Router>
            <div className="min-h-screen flex flex-col">
                <title>InfoFlash - L'actualité qui fait réfléchir</title>
                <meta
                    name="description"
                    content="Découvrez les dernières actualités et tendances avec InfoFlash, votre portail d'information de référence."
                />
                <meta property="og:title" content="InfoFlash - L'actualité qui fait réfléchir"/>
                <meta
                    property="og:description"
                    content="Découvrez les dernières actualités et tendances avec InfoFlash, votre portail d'information de référence."
                />
                <meta property="og:type" content="website"/>
                <meta property="og:url" content="https://infoflash.example.com"/>
                <meta property="og:image" content="/og-image.jpg"/>
                <link rel="canonical" href="https://infoflash.example.com"/>
                <Header/>
                <main className="flex-grow container mx-auto px-4 py-8">
                    <Routes>
                        <Route path="/" element={<HomePage/>}/>
                        <Route path="/article/:id" element={<ArticlePage/>}/>
                        <Route path="/category/:category" element={<CategoryPage/>}/>
                    </Routes>
                </main>
                <Footer/>
            </div>
        </Router>
    )
}

export default App
