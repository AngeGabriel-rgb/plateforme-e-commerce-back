-- CreateTable
CREATE TABLE "utilisateur" (
    "id" SERIAL NOT NULL,
    "nom" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "adresseLivraison" TEXT NOT NULL,

    CONSTRAINT "utilisateur_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "produit" (
    "id" SERIAL NOT NULL,
    "nom" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "prix" DOUBLE PRECISION NOT NULL,
    "stock" INTEGER NOT NULL,
    "marque" TEXT NOT NULL,
    "image" TEXT NOT NULL,
    "categorieId" INTEGER NOT NULL,

    CONSTRAINT "produit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categorie" (
    "id" SERIAL NOT NULL,
    "nom" TEXT NOT NULL,

    CONSTRAINT "categorie_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "commande" (
    "id" SERIAL NOT NULL,
    "dateCommande" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "statut" TEXT NOT NULL,
    "totalCommande" DOUBLE PRECISION NOT NULL,
    "modePaiement" TEXT NOT NULL,
    "adresseLivraison" TEXT NOT NULL,
    "utilisateurId" INTEGER NOT NULL,

    CONSTRAINT "commande_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ligneCommande" (
    "id" SERIAL NOT NULL,
    "commandeId" INTEGER NOT NULL,
    "produitId" INTEGER NOT NULL,
    "quantite" INTEGER NOT NULL,
    "prixUnitaire" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "ligneCommande_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "panier" (
    "id" SERIAL NOT NULL,
    "utilisateurId" INTEGER NOT NULL,
    "dateCreation" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "panier_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lignePanier" (
    "id" SERIAL NOT NULL,
    "panierId" INTEGER NOT NULL,
    "produitId" INTEGER NOT NULL,
    "quantite" INTEGER NOT NULL,

    CONSTRAINT "lignePanier_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "paiement" (
    "id" SERIAL NOT NULL,
    "commandeId" INTEGER NOT NULL,
    "montant" DOUBLE PRECISION NOT NULL,
    "datePaiement" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "statut" TEXT NOT NULL,
    "methodePaiement" TEXT NOT NULL,

    CONSTRAINT "paiement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "avis" (
    "id" SERIAL NOT NULL,
    "produitId" INTEGER NOT NULL,
    "utilisateurId" INTEGER NOT NULL,
    "note" INTEGER NOT NULL,
    "commentaire" TEXT,
    "dateAvis" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "avis_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "promotion" (
    "id" SERIAL NOT NULL,
    "codePromo" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "valeur" DOUBLE PRECISION NOT NULL,
    "dateDebut" TIMESTAMP(3) NOT NULL,
    "dateFin" TIMESTAMP(3) NOT NULL,
    "produitId" INTEGER NOT NULL,
    "administrateurId" INTEGER NOT NULL,

    CONSTRAINT "promotion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "administrateur" (
    "id" SERIAL NOT NULL,
    "nom" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,

    CONSTRAINT "administrateur_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gestionProduit" (
    "id" SERIAL NOT NULL,
    "adminId" INTEGER NOT NULL,
    "produitId" INTEGER NOT NULL,
    "action" TEXT NOT NULL,
    "dateAction" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "gestionProduit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gestionCommande" (
    "id" SERIAL NOT NULL,
    "adminId" INTEGER NOT NULL,
    "commandeId" INTEGER NOT NULL,
    "action" TEXT NOT NULL,
    "dateAction" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "gestionCommande_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gestionUtilisateur" (
    "id" SERIAL NOT NULL,
    "adminId" INTEGER NOT NULL,
    "utilisateurId" INTEGER NOT NULL,
    "action" TEXT NOT NULL,
    "dateAction" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "gestionUtilisateur_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gestionPromotion" (
    "id" SERIAL NOT NULL,
    "administrateurId" INTEGER NOT NULL,
    "promotionId" INTEGER NOT NULL,
    "action" TEXT NOT NULL,
    "dateAction" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "gestionPromotion_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "utilisateur_email_key" ON "utilisateur"("email");

-- CreateIndex
CREATE UNIQUE INDEX "promotion_codePromo_key" ON "promotion"("codePromo");

-- CreateIndex
CREATE UNIQUE INDEX "administrateur_email_key" ON "administrateur"("email");

-- AddForeignKey
ALTER TABLE "produit" ADD CONSTRAINT "produit_categorieId_fkey" FOREIGN KEY ("categorieId") REFERENCES "categorie"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "commande" ADD CONSTRAINT "commande_utilisateurId_fkey" FOREIGN KEY ("utilisateurId") REFERENCES "utilisateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ligneCommande" ADD CONSTRAINT "ligneCommande_commandeId_fkey" FOREIGN KEY ("commandeId") REFERENCES "commande"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ligneCommande" ADD CONSTRAINT "ligneCommande_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "produit"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "panier" ADD CONSTRAINT "panier_utilisateurId_fkey" FOREIGN KEY ("utilisateurId") REFERENCES "utilisateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lignePanier" ADD CONSTRAINT "lignePanier_panierId_fkey" FOREIGN KEY ("panierId") REFERENCES "panier"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lignePanier" ADD CONSTRAINT "lignePanier_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "produit"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "paiement" ADD CONSTRAINT "paiement_commandeId_fkey" FOREIGN KEY ("commandeId") REFERENCES "commande"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "avis" ADD CONSTRAINT "avis_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "produit"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "avis" ADD CONSTRAINT "avis_utilisateurId_fkey" FOREIGN KEY ("utilisateurId") REFERENCES "utilisateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "promotion" ADD CONSTRAINT "promotion_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "produit"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gestionProduit" ADD CONSTRAINT "gestionProduit_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "administrateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gestionProduit" ADD CONSTRAINT "gestionProduit_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "produit"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gestionCommande" ADD CONSTRAINT "gestionCommande_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "administrateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gestionCommande" ADD CONSTRAINT "gestionCommande_commandeId_fkey" FOREIGN KEY ("commandeId") REFERENCES "commande"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gestionUtilisateur" ADD CONSTRAINT "gestionUtilisateur_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "administrateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gestionUtilisateur" ADD CONSTRAINT "gestionUtilisateur_utilisateurId_fkey" FOREIGN KEY ("utilisateurId") REFERENCES "utilisateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gestionPromotion" ADD CONSTRAINT "gestionPromotion_administrateurId_fkey" FOREIGN KEY ("administrateurId") REFERENCES "administrateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gestionPromotion" ADD CONSTRAINT "gestionPromotion_promotionId_fkey" FOREIGN KEY ("promotionId") REFERENCES "promotion"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
