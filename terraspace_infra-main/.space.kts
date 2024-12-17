/**
 * JetBrains Space Automation
 * This Kotlin-script file lets you automate build activities
 * For more info, see https://www.jetbrains.com/help/space/automation.html
 */

job("Build Fleet indexes") {
    // ide is an IDE you want Space to build indexes for:
    // for JetBrains Fleet - Ide.Fleet
    // for IntelliJ-based IDEs via Gateway -
    // Ide.Idea, Ide.WebStorm, Ide.RubyMine,
    // Ide.CLion, Ide.GoLand, Ide.PhpStorm,
    // Ide.PyCharm, Ide.Rider

    // optional
    startOn {
        // run on schedule every day at 5AM
        schedule { cron("0 5 * * *") }
        // run on every commit...
        gitPush {
            // ...but only to the main branch
            branchFilter {
                +"refs/heads/main"
            }
        }
    }

    warmup(ide = Ide.Fleet) {
        // this job will run in a container based on the image
        // specified in the devfile.yaml (if specified) and for ide version (if specified)
        devfile = ".space/devfile.yaml"
        // optional custom script
        scriptLocation = "./dev-env-warmup.sh"
    }

    // optional
    git {
        // fetch the entire commit history
        depth = UNLIMITED_DEPTH
        // fetch all branches
        refSpec = "refs/*:refs/*"
    }
}

job("Code analysis, plan, up and test") {
    startOn {
        gitPush {
            enabled =true

            pathFilter {
                -"src/**"
            }
        }
    }

    container(displayName = "Sonarqube continuous inspection of code quality and security", image = "openjdk:11")
    {
        env["SONAR_TOKEN"] = Secrets("terraspace_infra_sonar_token")
        kotlinScript { api->
            api.gradlew("sonarqube")
        }
    }
}