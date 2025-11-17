# Update Models Script Documentation

## Overview

This project contains versions of a bash script to update AI models for OpenCode by fetching from local Ollama and LM Studio servers and updating the configuration JSON file.

## Versions

-   **V1/**: Original script (moved from root).
-   **V2/**: Improved version with enhancements.
-   **V3/**: Version with user prompts for Ollama and LM Studio setup.
-   **V4/**: Latest version with Llama.cpp support added.

## Changes Made in V2

1. **Server Timeout**: Added 15-second timeout for server reachability checks using `curl --connect-timeout 15 --max-time 15`.
2. **Failure Handling**: If both servers are unreachable, display "Both Servers could not be reached - No Changes were Made" and exit without modifying the config.
3. **Conditional Updates**:
    - If only Ollama is running: Update only Ollama models, show "Only the Ollama models were Updated!".
    - If only LM Studio is running: Update only LM Studio models, show "Only the LM Studio models were Updated!".
    - If both are running: Update both, show "Both Ollama & LM Studio models were Updated!".
4. **Model Removal**: Check for models no longer present on servers and remove them from the config, displaying "X Non Present Models were Removed!" where X is the count.
5. **Backup Adjustment**: Backup the config only if at least one server is reachable.
6. **Message Refinement**: Removed individual "Updated X models" prints; added summary messages for updates and removals.

## Changes Made in V3

1. **User Prompts**: On first run, prompts user to choose between localhost or network IP for Ollama and LM Studio setups.
2. **Dynamic URLs**: Sets OLLAMA_URL and LMSTUDIO_URL based on user input (localhost or entered IP), replacing hardcoded IPs.
3. **Config Persistence**: Saves user choices in ~/.update-models-config for future runs, avoiding re-prompting.
4. **Improved Flexibility**: Supports both local and network deployments seamlessly.

## Changes Made in V4

1. **Added Llama.cpp Support**: Prompts for Llama.cpp setup (localhost or network), fetches models from /v1/models endpoint (default port 8080), updates config with 'llamacpp' provider.
2. **Updated Failure Check**: Now checks if all three servers fail, exits with "All Servers could not be reached - No Changes were Made".
3. **Enhanced Update Messages**: Dynamically lists which providers were updated (e.g., "Only the Ollama & LM Studio models were Updated!").
4. **Config Persistence**: Saves LLAMA_URL in ~/.update-models-config.

## Repository

The project has been uploaded to GitHub as "OpenCode-Model-Updater" (https://github.com/mordang7/OpenCode-Model-Updater), currently containing V3 for public release. V4 is ready locally but pending push due to tool restrictions. V1 and V2 remain local.

## Release

-   **v1.0**: Initial release created on GitHub with title "Initial Release" and description "This is the initial release of OpenCode Model Updater".

## Usage

To make executable: `chmod +x update-models.sh`
To run: `./update-models.sh`

## Dependencies

-   curl
-   jq
-   python3
-   OpenCode config at `$HOME/.config/opencode/opencode.json`
