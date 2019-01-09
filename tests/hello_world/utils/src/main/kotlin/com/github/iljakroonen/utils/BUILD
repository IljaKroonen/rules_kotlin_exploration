load("@com_github_iljakroonen_rules_kotlin//:kotlin.bzl", "kt_jvm_library")

kt_jvm_library(
    name = "utils",
    srcs = glob([
        "*.kt",
    ]),
    visibility = [
        "//utils:__subpackages__",
    ],
    exports = [
        "//add/src/main/kotlin/com/github/iljakroonen/add",
        "//subtract/src/main/java/com/github/iljakroonen/subtract",
    ],
)
