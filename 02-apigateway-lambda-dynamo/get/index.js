console.log('function starts');

const AWS = require('aws-sdk');
const docClient = new AWS.DynamoDB.DocumentClient({region: 'ap-southeast-2'});

exports.handler = function (event, context, callback) {
    console.log('processing the following event`: %j', event);


    let scanningParameters = {
        TableName: 'CodingTips',
        Limit: 100 //maximum result of 100 items
    };


//In dynamoDB scan looks through your entire table and fetches all data
    docClient.scan(scanningParameters, function (err, data) {
        if (err) {
            callback(err, null);
        } else {
            console.log(JSON.stringify(data))
            var response = {
                "statusCode": 200,
                "headers": {
                    "Content-Type": "application/json"
                },
                "body": JSON.stringify(data)
            };
            callback(null, response);
        }
    })
}
