# OpenCode Model Updater

This script updates AI models in OpenCode by fetching them from your local Ollama and LM Studio servers.

## What it does

-   Checks for new or removed models on Ollama and LM Studio.
-   Updates your OpenCode config with the latest models.
-   Removes models that are no longer available.
-   Shows messages about what was updated.

## How to use

1. Make the script executable: `chmod +x Update-LM-Models/V3/update-models.sh`
2. Run the script: `./Update-LM-Models/V3/update-models.sh`
3. On first run, answer the prompts for Ollama and LM Studio setup (localhost or network IP).
4. Restart OpenCode and check /models for updates.

## Requirements

-   Ollama or LM Studio running locally or on your network.
-   curl, jq, python3 installed.
