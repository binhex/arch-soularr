#!/usr/bin/dumb-init /bin/bash

install_path="/usr/lib/soularr"
virtualenv_path="${install_path}/venv"
config_path="/config/soularr"

# ensure we are in the install directory
cd "${install_path}" || exit 1

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

# setup signal handlers for graceful shutdown
shutdown='false'
trap "shutdown='true'" SIGTERM SIGINT

# run app in loop with restart capability
while [[ "${shutdown}" == 'false' ]]; do
	python3 "${install_path}/soularr.py" --config-dir "${config_path}" --no-lock-file &
	pid=$!

	# wait for the process or shutdown signal
	while kill -0 $pid 2>/dev/null && [[ "${shutdown}" == 'false' ]]; do
		sleep 1
	done

	# if shutdown requested, kill the python process
	if [[ "${shutdown}" == 'true' ]]; then
		kill -TERM $pid 2>/dev/null
		wait $pid 2>/dev/null
		break
	fi

	# process exited, wait before restart
	wait $pid 2>/dev/null

	if [[ "${shutdown}" == 'false' ]]; then
		echo "[info] Process exited, restarting in ${SCRIPT_INTERVAL:-300} seconds..."
		sleep "${SCRIPT_INTERVAL:-300}" &
		wait $!
	fi
done

echo "[info] Shutdown complete"
