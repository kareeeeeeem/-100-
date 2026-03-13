import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationId = "com.example.dev"
            resValue(type = "string", name = "app_name", value = "منصة 100 للقدرات")
        }
        create("stag") {
            dimension = "flavor-type"
            applicationId = "com.example.stag"
            resValue(type = "string", name = "app_name", value = "Lms App Stag")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.kareem.lms"
            resValue(type = "string", name = "app_name", value = "منصه 100 للقدرات")
        }
    }
}