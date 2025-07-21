#!/bin/bash
# Update the dynamic linker's cache to ensure all shared libraries are accessible.
ldconfig
# Execute the command passed to the Docker container (e.g., python your_app.py)
exec "$@"