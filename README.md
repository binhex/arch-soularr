# Application

[Soularr](https://github.com/mrusse/soularr)

## Description

Soularr is a Python application that automates music downloads from Soulseek for Lidarr. It monitors Lidarr for wanted albums and searches Soulseek to download them, providing seamless integration between your music collection manager and the Soulseek network.

## Build notes

Latest commit to branch main for Soularr.

## Usage

```bash
docker run -d \
    --name=<container name> \
    -v <path for data files>:/data \
    -v <path for config files>:/config \
    -v /etc/localtime:/etc/localtime:ro \
    -e LIDARR_API_KEY=<lidarr api key> \
    -e LIDARR_HOST_URL=<lidarr host url> \
    -e LIDARR_DOWNLOAD_DIR=<lidarr download directory> \
    -e LIDARR_DISABLE_SYNC=<disable sync true/false> \
    -e SLSKD_API_KEY=<slskd api key> \
    -e SLSKD_HOST_URL=<slskd host url> \
    -e SLSKD_URL_BASE=<slskd url base> \
    -e SLSKD_DOWNLOAD_DIR=<slskd download directory> \
    -e SLSKD_DELETE_SEARCHES=<delete searches true/false> \
    -e SLSKD_STALLED_TIMEOUT=<stalled timeout in seconds> \
    -e HEALTHCHECK_COMMAND=<command> \
    -e HEALTHCHECK_ACTION=<action> \
    -e HEALTHCHECK_HOSTNAME=<hostname> \
    -e UMASK=<umask for created files> \
    -e PUID=<uid for user> \
    -e PGID=<gid for user> \
    binhex/arch-soularr
```

Please replace all user variables in the above command defined by <> with the
correct values.

## Access application

Console only

## Example

```bash
docker run -d \
    --name=soularr \
    -v /root/docker/data:/data \
    -v /apps/docker/soularr:/config \
    -v /etc/localtime:/etc/localtime:ro \
    -e LIDARR_API_KEY=yourlidarrapikey \
    -e LIDARR_HOST_URL=http://lidarr:8686 \
    -e LIDARR_DOWNLOAD_DIR=/data/lidarr_downloads \
    -e LIDARR_DISABLE_SYNC=False \
    -e SLSKD_API_KEY=yourslskdapikey \
    -e SLSKD_HOST_URL=http://slskd:5030 \
    -e SLSKD_URL_BASE=/ \
    -e SLSKD_DOWNLOAD_DIR=/data/slskd_downloads \
    -e SLSKD_DELETE_SEARCHES=False \
    -e SLSKD_STALLED_TIMEOUT=3600 \
    -e UMASK=000 \
    -e PUID=0 \
    -e PGID=0 \
    binhex/arch-soularr
```

## Notes

User ID (PUID) and Group ID (PGID) can be found by issuing the following command
for the user you want to run the container as:-

```bash
id <username>
```

___
If you appreciate my work, then please consider buying me a beer  :D

[![PayPal donation](https://www.paypal.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=MM5E27UX6AUU4)

[Documentation](https://github.com/binhex/documentation) | [Support forum](http://forums.unraid.net/index.php?topic=45821.0)
