import jwt from "jsonwebtoken";
import dotenv from "dotenv";

dotenv.config();

const JWT_SECRET = process.env.JWT_SECRET;

export const verifyToken = (req, res, next) => {
  console.log("Headers:", req.headers);
  console.log("Cookies:", req.cookies);

  // Vérifie si l'authorization header est bien structuré
  const authHeader = req.headers.authorization;
  const token =
    authHeader && authHeader.startsWith("Bearer ")
      ? authHeader.split(" ")[1]
      : null;

  if (!token) {
    console.error("Erreur: Aucun token trouvé");
    return res.status(401).json({
      message:
        "Accès non autorisé. Connectez vous en tant qu'admin. Token manquant.",
    });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.administrateur = decoded; // Stocke l'utilisateur déchiffré
    next();
  } catch (error) {
    console.error("Erreur: Token invalide ou expiré", error);
    return res.status(403).json({ message: "Token invalide ou expiré." });
  }
};
