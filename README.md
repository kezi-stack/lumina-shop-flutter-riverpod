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

## Validation

```bash
flutter analyze
flutter test
```