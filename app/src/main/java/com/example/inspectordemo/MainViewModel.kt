package com.example.inspectordemo

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class MainViewModel(application: Application) : AndroidViewModel(application) {
    private val apiService = provideRetrofit(application)

    private val _post = MutableStateFlow<Post?>(null)
    val post: StateFlow<Post?> = _post

    init {
        fetchPost()
    }

    private fun fetchPost() {
        viewModelScope.launch(Dispatchers.IO) {
            try {
                val response = apiService.getPost()
                _post.value = response
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}
