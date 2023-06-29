FROM infracost/infracost:ci-0.10

COPY cost.sh /
RUN chmod +x /cost.sh

RUN apk add zstd

ENTRYPOINT ["ash","/cost.sh"]
