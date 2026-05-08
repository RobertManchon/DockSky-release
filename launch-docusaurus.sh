#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
PORT=3010

# node installé via nvm — chemin absolu pour les lancements hors terminal
NVM_NODE_DIR="/home/bob/.nvm/versions/node/v22.22.2/bin"
export PATH="$NVM_NODE_DIR:$PATH"

cd "$REPO_DIR"

# Installe les dépendances si node_modules absent ou incomplet
if [ ! -f node_modules/.package-lock.json ] && [ ! -f node_modules/.yarn-integrity ]; then
    echo "📦 Installation des dépendances npm..."
    npm install
fi

# Lance Docusaurus en arrière-plan et ouvre le navigateur
echo "🚀 Démarrage Docusaurus sur http://localhost:$PORT ..."
npm start -- --port "$PORT" &
DOCUSAURUS_PID=$!

# Attente que le serveur réponde
for i in $(seq 1 30); do
    if curl -sf "http://localhost:$PORT" >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

xdg-open "http://localhost:$PORT"

# Attend que le processus se termine (Ctrl+C ferme tout)
wait "$DOCUSAURUS_PID"
