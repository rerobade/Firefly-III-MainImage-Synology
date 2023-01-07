ARG build_platform
ARG build_base
FROM fireflyiii/base:$build_base-$build_platform

# For more information about fireflyiii/base visit https://dev.azure.com/firefly-iii/BaseImage

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY entrypoint-fpm.sh /usr/local/bin/entrypoint-fpm.sh
COPY counter.txt /var/www/counter-main.txt
COPY date.txt /var/www/build-date-main.txt

ARG version
ENV VERSION=$version
RUN curl -sSL https://github.com/firefly-iii/firefly-iii/archive/$VERSION.tar.gz | tar xzC $FIREFLY_III_PATH --strip-components 1 && \
    chmod -R 775 $FIREFLY_III_PATH/storage && \
    composer install --prefer-dist --no-dev --no-scripts && /usr/local/bin/finalize-image.sh

COPY alerts.json /var/www/html/resources/alerts.json

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
