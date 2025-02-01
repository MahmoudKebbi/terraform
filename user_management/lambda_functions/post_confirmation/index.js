const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB.DocumentClient();
const tableName = process.env.TABLE_NAME;

exports.handler = async (event) => {
  const userAttributes = event.request.userAttributes;
  const userId = event.userName;
  const email = userAttributes.email;
  const name = userAttributes.name;

  const params = {
    TableName: tableName,
    Item: {
      user_id: userId,
      email: email,
      name: name,
    },
  };

  try {
    await dynamodb.put(params).promise();
    return event;
  } catch (error) {
    console.error(error);
    throw new Error("Error saving user to DynamoDB");
  }
};
