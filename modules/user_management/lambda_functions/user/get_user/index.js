const AWS = require("aws-sdk");
const dynamoDb = new AWS.DynamoDB.DocumentClient();
const TABLE_NAME = process.env.TABLE_NAME;

exports.handler = async (event) => {
  const cognitoUsername =event.requestContext.authorizer.claims["cognito:username"];
  const usernameFromPath = event.pathParameters.username;

  if (usernameFromPath !== cognitoUsername) {
    return {
      statusCode: 403,
      body: JSON.stringify({ message: "Forbidden" }),
    };
  }

  const { user_id } = event.requestContext.authorizer.claims.sub;

  const params = {
    TableName: TABLE_NAME,
    Key: { user_id },
  };

  try {
    const { Item } = await dynamoDb.get(params).promise();
    if (!Item) {
      return {
        statusCode: 404,
        body: JSON.stringify({ message: "User not found" }),
      };
    }
    return {
      statusCode: 200,
      body: JSON.stringify(Item),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Failed to get user", error }),
    };
  }
};
