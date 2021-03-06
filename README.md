# Docker for Data Science

This repo contains scripts to run Jupyter (and install all DS libs) on a remote docker container.

## How to use this code

1. Make sure you have installed [NVIDIA driver](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#how-do-i-install-the-nvidia-driver) and [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)
    - `nvidia-docker version`
    - `nvidia-smi`
2. Set up the connection with remote server: ```ssh -L listening_remote_port:host:hostport user@remote```. For example: ```ssh -L 9999:localhost:9999 user@remote```
3. Clone repo to the remote and run `build.sh`.
4. Then run:

    ```bash
    nvidia-docker run -dit --restart unless-stopped --ipc=host -p remote_host_port:container_port -v /path/to/host/dir:/path/to/container/dir -v /any/other/host/dir:/any --name sandpiturtle_lab sandpiturtle/lab
    ```
