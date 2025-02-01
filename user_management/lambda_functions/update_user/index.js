const AWS = require("aws-sdk");
const dynamoDb = new AWS.DynamoDB.DocumentClient();
const TABLE_NAME = process.env.TABLE_NAME;

exports.handler = async (event) => {
  const { user_id } = event.pathParameters;
  const { email, name } = JSON.parse(event.body);

  const params = {
    TableName: TABLE_NAME,
    Key: { user_id },
    UpdateExpression: "set email = :email, name = :name",
    ExpressionAttributeValues: {
      ":email": email,
      ":name": name,
    },
    ReturnValues: "UPDATED_NEW",
  };

  try {
    const { Attributes } = await dynamoDb.update(params).promise();
    return {
      statusCode: 200,
      body: JSON.stringify(Attributes),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Failed to update user", error }),
    };
  }
};
