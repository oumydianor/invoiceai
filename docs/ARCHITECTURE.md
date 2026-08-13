# Architecture

Le projet suit MVVM avec Provider et une injection explicite.

- `app/` : démarrage, environnement, injection, routeur et thème.
- `core/` : erreurs, résultats, services, responsive, utilitaires et composants partagés.
- `features/authentication/domain/` : entités, contrats et cas d’usage sans dépendance Firebase.
- `features/authentication/data/` : DTO, mappers et implémentations Firebase.
- `features/authentication/presentation/` : pages, ViewModels et widgets.

Les widgets ne doivent jamais appeler Firebase directement. Les dépendances sont fournies à la racine. Les ViewModels ne conservent pas de `BuildContext` et exposent des états explicites.

La fondation actuelle utilise des pages clairement identifiées comme non connectées. Elles seront remplacées progressivement pendant la phase Authentification.

## Prototype de facturation

Le module `features/invoicing/` illustre le parcours métier principal sans backend :

- `domain/` contient les modèles immuables `Invoice`, `InvoiceLine`, `Client` et `InvoiceDraft` ;
- `application/` contient le parseur de texte français, remplaçable ensuite par un adaptateur vers une API d’IA ;
- `presentation/state/` fournit un `DemoStore` en mémoire avec les données et actions de démonstration ;
- `presentation/pages/` regroupe les écrans indépendants du stockage ;
- `presentation/widgets/` contient le shell responsive et les composants de facture partagés.

Le `DemoStore` est injecté au démarrage avec Provider. Pour passer en production, introduire un contrat de dépôt dans `domain/`, implémenter ce contrat avec Firestore ou une API, puis injecter cette implémentation sans modifier les pages.
