# Lumen docker image

Build the container for your Lumen microservice quickly and easily. The basic image fabriziocaf/lumen:tagname is already equipped with all the basic functions for an app integrated on the Framework Lumen 7 (also compatible with v. 6).

## Start

**Dockerfile** production and staging:
  
    FROM fabriziocaf/lumen:tagname  
    COPY ./source /var/www/
    USER root
    RUN cp .env.example .env \
     && set -xe \
     && composer install --no-dev --no-scripts --no-suggest --no-interaction --prefer-dist --optimize-autoloader \
     && composer dump-autoload --no-dev --optimize --classmap-authoritative
    USER www-data 
    
**Dockerfile** dev:
  
    FROM fabriziocaf/lumen:tagname  
    COPY ./source /var/www/
    USER root
    RUN cp .env.example .env \
     && set -xe \
     && composer install --no-suggest --no-interaction --prefer-dist --optimize-autoloader \
     && composer dump-autoload --optimize --classmap-authoritative
    USER www-data
    
**docker-compose**:

    appname:
        image: fabriziocaf/lumen:tagname
        container_name: appname
        build:
          context: .
        volumes:
          - ./sourcedir:/var/www
          
sourcedir = path of your code
