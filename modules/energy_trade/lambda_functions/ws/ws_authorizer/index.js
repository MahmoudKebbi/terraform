// authorizer.js
const jwt = require("jsonwebtoken");
const jwksClient = require("jwks-rsa");

const client = jwksClient({
  jwksUri: `https://cognito-idp.${process.env.REGION}.amazonaws.com/${process.env.USER_POOL_ID}/.well-known/jwks.json`,
});

function getKey(header, callback) {
  client.getSigningKey(header.kid, function (err, key) {
    const signingKey = key.publicKey || key.rsaPublicKey;
    callback(null, signingKey);
  });
}

exports.handler = (event, context, callback) => {
  const token = event.authorizationToken.split(" ")[1];

  jwt.verify(
    token,
    getKey,
    {
      audience: process.env.CLIENT_ID,
      issuer: `https://cognito-idp.${process.env.REGION}.amazonaws.com/${process.env.USER_POOL_ID}`,
    },
    function (err, decoded) {
      if (err) {
        callback("Unauthorized");
      } else {
        callback(
          null,
          generatePolicy(decoded.sub, "Allow", event.methodArn, decoded)
        );
      }
    }
  );
};

function generatePolicy(principalId, effect, resource, decoded) {
  const authResponse = {};
  authResponse.principalId = principalId;
  if (effect && resource) {
    const policyDocument = {};
    policyDocument.Version = "2012-10-17";
    policyDocument.Statement = [];
    const statementOne = {};
    statementOne.Action = "execute-api:Invoke";
    statementOne.Effect = effect;
    statementOne.Resource = resource;
    policyDocument.Statement[0] = statementOne;
    authResponse.policyDocument = policyDocument;
  }
  authResponse.context = decoded;
  return authResponse;
}
