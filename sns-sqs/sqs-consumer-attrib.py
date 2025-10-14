import boto3
import json
import time

# Use dev config profile configured to use dev-user IAM user API key
session = boto3.Session(profile_name='dev', region_name='us-east-2')

# Start a session for SQS
sqs_client = session.client('sqs')

# URL string for the sqs
queue_url = 'https://sqs.us-east-2.amazonaws.com/530012465576/homework6sqs'

# run forever
while True:
    # Receive message from SQS queue, 1 message at a time
    response = sqs_client.receive_message(
        QueueUrl=queue_url,
        AttributeNames=['SentTimestamp'],
        MaxNumberOfMessages=1,
        MessageAttributeNames=['All'],
    )
    try:
        # Try to take a message.
        message = response['Messages'][0]
        message_body = message['Body']
        # parse json body
        message_json = json.loads(message_body)
        message_string = message_json['Message']

        # parse attribute
        message_attributes = message_json['MessageAttributes']

        # Parse message attribute's status
        attrib_dict = message_attributes['status']
        status = attrib_dict['Value']

        # Fail message. Show it but continue to the next without deleting
        if status == 'fail':
            print("**** Bad message received: " + message_string)
            continue

        # Get the receipt handle
        receipt_handle = message['ReceiptHandle']
        # Delete the message from the queue
        sqs_client.delete_message(
            QueueUrl=queue_url,
            ReceiptHandle=receipt_handle
        )
        print("Message received: " + message_string)

    except KeyError:
        print("No message on the queue")
        # Clear the message to an empty list
        message = []

        # Sleep 1 seconds for the next try
        time.sleep(1)


