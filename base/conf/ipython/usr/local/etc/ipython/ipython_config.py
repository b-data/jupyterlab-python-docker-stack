c.InlineBackend.figure_formats = {"svg", "pdf"}

import os

if (
    os.path.exists(os.path.join(os.environ["HOME"], "bin"))
    and not os.path.join(os.environ["HOME"], "bin") in os.getenv("PATH", "")
):
    os.environ["PATH"] = (
        os.path.join(os.environ["HOME"], "bin")
        + os.pathsep
        + os.getenv("PATH", "")
    )

if (
    os.path.exists(os.path.join(os.environ["HOME"], ".local", "bin"))
    and not os.path.join(os.environ["HOME"], ".local", "bin")
    in os.getenv("PATH", "")
):
    os.environ["PATH"] = (
        os.path.join(os.environ["HOME"], ".local", "bin")
        + os.pathsep
        + os.getenv("PATH", "")
    )
