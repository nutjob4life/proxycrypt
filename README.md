# 🕵️‍♀️ ProxyCrypt

ProxyCrypt is a lightweight HTTPS wrapper for a non-encrypted reversed-proxy with a random self-signed encryption certificate key. It acts as an SSL/TLS termination for upstream services, relieving them of the computational requirements of encryption (not to mention the woeful practice of including keystores in their Docker images).

It also offers whitelisting.

ProxyCrypt itself does not include a certificate or keystore. Instead, it generates a random self-signed certificate on each startup. This means:

-   Better separation of concerns: application containers and processes can focus on their applications, not on encryption.
-   A single TLS stack can be presented to an outside composition or swarm, enabling tighter focus on vulnerabilities instead of chasing them around multiple implementations in multiple containers/processes.
-   Private keystores shouldn't appear in images in public image/container registries since anyone can grab a copy and masquerade as your own service.
    -   Generating and storing keystores at image build time also doesn't give a good way to support certificate revocation.
-   This approach should also satisfy the JPL requirement of having at least self-signed certificates on all host-accessible services

It's powered by [Nginx](https://nginx.org/) and [Alpine](https://www.alpinelinux.org/), which is why ProxyCrypt is so lightweight 🪶.


## 🏃‍♀️ Building and Running

To build the ProxyCrypt image, run:

    docker image build --tag nutjob4life/proxycrypt --file docker/Dockerfile .

To run it, put it in your Docker Composition/Swarm/etc., and set these environment variables as needed:

| Variable         | Use                                                                   | Default            |
|:-----------------|:----------------------------------------------------------------------|:-------------------|
| `PROXY_URL`      | Upstream service in the composition/swarm/etc.                        | (unset, required)  |
| `PROXY_PATH`     | URL path from which the service should be called, e.g. /exposed_path/ | (unset, required)  |
| `PROXY_PORT`     | port used by the proxy, as seen by the user                           | (unset, required)  |
| `CERT_CN`        | Common name for the random certificate, such as `www.myservice.io`    | `localhost`        |
| `CERT_DAYS`      | How many days before the random certificate expires                   | `365`              |
| `PROXY_REDIRECT` | How to rewrite Location and Refresh headers if necessary              | (unset, required)¹ |
| `WHITELIST`      | Comma-separated list of valid upstream IP addresses                   | N/A²               |

You can also run it locally for testing purposes. Suppose you've got a non-SSL service on TCP port, say, 9200 on your rig. You can run:

    docker container run --env PROXY_URL=http://host.docker.internal:9200/ ---env PROXY_PATH=/exposed_path/ --publish 8888:443 --rm nutjob4life/proxycrypt --detach

and get an `https` version of that service on port 8888:

    curl --insecure https://localhost:8888/exposed_path

You'll need the `--insecure` (or its equivalent in other applications) since it's a self-signed key.


### 🔢 Versioning

I use the [SemVer](https://semver.org/) philosophy for versioning this software.


## 📃 License

The project is licensed under the [Apache version 2](LICENSE.md) license.


## 👣 Footnotes

¹See the [Nginx documentation on `proxy_redirect`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_redirect) for more information. Unsure where to start? Try using the word `default`.
²See the [Nginx documentation on `allow` and `deny`](https://nginx.org/en/docs/http/ngx_http_access_module.html) for syntax.
