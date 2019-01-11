load("@com_github_iljakroonen_rules_kotlin//:kotlin.bzl", "kt_jvm_import", "kt_jvm_library")

# This import contains an inline function
# We are then using the inline function to demonstrate that we don't have ijarification
kt_jvm_import(
    name = "logging",
    jars = [
        "//logging/src/main/kotlin/com/github/iljakroonen/logging:logging.jar",
    ],
)

kt_jvm_library(
    name = "main_lib",
    srcs = [
        "HelloWorld.kt",
    ],
    data = [
        "//data:config",
    ],
    resources = [
        "//main/src/main/resources",
    ],
    deps = [
        ":logging",
        "//add/src/main/kotlin/com/github/iljakroonen/add",
        "//subtract/src/main/java/com/github/iljakroonen/subtract",
    ],
)

java_binary(
    name = "main",
    main_class = "com.github.iljakroonen.main.HelloWorldKt",
    runtime_deps = [
        ":main_lib",
    ],
)
