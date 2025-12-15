resource "aws_s3_bucket" "codepipeline_artifact" {
  bucket = artifact_bucket1245
  versioning {
    enabled = true
  }
}

