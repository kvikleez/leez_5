// Top-level build file where you can add configuration options common to all sub-projects/modules.
buildscript {
    ext {
        kotlin_version = '1.9.22' // Use a stable Kotlin version (adjust if you need Kotlin 2.x)
    }
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.google.gms:google-services:4.4.2' // Updated Google Services plugin
        classpath 'com.android.tools.build:gradle:8.2.2' // Updated Android Gradle plugin
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
    project.evaluationDependsOn(':app')
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}