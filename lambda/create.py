import json
import boto3
from datetime import datetime
from decimal import Decimal
import uuid

dynamodb = boto3.resource('dynamodb')
table_name = 'todo-app-table'  # Replace with your actual table name
table = dynamodb.Table(table_name)


def lambda_handler(event, context):
    """
    Lambda function to add new tasks to DynamoDB

    Expected event structure:
    {
        "task": "Task description",
        "priority": "High|Medium|Low",
        "status": "Pending|In Progress|Completed",
        "due_date": "YYYY-MM-DD" (optional)
    }
    """

    try:
        if isinstance(event.get('body'), str):
            body = json.loads(event['body'])
        else:
            body = event

        # Validate required fields
        required_fields = ['task', 'priority', 'status']
        for field in required_fields:
            if field not in body:
                return {
                    'statusCode': 400,
                    'body': json.dumps({
                        'error': f'Missing required field: {field}',
                        'required_fields': required_fields
                    })
                }

        # Validate priority values
        valid_priorities = ['High', 'Medium', 'Low']
        if body['priority'] not in valid_priorities:
            return {
                'statusCode': 400,
                'body': json.dumps({
                    'error': f'Invalid priority. Must be one of: {valid_priorities}'
                })
            }

        # Validate status values
        valid_statuses = ['Pending', 'In Progress', 'Completed']
        if body['status'] not in valid_statuses:
            return {
                'statusCode': 400,
                'body': json.dumps({
                    'error': f'Invalid status. Must be one of: {valid_statuses}'
                })
            }

        # Generate unique ID for the task
        task_id = str(uuid.uuid4())

        # Prepare item for DynamoDB
        item = {
            'id': task_id,
            'task': body['task'],
            'priority': body['priority'],
            'status': body['status'],
            'created_at': datetime.now().isoformat(),
            'updated_at': datetime.now().isoformat()
        }

        # Add due_date if provided
        if 'due_date' in body and body['due_date']:
            # Validate date format
            try:
                datetime.strptime(body['due_date'], '%Y-%m-%d')
                item['due_date'] = body['due_date']
            except ValueError:
                return {
                    'statusCode': 400,
                    'body': json.dumps({
                        'error': 'Invalid due_date format. Use YYYY-MM-DD'
                    })
                }

        # Insert item into DynamoDB
        response = table.put_item(Item=item)

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'message': 'Task added successfully',
                'task_id': task_id,
                'item': item
            })
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': 'Internal server error',
                'message': str(e)
            })
        }

# Additional helper function to add multiple tasks at once


def add_multiple_tasks(tasks_list):
    """
    Helper function to add multiple tasks in a batch
    """
    try:
        with table.batch_writer() as batch:
            for task_data in tasks_list:
                task_id = str(uuid.uuid4())
                item = {
                    'id': task_id,
                    'task': task_data['task'],
                    'priority': task_data['priority'],
                    'status': task_data['status'],
                    'created_at': datetime.now().isoformat(),
                    'updated_at': datetime.now().isoformat()
                }

                if 'due_date' in task_data and task_data['due_date']:
                    item['due_date'] = task_data['due_date']

                batch.put_item(Item=item)

        return {'success': True, 'message': f'Added {len(tasks_list)} tasks successfully'}

    except Exception as e:
        return {'success': False, 'error': str(e)}


# Example usage for testing locally
if __name__ == "__main__":
    # Test event
    test_event = {
        "task": "Complete AWS Lambda implementation",
        "priority": "High",
        "status": "In Progress",
        "due_date": "2025-07-10"
    }

    # Simulate Lambda execution
    result = lambda_handler(test_event, None)
    print(json.dumps(result, indent=2))
