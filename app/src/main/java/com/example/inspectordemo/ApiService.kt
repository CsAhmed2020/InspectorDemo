package com.example.inspectordemo

import android.content.Context
import com.chuckerteam.chucker.api.ChuckerCollector
import com.chuckerteam.chucker.api.ChuckerInterceptor
import com.chuckerteam.chucker.api.RetentionManager
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET

// Define a sample data model for the response
data class Post(val userId: Int, val id: Int, val title: String, val body: String)

// API service interface
interface ApiService {
    @GET("posts/1") // Replace with an endpoint that provides JSON data
    suspend fun getPost(): Post
}

// Function to create an OkHttpClient with logging and Chucker interceptors
fun provideOkHttpClient(context: Context): OkHttpClient {

    val chuckerCollector = ChuckerCollector(
        context = context,
        // Toggles visibility of the notification
        showNotification = true,
        // Allows to customize the retention period of collected data
        retentionPeriod = RetentionManager.Period.ONE_HOUR
    )

    val loggingInterceptor = HttpLoggingInterceptor().apply {
        level = HttpLoggingInterceptor.Level.BODY
    }

    return OkHttpClient.Builder()
        .addInterceptor(loggingInterceptor) // Log network requests and responses
        .addInterceptor(ChuckerInterceptor.Builder(context)
            .collector(chuckerCollector)
            .maxContentLength(250_000L)
            .alwaysReadResponseBody(true)
            .build()) // Chucker for in-app inspection
        .build()
}

// Function to create Retrofit instance
fun provideRetrofit(context: Context): ApiService {
    val retrofit = Retrofit.Builder()
        .baseUrl("https://jsonplaceholder.typicode.com/") // Fake API
        .client(provideOkHttpClient(context))
        .addConverterFactory(GsonConverterFactory.create())
        .build()

    return retrofit.create(ApiService::class.java)
}
