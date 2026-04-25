 Oracle Cloud Proxy for Claude Code

This is the definitive guide to hosting a high-performance, **zero-cost** AI development environment. By the end of this guide, you will have a 24/7 server in the cloud acting as a brain for your **Claude Code CLI**.

---

## 🏗️ The Architecture
We are leveraging three powerful components:
1. **The Core:** [Alishahryar1/free-claude-code](https://github.com/Alishahryar1/free-claude-code) — The proxy that intercepts Claude Code's calls.
2. **The Backend:** **OpenRouter** — Providing access to free elite models (DeepSeek-R1, Qwen 2.5).
3. **The Host:** **Oracle Cloud Always-Free** — Running the proxy 24/7 so your laptop stays light.

---

## 🔑 Phase 1: Authentication (OpenRouter)
You need a single API key to unlock all free models.

1. Visit **[openrouter.ai/keys](https://openrouter.ai/keys)**.
2. Sign in (Google/GitHub).
3. Create a new key named `Oracle-Proxy`.
4. **Copy it immediately.** You will need it for the `.env` configuration.
5. *Note:* Ensure you use the models with the `:free` suffix to keep costs at zero.

---

## ☁️ Phase 2: The Oracle Cloud Infrastructure
1. **Launch a VM**:
   - Image: **Ubuntu 22.04 LTS** (Canonical).
   - Shape: `VM.Standard.E2.1.Micro` or `VM.Standard.A1.Flex` (Always Free Eligible).
   - **SSH Keys**: Download both the private and public keys.
2. **Network/Firewall Configuration**:
   - Go to your Instance details -> Click **Virtual Cloud Network**.
   - Select **Security Lists** -> **Default Security List**.
   - Add an **Ingress Rule**:
     - **Source CIDR**: `0.0.0.0/0`
     - **IP Protocol**: `TCP`
     - **Destination Port Range**: `8082`
     - **Description**: `Free Claude Code API Access`

---

## 🛠️ Phase 3: Server Installation (The Deep Dive)
Once you SSH into your server (`ssh -i key.key ubuntu@your-ip`), follow these exact steps:

### 1. System Preparation
Update your Ubuntu system and install essential tools:
```bash
sudo apt-get update && sudo apt-get install -y git python3-pip curl
```

### 2. Install UV (Modern Package Manager)
We use `uv` for lightning-fast, isolated Python environments:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.cargo/env
```

### 3. Clone the Engine
This is the heart of the proxy. We clone the repository and enter the directory:
```bash
git clone https://github.com/Alishahryar1/free-claude-code.git
cd free-claude-code
```

### 4. Configuration (`.env`)
Create your configuration file from the template:
```bash
cp .env.example .env
nano .env
```
Update these specific lines:
- `OPENROUTER_API_KEY="your_key_here"`
- `PORT=8082`
- `MODEL_OPUS="open_router/deepseek/deepseek-r1:free"`
- `MODEL_SONNET="open_router/qwen/qwen-2.5-coder-32b-instruct:free"`

### 5. Launch the Proxy
Install dependencies and start the server:
```bash
uv sync
uv run uvicorn server:app --host 0.0.0.0 --port 8082
```

---

## 💻 Phase 4: Connecting Claude Code (Local Laptop)
On your laptop (Windows/Mac/Linux), you just need to point the official Claude CLI to your new Oracle server.

### Windows (PowerShell)
```powershell
$env:ANTHROPIC_BASE_URL="http://YOUR_ORACLE_IP:8082"; claude
```

### Mac/Linux (Bash/Zsh)
```bash
export ANTHROPIC_BASE_URL="http://YOUR_ORACLE_IP:8082"
claude
```

---

## 💡 Troubleshooting & Tips
- **Port Error**: If it says port 8082 is blocked, double-check your Oracle Security List ingress rules.
- **Python Version**: If you get a version error, our script automatically handles it by modifying `pyproject.toml` to support Python 3.10+.
- **Process Management**: To keep the server running even after you close SSH, use `nohup` or `screen`:
  ```bash
  screen -dmS proxy uv run uvicorn server:app --host 0.0.0.0 --port 8082
  ```
