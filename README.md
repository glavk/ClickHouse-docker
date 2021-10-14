# ClickHouse-docker

Build ClickHouse docker image for ARM (Graviton2).

Based on official [Dockerfile](https://github.com/ClickHouse/ClickHouse/tree/master/docker/server)

--- 

Example of usage build with tag clickhouse:
```sh 
docker build . -t clickhouse
```

and run:
```sh
docker run -d clickhouse
```