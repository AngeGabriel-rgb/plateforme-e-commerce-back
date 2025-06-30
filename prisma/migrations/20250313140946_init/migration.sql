/*
  Warnings:

  - You are about to drop the column `motDePasse` on the `utilisateur` table. All the data in the column will be lost.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_utilisateur" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nom" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "adresseLivraison" TEXT NOT NULL
);
INSERT INTO "new_utilisateur" ("adresseLivraison", "email", "id", "nom") SELECT "adresseLivraison", "email", "id", "nom" FROM "utilisateur";
DROP TABLE "utilisateur";
ALTER TABLE "new_utilisateur" RENAME TO "utilisateur";
CREATE UNIQUE INDEX "utilisateur_email_key" ON "utilisateur"("email");
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
