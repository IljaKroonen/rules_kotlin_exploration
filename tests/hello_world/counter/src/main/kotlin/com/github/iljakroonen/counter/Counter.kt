package com.github.iljakroonen.counter

open class Counter {
    private var currentCount = 0L

    fun count() {
        currentCount += 1
    }

    val count get() = currentCount
}
