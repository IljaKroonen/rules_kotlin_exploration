licenses(["notice"])
load("@com_github_iljakroonen_rules_kotlin//:kotlin.bzl", "kt_jvm_import")
java_library(
    name = "junit",
    exports = [
        "//external:jar/junit/junit"
    ],
    runtime_deps = [
        "//third_party/jvm/org/hamcrest:hamcrest_core"
    ],
    visibility = [
        "//third_party/jvm:__subpackages__"
    ]
)


