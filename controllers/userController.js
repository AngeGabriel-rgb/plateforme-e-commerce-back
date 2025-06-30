import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

import dotenv from "dotenv";
import Stripe from "stripe";

dotenv.config();
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

// Afficher la page d'accueil
export const accueil = (req, res) => {
  res.status(200).json({ message: "Page d'accueil" });
};

// Récupérer toutes les catégories
export const getAllCategorie = async (req, res) => {
  try {
    const categories = await prisma.categorie.findMany();
    res.json(categories);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Obtenir une catégorie par ID
export const getCategorieById = async (req, res) => {
  try {
    const categorie = await prisma.categorie.findUnique({
      where: {
        id: parseInt(req.params.id),
      },
      include: {
        produits: true,
      },
    });
    if (!categorie) {
      return res.status(404).json({ message: "Categorie non trouvée" });
    }
    res.status(200).json(categorie);
  } catch (err) {
    res.status(500).json({
      message: "Erreur lors de la récupération de la catégorie",
      error: err.message,
    });
  }
};

// Récupérer toutes les produit Promotion
export const getAllproduit = async (req, res) => {
  try {
    const produits = await prisma.produit.findMany();
    res.json(produits);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Obtenir une produit par ID
export const getproduitById = async (req, res) => {
  try {
    const produit = await prisma.produit.findUnique({
      where: {
        id: parseInt(req.params.id),
      },
      include: {
        Promotion: true,
      },
    });
    if (!produit) {
      return res.status(404).json({ message: "produit non trouvé" });
    }
    res.status(200).json(produit);
  } catch (err) {
    res.status(500).json({
      message: "Erreur lors de la récupération du produit",
      error: err.message,
    });
  }
};

// Récupérer toutes les promotion
export const getAllPromotion = async (req, res) => {
  try {
    const promotions = await prisma.promotion.findMany();
    res.json(promotions);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Obtenir une promotion par ID
export const getPromotionById = async (req, res) => {
  try {
    const promotion = await prisma.promotion.findUnique({
      where: {
        id: parseInt(req.params.id),
      },
      include: {
        GestionPromotion: true,
      },
    });
    if (!promotion) {
      return res.status(404).json({ message: "promotion non trouvée" });
    }
    res.status(200).json(promotion);
  } catch (err) {
    res.status(500).json({
      message: "Erreur lors de la récupération de la Promotion",
      error: err.message,
    });
  }
};

// Récupérer le contenu du panier d'un utilisateur
export const getPanier = async (req, res) => {
  try {
    const { utilisateurId } = req.params;
    const panier = await prisma.panier.findUnique({
      where: { utilisateurId: parseInt(utilisateurId) },
      include: {
        lignesPanier: {
          include: {
            produit: true,
          },
        },
      },
    });
    if (!panier) {
      return res.status(404).json({ message: "Panier non trouvé" });
    }
    res.status(200).json(panier);
  } catch (error) {
    res.status(500).json({
      message: "Erreur lors de la récupération du panier",
      error: error.message,
    });
  }
};

// Ajouter un produit au panier
export const addToPanier = async (req, res) => {
  try {
    const { utilisateurId, produitId, quantite } = req.body;

    // Vérifier si le panier de l'utilisateur existe
    let panier = await prisma.panier.findUnique({
      where: { utilisateurId },
    });

    if (!panier) {
      panier = await prisma.panier.create({
        data: { utilisateurId },
      });
    }

    // Vérifier si le produit est déjà dans le panier
    const ligneExistante = await prisma.lignePanier.findFirst({
      where: { panierId: panier.id, produitId },
    });

    if (ligneExistante) {
      // Mettre à jour la quantité
      const updatedLigne = await prisma.lignePanier.update({
        where: { id: ligneExistante.id },
        data: { quantite: ligneExistante.quantite + quantite },
      });
      return res.status(200).json(updatedLigne);
    }

    // Ajouter un nouveau produit au panier
    const lignePanier = await prisma.lignePanier.create({
      data: {
        panierId: panier.id,
        produitId,
        quantite,
      },
    });
    res.status(201).json(lignePanier);
  } catch (error) {
    res.status(500).json({
      message: "Erreur lors de l'ajout au panier",
      error: error.message,
    });
  }
};

// Modifier la quantité d'un produit dans le panier
export const updatePanier = async (req, res) => {
  try {
    const { id } = req.params;
    const { quantite } = req.body;
    const lignePanier = await prisma.lignePanier.update({
      where: { id: parseInt(id) },
      data: { quantite },
    });
    res.status(200).json(lignePanier);
  } catch (error) {
    res.status(500).json({
      message: "Erreur lors de la mise à jour du panier",
      error: error.message,
    });
  }
};

// Supprimer un produit du panier
export const removeFromPanier = async (req, res) => {
  try {
    const { id } = req.params;
    await prisma.lignePanier.delete({ where: { id: parseInt(id) } });
    res.status(200).json({ message: "Produit supprimé du panier" });
  } catch (error) {
    res.status(500).json({
      message: "Erreur lors de la suppression du produit du panier",
      error: error.message,
    });
  }
};
