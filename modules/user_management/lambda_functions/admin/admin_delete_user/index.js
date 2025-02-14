const AWS = require("aws-sdk");
const cognito = new AWS.CognitoIdentityServiceProvider();
const dynamodb = new AWS.DynamoDB.DocumentClient();
const userPoolId = process.env.USER_POOL_ID;
const tableName = process.env.TABLE_NAME;

exports.handler = async (event) => {
  console.log("Received event:", JSON.stringify(event, null, 2));

  // Log environment variables
  console.log("Environment variables:", JSON.stringify(process.env, null, 2));

  const senderGroups = event.requestContext.authorizer.claims["cognito:groups"];
  const usernameToDelete = event.pathParameters.username; // Assuming username is passed as a path parameter

  try {
    // Check if the sender is in the Admins group
    if (!senderGroups.includes("Admins")) {
      console.warn("Access denied: sender is not in Admins group");
      return {
        statusCode: 403,
        body: JSON.stringify({
          error: "Access denied",
          message: "You must be an admin to perform this action",
        }),
      };
    }

    // Query the DynamoDB table to get the UUID using the username
    const queryParams = {
      TableName: tableName,
      IndexName: usernameIndex, // Use the GSI
      KeyConditionExpression: "username = :username",
      ExpressionAttributeValues: {
        ":username": usernameToDelete,
      },
    };

    console.log("Querying DynamoDB with params:", queryParams);
    const queryResult = await dynamodb.query(queryParams).promise();
    if (queryResult.Items.length === 0) {
      console.warn("User not found in DynamoDB");
      return {
        statusCode: 404,
        body: JSON.stringify({ message: "User not found" }),
      };
    }

    const user_id = queryResult.Items[0].user_id; // Assuming the primary key is named 'uuid'

    // Delete the user from Cognito
    console.log("Deleting user from Cognito:", usernameToDelete);
    await cognito
      .adminDeleteUser({
        UserPoolId: userPoolId,
        Username: usernameToDelete,
      })
      .promise();

    // Delete the user from DynamoDB using the UUID
    console.log("Deleting user from DynamoDB with user_id:", user_id);
    await dynamodb
      .delete({
        TableName: tableName,
        Key: {
          user_id: user_id,
        },
      })
      .promise();

    console.log("User deleted successfully");
    return {
      statusCode: 200,
      body: JSON.stringify({ message: "User deleted successfully" }),
    };
  } catch (error) {
    console.error("Error deleting user:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: error.message }),
    };
  }
};
