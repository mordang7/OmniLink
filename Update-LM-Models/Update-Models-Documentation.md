# Update Models Script Documentation

## Overview

This project contains versions of a bash script to update AI models for OpenCode by fetching from local Ollama and LM Studio servers and updating the configuration JSON file.

## Versions

-   **V1/**: Original script (moved from root).
-   **V2/**: Improved version with enhancements.

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

## Usage

To make executable: `chmod +x update-models.sh`
To run: `./update-models.sh`

## Dependencies

-   curl
-   jq
-   python3
-   OpenCode config at `$HOME/.config/opencode/opencode.json`
