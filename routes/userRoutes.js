import express from "express";
import { createCheckoutSession } from "../controllers/paiementController.js";
import {
  accueil,
  getAllCategorie,
  getCategorieById,
  getAllproduit,
  getproduitById,
  getAllPromotion,
  getPromotionById,
  getPanier,
  addToPanier,
  updatePanier,
  removeFromPanier,
} from "../controllers/userController.js";

const router = express.Router();

router.get("/", accueil);
router.get("/categorie", getAllCategorie);
router.get("/categorie/:id", getCategorieById);
router.get("/produit", getAllproduit);
router.get("/produit/:id", getproduitById);
router.get("/promotion", getAllPromotion);
router.get("/promotion/:id", getPromotionById);

router.get("/:utilisateurId", getPanier);
router.post("/add", addToPanier);
router.put("/:id", updatePanier);
router.delete("/:id", removeFromPanier);

router.post("/session-paiement", createCheckoutSession);

export default router;
