import Config

import_config System.get_env("APP_ENV") <> "/" <> System.get_env("COUNTRY") <> ".exs"
