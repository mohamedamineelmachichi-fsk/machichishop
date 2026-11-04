# MACHICHI STORE — Next.js + Supabase + Netlify

Boutique mode homme, interface client en darija RTL, panier et commande WhatsApp (+212620790347), administration sécurisée `/admin`.

## Démarrage rapide en local

1. Installer Node.js 22 (ou version LTS compatible).
2. Décompresser le ZIP puis ouvrir un terminal dans le dossier `machichi-store`.
3. `npm install`
4. Copier `.env.example` vers `.env.local` et renseigner `NEXT_PUBLIC_SUPABASE_URL` et `NEXT_PUBLIC_SUPABASE_ANON_KEY` (Supabase > Project Settings > API Keys).
5. Dans **Supabase > SQL Editor**, exécuter `supabase/setup.sql`.
6. Dans **Supabase > Authentication > Users**, créer le compte du propriétaire avec une adresse e-mail et un mot de passe confidentiels.
7. Dans **SQL Editor**, donner les droits de gestion à **ce compte uniquement** :

```sql
insert into public.admins(user_id)
select id from auth.users where email='VOTRE_EMAIL@example.com'
on conflict do nothing;
```

8. `npm run dev` ; ouvrir `http://localhost:3000` (boutique) et `http://localhost:3000/admin` (gestion).

**IMPORTANT :** Il ne faut PAS mettre de mot de passe, de clé `service_role` ou de clé Supabase secrète dans le code ni dans `NEXT_PUBLIC_*`. Utiliser uniquement la clé **publishable/anon**. La sécurité repose sur Authentication + RLS et la liste `public.admins`. Désactiver les inscriptions publiques si vous souhaitez éviter la création d'autres comptes (Authentication > Providers > Email). Définir un mot de passe fort.

## Publier sur Netlify

1. Créer un dépôt GitHub avec **le contenu** de ce dossier à la racine (il doit y avoir `app/` et `package.json`).
2. Netlify > Add new project > Import an existing project > GitHub > sélectionner le dépôt.
3. Build command `npm run build`; publish directory `.next` (le support Next.js de Netlify est automatique).
4. **Netlify > Project configuration > Environment variables** : ajouter les 2 valeurs de `.env.local`.
5. Lancer le déploiement puis ouvrir l'URL Netlify. Tester `/admin`.
6. Supabase > Authentication > URL Configuration : renseigner l'URL publique de Netlify dans `Site URL` (et les redirect URLs si vous activez un jour les liens e-mail).

## Produits, photos, couleurs et stock

- Le propriétaire se connecte à `/admin` et ajoute ou modifie les produits.
- Les photos sont stockées dans Supabase Storage, bucket public `product-images`, mais **seul un administrateur** peut uploader/modifier/supprimer.
- Le produit peut être enregistré comme **brouillon**. Sa publication exige au moins une photo et une combinaison taille/couleur avec un stock positif.
- Stock à configurer **séparément** pour chaque couleur et chaque taille. Bouton de commande désactivé pour les tailles épuisées.
- Les changements sont conservés après fermeture du navigateur et visibles immédiatement au prochain chargement du site.
- Les photos chargées mais ensuite retirées d'un produit peuvent rester dans Storage. Pour les supprimer physiquement, passer par Supabase Storage ; un nettoyage automatisé demanderait un endpoint sécurisé supplémentaire.

## Produits exemples et images

**Aucune donnée de stock n'est inventée.** Tant que Supabase n'est pas configuré, deux articles de démonstration apparaissent avec stock zéro ; on ne peut pas les commander. Après connexion, seuls les vrais produits publiés dans la base sont visibles ; ajoutez les vrais articles via `/admin`. Les deux photos de démonstration ont été recadrées à partir des **captures d'écran fournies**, uniquement pour aider à visualiser la mise en page. Vérifiez les droits d'utilisation commerciale et remplacez-les par vos propres photos avant publication. Pour créer les deux articles dans Supabase, renseignez leurs prix, images, tailles et quantités réellement disponibles dans l'interface d'administration.

Exemples à créer : BAGGY JEAN DARK BLUE (289 DH, ancien prix 390, tailles 31/32/33/34/36) et ENSEMBLE ZIPPER OVERSIZE (229 DH, tailles M/L/XL).

## Commande WhatsApp

1. Client ouvre un produit, choisit une **combinaison disponible** de couleur et taille, et une quantité <= au stock affiché.
2. Il ajoute au panier et peut ajouter d'autres modèles.
3. Il complète prénom, nom, téléphone, ville et adresse (notes facultatives).
4. Le site ouvre un lien `wa.me` avec un message encodé contenant tous les articles, quantités, prix et coordonnées.
5. **Le client doit cliquer Envoyer dans WhatsApp**. Le site ne signale jamais une commande confirmée simplement parce que WhatsApp s'est ouvert.
6. Les frais de livraison sont « à confirmer avec le magasin », ils ne sont pas inclus dans le total produits.

**Limite importante :** un panier WhatsApp ne constitue pas un système d'enregistrement de commandes, de réservation de stock, ni de synchronisation de stock en temps réel. Les quantités ne diminuent pas automatiquement après l'envoi d'un message ; mettez à jour le stock depuis l'administration une fois la commande acceptée. Pour des stocks garantis avec achats simultanés, il faudra ajouter une vraie gestion serveur de réservations / commandes.

## Tests de mise en production à exécuter

- Connexion du compte admin autorisé / refus d'un autre compte.
- Création brouillon, modification, upload multi-images, photos par couleur, publication, retrait, suppression.
- Vérifier l'absence de produits brouillons sur le site public, les filtres et la recherche.
- Tester sur Android/iOS, galerie, tailles hors stock, panier multi-produits et ouverture du lien WhatsApp.
- Tester les permissions RLS et Storage avec un compte non-admin.

## Contact

WhatsApp : +212620790347 — Instagram : @machichi.store — Facebook et TikTok dans le footer.
