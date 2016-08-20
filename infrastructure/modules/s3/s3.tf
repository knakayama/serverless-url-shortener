resource "random_id" "s3" {
  byte_length = 8

  keepers = {
    name = "${var.name}"
  }
}

data "aws_iam_policy_document" "s3" {
  statement {
    sid    = "AddPerm"
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${random_id.s3.hex}/*",
    ]

    principals = {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }
  }
}

resource "aws_s3_bucket" "s3" {
  bucket = "${random_id.s3.hex}"
  acl    = "public-read"
  policy = "${data.aws_iam_policy_document.s3.json}"

  website {
    index_document = "${var.s3_config["index"]}"
  }

  lifecycle_rule {
    id      = "DisposeShortUrls"
    prefix  = "u"
    enabled = true

    expiration {
      days = "${var.s3_config["expiration"]}"
    }
  }
}

resource "aws_s3_bucket_object" "s3" {
  bucket       = "${aws_s3_bucket.s3.id}"
  key          = "admin/index.html"
  source       = "${path.module}/sources/admin/index.html"
  content_type = "text/html"
}
