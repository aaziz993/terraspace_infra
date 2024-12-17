class BeforeBuildContext
  def call(runner)
    mod = runner.mod

    puts "runner #{runner}"
    puts "runner.hook #{runner.hook}"

    puts "mod #{mod}"
    puts "mod.name #{mod.name}"
    puts "mod.build_dir #{mod.build_dir}"
    puts "mod.cache_dir #{mod.cache_dir}"
    puts "mod.root #{mod.root}"
    puts "mod.type #{mod.type}"
    puts "mod.type_dir #{mod.type_dir}"
    puts "mod.options #{mod.options}"

    puts("Terraspace.root #{Terraspace.root}")
    puts("Terraspace.env #{Terraspace.env}")
  end
end

class AfterBuildContext
  def call(runner)
    mod = runner.mod
  end
end

before("build",
       execute: BeforeBuildContext,
)

after("build",
      execute: AfterBuildContext
)
