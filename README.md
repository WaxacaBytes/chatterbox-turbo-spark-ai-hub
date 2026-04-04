# Chatterbox Turbo SparkDeck Image

Thin container wrapper for running the official `resemble-ai/chatterbox` Turbo Gradio app on NVIDIA DGX Spark.

Goals:
- no modifications to Chatterbox source
- Python 3.11 environment, matching the upstream guidance
- prebuilt image suitable for pull-only SparkDeck installation

This image:
- installs CUDA 13 compatible PyTorch wheels for ARM64
- clones the official Chatterbox repo at a pinned upstream commit
- installs the official package from source without patching it
- launches the official `gradio_tts_turbo_app.py` through a small wrapper so the app binds to `0.0.0.0`, disables Gradio share mode, and enables visible errors

Upstream:
- https://github.com/resemble-ai/chatterbox

