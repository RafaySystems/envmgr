FROM infracost/infracost:ci-0.10

COPY cost.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/cost.sh

RUN apk add zstd

ENTRYPOINT ["ash","/usr/local/bin/cost.sh"]
