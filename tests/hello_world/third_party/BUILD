package(default_visibility = ["//visibility:public"])

java_library(
    name = "test_deps",
    exports = [
        "//third_party/jvm/io/kotlintest:kotlintest_assertions",
        "//third_party/jvm/io/kotlintest:kotlintest_core",
        "//third_party/jvm/io/kotlintest:kotlintest_runner_junit4",
    ],
)

java_binary(
    name = "bazel_deps",
    main_class = "com.github.johnynek.bazel_deps.ParseProject",
    runtime_deps = ["@bazel_deps//jar"],
)
