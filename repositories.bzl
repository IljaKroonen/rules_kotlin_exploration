load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def kotlin_repositories():
    http_archive(
        name = "org_jetbrains_kotlin",
        urls = [
            #"https://github.com/JetBrains/kotlin/releases/download/v1.3.10/experimental-kotlin-compiler-1.3.10-windows-x64.zip"
            "https://github.com/JetBrains/kotlin/releases/download/v1.3.11/experimental-kotlin-compiler-linux-x64.zip",
        ],
        sha256 = "611f6a465ed4fc30814744c20f7f627fc9c7773fb40f56eb51ca718021233c86",
        #sha256 = "63b1a3529cf05d980767c2f8e4018cd5cf7f6ad966aa507ef3d05263dc24339b",
        strip_prefix = "kotlinc",
        build_file = "@com_github_iljakroonen_rules_kotlin//:BUILD.kotlin",
    )
