licenses(["notice"])
load("@com_github_iljakroonen_rules_kotlin//:kotlin.bzl", "kt_jvm_import")
java_library(
    name = "reflections",
    exports = [
        "//external:jar/org/reflections/reflections"
    ],
    runtime_deps = [
        "//third_party/jvm/com/google/guava:guava",
        "//third_party/jvm/org/javassist:javassist"
    ],
    visibility = [
        "//third_party/jvm:__subpackages__"
    ]
)


