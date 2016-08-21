from __future__ import print_function
from urlparse import urlparse
import os
import json
import boto3
import random
import string

S3_BUCKET = os.environ["S3Bucket"]
S3_PREFIX = os.environ["S3Prefix"]


def is_valid_url(url):
    url_check = urlparse(url)

    if url_check[0] or url_check[1]:
        return True

def done(url_long, url_short, error=""):
    print({"url_long": url_long, "url_short": url_short, "error": error})
    return {"url_long": url_long, "url_short": url_short, "error": error}


def check_and_create_s3_redirect(s3_bucket, key_short, url_long, cdn_prefix, id_short):
    client = boto3.client("s3")

    try:
        client.head_object(Bucket=s3_bucket, Key=key_short)
    except Exception as e:
        if e.response["Error"]["Message"] == "Not Found":
            try:
                client.put_object(
                    Bucket=s3_bucket,
                    Key=key_short,
                    Body="",
                    WebsiteRedirectLocation=url_long,
                    ContentType="text/plan"
                    )
            except Exception as e:
                return done(url_long, "", e.response["Error"]["Message"])
            else:
                ret_url = "https://" + cdn_prefix + "/" + id_short
                print("Success, short_url = {}".format(ret_url))
                return done(url_long, ret_url)
        else:
            return done(url_long, "", "Cloud not find an suitable name, error: {}".format(e))
    else:
        return check_and_create_s3_redirect(S3_BUCKET, key_short, url_long, cdn_prefix, id_short)


def handle(event, context):
    url_long = event["url_long"]
    cdn_prefix = event["cdn_prefix"]

    if not is_valid_url(url_long):
        return done(url_long, "", "Invalid URL format")

    id_short = "".join([random.choice(string.ascii_letters + string.digits) for n in xrange(7)])
    key_short = S3_PREFIX + "/" + id_short
    print("Long URL to shorten: {}".format(url_long))
    print("Short id = {}".format(key_short))

    return check_and_create_s3_redirect(S3_BUCKET, key_short, url_long, cdn_prefix, id_short)
