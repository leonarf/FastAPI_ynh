#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

# Transfer the main SSO domain to the App:
ynh_current_host=$(cat /etc/yunohost/current_host)
__YNH_CURRENT_HOST__=${ynh_current_host}

#=================================================
# ARGUMENTS FROM CONFIG PANEL
#=================================================

# 'debug_enabled' -> '__DEBUG_ENABLED__' -> settings.DEBUG
debug_enabled="0" # "1" or "0" string

# 'log_level' -> '__LOG_LEVEL__' -> settings.LOG_LEVEL
log_level="WARNING"

#=================================================
# SET CONSTANTS
#=================================================

# e.g.: point pip cache to: /var/www/$app/.cache/
XDG_CACHE_HOME="$install_dir/.cache/"

myynh_setup_python_venv() {
    # Always recreate everything fresh with current python version
    if [ -d "$install_dir/venv" ]; then
        ynh_safe_rm "$install_dir/venv"
    fi

    # Skip pip because of: https://github.com/YunoHost/issues/issues/1960
    ynh_exec_as_app python3 -m venv --without-pip "$install_dir/venv"

    ynh_exec_as_app "$install_dir/venv/bin/python3" -m ensurepip
    # using --no-cache-dir option because user doesn't have permission to write on cache directory (don't know if it's on purpose or not)
    ynh_exec_as_app "$install_dir/venv/bin/pip3" install --no-cache-dir --upgrade wheel pip setuptools
    ynh_exec_as_app "$install_dir/venv/bin/pip3" install --no-cache-dir -r "$install_dir/$requirements_path"
}
