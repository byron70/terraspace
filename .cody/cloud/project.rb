github("boltops-tools/terraspace")
image("aws/codebuild/amazonlinux2-x86_64-standard:3.0")
env_vars(
  TS_API:   "ssm:/#{Cody.env}/TS_API",
  TS_TOKEN: "ssm:/#{Cody.env}/TS_TOKEN",
)
