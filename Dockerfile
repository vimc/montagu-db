FROM postgres:9.6.2
COPY bin /montagu-bin
ENV PATH="/montagu-bin:$PATH"
ENV POSTGRES_DB montagu
ENV POSTGRES_USER vimc
ENV POSTGRES_PASSWORD changeme
# This is needed to override the loss of data that happens if you
# don't mount a persistent volume at the mount point.
ENV PGDATA /pgdata

COPY conf /etc/montagu
## or COPY ... --chown=<user>:<group> in recent docker (>=17.09)
RUN chown -R postgres:postgres /etc/montagu

RUN start-with-config.sh /etc/montagu/postgresql.conf --version

# Configuration to allow streaming replication:
RUN echo "host replication all all md5" >> $PGDATA/pg_hba.conf && \
        createuser -U vimc -w --superuser   barman && \
        createuser -U vimc -w --replication streaming_barman

ENTRYPOINT ["start-with-config.sh"]
CMD ["/etc/montagu/postgresql.conf"]
