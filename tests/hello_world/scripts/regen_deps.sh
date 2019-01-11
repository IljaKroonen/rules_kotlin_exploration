WS_ROOT=$(bazel info workspace)

MSYS_NO_PATHCONV=1 bazel run "//third_party:bazel_deps" generate -- \
    -r ${WS_ROOT} \
    -d third_party/dependencies.yaml \
    -s third_party/jvm/workspace.bzl
