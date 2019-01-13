package com.github.iljakroonen.main

import dagger.Component
import dagger.Module
import dagger.Provides

interface Provided {
    fun return2(): Int
}

@Module
class ExampleModule {
    @Provides
    fun provideProvided() = object : Provided {
        override fun return2(): Int {
            return 2
        }
    }
}

@Component(modules = [ExampleModule::class])
interface ExampleComponent {
    fun provided(): Provided
}
