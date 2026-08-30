const jwt = require('jsonwebtoken');
require('dotenv').config();

function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    
    if (!token) {
        return res.status(401).json({ 
            success: false, 
            message: '未提供认证令牌' 
        });
    }
    
    jwt.verify(token, process.env.JWT_SECRET || 'your_secret_key', (err, decoded) => {
        if (err) {
            return res.status(403).json({ 
                success: false, 
                message: '令牌无效或已过期' 
            });
        }
        
        req.userId = decoded.userId;
        req.username = decoded.username;
        next();
    });
}

module.exports = { authenticateToken };