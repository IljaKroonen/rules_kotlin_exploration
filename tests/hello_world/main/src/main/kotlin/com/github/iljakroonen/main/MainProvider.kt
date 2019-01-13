package com.github.iljakroonen.main

import com.github.iljakroonen.counter.Counter
import dagger.Component
import javax.inject.Singleton

@Singleton
@Component
interface MainProvider {
    fun counter(): Counter
}
