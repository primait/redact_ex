FROM public.ecr.aws/prima/elixir:1.13.4-1

# Serve per avere l'owner dei file scritti dal container uguale all'utente Linux sull'host
USER app

WORKDIR /code

ENTRYPOINT ["/bin/bash", "-c"]
CMD []
