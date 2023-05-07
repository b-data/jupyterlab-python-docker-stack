# Copyright (c) 2022 b-data GmbH.
# Distributed under the terms of the MIT License.

c.InlineBackend.figure_formats = {"svg", "pdf"}

import os

if (
    os.path.exists(os.path.join(os.environ["HOME"], "bin"))
    and os.getenv("SHLVL") == "0"
):
    os.environ["PATH"] = (
        os.path.join(os.environ["HOME"], "bin")
        + os.pathsep
        + os.getenv("PATH", "")
    )

if (
    os.path.exists(os.path.join(os.environ["HOME"], ".local/bin"))
    and os.getenv("SHLVL") == "0"
):
    os.environ["PATH"] = (
        os.path.join(os.environ["HOME"], ".local/bin")
        + os.pathsep
        + os.getenv("PATH", "")
    )
