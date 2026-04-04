import os
import sys


APP_ROOT = "/opt/chatterbox"
sys.path.insert(0, APP_ROOT)

import gradio_tts_turbo_app as app  # noqa: E402


if __name__ == "__main__":
    port = int(os.getenv("PORT", "7860"))
    app.demo.queue(
        max_size=50,
        default_concurrency_limit=1,
    ).launch(
        server_name="0.0.0.0",
        server_port=port,
        share=False,
        show_error=True,
    )

