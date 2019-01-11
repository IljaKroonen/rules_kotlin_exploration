package com.github.iljakroonen.rules.kotlin;

import com.google.devtools.build.buildjar.jarhelper.JarCreator;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;

class CompileKotlin {
    public static void main(String[] args) {
        try {
            String kotlincExecutablePath = args[0];
            String jdkHome = args[1];
            String[] kotlinSources = args[2].split(System.getProperty("path.separator"));
            String compileClasspath = args[3];
            Path outputJar = Paths.get(args[4]);

            Path tempCompilationDirectory = Files.createTempDirectory("kotlinc_outputs");

            String[] kotlincFlags = new String[]{
                    "-d",
                    tempCompilationDirectory.toString(),
                    "-cp",
                    compileClasspath,
                    "-jdk-home",
                    jdkHome,
                    "-jvm-target",
                    "1.8"
            };

            ArrayList<String> kotlincArgs = new ArrayList<>();
            kotlincArgs.add(kotlincExecutablePath);
            kotlincArgs.addAll(Arrays.asList(kotlinSources));
            kotlincArgs.addAll(Arrays.asList(kotlincFlags));

            Process process = new ProcessBuilder()
                    .command(kotlincArgs)
                    .redirectError(ProcessBuilder.Redirect.INHERIT).redirectOutput(ProcessBuilder.Redirect.INHERIT)
                    .start();

            int outCode = process.waitFor();

            assert (outCode == 0);

            JarCreator jarCreator = new JarCreator(outputJar);
            jarCreator.addDirectory(tempCompilationDirectory);
            jarCreator.setCompression(true);
            jarCreator.setNormalize(true);
            jarCreator.execute();
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
        }
    }
}
