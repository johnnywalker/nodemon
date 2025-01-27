# nodemon

Run node.js process and collect statistics.

## Usage

Start a StatsD server:

```shell
docker run -d --name graphite \
       -p 80:80 \
       -p 2003-2004:2003-2004 \
       -p 2023-2024:2023-2024 \
       -p 8125:8125/udp \
       -p 8126:8126 \
       graphiteapp/graphite-statsd
```

Start shell with `nix`:

```shell
nix shell . --command zsh
```

Run process via `nodemon`:

```shell
nodemon -p dev ./node_modules/.bin/gatsby build
```
