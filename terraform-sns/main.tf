provider "aws" {
    region = "us-east-2"
}

resource "aws_sns_topic" "tamagawa_cscie90_hw9" {
    name = "tamagawa-cscie90-hw9"
}


resource "aws_sns_topic_subscription" "email_target" {
  topic_arn = aws_sns_topic.tamagawa_cscie90_hw9.arn
  protocol  = "email"
  endpoint  = "ntamagawa@gmail.com"
}