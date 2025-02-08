const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB.DocumentClient();
const cognito = new AWS.CognitoIdentityServiceProvider();
const tableName = process.env.TABLE_NAME;
const userPoolId = process.env.USER_POOL_ID;

exports.handler = async (event) => {
  console.log("Received event:", JSON.stringify(event, null, 2));

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
    await dynamodb.put(params).promise();
    // Add user to the "Users" group in Cognito
    await cognito
      .adminAddUserToGroup({
        UserPoolId: userPoolId,
        Username: username,
        GroupName: "Users",
      })
      .promise();
    return { message: "User confirmed successfully" };
  } catch (error) {
    console.error(error);
    throw new Error("Error saving user to DynamoDB");
  }
};
