# foa

Feedback On Anything.

## build & run

### quick start

Remove temporary feedback storage, build and run the application:

```
$ ./quick_start.sh
```

### start

Remove temporary feedback storage, generate documentation, build and run the application:

```
$ ./start.sh
```

### clean

Remove temporary feedback storage, generate documentation:

```
$ ./clean.sh
```

### docker

```shell
docker build -t build_foa --file=alpine/build/dockerfile .
```

```shell
sudo docker run --rm --volume="$PWD/alpine/run/artifacts:/artifacts" build_foa
```

```shell
sudo docker build -t foa alpine/run/
```

```shell
./create_certs.sh
```

```shell
sudo docker run -d -p 3000:3000 --volume="$PWD/ssl:/etc/ssl/certs" --log-driver=syslog foa
```