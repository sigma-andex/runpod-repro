"""Logging configuration for saliency analysis."""

import logging
import os
from typing import Dict, Any

# Environment variable for log level
LOG_LEVEL = os.environ.get("LOG_LEVEL", "INFO").upper()

def setup_logging():
    """Configure logging for the application."""
    logging.basicConfig(
        level=getattr(logging, LOG_LEVEL, logging.INFO),
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )
