import json
import boto3
from botocore.exceptions import ClientError
import os

# define resource
dynamodb = boto3.resource('dynamodb')


def lambda_handler(event, context):
    """
    Lambda function to get all rows
    """

    # table_name = os.environ.get('TABLE_NAME')

    # # check if tb exists
    # if not table_name:
    #     return {
    #         'statusCode': 400,
    #         'headers': {
    #             'Content-Type': 'application/json',
    #             'Access-Control-Allow-Origin': '*'
    #         },
    #         'body': json.dumps({
    #             'error': 'TABLE_NAME environment variable not set'
    #         })
    #     }

    try:
        table = dynamodb.Table("todo-app-table")

        # Scan the table, maximum 20 items
        query = table.scan(
            Limit=20,
            Select='ALL_ATTRIBUTES'
        )

        items = query.get('Items', [])
        count = len(items)

        # Check if there are more items (pagination info)
        has_more = 'LastEvaluatedKey' in query

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps(
                {
                    'success': True,
                    'count': count,
                    'has_more': has_more,
                    'items': items
                },
                default=str  # default string type
            )
        }

    # error handling
    except ClientError as e:
        print(f"DynamoDB Error: {e}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': 'Failed to retrieve items from DynamoDB',
                'details': str(e)
            })
        }

    except Exception as e:
        print(f"Unexpected Error: {e}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': 'An unexpected error occurred',
                'details': str(e)
            })
        }


if __name__ == "__main__":
    print(lambda_handler(None, None))
