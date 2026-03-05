import java.io.File
import org.gradle.api.tasks.Delete

// Force Gradle outputs to Flutter's expected ../build folder (project root)
val newBuildDir = File(rootProject.projectDir, "../build")

rootProject.buildDir = newBuildDir

subprojects {
    buildDir = File(newBuildDir, name)
}

subprojects {
    evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(newBuildDir)
}