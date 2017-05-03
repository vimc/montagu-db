FROM postgres:9.6.2
ADD bin /montagu-bin
ENV PATH="/montagu-bin:$PATH"
ENV POSTGRES_DB montagu
ENV POSTGRES_USER vimc
ENV POSTGRES_PASSWORD changeme
# This is needed to override the loss of data that happens if you
# don't mount a persistent volume at the mount point.
ENV PGDATA /pgdata
COPY schema/montagu-db.sql montagu-db.sql
COPY functions functions
RUN sed "s/'current_timestamp'/CURRENT_TIMESTAMP/" montagu-db.sql > \
      /docker-entrypoint-initdb.d/montagu.sql && \
    cat functions/impact.sql >> /docker-entrypoint-initdb.d/montagu.sql && \
    cat functions/indexes.sql >> /docker-entrypoint-initdb.d/montagu.sql && \
    ./docker-entrypoint.sh --version && \
    rm -f /docker-entrypoint-initdb.d/montagu.sql
