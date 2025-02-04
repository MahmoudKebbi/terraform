const AWS = require("aws-sdk");
const cognito = new AWS.CognitoIdentityServiceProvider();
const dynamodb = new AWS.DynamoDB.DocumentClient();
const userPoolId = process.env.USER_POOL_ID;
const tableName = process.env.TABLE_NAME;
const usernameIndex = process.env.USERNAME_INDEX; // Add the GSI name as an environment variable

exports.handler = async (event) => {
  const adminUsername =
    event.requestContext.authorizer.claims["cognito:username"];
  const usernameToDelete = event.pathParameters.username; // Assuming username is passed as a path parameter

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
      throw new Error("User is not authorized to delete users");
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

    const queryResult = await dynamodb.query(queryParams).promise();
    if (queryResult.Items.length === 0) {
      return {
        statusCode: 404,
        body: JSON.stringify({ message: "User not found" }),
      };
    }

    const user_id = queryResult.Items[0].user_id; // Assuming the primary key is named 'uuid'

    // Delete the user from Cognito
    await cognito
      .adminDeleteUser({
        UserPoolId: userPoolId,
        Username: usernameToDelete,
      })
      .promise();

    // Delete the user from DynamoDB using the UUID
    await dynamodb
      .delete({
        TableName: tableName,
        Key: {
          user_id: user_id,
        },
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
      body: JSON.stringify({ message: error.message }),
    };
  }
};
