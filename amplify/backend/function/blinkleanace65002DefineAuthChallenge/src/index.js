exports.handler = async (event) => {
    if (event.request.session &&
        event.request.session.length >= 3 &&
        event.request.session.slice(-1)[0].challengeResult === false) {
        // The user tried 3 times and failed, so fail the whole thing
        event.response.issueTokens = false;
        event.response.failAuthentication = true;
    } else if (event.request.session &&
        event.request.session.length > 0 &&
        event.request.session.slice(-1)[0].challengeResult === true) {
        // The user entered the correct code! Log them in.
        event.response.issueTokens = true;
        event.response.failAuthentication = false;
    } else {
        // We haven't verified them yet, so issue the Custom OTP challenge
        event.response.issueTokens = false;
        event.response.failAuthentication = false;
        event.response.challengeName = 'CUSTOM_CHALLENGE';
    }
    return event;
};
