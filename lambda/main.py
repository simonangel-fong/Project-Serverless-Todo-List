import json
import boto3
from decimal import Decimal
import uuid
from datetime import datetime

client = boto3.client('dynamodb')
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table('todo-app-table')


def lambda_handler(event, context):
    print(event)
    body = {}
    statusCode = 200
    headers = {
        "Content-Type": "application/json"
    }

    try:
        # DELETE /items/{id} - Removes an item by ID
        if event['routeKey'] == "DELETE /items/{id}":
            table.delete_item(
                Key={'id': event['pathParameters']['id']})
            body = 'Deleted item ' + event['pathParameters']['id']

        # GET /items/{id} - Retrieves a single item by ID
        elif event['routeKey'] == "GET /items/{id}":
            body = table.get_item(
                Key={'id': event['pathParameters']['id']})
            body = body["Item"]
            responseBody = [
                {
                    'task': body['task'],
                    'priority': body['priority'],
                    'status': body['status'],
                    'due_date': body['due_date']
                }
            ]
            body = responseBody

        # GET /items - Retrieves all items (scan operation)
        elif event['routeKey'] == "GET /items":
            body = table.scan()
            body = body["Items"]
            print("----ITEMS----")
            print(body)
            responseBody = []
            for items in body:
                responseItems = [
                    {
                        'task': items['task'],
                        'priority': items['priority'],
                        'status': items['status'],
                        'due_date': items['due_date']
                    }
                ]
                responseBody.append(responseItems)
            body = responseBody

        # PUT /items - Creates or updates an item
        elif event['routeKey'] == "PUT /items":
            requestJSON = json.loads(event['body'])

            # Generate time-based ID with UUID suffix
            timestamp = datetime.utcnow().strftime('%Y%m%d%H%M%S')
            unique_id = f"{timestamp}-{str(uuid.uuid4())[:8]}"
            table.put_item(
                Item={
                    'id': unique_id,
                    'task': requestJSON['task'],
                    'priority': requestJSON['priority'],
                    'status': requestJSON['status'],
                    'due_date': requestJSON['due_date']
                })
            body = {"status": "success", "id": unique_id}

    # error
    except KeyError:
        statusCode = 400
        body = 'Unsupported route: ' + event['routeKey']

    # define return
    body = json.dumps(body)
    res = {
        "statusCode": statusCode,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": body
    }
    return res


if __name__ == "__main__":
    test_context = {'testing': True}

    # PUT Events - Create items
    put_event_01 = {
        'routeKey': 'PUT /items',
        'body': json.dumps({
            'task': "Finish project proposal",
            'priority': 'High',
            'status': 'In Progress',
            'due_date': '2025-07-05',
        })
    }

    put_event_02 = {
        'routeKey': 'PUT /items',
        'body': json.dumps({
            'task': "Review documentation",
            'priority': 'Medium',
            'status': 'Pending',
            'due_date': '2025-07-10',
        })
    }

    put_event_03 = {
        'routeKey': 'PUT /items',
        'body': json.dumps({
            'task': "Team meeting",
            'priority': 'Low',
            'status': 'Completed',
            'due_date': '2025-07-01',
        })
    }

    print("=========== PUT - Create Items ===========")
    result1 = lambda_handler(put_event_01, test_context)
    print("PUT Event 01:", result1)

    result2 = lambda_handler(put_event_02, test_context)
    print("PUT Event 02:", result2)

    result3 = lambda_handler(put_event_03, test_context)
    print("PUT Event 03:", result3)

    # Extract IDs for further testing
    id1 = json.loads(result1['body'])["id"]
    id2 = json.loads(result2['body'])["id"]
    id3 = json.loads(result3['body'])["id"]

    print(f"\nGenerated IDs: {id1}, {id2}, {id3}")

    print("\n=========== GET - Single Items ===========")

    # GET Events - Get single items
    get_event_01 = {
        'routeKey': 'GET /items/{id}',
        'pathParameters': {'id': id1}
    }

    get_event_02 = {
        'routeKey': 'GET /items/{id}',
        'pathParameters': {'id': id2}
    }

    get_event_nonexistent = {
        'routeKey': 'GET /items/{id}',
        'pathParameters': {'id': 'nonexistent-id-123'}
    }

    print("GET Event 01:", lambda_handler(get_event_01, test_context))
    print("GET Event 02:", lambda_handler(get_event_02, test_context))
    print("GET Non-existent:", lambda_handler(get_event_nonexistent, test_context))

    # print("\n=========== GET - All Items ===========")
    # # GET All Items

    # get_all_event = {
    #     'routeKey': 'GET /items'
    # }

    # print("GET All Items:", lambda_handler(get_all_event, test_context))

    # DELETE Events
    delete_event_01 = {
        'routeKey': 'DELETE /items/{id}',
        'pathParameters': {'id': id1}
    }

    delete_event_nonexistent = {
        'routeKey': 'DELETE /items/{id}',
        'pathParameters': {'id': 'nonexistent-id-456'}
    }

    print("\n=========== DELETE - Items ===========")
    print("DELETE Event 01:", lambda_handler(delete_event_01, test_context))
    print("DELETE Non-existent:",
          lambda_handler(delete_event_nonexistent, test_context))
