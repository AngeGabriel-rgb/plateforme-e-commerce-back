import express from "express";
import { verifyToken } from "../middlewares/auth.js";
import {
  afficherAdminAccueil,
  creerAdmin,
  loginAdmin,
  createCategorie,
  getAllCategorie,
  getCategorieById,
  updateCategorie,
  deleteCategorie,
  createProduit,
  getAllproduit,
  getproduitById,
  updateproduit,
  deleteproduit,
  createPromotion,
  getAllPromotion,
  getPromotionById,
  updatePromotion,
  deletePromotion,
} from "../controllers/adminControllers.js";

const router = express.Router();

router.get("/", afficherAdminAccueil);
router.post("/register", verifyToken, creerAdmin);
router.post("/login", loginAdmin);
router.post("/categorie", verifyToken, createCategorie);
router.get("/categorie", getAllCategorie);
router.get("/categorie/:id", getCategorieById);
router.put("/categorie/:id", verifyToken, updateCategorie);
router.delete("/categorie/:id", verifyToken, deleteCategorie);
router.post("/produit", verifyToken, createProduit);
router.get("/produit", getAllproduit);
router.get("/produit/:id", getproduitById);
router.put("/produit/:id", verifyToken, updateproduit);
router.delete("/produit/:id", verifyToken, deleteproduit);
router.post("/promotion", verifyToken, createPromotion);
router.get("/promotion", getAllPromotion);
router.get("/promotion/:id", getPromotionById);
router.put("/promotion/:id", verifyToken, updatePromotion);
router.delete("/promotion/:id", verifyToken, deletePromotion);

export default router;
