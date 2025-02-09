const AWS = require("aws-sdk");
const dynamoDb = new AWS.DynamoDB.DocumentClient();
const cognito = new AWS.CognitoIdentityServiceProvider();
const TABLE_NAME = process.env.TABLE_NAME;
const USER_POOL_ID = process.env.USER_POOL_ID;

exports.handler = async (event) => {
  
  if (!TABLE_NAME || !USER_POOL_ID) {
    console.error("Environment variables TABLE_NAME or USER_POOL_ID are not set");
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Server configuration error" }),
    };
  }

  console.log("Received event:", JSON.stringify(event, null, 2));

  const usernameFromPath = event.pathParameters.username;
  const userId = event.requestContext.authorizer.claims.sub;

  const params = {
    TableName: TABLE_NAME,
    Key: { user_id: userId },
  };

  try {
    // Fetch the user from DynamoDB to verify existence
    const { Item } = await dynamoDb.get(params).promise();
    if (!Item) {
      console.error("User not found for user_id:", userId);
      return {
        statusCode: 404,
        body: JSON.stringify({ message: "User not found" }),
      };
    }

    if (Item.username !== usernameFromPath) {
      console.error(
        "Username mismatch: path username:",
        usernameFromPath,
        "DB username:",
        Item.username
      );
      return {
        statusCode: 403,
        body: JSON.stringify({ message: "Forbidden" }),
      };
    }

    // Delete the user from DynamoDB
    await dynamoDb.delete(params).promise();
    console.log("User deleted from DynamoDB:", userId);

    // Delete the user from Cognito User Pool
    await cognito
      .adminDeleteUser({
        UserPoolId: USER_POOL_ID,
        Username: Item.username,
      })
      .promise();
    console.log("User deleted from Cognito User Pool:", Item.username);

    return {
      statusCode: 200,
      body: JSON.stringify({ message: "User deleted successfully" }),
    };
  } catch (error) {
    console.error("Error deleting user:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Failed to delete user",
        error: error.message,
      }),
    };
  }
};
