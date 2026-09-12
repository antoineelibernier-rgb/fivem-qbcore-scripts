# Système de Gestion d'Entreprises FiveM QBcore

Système complet de gestion d'entreprises pour serveur GTA RP FiveM utilisant le framework QBcore.

## Fonctionnalités

### 🏢 Gestion des Entreprises
- ✅ Admin peut créer des entreprises personnalisées
- ✅ Admin peut définir propriétaires et boss pour chaque entreprise
- ✅ Admin est automatiquement propriétaire de TOUTES les entreprises
- ✅ Systèmes de hiérarchie (Propriétaire > Boss > Employé)

### 💼 Tablette de Gestion
- ✅ Accès réservé aux boss et propriétaires
- ✅ Vue d'ensemble avec statistiques en temps réel
- ✅ Gestion des employés
- ✅ Statistiques de l'entreprise
- ✅ Gestion des finances

### 👥 Recrutement
- ✅ Boss peut recruter les joueurs à proximité
- ✅ Proposition de contrat avec acceptation/refus
- ✅ Système d'employés avec suivi

### 💰 Système de Paiement
- ✅ Paiement automatique des employés
- ✅ Déduction depuis le solde de l'entreprise
- ✅ Notifications de paiement

### 📊 Statistiques
- ✅ Revenus totaux
- ✅ Dépenses totales
- ✅ Employés embauchés/licenciés
- ✅ Historique des transactions

## Installation

1. Cloner le repository dans votre dossier `resources`
   ```bash
   cd resources
   git clone https://github.com/antoineelibernier-rgb/fivem-qbcore-scripts.git
   ```

2. Ajouter à votre `server.cfg`
   ```
   ensure fivem-qbcore-scripts
   ```

3. Redémarrer le serveur

## Dépendances

- qb-core
- qb-menu
- qb-target (pour les zones de interaction)

## Commandes

### Admin
```
/createjob [nom] [label]      - Créer un nouveau job
/setboss [company] [playerId] - Définir un boss
/setowner [company] [playerId]- Définir un propriétaire
```

### Joueur
```
/tablet                       - Ouvrir la tablette (boss/owner)
/fireemployee [playerId]      - Licencier un employé (boss/owner)
```

## Configuration

Modifiez `shared/config.lua` pour:
- Ajouter/modifier les entreprises
- Changer les salaires de base
- Modifier l'intervalle de paiement
- Configurer les permissions

## Structure du Projet

```
├── fxmanifest.lua
├── shared/
│   ├── config.lua
│   └── functions.lua
├── server/
│   ├── database.lua
│   └── main.lua
├── client/
│   └── main.lua
└── ui/
    ├── index.html
    ├── style.css
    └── script.js
```

## Développement

### Ajouter une Nouvelle Entreprise

1. Ouvrir `shared/config.lua`
2. Ajouter dans `Config.Companies`:
   ```lua
   ['company_name'] = {
       name = 'company_name',
       label = 'Company Label',
       icon = 'icon_name',
       location = vector3(x, y, z),
       boss_location = vector3(x, y, z),
       recruiter_offset = 2.0,
       salary = 500,
       maxEmployees = 15,
   },
   ```

3. Utiliser `/createjob company_name "Company Label"`

## Problèmes Connus

- La base de données est actuellement en mémoire (non persistante)
- À intégrer avec une vraie base de données (MySQL)

## Roadmap

- [ ] Intégration MySQL
- [ ] Système de permissions granulaire
- [ ] Logs des actions
- [ ] Interface de gestion améliorée
- [ ] Système d'audit
- [ ] Suppression d'entreprises
- [ ] Transfert de propriétaire

## Support

Pour les problèmes ou suggestions, créez une issue sur GitHub.

## Licence

MIT License - Voir LICENSE pour plus de détails

## Auteur

Antoine Elibernier - [@antoineelibernier-rgb](https://github.com/antoineelibernier-rgb)
