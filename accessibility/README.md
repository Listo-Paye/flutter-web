# Accessibilité – Benchmark d’Accessibilité

Ce document détaille la méthodologie et les résultats d’un benchmark comparatif sur l’accessibilité entre Flutter Web et
ReactJS. L’objectif est d’évaluer dans quelle mesure chacune de ces solutions permet de produire une application web
accessible, respectant les normes WCAG et offrant une expérience optimale aux utilisateurs en situation de handicap.

---

## 1. Objectif du Benchmark Accessibilité

L’objectif principal est de mesurer la capacité de chaque technologie à fournir un rendu accessible en se concentrant
sur :

- **La conformité aux normes WCAG** : S’assurer que le contenu et les fonctionnalités respectent les recommandations
  d’accessibilité.
- **L’utilisation des attributs ARIA et des éléments sémantiques** : Garantir que la structure de la page est clairement
  identifiable par les lecteurs d’écran et autres technologies d’assistance.
- **L’optimisation de la navigation** : Vérifier que l’ensemble des composants est accessible via le clavier et que le
  focus visuel est correctement géré.

---

## 2. Description du Projet de Référence

Le projet de référence est une application de gestion de tâches collaboratives, conçue pour permettre aux équipes de
suivre, organiser et modifier leurs projets de manière fluide et intuitive. Pour chacune des versions – Flutter Web et
ReactJS – les mêmes exigences d’accessibilité sont appliquées :

- **Architecture harmonisée**  
  L’interface est structurée autour d’un header, d’un menu de navigation latéral, d’un tableau de bord central affichant
  les tâches et d’un footer. Cette organisation vise à offrir une navigation claire et cohérente pour tous les
  utilisateurs.

- **Utilisation de balises sémantiques et d’attributs ARIA**  
  La version ReactJS s’appuie sur un rendu HTML natif structuré avec des éléments tels que `<header>`, `<nav>`, `<main>`
  et `<footer>`. La version Flutter Web, quant à elle, intègre des widgets *Semantics* et des attributs personnalisés
  pour assurer une identification claire des zones interactives et des contenus dynamiques.

- **Interaction et formulaires accessibles**  
  Les formulaires de création et de modification de tâches, ainsi que les interactions (boutons, menus déroulants,
  modales) sont conçus pour être navigables au clavier avec des indicateurs de focus bien définis et des labels
  explicites, garantissant une utilisation aisée par tous.

Ainsi, que ce soit via Flutter Web ou ReactJS, l’objectif est de produire une application de gestion de tâches dont
l’accessibilité est optimisée dès la conception.

---

## 3. Outils Utilisés

Pour évaluer l’accessibilité, les outils suivants sont mobilisés :

- **Google Lighthouse (section Accessibilité)** : Pour obtenir un score global d’accessibilité et identifier les points
  faibles dans la structure et l’implémentation.
- **axe Accessibility Checker** : Pour détecter les erreurs et les manquements aux standards WCAG.
- **WAVE (Web Accessibility Evaluation Tool)** : Pour visualiser les annotations et vérifier la présence des attributs
  ARIA et des éléments sémantiques.
- **Inspecteurs intégrés dans les navigateurs** : Pour analyser en détail le DOM et la navigation au clavier.

Ces outils offrent une évaluation complète de la conformité de chaque version aux bonnes pratiques d’accessibilité.

---

## 4. Méthodologie d’Évaluation et Critères

La méthodologie d’évaluation repose sur plusieurs axes :

### 4.1. Structure Sémantique et Attributs ARIA

- **Balises et éléments sémantiques**  
  Vérifier l’utilisation appropriée des balises structurantes (comme `<header>`, `<nav>`, `<main>`, `<footer>`) ou
  l’équivalent via les widgets *Semantics* dans Flutter.

- **Attributs ARIA**  
  S’assurer que les rôles et attributs ARIA sont correctement appliqués aux éléments interactifs pour faciliter leur
  interprétation par les lecteurs d’écran.

### 4.2. Navigation et Interaction

- **Navigation au clavier**  
  Tester la possibilité de naviguer sur l’ensemble de l’application uniquement au clavier, sans recours à la souris.

- **Focus visuel**  
  Vérifier que les indicateurs de focus sont clairement définis et visibles lors du parcours de la page.

- **Labels et textes alternatifs**  
  Examiner la présence de labels explicites pour les formulaires, boutons et autres éléments interactifs, assurant une
  bonne interprétation par les technologies d’assistance.

### 4.3. Conformité aux Normes WCAG

- **Analyse automatisée**  
  Utiliser les rapports générés par Google Lighthouse, axe et WAVE pour identifier les écarts par rapport aux critères
  WCAG (niveau AA, par exemple).

- **Tests manuels**  
  Effectuer des tests en simulant l’utilisation d’un lecteur d’écran (par exemple, NVDA ou VoiceOver) pour valider
  l’accessibilité réelle de l’application.

---

## 5. Résultats

| Métrique              | Flutter Web | ReactJS |
|-----------------------|-------------|---------|
| Indicateur Lighthouse | 100         | 92      |

---

## 6. Recommandations et Conclusion

En conclusion, ce benchmark d’accessibilité met en lumière que :

- **ReactJS** bénéficie naturellement d’un rendu HTML sémantique, facilitant ainsi le respect des normes
  d’accessibilité.
- **Flutter Web**, bien qu’exigeant une approche spécifique via l’utilisation des widgets *Semantics* et d’attributs
  personnalisés, peut atteindre des niveaux de conformité comparables lorsque les optimisations appropriées sont mises
  en œuvre.
