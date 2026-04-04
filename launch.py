import os
import sys


APP_ROOT = "/opt/chatterbox"
sys.path.insert(0, APP_ROOT)

os.environ.setdefault("HF_HUB_DISABLE_PROGRESS_BARS", "1")

import gradio_tts_turbo_app as app  # noqa: E402


_preloaded_model = None
_original_from_pretrained = app.ChatterboxTurboTTS.from_pretrained


def get_model():
    global _preloaded_model
    if _preloaded_model is None:
        _preloaded_model = _original_from_pretrained(app.DEVICE)
    return _preloaded_model


def _cached_from_pretrained(*args, **kwargs):
    return get_model()


app.ChatterboxTurboTTS.from_pretrained = staticmethod(_cached_from_pretrained)


if __name__ == "__main__":
    port = int(os.getenv("PORT", "7860"))
    print(f"Preloading Chatterbox-Turbo on {app.DEVICE} before serving...")
    get_model()
    app.demo.queue(
        max_size=50,
        default_concurrency_limit=1,
    ).launch(
        server_name="0.0.0.0",
        server_port=port,
        share=False,
        show_error=True,
    )
