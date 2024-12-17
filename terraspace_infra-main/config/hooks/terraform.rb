class BeforeApplyContext
  def call(runner)
    mod = runner.mod
  end
end

class AfterApplyContext
  def call(runner)
    mod = runner.mod
  end
end

before("apply",
       execute: BeforeApplyContext,
)

after("apply",
      execute: AfterApplyContext,
)
