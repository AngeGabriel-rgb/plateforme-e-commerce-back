import { PrismaClient } from "@prisma/client";
import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";

import dotenv from "dotenv";
dotenv.config();

const prisma = new PrismaClient();

// Afficher la page d'accueil de l'administrateur
export const afficherAdminAccueil = (req, res) => {
  res.status(200).json({ message: "Page d'accueil admin", actions: ["Login"] });
};

// Créer un nouvel administrateur
export const creerAdmin = async (req, res) => {
  const { nom, email, password } = req.body;

  try {
    if (!email || !password) {
      return res.status(400).json({ message: "Email et mot de passe requis" });
    }

    // Vérifier si l'admin existe déjà
    const adminExiste = await prisma.administrateur.findUnique({
      where: { email },
    });
    if (adminExiste) {
      return res
        .status(400)
        .json({ message: "Cet administrateur existe déjà" });
    }

    // Hasher le mot de passe
    const hashedPassword = await bcryptjs.hash(password, 10);

    // Créer l'admin
    const nouvelAdmin = await prisma.administrateur.create({
      data: {
        nom,
        email,
        password: hashedPassword,
      },
    });

    res.status(201).json({
      message: "Administrateur créé avec succès",
      administrateur: nouvelAdmin,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Se connecter en tant qu'administrateur
export const loginAdmin = async (req, res) => {
  const { email, password } = req.body;

  try {
    if (!email || !password) {
      return res.status(400).json({ message: "Email et mot de passe requis" });
    }

    const administrateur = await prisma.administrateur.findUnique({
      where: { email: email.toLowerCase() },
    });

    if (
      administrateur &&
      (await bcryptjs.compare(password, administrateur.password))
    ) {
      const token = jwt.sign(
        { administrateurId: administrateur.id, email: administrateur.email },
        process.env.JWT_SECRET,
        { expiresIn: "1h" }
      );

      res.cookie("token", token, {
        httpOnly: true,
        secure: process.env.NODE_ENV === "production",
        sameSite: "Strict",
        maxAge: 3600000,
      });
      res.status(200).json({
        message: "Connexion réussie",
        token,
      });
    } else {
      res.status(401).json({ message: "Identifiants invalides" });
    }
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ message: "Erreur serveur", error: error.toString() });
  }
};

// Créer une nouvelle catégorie
export const createCategorie = async (req, res) => {
  const { nom } = req.body;

  try {
    const newCategorie = await prisma.categorie.create({
      data: { nom },
    });
    res
      .status(201)
      .json({ message: "categorie creer avec succes", newCategorie });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
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
    });
    if (!categorie) {
      return res.status(404).json({ message: "Categorie non trouvée" });
    }
    res.status(200).json(categorie);
  } catch (err) {
    res.status(500).json({
      message: "Erreur lors de la recuperation de la categorie",
      error: err.message,
    });
  }
};

// Mettre à jour une catégorie
export const updateCategorie = async (req, res) => {
  try {
    const updatedCategorie = await prisma.categorie.update({
      where: {
        id: parseInt(req.params.id),
      },
      data: req.body,
    });
    res.status(200).json({
      message: "Categorie modifiée avec succes",
      categorie: updatedCategorie,
    });
  } catch (err) {
    res.status(500).json({
      message: "Erreur lors de la modification de la categorie",
      error: err.message,
    });
  }
};

// Supprimer une catégorie
export const deleteCategorie = async (req, res) => {
  try {
    await prisma.categorie.delete({
      where: {
        id: parseInt(req.params.id),
      },
    });
    res.status(200).json({ message: "Categorie supprimer avec succes" });
  } catch (err) {
    res.status(500).json({
      message: "Erreur lors de la suppression de la categorie",
      error: err.message,
    });
  }
};

// Créer une nouvelle produit
export const createProduit = async (req, res) => {
  const { nom, description, prix, stock, marque, image, categorieId } =
    req.body;

  try {
    const newproduit = await prisma.produit.create({
      data: { nom, description, prix, stock, marque, image, categorieId },
    });
    res.status(201).json({ message: "produit creer avec succes", newproduit });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Récupérer toutes les produit
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
    });
    if (!produit) {
      return res.status(404).json({ message: "produit non trouvé" });
    }
    res.status(200).json(produit);
  } catch (err) {
    res
      .status(500)
      .json({ message: "Error fetching produit", error: err.message });
  }
};

// Mettre à jour une produit
export const updateproduit = async (req, res) => {
  try {
    const updatedproduit = await prisma.produit.update({
      where: {
        id: parseInt(req.params.id),
      },
      data: req.body,
    });
    res.status(200).json({
      message: "produit modifier avec succes",
      produit: updatedproduit,
    });
  } catch (err) {
    res.status(500).json({
      message: "Erreur lors de la modification du produit",
      error: err.message,
    });
  }
};

// Supprimer une produit
export const deleteproduit = async (req, res) => {
  try {
    await prisma.produit.delete({
      where: {
        id: parseInt(req.params.id),
      },
    });
    res.status(200).json({ message: "produit supprimer avec succes" });
  } catch (err) {
    res.status(500).json({
      message: "Erreur lors de la suppression du produit",
      error: err.message,
    });
  }
};

// Créer une nouvelle promotion
export const createPromotion = async (req, res) => {
  const {
    codePromo,
    description,
    type,
    valeur,
    dateDebut,
    dateFin,
    produitId,
    administrateurId,
  } = req.body;

  try {
    const newPromotion = await prisma.promotion.create({
      data: {
        codePromo,
        description,
        type,
        valeur,
        dateDebut,
        dateFin,
        produitId,
        administrateurId,
      },
    });
    res
      .status(201)
      .json({ message: "promotion creer avec succes", newPromotion });
  } catch (error) {
    res.status(500).json({ message: error.message });
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
    });
    if (!promotion) {
      return res.status(404).json({ message: "promotion non trouvée" });
    }
    res.status(200).json(promotion);
  } catch (err) {
    res
      .status(500)
      .json({ message: "Error fetching Promotion", error: err.message });
  }
};

// Mettre à jour une promotion
export const updatePromotion = async (req, res) => {
  try {
    const updatedPromotion = await prisma.promotion.update({
      where: {
        id: parseInt(req.params.id),
      },
      data: req.body,
    });
    res.status(200).json({
      message: "promotion modifiée avec succes",
      promotion: updatedPromotion,
    });
  } catch (err) {
    res.status(500).json({
      message: "Erreur lors de la modification de la promotion",
      error: err.message,
    });
  }
};

// Supprimer une promotion
export const deletePromotion = async (req, res) => {
  try {
    await prisma.promotion.delete({
      where: {
        id: parseInt(req.params.id),
      },
    });
    res.status(200).json({ message: "promotion supprimer avec succes" });
  } catch (err) {
    res.status(500).json({
      message: "Erreur lors de la suppression de la promotion",
      error: err.message,
    });
  }
};
