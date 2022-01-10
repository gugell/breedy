# if [[ -f "${PODS_ROOT}/SwiftGen/bin/swiftgen" ]]; then
#   "${PODS_ROOT}/SwiftGen/bin/swiftgen config run --config ${SRCROOT}/.configs/swiftgen.yml"
# else
#   echo "warning: SwiftGen is not installed. Run 'pod install --repo-update' to install it."
# fi

if which swiftgen >/dev/null; then
  swiftgen config run --config .configs/swiftgen.yml
else
  echo "warning: SwiftGen not installed, download it from https://github.com/SwiftGen/SwiftGen"
  exit 1
fi
