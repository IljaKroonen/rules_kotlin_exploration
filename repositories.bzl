load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

def kotlin_repositories():
    http_archive(
        name = "org_jetbrains_kotlin",
        urls = [
            #"https://github.com/JetBrains/kotlin/releases/download/v1.3.10/experimental-kotlin-compiler-1.3.10-windows-x64.zip"
            #"https://github.com/JetBrains/kotlin/releases/download/v1.3.11/experimental-kotlin-compiler-linux-x64.zip",
            "https://github.com/JetBrains/kotlin/releases/download/v1.3.11/kotlin-compiler-1.3.11.zip",
        ],
        sha256 = "03de0f1a4b49d36433e60ae495982f046782eb3725e6e22a04e24ef38be9a409",
        #sha256 = "611f6a465ed4fc30814744c20f7f627fc9c7773fb40f56eb51ca718021233c86",
        #sha256 = "63b1a3529cf05d980767c2f8e4018cd5cf7f6ad966aa507ef3d05263dc24339b",
        strip_prefix = "kotlinc",
        build_file = "@com_github_iljakroonen_rules_kotlin//:BUILD.kotlin",
    )

    http_file(
        name = "io_bazel_jarhelper_java",
        urls = ["https://raw.githubusercontent.com/bazelbuild/bazel/dc8fea0d7fce9f6aaa7b971d1bf2d81895c77fac/src/java_tools/buildjar/java/com/google/devtools/build/buildjar/jarhelper/JarHelper.java"],
        sha256 = "3b8f0e350ac185fe5783d768845eb458e5c6365bf4c57bbcd01850e3262136cd",
    )

    http_file(
        name = "io_bazel_jarcreator_java",
        urls = ["https://raw.githubusercontent.com/bazelbuild/bazel/dc8fea0d7fce9f6aaa7b971d1bf2d81895c77fac/src/java_tools/buildjar/java/com/google/devtools/build/buildjar/jarhelper/JarCreator.java"],
        sha256 = "eacb422a5aa1e256fd263354d0dedcff6d95c378e5534d4778d0390fd41f6978",
    )
