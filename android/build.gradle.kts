
rootProject.buildDir = file("../build")
subprojects {
    project.buildDir = file("${rootProject.buildDir}/${project.name}")
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    configurations.all {
        resolutionStrategy {
            // Fix: androidx.browser:1.9.x and androidx.core:1.17.0 require AGP 8.9.1+
            // Pinning to the latest versions compatible with AGP 8.5.2 and SDK 35
            force("androidx.browser:browser:1.8.0")
            force("androidx.core:core:1.15.0")
            force("androidx.core:core-ktx:1.15.0")
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}