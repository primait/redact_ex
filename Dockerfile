FROM 279066465364.dkr.ecr.eu-west-1.amazonaws.com/prima-elixir:1.20.4-3

# Serve per avere l'owner dei file scritti dal container uguale all'utente Linux sull'host
USER app

WORKDIR /code

ENTRYPOINT ["/bin/bash", "-c"]
CMD []
