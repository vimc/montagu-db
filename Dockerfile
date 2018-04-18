FROM postgres:10.3
COPY bin /montagu-bin
ENV PATH="/montagu-bin:$PATH"
ENV POSTGRES_DB montagu
ENV POSTGRES_USER vimc
ENV POSTGRES_PASSWORD changeme
# This is needed to override the loss of data that happens if you
# don't mount a persistent volume at the mount point.
ENV PGDATA /pgdata

COPY conf /etc/montagu
RUN cat /etc/montagu/postgresql.conf /etc/montagu/postgresql.test.conf.in > \
        /etc/montagu/postgresql.test.conf
RUN cat /etc/montagu/postgresql.conf /etc/montagu/postgresql.production.conf.in > \
        /etc/montagu/postgresql.production.conf
RUN chown -R postgres:postgres /etc/montagu
RUN ./docker-entrypoint.sh --version

RUN cp /montagu-bin/create-users.sh /docker-entrypoint-initdb.d/

ENTRYPOINT ["start-with-config.sh"]
CMD ["/etc/montagu/postgresql.conf"]
