load("@com_github_iljakroonen_rules_kotlin//:kotlin.bzl", "kt_jvm_library")

kt_jvm_library(
    name = "counter",
    srcs = glob([
        "*.kt",
    ]),
    visibility = [
        "//main:__subpackages__",
    ],
    deps = [
        "//third_party:dagger",
    ],
)
