# Groupe 6 (Volkan AKTER et Théo CHALOYARD)

Notre projet à pour objectif de garantir une ordonnance d'un médécin qui utilise le système de génération d'ordonnance de Doctolib avec une API mi-décentralisée.

### Exemple de fonctionnement théorique :
   - Le médécin rédige l'ordonnace qui peut être de trois types différents (court,long,stupéfiant).
   - Lors de la création de l'ordonnance un token et généré puis transmis à l'espace santé du patient.
   - Le patient arrive à la pharmacie puis donne l'ordonnance.
   - La pharmacie demande le token au patient puis il vérifie si le token est valide.
   - Lorsque le token est validé et que l'ordonnace est composé des bonnes informations alors l'ordonnance est valide.

### Exemple de fonctionnement pratique :
   - Le médécin rédige l'ordonnace qui peut être de trois types différents (court,long,stupéfiant) = 
        - On utilise la fonction ```creerOrdonnance(RPPS,_valeurType)``` qui va prendre en entrée  le RPPS du médécin ce qui correspond à un code unique par médécin (exemple : 410003879623017) et une valeur comprise entre 1 et 3 qui correspond au type d'ordonnance (1=court,2=long,3=stupéfiant), après l'éxecution du code un token est généré (exemple : 0X042730D9D47312F9742EB464238BEA7CDF241D638DA3DF216872A2900C2448C3).
   - Lors de la création de l'ordonnance un token et généré puis transmis à l'espace santé du patient.
   - Le patient arrive à la pharmacie puis donne l'ordonnance.
   - La pharmacie demande le token au patient puis il vérifie si le token est valide.
        - On utilise la fonction ```verifierToken(identifiant de l'ordonnance,token de l'ordonnance)``` qui va prendre en entrée l'identifiant de l'ordonnance et le token puis va vérifier si le token correspond bien à celui de l'ordonnance et retourne true en cas de correspondance ou false en cas d'erreur.
   - Lorsque le token est validé et que l'ordonnace est composé des bonnes informations alors l'ordonnance est valide.
        - Pour vérifier si la date de l'ordonnance est valide on utilise la fonction ```verifierDateOrdonnance(identifiant de l'ordonnance)``` qui prend en entrée l'identifiant de l'ordonnance puis vérifie selon le type de l'ordonnance si l'ordonnance n'est pas périmé.
        - Pour vérifier les informations de l'ordonnance est valide on utilise la fonction ```obtenirOrdonnance(identifiant de l'ordonnance)``` qui prend en entrée l'identifiant de l'ordonnance puis retourne son identifiant, le RPPS du médécin, le type d'ordonnance et la date de création de l'ordonnance. 


## Explication détaillée du code Solidity

### **Structure:**

1. **Déclaration du contrat:**
   - Le code définit un contrat nommé `Ordonnances`.

2. **Structure d'Ordonnance:**
   - Une structure nommée `Ordonnance` est créée pour représenter une prescription médicale.
   - Elle possède les propriétés suivantes :
     - `id`: Un identifiant unique (uint256).
     - `RPPS`: Numéro d'identification du patient (string).
     - `contenu`: Type de prescription (enum TypeContrat).
     - `timestamp`: Horodatage de création (uint256).
     - `token`: Jeton unique associé à la prescription (bytes32).

3. **Mapping:**
   - Un mapping nommé `ordonnances` stocke toutes les prescriptions créées.
   - Il mappe un identifiant unique (uint256) à un objet Ordonnance.
   - Cela permet de récupérer les prescriptions par leur identifiant.

4. **Enumération:**
   - Une énumération nommée `TypeContrat` définit les types possibles de prescriptions :
     - COURT (court terme) = 90 jours.
     - LONG (long terme) = 365 jours.
     - STUPEFIANT (pour les substances contrôlées) = 3 jours.

5. **Evénements:**
   - Deux événements sont définis :
     - `OrdonnanceCreated`: Émis lors de la création d'une nouvelle prescription, en fournissant des détails tels que l'ID, le RPPS, le type, l'horodatage et le token.
     - `OrdonnanceDeleted`: Émis lors de la suppression d'une prescription, en indiquant son ID.

### **Fonctions:**

1. **Constructeur:**
   - Initialise la variable `ordonnanceCount` à 0, utilisée pour suivre la génération d'ID.

2. **creerOrdonnance:**
   - Crée une nouvelle prescription :
     - Incrémente `ordonnanceCount` pour attribuer un ID unique.
     - Valide la valeur de type fournie.
     - Convertit la valeur de type en type d'énumération correspondant.
     - Génère un jeton unique en utilisant le hachage Keccak-256.
     - Ajoute la nouvelle prescription au mapping `ordonnances`.
     - Déclenche l'événement `OrdonnanceCreated`.

3. **verifierDateOrdonnance:**
   - Vérifie si une prescription est toujours valide en fonction de son type et de l'horodatage de sa création :
     - Récupère la prescription à partir du mapping.
     - Détermine la période de validité en fonction du type de prescription.
     - Calcule le temps écoulé depuis la création.
     - Retourne un booléen indiquant si la prescription est toujours dans sa période de validité.

4. **obtenirOrdonnance:**
   - Retourne des informations sur une prescription avec l'ID spécifié :
     - Récupère la prescription à partir du mapping.
     - Retourne son ID, son RPPS, son type et son horodatage.

5. **verifierToken:**
   - Vérifie si un jeton fourni correspond au jeton associé à une prescription :
     - Récupère la prescription à partir du mapping.
     - Compare le jeton fourni avec le jeton de la prescription.
     - Retourne un booléen indiquant s'ils correspondent.

6. **supprimerOrdonnance:**
   - Supprime une prescription du mapping :
     - Supprime la prescription du mapping `ordonnances` en utilisant son ID.
     - Déclenche l'événement `OrdonnanceDeleted`.

