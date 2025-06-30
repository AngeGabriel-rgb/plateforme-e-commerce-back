-- CreateTable
CREATE TABLE "Utilisateur" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nom" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "motDePasse" TEXT NOT NULL,
    "adresseLivraison" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "Produit" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nom" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "prix" REAL NOT NULL,
    "stock" INTEGER NOT NULL,
    "marque" TEXT NOT NULL,
    "image" TEXT NOT NULL,
    "categorieId" INTEGER NOT NULL,
    CONSTRAINT "Produit_categorieId_fkey" FOREIGN KEY ("categorieId") REFERENCES "Categorie" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Categorie" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nom" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "Commande" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "dateCommande" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "statut" TEXT NOT NULL,
    "totalCommande" REAL NOT NULL,
    "modePaiement" TEXT NOT NULL,
    "adresseLivraison" TEXT NOT NULL,
    "utilisateurId" INTEGER NOT NULL,
    CONSTRAINT "Commande_utilisateurId_fkey" FOREIGN KEY ("utilisateurId") REFERENCES "Utilisateur" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "LigneCommande" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "commandeId" INTEGER NOT NULL,
    "produitId" INTEGER NOT NULL,
    "quantite" INTEGER NOT NULL,
    "prixUnitaire" REAL NOT NULL,
    CONSTRAINT "LigneCommande_commandeId_fkey" FOREIGN KEY ("commandeId") REFERENCES "Commande" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "LigneCommande_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "Produit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Panier" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "utilisateurId" INTEGER NOT NULL,
    "dateCreation" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Panier_utilisateurId_fkey" FOREIGN KEY ("utilisateurId") REFERENCES "Utilisateur" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "LignePanier" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "panierId" INTEGER NOT NULL,
    "produitId" INTEGER NOT NULL,
    "quantite" INTEGER NOT NULL,
    CONSTRAINT "LignePanier_panierId_fkey" FOREIGN KEY ("panierId") REFERENCES "Panier" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "LignePanier_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "Produit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Paiement" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "commandeId" INTEGER NOT NULL,
    "montant" REAL NOT NULL,
    "datePaiement" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "statut" TEXT NOT NULL,
    "methodePaiement" TEXT NOT NULL,
    CONSTRAINT "Paiement_commandeId_fkey" FOREIGN KEY ("commandeId") REFERENCES "Commande" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Avis" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "produitId" INTEGER NOT NULL,
    "utilisateurId" INTEGER NOT NULL,
    "note" INTEGER NOT NULL,
    "commentaire" TEXT,
    "dateAvis" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Avis_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "Produit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Avis_utilisateurId_fkey" FOREIGN KEY ("utilisateurId") REFERENCES "Utilisateur" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Promotion" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "codePromo" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "valeur" REAL NOT NULL,
    "dateDebut" DATETIME NOT NULL,
    "dateFin" DATETIME NOT NULL,
    "produitId" INTEGER NOT NULL,
    "administrateurId" INTEGER NOT NULL,
    CONSTRAINT "Promotion_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "Produit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Administrateur" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nom" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "motDePasse" TEXT NOT NULL,
    "role" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "GestionProduit" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "adminId" INTEGER NOT NULL,
    "produitId" INTEGER NOT NULL,
    "action" TEXT NOT NULL,
    "dateAction" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "GestionProduit_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "Administrateur" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "GestionProduit_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "Produit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "GestionCommande" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "adminId" INTEGER NOT NULL,
    "commandeId" INTEGER NOT NULL,
    "action" TEXT NOT NULL,
    "dateAction" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "GestionCommande_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "Administrateur" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "GestionCommande_commandeId_fkey" FOREIGN KEY ("commandeId") REFERENCES "Commande" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "GestionUtilisateur" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "adminId" INTEGER NOT NULL,
    "utilisateurId" INTEGER NOT NULL,
    "action" TEXT NOT NULL,
    "dateAction" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "GestionUtilisateur_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "Administrateur" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "GestionUtilisateur_utilisateurId_fkey" FOREIGN KEY ("utilisateurId") REFERENCES "Utilisateur" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "GestionPromotion" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "administrateurId" INTEGER NOT NULL,
    "promotionId" INTEGER NOT NULL,
    "action" TEXT NOT NULL,
    "dateAction" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "GestionPromotion_administrateurId_fkey" FOREIGN KEY ("administrateurId") REFERENCES "Administrateur" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "GestionPromotion_promotionId_fkey" FOREIGN KEY ("promotionId") REFERENCES "Promotion" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "Utilisateur_email_key" ON "Utilisateur"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Promotion_codePromo_key" ON "Promotion"("codePromo");

-- CreateIndex
CREATE UNIQUE INDEX "Administrateur_email_key" ON "Administrateur"("email");
