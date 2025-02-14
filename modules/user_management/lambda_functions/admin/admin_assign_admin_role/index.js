const AWS = require("aws-sdk");
const cognito = new AWS.CognitoIdentityServiceProvider();
const userPoolId = process.env.USER_POOL_ID;

exports.handler = async (event) => {
  console.log("Received event:", JSON.stringify(event, null, 2));

  // Log environment variables
  console.log("Environment variables:", JSON.stringify(process.env, null, 2));

  let username;
  try {
    username = JSON.parse(event.body).username;
  } catch (error) {
    console.error("Error parsing event body:", error);
    return {
      statusCode: 400,
      body: JSON.stringify({
        error: "Invalid request body",
        details: error.message,
      }),
    };
  }

  const senderGroups = event.requestContext.authorizer.claims["cognito:groups"];
  console.log("Sender groups:", senderGroups);

  const addParams = {
    GroupName: "Admins",
    UserPoolId: userPoolId,
    Username: username,
  };

  const removeParams = {
    GroupName: "Users",
    UserPoolId: userPoolId,
    Username: username,
  };

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

    // Remove user from Users group
    console.log("Removing user from Users group:", removeParams);
    await cognito.adminRemoveUserFromGroup(removeParams).promise();

    // Add user to Admins group
    console.log("Adding user to Admins group:", addParams);
    await cognito.adminAddUserToGroup(addParams).promise();

    console.log("User successfully updated");
    return {
      statusCode: 200,
      body: JSON.stringify({
        message:
          "User removed from users group and added to admin group successfully",
      }),
    };
  } catch (error) {
    console.error("Error updating user groups:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        error: "Could not update user groups",
        details: error.message,
      }),
    };
  }
};
