const { SNSClient, PublishCommand } = require("@aws-sdk/client-sns");
const sns = new SNSClient();

exports.handler = async (event) => {
    if (event.request.challengeName === 'CUSTOM_CHALLENGE') {
        const phoneNumber = event.request.userAttributes.phone_number;
        const otpCode = Math.floor(100000 + Math.random() * 900000).toString();
        
        console.log(`Attempting to send OTP: ${otpCode} to ${phoneNumber}`);
        
        try {
            await sns.send(new PublishCommand({
                Message: `Your BlinKlean verification code is: ${otpCode}`,
                PhoneNumber: phoneNumber,
                MessageAttributes: {
                    'AWS.SNS.SMS.SMSType': { DataType: 'String', StringValue: 'Transactional' }
                }
            }));
            console.log('OTP sent successfully');
        } catch (error) {
            console.error('Error sending OTP via SNS:', error);
            // Optionally rethrow if you want to fail the challenge creation
            throw error;
        }

        event.response.publicChallengeParameters = { phone: phoneNumber };
        event.response.privateChallengeParameters = { answer: otpCode };
    }
    return event;
};

