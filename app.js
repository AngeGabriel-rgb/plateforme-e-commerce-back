import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import ejs from "ejs";
import Stripe from "stripe";
import adminRoutes from "./routes/adminRoutes.js";
import userRoutes from "./routes/userRoutes.js";
import {
  stripeWebhook,
  handleWebhook,
} from "./controllers/paiementController.js";

dotenv.config();
const app = express();
const port = 3001;

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
// Middleware
app.use(express.json()); // Middleware pour parser le JSON dans les requêtes
app.use(express.urlencoded({ extended: true })); // Pour parser les formulaires URL-encodés
app.use(
  cors({
    origin: "http://localhost:3000",
    "https://olostore.netlify.app/": true, // Autoriser les requêtes de ce domaine
    methods: ["GET", "POST", "PUT", "DELETE"],
    credentials: true,
  })
);

app.engine("html", ejs.__express);

// Créer une route pour la page d'accueil
app.get("/", (req, res) => {
  res.send("Hello, world!");
});
app.post("/webhook-stripe", stripeWebhook, handleWebhook);

// Utilisation des routes
app.use("/api/admin", adminRoutes);
app.use("/api/user", userRoutes);
//app.use("/api/paiement", userRoutes);

// Démarrer le serveur
app.listen(port, () => {
  console.log(`Serveur en cours sur http://localhost:${port}`);
});
