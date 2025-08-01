package com.lumoralabs.macro.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color

@Composable
fun UniversalBackground(
    content: @Composable () -> Unit
) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                brush = Brush.linearGradient(
                    colors = listOf(
                        Color.Black,
                        Color.Gray.copy(alpha = 0.7f),
                        Color.Cyan.copy(alpha = 0.1f),
                        Color.Gray.copy(alpha = 0.3f)
                    )
                )
            )
    ) {
        content()
    }
}
