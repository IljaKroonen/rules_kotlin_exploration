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

java_plugin(
    name = "dagger_component_plugin",
    generates_api = 1,
    processor_class = "dagger.internal.codegen.ComponentProcessor",
    visibility = ["//visibility:private"],
    deps = [
        "//third_party/jvm/com/google/dagger:dagger_compiler",
    ],
)

java_library(
    name = "dagger",
    exported_plugins = [":dagger_component_plugin"],
    exports = [
        "//third_party/jvm/com/google/dagger",
        "//third_party/jvm/javax/inject:javax_inject",
    ],
)
