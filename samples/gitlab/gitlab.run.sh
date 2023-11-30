docker run -itd -p 2222:22 -p 2443:443 -p 5678:5678 --name gitlab --restart=always \
                -v /srv/gitlab/config:/etc/gitlab \
                -v /srv/gitlab/logs:/var/log/gitlab \
                -v /srv/gitlab/data:/var/opt/gitlab \
docker.io/gitlab/gitlab-ce
