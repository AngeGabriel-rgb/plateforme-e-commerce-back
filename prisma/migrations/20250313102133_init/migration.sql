/*
  Warnings:

  - You are about to drop the `Administrateur` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Avis` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Categorie` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Commande` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `GestionCommande` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `GestionProduit` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `GestionPromotion` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `GestionUtilisateur` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `LigneCommande` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `LignePanier` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Paiement` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Panier` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Produit` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Promotion` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Utilisateur` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "Administrateur";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "Avis";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "Categorie";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "Commande";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "GestionCommande";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "GestionProduit";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "GestionPromotion";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "GestionUtilisateur";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "LigneCommande";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "LignePanier";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "Paiement";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "Panier";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "Produit";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "Promotion";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "Utilisateur";
PRAGMA foreign_keys=on;

-- CreateTable
CREATE TABLE "utilisateur" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nom" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "motDePasse" TEXT NOT NULL,
    "adresseLivraison" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "produit" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nom" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "prix" REAL NOT NULL,
    "stock" INTEGER NOT NULL,
    "marque" TEXT NOT NULL,
    "image" TEXT NOT NULL,
    "categorieId" INTEGER NOT NULL,
    CONSTRAINT "produit_categorieId_fkey" FOREIGN KEY ("categorieId") REFERENCES "categorie" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "categorie" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nom" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "commande" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "dateCommande" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "statut" TEXT NOT NULL,
    "totalCommande" REAL NOT NULL,
    "modePaiement" TEXT NOT NULL,
    "adresseLivraison" TEXT NOT NULL,
    "utilisateurId" INTEGER NOT NULL,
    CONSTRAINT "commande_utilisateurId_fkey" FOREIGN KEY ("utilisateurId") REFERENCES "utilisateur" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ligneCommande" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "commandeId" INTEGER NOT NULL,
    "produitId" INTEGER NOT NULL,
    "quantite" INTEGER NOT NULL,
    "prixUnitaire" REAL NOT NULL,
    CONSTRAINT "ligneCommande_commandeId_fkey" FOREIGN KEY ("commandeId") REFERENCES "commande" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "ligneCommande_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "produit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "panier" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "utilisateurId" INTEGER NOT NULL,
    "dateCreation" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "panier_utilisateurId_fkey" FOREIGN KEY ("utilisateurId") REFERENCES "utilisateur" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "lignePanier" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "panierId" INTEGER NOT NULL,
    "produitId" INTEGER NOT NULL,
    "quantite" INTEGER NOT NULL,
    CONSTRAINT "lignePanier_panierId_fkey" FOREIGN KEY ("panierId") REFERENCES "panier" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "lignePanier_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "produit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "paiement" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "commandeId" INTEGER NOT NULL,
    "montant" REAL NOT NULL,
    "datePaiement" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "statut" TEXT NOT NULL,
    "methodePaiement" TEXT NOT NULL,
    CONSTRAINT "paiement_commandeId_fkey" FOREIGN KEY ("commandeId") REFERENCES "commande" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "avis" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "produitId" INTEGER NOT NULL,
    "utilisateurId" INTEGER NOT NULL,
    "note" INTEGER NOT NULL,
    "commentaire" TEXT,
    "dateAvis" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "avis_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "produit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "avis_utilisateurId_fkey" FOREIGN KEY ("utilisateurId") REFERENCES "utilisateur" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "promotion" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "codePromo" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "valeur" REAL NOT NULL,
    "dateDebut" DATETIME NOT NULL,
    "dateFin" DATETIME NOT NULL,
    "produitId" INTEGER NOT NULL,
    "administrateurId" INTEGER NOT NULL,
    CONSTRAINT "promotion_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "produit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "administrateur" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nom" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "gestionProduit" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "adminId" INTEGER NOT NULL,
    "produitId" INTEGER NOT NULL,
    "action" TEXT NOT NULL,
    "dateAction" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "gestionProduit_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "administrateur" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "gestionProduit_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "produit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "gestionCommande" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "adminId" INTEGER NOT NULL,
    "commandeId" INTEGER NOT NULL,
    "action" TEXT NOT NULL,
    "dateAction" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "gestionCommande_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "administrateur" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "gestionCommande_commandeId_fkey" FOREIGN KEY ("commandeId") REFERENCES "commande" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "gestionUtilisateur" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "adminId" INTEGER NOT NULL,
    "utilisateurId" INTEGER NOT NULL,
    "action" TEXT NOT NULL,
    "dateAction" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "gestionUtilisateur_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "administrateur" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "gestionUtilisateur_utilisateurId_fkey" FOREIGN KEY ("utilisateurId") REFERENCES "utilisateur" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "gestionPromotion" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "administrateurId" INTEGER NOT NULL,
    "promotionId" INTEGER NOT NULL,
    "action" TEXT NOT NULL,
    "dateAction" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "gestionPromotion_administrateurId_fkey" FOREIGN KEY ("administrateurId") REFERENCES "administrateur" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "gestionPromotion_promotionId_fkey" FOREIGN KEY ("promotionId") REFERENCES "promotion" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "utilisateur_email_key" ON "utilisateur"("email");

-- CreateIndex
CREATE UNIQUE INDEX "promotion_codePromo_key" ON "promotion"("codePromo");

-- CreateIndex
CREATE UNIQUE INDEX "administrateur_email_key" ON "administrateur"("email");
