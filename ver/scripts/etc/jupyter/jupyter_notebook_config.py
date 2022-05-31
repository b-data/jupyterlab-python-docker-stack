# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

from jupyter_core.paths import jupyter_data_dir
import subprocess
import os
import errno
import stat
import shutil

c = get_config()
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8888

# https://github.com/jupyter/notebook/issues/3130
c.FileContentsManager.delete_to_trash = False

def _codeserver_command(port):
    full_path = shutil.which("code-server")
    if not full_path:
        raise FileNotFoundError("Can not find code-server in $PATH")
    work_dir = os.getenv("CODE_WORKDIR", None)
    if work_dir is None:
        work_dir = os.getenv("JUPYTER_SERVER_ROOT", ".")
    elif os.path.isdir(work_dir) is False:
        os.mkdir(work_dir)
    data_dir = os.getenv("CODE_USER_DATA_DIR", "")
    if data_dir != "":
        data_dir = "--user-data-dir=" + str(data_dir)
    extensions_dir = os.getenv("CODE_EXTENSIONS_DIR", "")
    if extensions_dir != "":
        extensions_dir = "--extensions-dir=" + str(extensions_dir)

    return [
        full_path,
        "--bind-addr=0.0.0.0:" + str(port),
        "--auth",
        "none",
        data_dir,
        extensions_dir,
        work_dir,
    ]

c.ServerProxy.servers = {
    "code-server": {
        "command": _codeserver_command,
        "timeout": 20,
        "launcher_entry": {
            "title": "code-server",
            "icon_path": "/opt/code-server/vscode.svg"
        },
        "new_browser_tab": True
    }
}

# Generate a self-signed certificate
OPENSSL_CONFIG = """\
[req]
distinguished_name = req_distinguished_name
[req_distinguished_name]
"""
if "GEN_CERT" in os.environ:
    dir_name = jupyter_data_dir()
    pem_file = os.path.join(dir_name, "notebook.pem")
    os.makedirs(dir_name, exist_ok=True)

    # Generate an openssl.cnf file to set the distinguished name
    cnf_file = os.path.join(os.getenv("CONDA_DIR", "/usr/lib"), "ssl", "openssl.cnf")
    if not os.path.isfile(cnf_file):
        with open(cnf_file, "w") as fh:
            fh.write(OPENSSL_CONFIG)

    # Generate a certificate if one doesn't exist on disk
    subprocess.check_call(
        [
            "openssl",
            "req",
            "-new",
            "-newkey=rsa:2048",
            "-days=365",
            "-nodes",
            "-x509",
            "-subj=/C=XX/ST=XX/L=XX/O=generated/CN=generated",
            f"-keyout={pem_file}",
            f"-out={pem_file}",
        ]
    )
    # Restrict access to the file
    os.chmod(pem_file, stat.S_IRUSR | stat.S_IWUSR)
    c.NotebookApp.certfile = pem_file

# Change default umask for all subprocesses of the notebook server if set in
# the environment
if 'NB_UMASK' in os.environ:
    os.umask(int(os.environ['NB_UMASK'], 8))
