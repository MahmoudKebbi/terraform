const AWS = require("aws-sdk");
const cognito = new AWS.CognitoIdentityServiceProvider();
const userPoolId = process.env.USER_POOL_ID;

exports.handler = async (event) => {
  console.log("Received event:", JSON.stringify(event, null, 2));

  if (!userPoolId) {
    console.error("USER_POOL_ID environment variable is not set");
    return {
      statusCode: 500,
      body: JSON.stringify({
        error: "USER_POOL_ID environment variable is not set",
      }),
    };
  }

  let username;
  try {
    username = JSON.parse(event.body).username;
    console.log("Username to be updated:", username);
  } catch (parseError) {
    console.error("Error parsing event body:", parseError);
    return {
      statusCode: 400,
      body: JSON.stringify({
        error: "Invalid request body",
        details: parseError.message,
      }),
    };
  }

  const removeParams = {
    GroupName: "Admins",
    UserPoolId: userPoolId,
    Username: username,
  };

  const addParams = {
    GroupName: "Users",
    UserPoolId: userPoolId,
    Username: username,
  };

  try {
    // Remove user from Admins group
    await cognito.adminRemoveUserFromGroup(removeParams).promise();
    console.log(`User ${username} removed from Admins group`);

    // Add user to Users group
    await cognito.adminAddUserToGroup(addParams).promise();
    console.log(`User ${username} added to Users group`);

    return {
      statusCode: 200,
      body: JSON.stringify({
        message:
          "User removed from admin group and added to users group successfully",
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
