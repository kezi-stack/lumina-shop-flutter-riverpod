# Lumina Shop — Flutter + Riverpod

Projet de certification : application e-commerce mobile Flutter utilisant Riverpod comme unique solution de state management.

## Contenu

- Catalogue local avec liste, recherche, filtres, tri et détail produit
- Panier avec ajout, suppression, quantités et total
- Favoris persistés localement avec `SharedPreferences`
- Profil utilisateur mock
- États de chargement et d’erreur gérés avec `AsyncValue`
- Architecture en couches et providers Riverpod documentés
- Tests unitaires ciblés sur le panier et les filtres

## Lancer l’application

```bash
flutter pub get
flutter run
```

Voir les dossiers `lib/`, `assets/` et `test/` pour le code, les données locales et les tests.

## Architecture

Le projet suit une séparation en couches :

- `lib/data/models/` contient les modèles immuables (`Product`, `CartItem`, `Profile`).
- `lib/data/repositories/` encapsule les accès aux données locales et à `SharedPreferences`.
- `lib/presentation/providers/` contient l'état Riverpod et la logique de catalogue, favoris et panier.
- `lib/presentation/screens/` compose les écrans à partir des providers.
- `lib/presentation/widgets/` regroupe les composants réutilisables, dont les cartes produit et les images locales.
- `assets/products.json` fournit le catalogue mocké et `assets/images/` contient les visuels entièrement hors ligne.

## Providers Riverpod

Les providers sont centralisés dans `lib/presentation/providers/app_providers.dart` :

| Provider | Type | Rôle |
| --- | --- | --- |
| `productsProvider` | `FutureProvider` | Charge le catalogue depuis le JSON local. |
| `categoriesProvider` | `Provider` | Expose les catégories disponibles. |
| `searchQueryProvider` | `StateProvider` | Conserve la recherche saisie. |
| `selectedCategoryProvider` | `StateProvider` | Conserve le filtre de catégorie. |
| `sortOptionProvider` | `StateProvider` | Conserve le mode de tri. |
| `filteredProductsProvider` | `Provider` | Combine catalogue, recherche, filtre et tri. |
| `favoritesProvider` | `AsyncNotifierProvider` | Charge et persiste les favoris localement. |
| `profileProvider` | `Provider` | Expose le profil utilisateur mocké. |
| `cartProvider` | `StateNotifierProvider` | Gère les lignes, quantités et actions du panier. |
| `cartItemCountProvider` | `Provider` | Calcule le nombre total d'articles. |
| `cartTotalProvider` | `Provider` | Calcule le montant total du panier. |
| `currentTabProvider` | `StateProvider` | Contrôle l'onglet actif de la navigation. |

Les écrans observent ces providers avec `ref.watch`, tandis que les interactions utilisent `ref.read(...notifier)`. Les états asynchrones sont rendus avec `AsyncValue.when` afin de traiter explicitement chargement, succès et erreur.

## Validation

```bash
flutter analyze
flutter test
```