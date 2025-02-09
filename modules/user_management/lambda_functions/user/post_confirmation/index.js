const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB.DocumentClient();
const cognito = new AWS.CognitoIdentityServiceProvider();
const tableName = process.env.TABLE_NAME;
const userPoolId = process.env.USER_POOL_ID;

exports.handler = async (event) => {
  console.log("Received event:", JSON.stringify(event, null, 2));

  // Validate environment variables
  if (!tableName || !userPoolId) {
    console.error(
      "Environment variables TABLE_NAME and USER_POOL_ID must be defined"
    );
    throw new Error(
      "Environment variables TABLE_NAME and USER_POOL_ID must be defined"
    );
  }

  const userAttributes = event.request.userAttributes;
  const userId = userAttributes.sub; // Use the UUID from the user attributes
  const email = userAttributes.email;
  const username = event.userName; // Use the userName from the event

  const params = {
    TableName: tableName,
    Item: {
      user_id: userId,
      email: email,
      username: username,
    },
  };

  try {
    console.log(
      "Saving user to DynamoDB with params:",
      JSON.stringify(params, null, 2)
    );
    await dynamodb.put(params).promise();
    console.log("User saved to DynamoDB:", params.Item);

    // Add user to the "Users" group in Cognito
    const addUserParams = {
      UserPoolId: userPoolId,
      Username: username,
      GroupName: "Users",
    };
    console.log(
      "Adding user to Cognito group with params:",
      JSON.stringify(addUserParams, null, 2)
    );
    await cognito.adminAddUserToGroup(addUserParams).promise();
    console.log(`User ${username} added to "Users" group in Cognito`);

    // Return the event object to indicate success
    return event;
  } catch (error) {
    console.error("Error:", error);
    throw new Error(`Error processing user confirmation: ${error.message}`);
  }
};
