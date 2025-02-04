const AWS = require("aws-sdk");
const cognito = new AWS.CognitoIdentityServiceProvider();
const dynamodb = new AWS.DynamoDB.DocumentClient();
const userPoolId = process.env.USER_POOL_ID;
const tableName = process.env.TABLE_NAME;
const usernameIndex = process.env.USERNAME_INDEX; // Add the GSI name as an environment variable

exports.handler = async (event) => {
  const adminUsername =
    event.requestContext.authorizer.claims["cognito:username"];
  const usernameToGet = event.pathParameters.username; // Assuming username is passed as a path parameter

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
      throw new Error("User is not authorized to get user details");
    }

    const params = {
      TableName: tableName,
      IndexName: usernameIndex, // Use the GSI
      KeyConditionExpression: "username = :username",
      ExpressionAttributeValues: {
        ":username": usernameToGet,
      },
    };

    const result = await dynamodb.query(params).promise();
    if (result.Items.length === 0) {
      return {
        statusCode: 404,
        body: JSON.stringify({ message: "User not found" }),
      };
    }
    return {
      statusCode: 200,
      body: JSON.stringify(result.Items[0]),
    };
  } catch (error) {
    console.error(error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: error.message }),
    };
  }
};
