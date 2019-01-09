package com.github.iljakroonen.logging

private var logLevel = 0

val currentLogLevel get() = logLevel

fun setLogLevel(newLogLevel: Int) {
    logLevel = newLogLevel
}

inline fun info(messageBuilder: () -> String) {
    if (currentLogLevel >= 1) {
        println(messageBuilder())
    }
}
