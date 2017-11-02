FROM postgres:10.0
COPY bin /montagu-bin
ENV PATH="/montagu-bin:$PATH"
ENV POSTGRES_DB montagu
ENV POSTGRES_USER vimc
ENV POSTGRES_PASSWORD changeme
# This is needed to override the loss of data that happens if you
# don't mount a persistent volume at the mount point.
ENV PGDATA /pgdata

COPY postgresql.conf postgresql.conf
COPY postgresql.test.conf postgresql.test.conf
COPY start-with-config.sh /montagu-bin/start-with-config.sh

RUN ./docker-entrypoint.sh --version
