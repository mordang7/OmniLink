#!/bin/bash

CONFIG_FILE="$HOME/.config/opencode/opencode.json"
BACKUP_FILE="$CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"
OLLAMA_URL="http://192.168.3.14:11434/v1/models"
LMSTUDIO_URL="http://192.168.3.14:1234/v1/models"

# Backup config (always, in case we update)
cp "$CONFIG_FILE" "$BACKUP_FILE" && echo "Backup created: $BACKUP_FILE"

# Function to fetch and parse models
fetch_models() {
    local url=$1
    local name=$2
    local models_json=$(curl -s "$url")

    if [[ $? -ne 0 ]]; then
        echo "$name is not running - 0 changes made (run $name if you want your models to update)"
        return 1
    fi

    local model_ids=$(echo "$models_json" | jq -r '.data[].id')

    if [[ -z "$model_ids" ]]; then
        echo "No models found in $name."
        return 1
    fi

    echo "$model_ids"
}

# Fetch Ollama models
OLLAMA_IDS=$(fetch_models "$OLLAMA_URL" "Ollama")
OLLAMA_SUCCESS=$?

# Fetch LM Studio models
LMSTUDIO_IDS=$(fetch_models "$LMSTUDIO_URL" "LM Studio")
LMSTUDIO_SUCCESS=$?

# If both failed (both IDS empty), skip update
if [[ -z "$OLLAMA_IDS" && -z "$LMSTUDIO_IDS" ]]; then
    echo "No updates performed due to both servers being unavailable."
    exit 0
fi

# Use Python to update JSON (only if at least one succeeded)
cat << EOF > update.py
import json
import sys

config_file = sys.argv[1]
ollama_str = sys.argv[2] if len(sys.argv) > 2 else ''
lmstudio_str = sys.argv[3] if len(sys.argv) > 3 else ''

# Load config
with open(config_file, 'r') as f:
    config = json.load(f)

# Helper to add/update provider
def update_provider(config, provider_name, models_str, base_url):
    if 'provider' not in config:
        config['provider'] = {}
    if provider_name not in config['provider']:
        config['provider'][provider_name] = {
            "npm": "@ai-sdk/openai-compatible",
            "name": provider_name.replace('-', ' ').title() + " (remote)",
            "options": {"baseURL": base_url},
            "models": {}
        }
    if models_str.strip():
        model_ids = models_str.strip().split('\\n')
        updated_count = 0
        for model_id in model_ids:
            if model_id.strip():
                # Improved naming: For Ollama cloud models, take base name before ':', title it, add " Cloud"
                # For LM Studio, keep full ID formatted (fallback for general cases)
                if provider_name == 'ollama' and ':cloud' in model_id:
                    base_name = model_id.split(':')[0].replace('-', ' ').title()
                    friendly_name = base_name + " Cloud"
                else:
                    # General fallback: title the full ID, replacing '-' with ' '
                    friendly_name = model_id.replace('-', ' ').replace('/', ' ').title()
                
                config['provider'][provider_name]['models'][model_id] = {"name": friendly_name}
                updated_count += 1
        print(f"Updated {updated_count} models for {provider_name}")
    else:
        print(f"No new models for {provider_name}")

# Update Ollama
if ollama_str:
    update_provider(config, 'ollama', ollama_str, "http://192.168.3.14:11434/v1")

# Update LM Studio
if lmstudio_str:
    update_provider(config, 'lmstudio', lmstudio_str, "http://192.168.3.14:1234/v1")

# Write back
with open(config_file, 'w') as f:
    json.dump(config, f, indent=2)

print(f"Config updated at {config_file}")
EOF

# Run Python script (pass strings even if empty for the failed one)
python3 update.py "$CONFIG_FILE" "$OLLAMA_IDS" "$LMSTUDIO_IDS"

# Clean up
rm update.py

echo "Done! Restart OpenCode and run /models to see updates."