#!/usr/bin/dumb-init /bin/bash

install_path="/usr/lib/soularr"
virtualenv_path="${install_path}/venv"
config_path="/config/soularr"

# activate virtualenv where requirements have been installed from install.sh
source "${virtualenv_path}/bin/activate"

# create config directory if it does not exist
mkdir -p "${config_path}"

# copy default config file if it does not exist
if [[ ! -f "${config_path}/config.ini" ]]; then
	cp "${install_path}/config.ini" "${config_path}/config.ini"
fi

# install ini manipulation python module
pip install crudini

# config manipulation via crudini
###

# Lidarr settings
crudini --set "${config_path}/config.ini" Lidarr api_key "${LIDARR_API_KEY}"
crudini --set "${config_path}/config.ini" Lidarr host_url "${LIDARR_HOST_URL}"
crudini --set "${config_path}/config.ini" Lidarr download_dir "${LIDARR_DOWNLOAD_DIR}"
crudini --set "${config_path}/config.ini" Lidarr disable_sync "${LIDARR_DISABLE_SYNC}"

# Slskd settings
crudini --set "${config_path}/config.ini" Slskd api_key "${SLSKD_API_KEY}"
crudini --set "${config_path}/config.ini" Slskd host_url "${SLSKD_HOST_URL}"
crudini --set "${config_path}/config.ini" Slskd url_base "${SLSKD_URL_BASE}"
crudini --set "${config_path}/config.ini" Slskd download_dir "${SLSKD_DOWNLOAD_DIR}"
crudini --set "${config_path}/config.ini" Slskd delete_searches "${SLSKD_DELETE_SEARCHES}"
crudini --set "${config_path}/config.ini" Slskd stalled_timeout "${SLSKD_STALLED_TIMEOUT}"

# run app (foreground)
python3 "${install_path}/soularr.py" --config-dir "${config_path}" --no-lock-file
