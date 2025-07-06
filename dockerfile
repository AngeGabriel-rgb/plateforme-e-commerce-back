# Utiliser une image de base Node avec la version spécifiée
FROM node:18

# Définir le répertoire de travail
WORKDIR /e-commerce back

# Copier package.json et package-lock.json (ou pnpm-lock.yaml)
COPY package*.json ./
# OU si tu utilises pnpm
# COPY pnpm-lock.yaml ./

# Installer pnpm
RUN npm install -g pnpm

# Installer les dépendances
RUN pnpm install

# Copier le reste de l'application
COPY . .

# Exposer le port que l'application utilise
EXPOSE 3001

# Commande pour démarrer l'application
CMD ["pnpm", "start"]