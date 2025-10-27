
import os
import logging
import time
from pydantic import BaseModel, ValidationError
from typing import List, Optional, Literal
import runpod

from .logging_config import setup_logging

# Setup logging
setup_logging()
logger = logging.getLogger(__name__)


def handler(job):
    logger.info("Received new saliency analysis job")
    request = job["input"]  # Access the input from the request.

    logger.info(f"Request: {request}")
    return {
        "output": "Hello, world!"
    }


runpod.serverless.start({"handler": handler})  # Required.
