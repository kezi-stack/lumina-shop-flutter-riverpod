# Lumina Shop — projet de certification Flutter

Application e-commerce mobile construite avec Flutter et Riverpod. Le projet couvre le catalogue, le détail produit, le panier, les favoris persistés, le filtrage/tri et un profil utilisateur mock.

## Démarrer le projet

Pré-requis : Flutter 3.22+ et Dart 3.4+.

```bash
cd flutter_shop
flutter pub get
flutter run
```

Pour lancer les tests :

```bash
flutter test
```

## Architecture en couches

```text
lib/
├── core/
│   └── theme/                 # Design system et thème Material 3
├── data/
│   ├── models/                # Product, CartItem, Profile
│   └── repositories/          # Accès aux produits JSON et SharedPreferences
├── presentation/
│   ├── providers/             # État et logique métier Riverpod
│   ├── screens/               # Écrans et composition des parcours
│   └── widgets/               # Composants réutilisables
└── main.dart
```

La couche `data` ne dépend pas des widgets. Les écrans consomment les providers et délèguent les mutations aux notifiers : aucune logique métier n’est stockée dans les widgets.

## Providers Riverpod

| Provider | Type | Responsabilité |
|---|---|---|
| `productRepositoryProvider` | `Provider` | Expose le repository produit |
| `productsProvider` | `FutureProvider` | Charge les produits depuis `assets/products.json` |
| `sharedPreferencesProvider` | `FutureProvider` | Initialise la persistance locale |
| `favoritesRepositoryProvider` | `FutureProvider` | Expose l’accès aux favoris persistés |
| `favoritesProvider` | `AsyncNotifierProvider` | Lit et modifie les favoris avec `AsyncValue` |
| `productFilterProvider` | `StateNotifierProvider` | Gère recherche, catégorie et tri |
| `categoriesProvider` | `Provider` | Dérive les catégories disponibles |
| `filteredProductsProvider` | `Provider` | Dérive la liste filtrée et triée |
| `cartProvider` | `StateNotifierProvider` | Gère ajout, suppression et quantités |
| `cartCountProvider` | `Provider` | Calcule le nombre d’articles du badge |
| `cartSubtotalProvider` | `Provider` | Calcule le sous-total du panier |
| `profileProvider` | `Provider` | Fournit les données du profil mock |
| `currentTabProvider` | `StateProvider` | Gère l’onglet actif de la navigation |

## Exigences couvertes

- **Catalogue liste + détail** : `CatalogScreen` et `ProductDetailScreen`.
- **Panier** : ajout depuis le détail, suppression, quantité +/- et total.
- **Favoris persistés** : `FavoritesNotifier` + `SharedPreferences`.
- **Filtrage et tri** : recherche textuelle, catégories, prix croissant/décroissant, note.
- **Profil utilisateur** : `ProfileScreen` avec données mock et actions simulées.
- **Riverpod exclusivement** : tous les états applicatifs sont portés par des providers/notifiers.
- **États loading/error** : `AsyncValue.when` est utilisé pour les produits et les favoris.
- **Données asynchrones** : les produits sont chargés via `FutureProvider` depuis un asset JSON.
- **Bonus** : feedback SnackBar lors de l’ajout au panier et états visuels sur favoris.

## Démonstration rapide

1. Ouvrir l’onglet Découvrir et attendre le chargement asynchrone.
2. Rechercher « lin », sélectionner une catégorie ou changer le tri.
3. Ouvrir un produit, l’ajouter au panier puis modifier la quantité.
4. Marquer un produit comme favori, relancer l’application et vérifier qu’il reste présent.
5. Consulter les onglets Favoris, Panier et Profil.

## Note pour la livraison GitHub

Le dossier `flutter_shop` est autonome : il peut être copié dans un dépôt public GitHub et lancé sans backend ni clé API. Les images de démonstration utilisent des URLs publiques Unsplash ; le catalogue lui-même reste local et déterministe.