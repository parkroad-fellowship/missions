package org.parkroadfellowship.app

import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.filters.LargeTest
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import pl.leancode.patrol.PatrolTestRule

@RunWith(AndroidJUnit4::class)
@LargeTest
class MainActivityTest {
    @Rule
    @JvmField
    val rule = PatrolTestRule<MainActivity>(MainActivity::class.java)

    @Test
    fun runDartIntegrationTests() {
        rule.patrol()
    }
}
