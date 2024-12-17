import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import com.github.jrubygradle.JRubyExec

plugins {
    kotlin("jvm") version "1.6.21"
    id("com.github.jruby-gradle.base") version "2.0.1"
    id ("org.sonarqube") version "3.3"
}

group = "ai.tech"
version = "1.0.0"

sonarqube {
    properties {
        property ("sonar.projectKey", "a-aziz93_terraspace-infra")
        property ("sonar.organization", "a-aziz93")
        property ("sonar.host.url", "https://sonarcloud.io")
    }
}

repositories {
    mavenCentral()
    this as ExtensionAware
    the<com.github.jrubygradle.api.core.RepositoryHandlerExtension>().gems()
}

dependencies {
    testImplementation(kotlin("test"))
    
    /* Using the built-in `gems` configuration to describe the
   * dependencies our JRubyExec-based tasks will need.
   */
    gems("rubygems:asciidoctor:1.5.2+")
    gems("rubygems:colorize:0.7.7+")
}

tasks.test {
    useJUnitPlatform()
}

tasks.withType<KotlinCompile> {
    kotlinOptions.jvmTarget = "11"
}

tasks.register<JRubyExec>("verifyAsciidoctorWorks") {
    description="Verify that we can execute the `asciidoctor` command line tool"
    setScriptArgs(mutableListOf("--version"))
    setScript(File("asciidoctor"))
}
