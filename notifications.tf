locals {
  chatbot_arn = "arn:aws:chatbot::646279979860:chat-configuration/slack-channel/twitter-counter-api-generator-deploy-pipeline-notifications"
}

resource "aws_codestarnotifications_notification_rule" "commits" {
  detail_type = "FULL"
  event_type_ids = [
    "codepipeline-pipeline-pipeline-execution-failed",
    "codepipeline-pipeline-pipeline-execution-canceled",
    "codepipeline-pipeline-pipeline-execution-started",
    "codepipeline-pipeline-pipeline-execution-resumed",
    "codepipeline-pipeline-pipeline-execution-succeeded",
    "codepipeline-pipeline-pipeline-execution-superseded",
    "codepipeline-pipeline-manual-approval-failed",
    "codepipeline-pipeline-manual-approval-needed",
    "codepipeline-pipeline-manual-approval-succeeded",
  ]

  name     = "twitter-counter-api-deploy-pipeline-notifications"
  resource = aws_codepipeline.pipeline.arn

  target {
    address = local.chatbot_arn
    type    = "AWSChatbotSlack"
  }
}
