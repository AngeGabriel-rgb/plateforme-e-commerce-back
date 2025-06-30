import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

// Récupérer tous les produits
export const getProduits = async (req, res) => {
  try {
    const produits = await prisma.produit.findMany();
    res.json(produits);
  } catch (error) {
    res
      .status(500)
      .json({ error: "Erreur lors de la récupération des produits." });
  }
};

// Ajouter un produit
export const createProduit = async (req, res) => {
  const { nom, description, prix, stock, marque, image, categorieId } =
    req.body;
  try {
    const produit = await prisma.produit.create({
      data: { nom, description, prix, stock, marque, image, categorieId },
    });
    res.json(produit);
  } catch (error) {
    res.status(500).json({ error: "Erreur lors de l'ajout du produit." });
  }
};
