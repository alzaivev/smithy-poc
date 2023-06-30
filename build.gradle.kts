plugins {
    java
    id("software.amazon.smithy").version("0.6.0")
}

repositories {
    mavenLocal()
    mavenCentral()
}

buildscript {
    dependencies {
        classpath("software.amazon.smithy:smithy-openapi:1.33.0")
        // The openapi plugin configured in the smithy-build.json example below
        // uses the restJson1 protocol defined in the aws-traits package. This
        // additional dependency must added to use that protocol.
        classpath("software.amazon.smithy:smithy-aws-traits:1.33.0")
    }
}

dependencies {
    // The dependency for restJson1 is required here too.
    implementation("software.amazon.smithy:smithy-aws-traits:1.33.0")
}

//dependencies {
//    implementation("software.amazon.smithy:smithy-model:1.33.0")
//}
//
//configure<software.amazon.smithy.gradle.SmithyExtension> {
//    // Uncomment this to use a custom projection when building the JAR.
//    // projection = "foo"
//}

// Uncomment to disable creating a JAR.
//tasks["jar"].enabled = false

java.sourceSets["main"].java {
    srcDirs("model", "src/main/smithy")
}
