const AWS = require('aws-sdk');
const sns = new AWS.SNS();

exports.handler = async (event) => {
    let otpCode;
    if (!event.request.session || event.request.session.length === 0) {
        // NEW SESSION: Generate a random 6-digit code
        otpCode = Math.floor(100000 + Math.random() * 900000).toString();
        
        // Send the SMS via Amazon SNS
        const phoneNumber = event.request.userAttributes.phone_number;
        await sns.publish({
            Message: `Your BlinkLean verification code is: ${otpCode}`,
            PhoneNumber: phoneNumber,
        }).promise();
    } else {
        // RETRY: Re-use the existing code from the previous session
        const previousChallenge = event.request.session.slice(-1)[0];
        otpCode = previousChallenge.challengeMetadata.match(/CODE-(\d*)/)[1];
    }

    // Pass the secret code to the "Verify" function (Private)
    event.response.privateChallengeParameters = { answer: otpCode };
    
    // Pass a hint to the Flutter app (Public)
    event.response.publicChallengeParameters = { hint: 'Enter the 6-digit code' };
    
    // Store the code in metadata so we can find it on retry
    event.response.challengeMetadata = `CODE-${otpCode}`;

    return event;
};
