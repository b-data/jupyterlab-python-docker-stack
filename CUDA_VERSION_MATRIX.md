# CUDA Version Matrix

Image tags = Python versions

Topmost entry = Tag `latest`

| Python     | CUDA   | cuBLAS    | cuDNN     | NCCL   | TensorRT[^2]             | Linux distro |
|:-----------|:-------|:----------|:----------|:-------|:-------------------------|:-------------|
| 3.13.7     | 13.0.1 | 13.0.2.14 | 9.13.0.50 | 2.28.3 | n/a                      | Ubuntu 24.04 |
| 3.12.11    | 12.9.0 | 12.9.0.13 | 8.9.7.29  | 2.26.5 | 10.11.0.33/<br>10.3.0.26 | Ubuntu 22.04 |
| 3.13.6     | 12.9.1 | 12.9.1.4  | 9.11.1.4  | 2.27.3 | n/a                      | Ubuntu 22.04 |
| 3.13.5     | 12.9.1 | 12.9.1.4  | 9.11.0.98 | 2.27.3 | n/a                      | Ubuntu 22.04 |
| 3.13.4     | 12.9.0 | 12.9.0.13 | 9.10.1.4  | 2.26.5 | n/a                      | Ubuntu 22.04 |
| 3.13.3     | 12.9.0 | 12.9.0.13 | 9.10.1.4  | 2.26.5 | n/a                      | Ubuntu 22.04 |
| 3.12.10    | 12.9.0 | 12.9.0.13 | 8.9.7.29  | 2.26.5 | 10.11.0.33/<br>10.3.0.26 | Ubuntu 22.04 |
| 3.13.2     | 12.8.1 | 12.8.4.1  | 9.8.0.87  | 2.25.1 | n/a                      | Ubuntu 22.04 |
| 3.12.9     | 12.8.1 | 12.8.4.1  | 8.9.7.29  | 2.25.1 | 10.8.0.43/<br>10.3.0.26  | Ubuntu 22.04 |
| 3.13.1     | 12.8.0 | 12.8.3.14 | 9.7.0.66  | 2.25.1 | n/a                      | Ubuntu 22.04 |
| 3.12.8     | 12.8.0 | 12.8.3.14 | 8.9.7.29  | 2.25.1 | 10.8.0.43/<br>10.3.0.26  | Ubuntu 22.04 |
| 3.13.0[^1] | 12.6.3 | 12.6.4.1  | 9.6.0.74  | 2.23.4 | n/a                      | Ubuntu 22.04 |
| 3.12.7     | 12.6.3 | 12.6.4.1  | 8.9.7.29  | 2.23.4 | 10.7.0.23/<br>10.3.0.26  | Ubuntu 22.04 |
| 3.11.10    | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^3]                | Ubuntu 22.04 |
| 3.12.6     | 12.6.1 | 12.6.1.4  | 8.9.7.29  | 2.23.4 | 10.4.0.26/<br>10.3.0.26  | Ubuntu 22.04 |
| 3.11.9     | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^3]                | Ubuntu 22.04 |
| 3.12.5     | 12.6.1 | 12.6.1.4  | 8.9.7.29  | 2.22.3 | 10.4.0.26/<br>10.3.0.26  | Ubuntu 22.04 |
| 3.12.4     | 12.5.1 | 12.5.3.2  | 8.9.7.29  | 2.22.3 | 10.3.0.26                | Ubuntu 22.04 |
| 3.12.3     | 12.5.0 | 12.5.2.13 | 8.9.7.29  | 2.21.5 | 10.0.1.6                 | Ubuntu 22.04 |
| 3.12.2     | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^3]                | Ubuntu 22.04 |
| 3.11.8     | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^3]                | Ubuntu 22.04 |
| 3.12.1     | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^3]                | Ubuntu 22.04 |
| 3.11.7     | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^3]                | Ubuntu 22.04 |
| 3.12.0[^1] | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^3]                | Ubuntu 22.04 |
| 3.11.6     | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^3]                | Ubuntu 22.04 |
| 3.11.5     | 11.8.0 | 11.11.3.6 | 8.9.0.131 | 2.15.5 | 8.5.3[^3]                | Ubuntu 22.04 |
| 3.11.4     | 11.8.0 | 11.11.3.6 | 8.9.0.131 | 2.15.5 | 8.5.3[^3]                | Ubuntu 22.04 |
| 3.10.13    | 11.8.0 | 11.11.3.6 | 8.9.0.131 | 2.15.5 | 8.5.3[^3]                | Ubuntu 22.04 |
| 3.11.3     | 11.8.0 | 11.11.3.6 | 8.9.0.131 | 2.15.5 | 8.5.3[^3]                | Ubuntu 22.04 |
| 3.10.12    | 11.8.0 | 11.11.3.6 | 8.9.0.131 | 2.15.5 | 8.5.3[^3]                | Ubuntu 22.04 |
| 3.11.2[^1] | 11.8.0 | 11.11.3.6 | 8.7.0.84  | 2.15.5 | 8.5.3[^3]                | Ubuntu 22.04 |
| 3.10.11    | 11.8.0 | 11.11.3.6 | 8.7.0.84  | 2.15.5 | 8.5.3[^3]                | Ubuntu 22.04 |
| 3.11.1[^1] | 11.8.0 | 11.11.3.6 | 8.7.0.84  | 2.16.2 | 8.5.3                    | Ubuntu 20.04 |
| 3.10.10    | 11.8.0 | 11.11.3.6 | 8.7.0.84  | 2.16.2 | 8.5.3                    | Ubuntu 20.04 |

[^1]: w/o numba  
[^2]: amd64/arm64  
[^3]: `amd64` only

## Breaking changes

* Python 3.13: Drop TensorRT
  * <https://github.com/tensorflow/tensorflow/pull/68303>

## PyTorch/TensorFlow compatibility

| Python | CUDA | PyTorch[^4]                  | TensorFlow[^5]                   |
|:-------|:-----|:-----------------------------|:---------------------------------|
| 3.13   | 13.0 | version ≥ 2.5 (experimental) | n/a                              |
| 3.12   | 12.9 | version ≥ 2.4                | 2.18 > version ≥ 2.16            |
| 3.13   | 12.8 | version ≥ 2.5 (experimental) | n/a                              |
| 3.12   | 12.8 | version ≥ 2.4                | 2.18 > version ≥ 2.16            |
| 3.13   | 12.6 | version ≥ 2.5 (experimental) | n/a                              |
| 3.12   | 12.6 | version ≥ 2.4                | 2.18 > version ≥ 2.16            |
| 3.12   | 12.5 | version ≥ 2.4                | 2.18 > version ≥ 2.16            |
| 3.12   | 11.8 | version ≥ 2.4                | 2.18 > version ≥ 2.16 (CPU-only) |
| 3.11   | 11.8 | version ≥ 2.0                | 2.16 > version ≥ 2.12            |
| 3.10   | 11.8 | version ≥ 1.12               | 2.16 > version ≥ 2.9             |

[^4]: Installs its own CUDA dependencies
[^5]: The expected TensorRT version is symlinked to the installed TensorRT
version.  
❗️ This relies on backwards compatibility of TensorRT, which may not always be
given.

## Recommended NVIDIA driver (Regular)

| CUDA   | Linux driver version | Windows driver version[^6] |
|:-------|:---------------------|:---------------------------|
| 13.0.1 | ≥ 580.82.07          | n/a                        |
| 12.9.1 | ≥ 575.57.08          | ≥ 576.57                   |
| 12.9.0 | ≥ 575.51.03          | ≥ 576.02                   |
| 12.8.1 | ≥ 570.124.06         | ≥ 572.61                   |
| 12.8.0 | ≥ 570.117            | ≥ 572.30                   |
| 12.6.3 | ≥ 560.35.05          | ≥ 561.17                   |
| 12.6.2 | ≥ 560.35.03          | ≥ 560.94                   |
| 12.6.1 | ≥ 560.35.03          | ≥ 560.94                   |
| 12.5.1 | ≥ 555.42.06          | ≥ 555.85                   |
| 12.5.0 | ≥ 555.42.02          | ≥ 555.85                   |
| 11.8.0 | ≥ 520.61.05          | ≥ 520.06                   |

[^6]: [GPU support in Docker Desktop | Docker Docs](https://docs.docker.com/desktop/gpu/)  
[Nvidia GPU Support for Windows · Issue #19005 · containers/podman](https://github.com/containers/podman/issues/19005)

## Supported NVIDIA drivers (LTSB)

Only works with
[NVIDIA Data Center GPUs](https://resources.nvidia.com/l/en-us-gpu) or
[select NGC-Ready NVIDIA RTX boards](https://docs.nvidia.com/certification-programs/ngc-ready-systems/index.html).

| CUDA   | Driver version 580[^7] | Driver version 535[^8] | Driver version 470[^9] |
|:-------|:----------------------:|:----------------------:|:----------------------:|
| 13.0.1 | 🟢                      | 🔵                      | 🔴                      |
| 12.9.1 | 🟡                      | 🟢                      | 🔵                      |
| 12.9.0 | 🟡                      | 🟢                      | 🔵                      |
| 12.8.1 | 🟡                      | 🟢                      | 🔵                      |
| 12.8.0 | 🟡                      | 🟢                      | 🔵                      |
| 12.6.3 | 🟡                      | 🟢                      | 🔵                      |
| 12.6.2 | 🟡                      | 🟢                      | 🔵                      |
| 12.6.1 | 🟡                      | 🟢                      | 🔵                      |
| 12.5.1 | 🟡                      | 🟢                      | 🔵                      |
| 12.5.0 | 🟡                      | 🟢                      | 🔵                      |
| 11.8.0 | 🟡                      | 🟡                      | 🟢                      |

🔴: Not supported  
🔵: Supported with the CUDA forward compat package only  
🟢: Supported due to minor-version compatibility  
🟡: Supported due to backward compatibility

[^7]: EOL: August 2028  
[^8]: EOL: June 2026  
[^9]: EOL: July 2024
