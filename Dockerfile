FROM postgres:9.6.2
ADD bin /montagu-bin
ENV PATH="/montagu-bin:$PATH"
ENV POSTGRES_DB montagu
ENV POSTGRES_USER vimc
ENV POSTGRES_PASSWORD changeme
