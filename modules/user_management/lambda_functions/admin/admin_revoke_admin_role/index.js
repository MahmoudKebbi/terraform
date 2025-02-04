const AWS = require("aws-sdk");
const cognito = new AWS.CognitoIdentityServiceProvider();
const userPoolId = process.env.USER_POOL_ID;

exports.handler = async (event) => {
  const username = JSON.parse(event.body).username;

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

    // Add user to Users group
    await cognito.adminAddUserToGroup(addParams).promise();

    return {
      statusCode: 200,
      body: JSON.stringify({
        message:
          "User removed from admin group and added to users group successfully",
      }),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({
        error: "Could not update user groups",
        details: error.message,
      }),
    };
  }
};
