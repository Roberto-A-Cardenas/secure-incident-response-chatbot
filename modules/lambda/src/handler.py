import boto3
import json
from datetime import datetime, timedelta

def lambda_handler(event, context):
    print("Event received:", event)

    message = "Hello! How can I help you with your AWS environment?"
    command = ""

    if "body" in event:
        try:
            body = json.loads(event["body"])
            command = body.get("query", "").lower()
        except Exception as e:
            print("Error parsing JSON body:", str(e))

    if "logs" in command:
        logs_client = boto3.client("logs")
        try:
            log_group = "/aws/lambda/incident-bot-handler"
            now = datetime.utcnow()
            start_time = int((now - timedelta(minutes=60)).timestamp() * 1000)

            response = logs_client.filter_log_events(
                logGroupName=log_group,
                startTime=start_time,
                limit=3,
            )

            events = response.get("events", [])
            if not events:
                message = "📄 No recent log entries in the past 60 minutes."
            else:
                log_messages = "\n".join([f"- {e['message']}" for e in events])
                message = f"📄 Recent logs:\n{log_messages}"

        except Exception as e:
            print("Error reading logs:", str(e))
            message = "⚠️ Could not retrieve logs. Check permissions or log group name."

    elif "guardduty" in command:
        gd_client = boto3.client("guardduty")
        try:
            detectors = gd_client.list_detectors()
            detector_id = detectors['DetectorIds'][0] if detectors['DetectorIds'] else None

            if not detector_id:
                message = "⚠️ GuardDuty is not enabled in this account."
            else:
                findings = gd_client.list_findings(
                    DetectorId=detector_id,
                    MaxResults=3
                )

                if not findings['FindingIds']:
                    message = "✅ No GuardDuty findings at the moment. All clear!"
                else:
                    finding_details = gd_client.get_findings(
                        DetectorId=detector_id,
                        FindingIds=findings['FindingIds']
                    )

                    summaries = [f"- {f['Title']} (Severity: {f['Severity']})" for f in finding_details['Findings']]
                    message = "🚨 GuardDuty Alerts:\n" + "\n".join(summaries)

        except Exception as e:
            print("Error retrieving GuardDuty findings:", str(e))
            message = "⚠️ Failed to retrieve GuardDuty findings. Check permissions or region."

    elif "help" in command:
        message = "🧠 I can respond to: 'logs', 'login', 'guardduty', 'help'. Try one!"

    elif command.strip() == "":
        message = "👋 You didn’t send a valid command. Try 'help'."

    else:
        message = f"🤖 Sorry, I didn’t understand '{command}'. Try 'help'."

    return {
        "statusCode": 200,
        "body": message
    }
