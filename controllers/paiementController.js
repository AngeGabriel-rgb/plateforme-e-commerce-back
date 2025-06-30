import express from "express";
import Stripe from "stripe";
import pkg from "@prisma/client";
const { PrismaClient } = pkg;
import dotenv from "dotenv";

dotenv.config();

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
const prisma = new PrismaClient();

// ouvrir une session de commande de produit
export const createCheckoutSession = async (req, res) => {
  try {
    const { utilisateurId, items } = req.body;

    const lineItems = items.map((item) => ({
      price_data: {
        currency: "eur",
        product_data: { name: item.nom, images: [item.image] },
        unit_amount: item.prix * 100,
      },
      quantity: item.quantite,
    }));

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ["card"],
      line_items: lineItems,
      mode: "payment",
      success_url: `http://localhost:3001/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: "http://localhost:3001/cancel",
    });

    // Enregistrer la commande en base de données
    const newCommande = await prisma.commande.create({
      data: {
        utilisateurId,
        statut: "En attente",
        totalCommande: items.reduce(
          (sum, item) => sum + item.prix * item.quantite,
          0
        ),
        modePaiement: "Stripe",
        adresseLivraison: "Adresse de test",
      },
    });

    res.json({ id: session.id });
  } catch (error) {
    console.error("Erreur de paiement Stripe:", error);
    res
      .status(500)
      .json({ error: "Échec de la création de la session de paiement." });
  }
};

export const stripeWebhook = express.raw({ type: "application/json" });

export const handleWebhook = async (req, res) => {
  console.log("📩 Webhook Stripe reçu !");

  const sig = req.headers["stripe-signature"];
  let event;

  try {
    event = stripe.webhooks.constructEvent(
      req.body,
      sig,
      process.env.STRIPE_WEBHOOK_SECRET
    );
  } catch (err) {
    console.error(
      `  Erreur lors de la vérification du webhook: ${err.message}`
    );
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Traiter uniquement l'événement de paiement réussi
  if (event.type === "checkout.session.completed") {
    const session = event.data.object;
    const paiementIntentId = session.payment_intent;
    const emailClient = session.customer_email; // Récupérer l'email du client

    try {
      // Trouver la commande liée à cet email (ou ID si stocké)
      const commande = await prisma.commande.findFirst({
        where: { utilisateur: { email: emailClient } },
      });

      if (commande) {
        // Mettre à jour le statut de la commande après paiement réussi
        await prisma.commande.update({
          where: { id: commande.id },
          data: {
            statut: "payée",
            modePaiement: "Stripe",
          },
        });

        console.log(`Commande ${commande.id} marquée comme payée.`);
      }
    } catch (error) {
      console.error(
        `Erreur lors de la mise à jour de la commande: ${error.message}`
      );
    }
  }

  res.status(200).json({ received: true });
};