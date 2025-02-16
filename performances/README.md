# **Benchmark : Performance et Fluidité - Flutter Web vs ReactJS**

## **1. Objectif**

Ce document détaille le protocole de test permettant de comparer les performances et la fluidité de Flutter Web et
ReactJS. L'objectif est d'obtenir des mesures chiffrées sur des critères clés, à l'aide d'outils standards, afin
d'identifier les forces et faiblesses de chaque technologie.

---

## **2. Scénarios de test**

Deux types d'applications seront développées pour effectuer les tests :

1. **Application statique simple** (page informative avec quelques interactions basiques)
2. **Application interactive complexe** (dashboard en temps réel avec graphiques et animations)

Chaque application sera développée en **Flutter Web** et en **ReactJS**, en appliquant des optimisations classiques pour
garantir une comparaison équitable.

---

## **3. Métriques et outils de mesure**

### **3.1 Critères de performance**

| Métrique                     | Description                                            |
|------------------------------|--------------------------------------------------------|
| Temps de chargement          | Temps avant affichage complet de la page               |
| First Contentful Paint (FCP) | Temps avant affichage du premier élément visible       |
| Time To Interactive (TTI)    | Temps avant que la page ne soit totalement interactive |
| Frames Per Second (FPS)      | Fluidité des animations et interactions                |
| Consommation CPU / mémoire   | Charge système durant l'exécution                      |

### **3.2 Outils utilisés**

- **Google Lighthouse** (Performance globale, FCP, TTI, FPS)
- **WebPageTest** (Temps de chargement, Waterfall analysis)
- **Chrome DevTools** (Profilage CPU/Mémoire)
- **Playwright / Puppeteer** (Tests d'interaction automatisés)

---

## **4. Plan de développement**

- Création d'une page de base avec HTML/CSS pour React et une structure équivalente en Flutter Web.
- Ajout de plusieurs composants interactifs : boutons, menus déroulants, et chargement d'images.
- Tests de chargement avec mise en cache activée et désactivée.
- Validation des performances avec Lighthouse et WebPageTest
- Comparaison des temps d'exécution avec et sans optimisations (lazy loading, compression d'assets).
- Mise en place d'un tableau de bord interactif avec Flutter Web et React.
- Intégration de graphiques en temps réel avec fl_chart pour Flutter et Chart.js pour React.
- Gestion des requêtes réseau : récupération des données depuis une API REST fictive.
- Mesure des performances sous charge (rafraîchissement de données en continu, animations simultanées).
- Tests sur plusieurs conditions réseau (Wi-Fi rapide, 4G, 3G).
- Analyse de la fluidité des interactions avec Chrome DevTools et Playwright.

---

## **5. Résultats préliminaires (valeurs fictives)**

| Métrique                     | Flutter Web  | ReactJS      |
|------------------------------|--------------|--------------|
| Temps de chargement (s)      | 3            | 3            |
| First Contentful Paint (FCP) | 1            | 1            |
| Time To Interactive (TTI)    | 1            | 1            |
| Frames Per Second (FPS)      | 60           | 60           |
| Consommation CPU / mémoire   | 15 % / 20 Mo | 15 % / 20 Mo |
