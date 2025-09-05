This repository provides a Docker container for [MeshSense](https://affirmatech.com/meshsense)
allowing it to run headless in server mode.

See: https://hub.docker.com/r/bajotumn/meshsense

Typical usage:
```shell
docker run -d -p 5920:5920 --name meshsense -e ACCESS_KEY=mySecretAccessKey meshsense
```

`docker-compose`
```yaml
volumes:
  data:
services:
  meshsense:
    image: bajotumn/meshsense
    restart: unless-stopped
    environment:
      - ACCESS_KEY=mySecretAccessKey
      - PORT=5920
    expose:
      - 5920
    volumes:
      - data:/root/.local/share/meshsense/
    labels:
      - traefik.enable=true
      - traefik.http.routers.meshsense.entrypoints=https
      - traefik.http.routers.meshsense.tls=true
      - traefik.http.routers.meshsense.rule=Host(`meshsense.<yourdomain>.com`)
      - traefik.http.services.meshsense.loadbalancer.server.port=5920
      - traefik.http.services.meshsense.loadbalancer.healthcheck=true
      - traefik.http.services.meshsense.loadbalancer.healthcheck.interval=30s
      - traefik.http.services.meshsense.loadbalancer.healthcheck.path=/
      - traefik.http.routers.meshsense.middlewares=google-oidc@file     # See tips for securing
```


## Tips for securing MeshSense
Use Traefik with oauth plugins like [Google OIDC Auth](https://plugins.traefik.io/plugins/65d5360746079255c9ffd1e2/google-oidc-auth)

`traefik.yml` static config (or docker labels if running traefik as container)
```yaml
experimental:
  plugins:
    google-oidc-auth-middleware:
      moduleName: "github.com/andrewkroh/google-oidc-auth-middleware"
      version: v0.2.0
```

`10-google-oauth.yml` dynamic config (or labels, but this gets very verbose)
```yaml
http:
  middlewares:
    google-oidc:
      plugin:
        googleoidc:
          oidc:
            clientID: example.apps.googleusercontent.com
            clientSecret: <secret>
          cookie:
            secret: make-this-secure
          authorized:
            emails:
              - my-fancy-email@gmail.com
```