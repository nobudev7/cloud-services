import datetime
import time

import boto3
import random

# Use dev config profile which is configured to use dev-user IAM user API key
session = boto3.Session(profile_name='dev', region_name='us-east-2')

# Start a session for SNS
sns_client = session.client('sns')

topic_arn="arn:aws:sns:us-east-2:530012465576:homework6"
message_status = ["fail", "succeed", "delivered", "added", "processed", "confirmed"]

# Loop 50 times to publish 50 messages
for i in range(50):

    # Set the timestamp string as iso format with second precision
    ts_str = str(datetime.datetime.now().isoformat(timespec="seconds"))

    response = sns_client.publish(
        TopicArn=topic_arn,
        Message="Tamagawa" + " "
                + ts_str + " "
                + str(i) + " "
                + random.choice(message_status)
    )

    # sleep 1 seconds to set the message apart in timestamp each other
    time.sleep(1)

    # Print the response from the SNS server.
    print(response)

# Show the total number of messages sent
print("Done: " + str(i+1) + " messages sent.")