ARG build_platform
ARG build_base
ARG build_version
FROM fireflyiii/base:$build_base-$build_platform

# USER nonroot

# See also: https://dev.azure.com/firefly-iii/MainImage

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY entrypoint-fpm.sh /usr/local/bin/entrypoint-fpm.sh

ENV VERSION=$build_version

# install Firefly III and execute finalize-image.
RUN curl -SL https://github.com/firefly-iii/firefly-iii/archive/$build_version.tar.gz | tar xzC $FIREFLY_III_PATH --strip-components 1 && \
    chmod -R 775 $FIREFLY_III_PATH/storage && \
    composer install --prefer-dist --no-dev --no-scripts && /usr/local/bin/finalize-image.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
