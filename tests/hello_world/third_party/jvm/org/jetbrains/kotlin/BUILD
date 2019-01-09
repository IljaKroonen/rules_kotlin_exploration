licenses(["notice"])
load("@com_github_iljakroonen_rules_kotlin//:kotlin.bzl", "kt_jvm_import")
java_library(
    name = "kotlin_reflect",
    exports = [
        "@org_jetbrains_kotlin//:kotlin-reflect"
    ],
    visibility = [
        "//third_party/jvm:__subpackages__"
    ]
)



java_library(
    name = "kotlin_script_runtime",
    exports = [
        "@org_jetbrains_kotlin//:kotlin-script-runtime"
    ],
    visibility = [
        "//third_party/jvm:__subpackages__"
    ]
)



java_library(
    name = "kotlin_stdlib",
    exports = [
        "@org_jetbrains_kotlin//:kotlin-stdlib"
    ],
    visibility = [
        "//third_party/jvm:__subpackages__"
    ]
)



java_library(
    name = "kotlin_stdlib_common",
    exports = [
        "//external:jar/org/jetbrains/kotlin/kotlin_stdlib_common"
    ],
    visibility = [
        "//third_party/jvm:__subpackages__"
    ]
)



java_library(
    name = "kotlin_stdlib_jdk7",
    exports = [
        "//external:jar/org/jetbrains/kotlin/kotlin_stdlib_jdk7"
    ],
    runtime_deps = [
        ":kotlin_stdlib"
    ],
    visibility = [
        "//third_party/jvm:__subpackages__"
    ]
)


