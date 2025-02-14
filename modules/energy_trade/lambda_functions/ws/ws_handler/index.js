// ws_handler.js
const AWS = require("aws-sdk");
const dynamoDB = new AWS.DynamoDB.DocumentClient();

const CONNECTIONS_TABLE = process.env.WS_CONNECTIONS_TABLE;

exports.handler = async (event) => {
  console.log("WebSocket Event:", JSON.stringify(event));
  const routeKey = event.requestContext.routeKey;
  const connectionId = event.requestContext.connectionId;

  try {
    if (routeKey === "$connect") {
      // Save connection ID
      await dynamoDB
        .put({
          TableName: CONNECTIONS_TABLE,
          Item: { connectionId },
        })
        .promise();
      return { statusCode: 200, body: "Connected" };
    } else if (routeKey === "$disconnect") {
      // Remove connection ID
      await dynamoDB
        .delete({
          TableName: CONNECTIONS_TABLE,
          Key: { connectionId },
        })
        .promise();
      return { statusCode: 200, body: "Disconnected" };
    } else {
      return { statusCode: 400, body: "Unsupported route" };
    }
  } catch (err) {
    console.error("WebSocket Error:", err);
    return { statusCode: 500, body: "Internal Error" };
  }
};
