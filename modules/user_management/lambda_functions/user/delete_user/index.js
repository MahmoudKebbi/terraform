const AWS = require("aws-sdk");
const dynamoDb = new AWS.DynamoDB.DocumentClient();
const cognito = new AWS.CognitoIdentityServiceProvider();
const TABLE_NAME = process.env.TABLE_NAME;
const USER_POOL_ID = process.env.USER_POOL_ID;

exports.handler = async (event) => {
  const cognitoUsername =
    event.requestContext.authorizer.claims["cognito:username"];
  const usernameFromPath = event.pathParameters.username;

  if (usernameFromPath !== cognitoUsername) {
    return {
      statusCode: 403,
      body: JSON.stringify({ message: "Forbidden" }),
    };
  }

  const user_id = event.requestContext.authorizer.claims.sub;

  const params = {
    TableName: TABLE_NAME,
    Key: { user_id },
  };

  try {
    // Delete the user from DynamoDB
    const { Item } = await dynamoDb.delete(params).promise();
    if (!Item) {
      return {
        statusCode: 404,
        body: JSON.stringify({ message: "User not found" }),
      };
    }

    // Delete the user from Cognito User Pool
    await cognito
      .adminDeleteUser({
        UserPoolId: USER_POOL_ID,
        Username: cognitoUsername,
      })
      .promise();

    return {
      statusCode: 200,
      body: JSON.stringify({ message: "User deleted successfully" }),
    };
  } catch (error) {
    console.error(error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Failed to delete user",
        error: error.message,
      }),
    };
  }
};
