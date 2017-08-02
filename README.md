# docker-python-base
Python base container for python apps

calls symlinks.sh on startup which will create symbolic links in /app for every file that exists in /config. If /config does not exist no links will be created. Kubernetes is configured to mount configs in the /config directory. After the links are created the startup.sh provided by each service will be called.
