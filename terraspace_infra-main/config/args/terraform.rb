command("init",
        args: ["-lock-timeout=20m"],
        env: { TF_VAR_key: "value" },
)

command("apply",
        args: ["-lock-timeout=21m"],
        env: { TF_VAR_key: "value" },
)

