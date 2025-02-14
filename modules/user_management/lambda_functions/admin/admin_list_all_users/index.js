const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB.DocumentClient();
const tableName = process.env.TABLE_NAME;

exports.handler = async (event) => {
  // Check if the required environment variables are set
  if (!tableName) {
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "TABLE_NAME environment variable is not set",
      }),
    };
  }
  const { limit, lastEvaluatedKey } = event.queryStringParameters || {};

  try {
    // Scan the DynamoDB table to get all users with pagination
    const scanParams = {
      TableName: tableName,
      Limit: limit ? parseInt(limit, 10) : 10, // Default limit to 10 if not provided
      ExclusiveStartKey: lastEvaluatedKey
        ? JSON.parse(lastEvaluatedKey)
        : undefined,
    };

    const scanResult = await dynamodb.scan(scanParams).promise();

    return {
      statusCode: 200,
      body: JSON.stringify({
        items: scanResult.Items,
        lastEvaluatedKey: scanResult.LastEvaluatedKey,
      }),
    };
  } catch (error) {
    console.error(error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: error.message }),
    };
  }
};
