# Copyright 2018 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Modified file from https://github.com/bazelbuild/rules_kotlin/blob/cab5eaffc2012dfe46260c03d6419c0d2fa10be0/kotlin/internal/jvm/plugins.bzl

def restore_label(l):
    """Restore a label struct to a canonical label string."""
    lbl = l.workspace_root
    if lbl.startswith("external/"):
        lbl = lbl.replace("external/", "@")
    return lbl + "//" + l.package + ":" + l.name

KtJvmPluginInfo = provider(
    doc = "This provider contains the plugin info for the JVM aspect",
    fields = {
        "annotation_processors": "a serializeable list of structs containing annotation processor definitions",
    },
)

_EMPTY_PLUGIN_INFO = [KtJvmPluginInfo(annotation_processors = [])]

def merge_plugin_infos(attrs):
    """Merge all of the plugin infos found in the provided sequence of attributes.
    Returns:
        A KtJvmPluginInfo provider, Each of the entries is serializable."""
    tally = {}
    annotation_processors = []
    for info in [a[KtJvmPluginInfo] for a in attrs]:
        for p in info.annotation_processors:
            if p.label not in tally:
                tally[p.label] = True
                annotation_processors.append(p)
    return KtJvmPluginInfo(
        annotation_processors = annotation_processors,
    )

def _kt_jvm_plugin_aspect_impl(target, ctx):
    if ctx.rule.kind == "java_plugin":
        processor = ctx.rule.attr
        merged_deps = java_common.merge([j[JavaInfo] for j in processor.deps])
        return [KtJvmPluginInfo(
            annotation_processors = [
                struct(
                    label = restore_label(ctx.label),
                    processor_class = processor.processor_class,
                    classpath = merged_deps.transitive_runtime_jars.to_list(),
                    generates_api = processor.generates_api,
                ),
            ],
        )]
    elif ctx.rule.kind == "java_library":
        return [merge_plugin_infos(ctx.rule.attr.exported_plugins)]
    else:
        return _EMPTY_PLUGIN_INFO

kt_jvm_plugin_aspect = aspect(
    doc = """This aspect collects Java Plugins info and other Kotlin compiler plugin configurations from the graph.""",
    attr_aspects = [
        "plugins",
        "exported_plugins",
    ],
    provides = [KtJvmPluginInfo],
    implementation = _kt_jvm_plugin_aspect_impl,
)