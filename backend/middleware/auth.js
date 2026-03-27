const { CognitoJwtVerifier } = require('aws-jwt-verify');

// Create verifier
const verifier = CognitoJwtVerifier.create({
  userPoolId: process.env.COGNITO_USER_POOL_ID || 'eu-north-1_eWRyRplzS',
  tokenUse: 'id',
  clientId: process.env.COGNITO_CLIENT_ID || '6htgbni04qrm81seusp048nr1d',
});

const verifyCognitoToken = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'No token provided' });
    }

    const token = authHeader.split('Bearer ')[1];
    
    // Verify the Cognito token
    const payload = await verifier.verify(token);
    
    req.user = {
      uid: payload.sub,
      email: payload.email,
      phone: payload.phone_number,
      name: payload.name || payload.nickname || payload['custom:name'],
      picture: payload.picture
    };
    
    next();
  } catch (error) {
    console.error('Cognito token verification failed:', error.message);
    return res.status(401).json({ error: 'Invalid token' });
  }
};

const optionalAuth = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.split('Bearer ')[1];
      const payload = await verifier.verify(token);
      req.user = {
        uid: payload.sub,
        email: payload.email,
        phone: payload.phone_number
      };
    }
  } catch (error) {
    // Token invalid, continue without user
    delete req.user;
  }
  next();
};

const requireRole = (...roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ error: 'Authentication required' });
    }
    next();
  };
};

module.exports = {
  verifyCognitoToken,
  optionalAuth,
  requireRole
};
