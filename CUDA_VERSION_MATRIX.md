# CUDA Version Matrix

Topmost entry = Tag `latest`

| Python     | CUDA   | cuBLAS    | cuDNN     | NCCL   | TensorRT  | Linux distro |
|:-----------|:-------|:----------|:----------|:-------|:----------|:-------------|
| 3.12.4     | 12.5.0 | 12.5.2.13 | 8.9.7.29  | 2.21.5 | 10.1.0.27 | Ubuntu 22.04 |
| 3.12.3     | 12.5.0 | 12.5.2.13 | 8.9.7.29  | 2.21.5 | 10.0.1.6  | Ubuntu 22.04 |
| 3.11.9     | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^2] | Ubuntu 22.04 |
| 3.12.2     | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^2] | Ubuntu 22.04 |
| 3.11.8     | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^2] | Ubuntu 22.04 |
| 3.12.1     | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^2] | Ubuntu 22.04 |
| 3.11.7     | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^2] | Ubuntu 22.04 |
| 3.12.0[^1] | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^2] | Ubuntu 22.04 |
| 3.11.6     | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^2] | Ubuntu 22.04 |
| 3.11.5     | 11.8.0 | 11.11.3.6 | 8.9.0.131 | 2.15.5 | 8.5.3[^2] | Ubuntu 22.04 |
| 3.11.4     | 11.8.0 | 11.11.3.6 | 8.9.0.131 | 2.15.5 | 8.5.3[^2] | Ubuntu 22.04 |
| 3.10.13    | 11.8.0 | 11.11.3.6 | 8.9.0.131 | 2.15.5 | 8.5.3[^2] | Ubuntu 22.04 |
| 3.11.3     | 11.8.0 | 11.11.3.6 | 8.9.0.131 | 2.15.5 | 8.5.3[^2] | Ubuntu 22.04 |
| 3.10.12    | 11.8.0 | 11.11.3.6 | 8.9.0.131 | 2.15.5 | 8.5.3[^2] | Ubuntu 22.04 |
| 3.11.2[^1] | 11.8.0 | 11.11.3.6 | 8.7.0.84  | 2.15.5 | 8.5.3[^2] | Ubuntu 22.04 |
| 3.10.11    | 11.8.0 | 11.11.3.6 | 8.7.0.84  | 2.15.5 | 8.5.3[^2] | Ubuntu 22.04 |
| 3.11.1[^1] | 11.8.0 | 11.11.3.6 | 8.7.0.84  | 2.16.2 | 8.5.3     | Ubuntu 20.04 |
| 3.10.10    | 11.8.0 | 11.11.3.6 | 8.7.0.84  | 2.16.2 | 8.5.3     | Ubuntu 20.04 |

[^1]: w/o numba
[^2]: `amd64` only

## PyTorch/TensorFlow compatibility

| Python | CUDA | PyTorch[^3]    | TensorFlow                |
|:-------|:-----|:---------------|:--------------------------|
| 3.12   | 12.5 | 2.2 ≤ version  | 2.16 ≤ version            |
| 3.12   | 11.8 | 2.2 ≤ version  | 2.16 ≤ version (CPU-only) |
| 3.11   | 11.8 | 2.0 ≤ version  | 2.12 ≤ version < 2.15     |
| 3.10   | 11.8 | 1.12 ≤ version | 2.8  ≤ version < 2.15     |

[^3]: Installs its own CUDA binaries

## Recommended NVIDIA driver (Regular)

| CUDA   | Linux driver version | Windows driver version[^4] |
|:-------|:---------------------|:---------------------------|
| 12.5.0 | ≥ 555.42.02          | ≥ 555.85                   |
| 11.8.0 | ≥ 520.61.05          | ≥ 520.06                   |

[^4]: [GPU support in Docker Desktop | Docker Docs](https://docs.docker.com/desktop/gpu/),
[Nvidia GPU Support for Windows · Issue #19005 · containers/podman](https://github.com/containers/podman/issues/19005)

## Supported NVIDIA drivers (LTSB)

| CUDA   | Driver version 535[^5] | Driver version 470[^6] |
|:-------|:----------------------:|:----------------------:|
| 12.5.0 | 🟢                      | 🟢                      |
| 11.8.0 | 🟡                      | 🟢                      |

🟢: Works due to the CUDA forward compat package  
🟡: Supported due to backward compatibility

[^5]: EOL: June 2026  
[^6]: EOL: July 2024
