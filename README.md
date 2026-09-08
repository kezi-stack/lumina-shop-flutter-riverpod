# Lumina Shop — Flutter + Riverpod

Projet de certification : application e-commerce mobile Flutter utilisant Riverpod comme unique solution de state management.

## Contenu

Le projet complet se trouve dans [`flutter_shop/`](flutter_shop/).

- Catalogue local avec liste, recherche, filtres, tri et détail produit
- Panier avec ajout, suppression, quantités et total
- Favoris persistés localement avec `SharedPreferences`
- Profil utilisateur mock
- États de chargement et d’erreur gérés avec `AsyncValue`
- Architecture en couches et providers Riverpod documentés
- Tests unitaires ciblés sur le panier et les filtres

## Lancer l’application

```bash
cd flutter_shop
flutter pub get
flutter run
```

Voir [`flutter_shop/README.md`](flutter_shop/README.md) pour le détail de l’architecture, la liste des providers et le parcours de démonstration.

## Validation

```bash
cd flutter_shop
flutter analyze
flutter test
```