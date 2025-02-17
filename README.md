## GET SSL certification with certbot + docker

## requirements

``` java
1. your domain
2. docker
```


## how to use it

### 1. execute `run.sh` with your domain and your email

``` bash
./run.sh [yourdomain.com] [youremail@yourdomain.com]
```

now your certification located in `./certificates/live/[yourdomain.com]`


## (optional) apply your docker nginx server

1. replace `[domain_here]` to your domain in `./nginx-ssl/nginx/conf.d/default.conf` and specify tarrget to pass your web application

``` nginx
server {
    listen 443 ssl;
    server_name [domain_here];

    ssl_certificate /etc/letsencrypt/live/[domain_here]/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/[domain_here]/privkey.pem;

    location / {
            proxy_pass http://[your application ip(private or public)];
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

2. run `docker-conmpose.yml` in `nginx-ssl` directory

```
docker compose up -d
```

## (optional) renew your certifications 

1. just run `run.sh` script in `renew` directory with nginx container name

```
./run.sh [nginx container name]
```

## apply test

``` bash
curl https://yourdomain.com
```

