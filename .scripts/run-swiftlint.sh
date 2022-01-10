if [ -z "$CI" ]; then
     "${PODS_ROOT}/SwiftLint/swiftlint" autocorrect --config ./.configs/swiftlint.yml
     "${PODS_ROOT}/SwiftLint/swiftlint" lint --config ./.configs/swiftlint.yml
fi
