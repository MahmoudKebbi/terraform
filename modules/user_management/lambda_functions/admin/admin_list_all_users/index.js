const AWS = require("aws-sdk");
const cognito = new AWS.CognitoIdentityServiceProvider();
const dynamodb = new AWS.DynamoDB.DocumentClient();
const userPoolId = process.env.USER_POOL_ID;
const tableName = process.env.TABLE_NAME;

exports.handler = async (event) => {
  const adminUsername =
    event.requestContext.authorizer.claims["cognito:username"];
  const { limit, lastEvaluatedKey } = event.queryStringParameters || {};

  try {
    // Check if the user is in the "Admins" group
    const adminGroups = await cognito
      .adminListGroupsForUser({
        UserPoolId: userPoolId,
        Username: adminUsername,
      })
      .promise();

    const isAdmin = adminGroups.Groups.some(
      (group) => group.GroupName === "Admins"
    );

    if (!isAdmin) {
      throw new Error("User is not authorized to list all users");
    }

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
