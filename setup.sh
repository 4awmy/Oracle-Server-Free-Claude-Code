#!/bin/bash
# 🚀 Auto-installer for Free Claude Code on Oracle Cloud
echo "------------------------------------------------"
echo "Project StudyX: Starting Cloud Proxy Installation"
echo "------------------------------------------------"

# 1. Update and install basic dependencies
echo "📦 Updating system and installing Git/Python..."
sudo apt-get update && sudo apt-get install -y git python3-pip curl

# 2. Install UV (Modern package manager)
echo "⚡ Installing UV package manager..."
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.cargo/env

# 3. Clone the Free Claude Code repository
echo "📂 Cloning Free Claude Code engine..."
git clone https://github.com/Alishahryar1/free-claude-code.git ~/free-claude-code
cd ~/free-claude-code

# 4. Fix Python Version Compatibility
# Oracle Ubuntu often comes with 3.10 or 3.12. This bypasses the 3.14 requirement.
echo "🔧 Fixing Python version compatibility..."
sed -i 's/requires-python = ">=3.14"/requires-python = ">=3.10"/' pyproject.toml

# 5. Initialize Configuration
echo "📝 Initializing .env configuration..."
cp .env.example .env
# Set default port to 8082 to match our guide
sed -i 's/PORT=8080/PORT=8082/' .env

# 6. Install Project Dependencies
echo "🏗️ Installing project dependencies with UV..."
uv sync

echo "------------------------------------------------"
echo "✅ SUCCESS: Installation Complete!"
echo "------------------------------------------------"
echo "👉 STEP 1: Edit your config to add your OpenRouter Key:"
echo "   nano ~/free-claude-code/.env"
echo ""
echo "👉 STEP 2: Start the server:"
echo "   cd ~/free-claude-code && uv run uvicorn server:app --host 0.0.0.0 --port 8082"
echo "------------------------------------------------"
