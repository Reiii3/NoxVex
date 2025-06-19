$AXFUN

check=$(settings get global driver_package)

if [[ $1 == true ]]; then
  if [[ "$check" = "$MODULE_PKG" ]]; then
    echo "Driver Game In $(pkglist -L $MODULE_PKG) isActive"
  else
    settings delete global updatable_driver_production_opt_in  >/dev/null 2>&1;
    settings put global updatable_driver_production_opt_in_apps $MODULE_PKG;
   apps=$(settings get global updatable_driver_production_opt_in_apps)
    echo "Activation Driver Game In $(pkglist -L $apps)"
  fi
else
  settings delete global updatable_driver_production_opt_in  >/dev/null 2>&1;
  echo "Driver Game Non-Actived"
fi