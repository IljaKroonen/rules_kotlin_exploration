package com.github.iljakroonen.counter

import dagger.Component

@Component
class Counter {
    private var currentCount = 0L

    fun count() {
        currentCount += 1
    }

    val count get() = currentCount
}
